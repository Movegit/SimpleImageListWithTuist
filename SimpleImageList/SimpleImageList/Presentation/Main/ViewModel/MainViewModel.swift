//
//  MainViewModel.swift
//  SimpleImageList
//
//  Created by 배정환 on 3/30/25.
//

import Foundation
import UIKit

protocol MainViewListType {
    func loadData(initialize: Bool) async
    var picList: [PicSumItem] { get set }
    var isLoadingData: Bool { get }
    var hasNext: Bool { get }
}

class MainViewModel: MainViewListType {
    let picsumService: PicSumImageServiceProtocol
    var picList: [PicSumItem] = []
    var currentPage: Int = 1
    var isLoadingData: Bool = false
    var hasNext: Bool = true
    private var pageSize: Int = 30

    init(picsumService: PicSumImageServiceProtocol = PicSumImageService(), defaultPageSize: Int = 30) {
        self.picsumService = picsumService
        self.pageSize = defaultPageSize
    }

    func loadData(initialize: Bool) async {
        if initialize {
            hasNext = true
            currentPage = 1
        }

        if isLoadingData || hasNext == false {
            return
        }

        let list = await picsumImages(size: pageSize)
        if initialize {
            picList = []
        }

        picList.append(contentsOf: list)
    }

    private func picsumImages(size: Int) async -> [PicSumItem] {
        if hasNext == true && !isLoadingData {
            isLoadingData = true
            let result = await picsumService.getImages(page: currentPage, limit: size)
            switch result {
            case .success(let response):
                isLoadingData = false
                hasNext = !response.isEmpty
                if hasNext == true {
                    self.currentPage += 1
                }

                return response.map {
                    PicSumItem(id: $0.id ?? "",
                               author: $0.author ?? "",
                               width: $0.width ?? 0,
                               height: $0.height ?? 0,
                               url: $0.url ?? "",
                               downloadUrl: $0.downloadUrl ?? "")
                }
            case .failure(let error):
                print(error.localizedDescription)
                isLoadingData = false
                return []
            }
        } else {
            isLoadingData = false
            return []
        }
    }
}

struct PicSumItem {
    var id: String = ""
    var author: String = ""
    var width: Int = 0
    var height: Int = 0
    var url: String = ""
    var downloadUrl: String = ""
}
