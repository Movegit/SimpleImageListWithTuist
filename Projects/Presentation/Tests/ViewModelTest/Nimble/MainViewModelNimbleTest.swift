//
//  MainViewModelNimbleTest.swift
//  SimpleImageListTests
//
//  Created by 배정환 on 4/5/25.
//

import Foundation
import Quick
import Nimble
@testable import JHPresentation

class MainViewModelNimbleTest: QuickSpec {

    override func spec() {
        var viewModel: MainViewListType?
        let timeout: Int = ProcessInfo.processInfo.environment["SIMULATOR_DEVICE_NAME"] != nil ? 10 : 5

        beforeEach {
            viewModel = MainViewModel()
        }

        afterEach {
            viewModel = nil
        }

        describe("MainViewModel") {
            context("초기화 상태") {
                it("picList가 비어 있어야 한다") {
                    expect(viewModel?.picList).to(beEmpty())
                }
            }

            context("loadData 호출 후 데이터 로드 성공") {
                it("picList가 비어 있지 않아야 한다") {
                    Task {
                        _ = await viewModel?.loadData(initialize: true)
                        await expect(viewModel?.picList).toEventually(beEmpty(), timeout: .seconds(timeout))
                    }
                }
            }

            context("데이터 로드 후 첫 번째 아이템 확인") {
                beforeEach {
                    Task {
                        _ = await viewModel?.loadData(initialize: true)
                        it("첫 번째 아이템이 nil이 아니어야 한다") {
                            expect(viewModel?.picList.first).toNot(beNil())
                        }
                    }
                }
            }
        }
    }
}
