//
//  MainViewControllerUITest.swift
//  SimpleImageListUITests
//
//  Created by 배정환 on 3/30/25.
//

import Foundation
import XCTest

class MainViewControllerUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testHeaderViewExists() throws {
        let headerView = app.otherElements["MainHeaderView"]

        XCTAssertTrue(headerView.exists, "HeaderView should exist")

        let headerTitle = headerView.staticTexts["Pic List"]
        XCTAssertTrue(headerTitle.exists, "headerTitle should be 'Pic List'")
    }

    func testCollectionViewExist() throws {
        let collectionView = app.collectionViews["MainViewCollectionView"]

        XCTAssertTrue(collectionView.exists, "mainVC collectionView should exist")
    }

    func testCollectionViewCellsExist() throws {
        let collectionView = app.collectionViews["MainViewCollectionView"]
        let existsPredicate = NSPredicate(format: "count > 0")
        expectation(for: existsPredicate, evaluatedWith: collectionView.cells, handler: nil)

        // 3. 비동기 대기
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("셀이 로드되지 않음: \(error.localizedDescription)")
            }
        }
        XCTAssertGreaterThan(collectionView.cells.count, 0, "collectionview should have cells")
    }

    func testCollectionViewPaging() throws {
        let collectionView = app.collectionViews["MainViewCollectionView"]
        let existsPredicate = NSPredicate(format: "count > 0")
        expectation(for: existsPredicate, evaluatedWith: collectionView.cells, handler: nil)

        // 3. 비동기 대기
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("셀이 로드되지 않음: \(error.localizedDescription)")
            }
        }

        let baseCount = collectionView.cells.count
        collectionView.swipeUp(velocity: .fast)

        sleep(1)

        let newCount = collectionView.cells.count
        XCTAssertGreaterThan(newCount, baseCount, "after pageLoading is success")
    }
}
