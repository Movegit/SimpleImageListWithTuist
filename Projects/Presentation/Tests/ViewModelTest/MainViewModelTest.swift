//
//  MainViewModelTest.swift
//  SimpleImageListTests
//
//  Created by 배정환 on 3/30/25.
//

import Foundation
import XCTest
@testable import JHPresentation

final class MainViewModelTest: XCTestCase {

    var viewModel: MainViewListType?

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = MainViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }

    func testGetImageSuccess() async {
        _ = await viewModel?.loadData(initialize: true)
        let picList = viewModel?.picList ?? []
        XCTAssertFalse(picList.isEmpty, "picList가 비어있음")
    }
}
