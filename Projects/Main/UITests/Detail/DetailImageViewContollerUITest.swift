//
//  DetailImageViewContollerUITest.swift
//  SimpleImageListUITests
//
//  Created by 배정환 on 3/30/25.
//

import Foundation
import XCTest

class DetailImageViewControllerUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testDetailImageViewControllerNavigation() throws {
        let collectionView = app.collectionViews["MainViewCollectionView"]
        let existsPredicate = NSPredicate(format: "count > 0")
        expectation(for: existsPredicate, evaluatedWith: collectionView.cells, handler: nil)

        // 1. 비동기 대기
        waitForExpectations(timeout: 8) { error in
            if let error = error {
                XCTFail("셀이 로드되지 않음: \(error.localizedDescription)")
            }
        }
        // 3번째 셀 가져오기
        let baseCell = collectionView.cells.element(boundBy: 2)
        baseCell.tap()

        let detailHeader = app.staticTexts["detailImage"]
        XCTAssertTrue(detailHeader.exists, "detailVC header title is detailImage")
    }

    func testDetailImageViewControllerNavigationBackButton() throws {
        let collectionView = app.collectionViews["MainViewCollectionView"]
        let existsPredicate = NSPredicate(format: "count > 0")
        expectation(for: existsPredicate, evaluatedWith: collectionView.cells, handler: nil)

        // 1. 비동기 대기
        waitForExpectations(timeout: 8) { error in
            if let error = error {
                XCTFail("셀이 로드되지 않음: \(error.localizedDescription)")
            }
        }
        // 3번째 셀 가져오기
        let baseCell = collectionView.cells.element(boundBy: 2)
        baseCell.tap()

        let backButton = app.buttons["DetailBackButton"]
        XCTAssertTrue(backButton.waitForExistence(timeout: 5))

        backButton.tap()

        XCTAssertTrue(collectionView.firstMatch.waitForExistence(timeout: 5))
    }
}
