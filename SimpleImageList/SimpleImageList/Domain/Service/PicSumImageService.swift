//
//  PicSumImageService.swift
//  SimpleImageList
//
//  Created by 배정환 on 3/30/25.
//

import Foundation
import UIKit

protocol PicSumImageServiceProtocol {
    func getImages(page: Int, limit: Int, completion: @escaping (Result<[PicSumListDto], APIError>) -> Void)
    func getImages(page: Int, limit: Int) async -> Result<[PicSumListDto], APIError>

    func detailImage(imageId: String, completion: @escaping (Result<PicSumDetailDto, APIError>) -> Void)
    func detailImage(imageId: String) async -> Result<PicSumDetailDto, APIError>
}

class PicSumImageService: PicSumImageServiceProtocol {
    private lazy var imageListUrl = "https://picsum.photos/v2/list"
    func detailImage(imageId: String) -> String {
        return "https://picsum.photos/id/\(imageId)/info"
    }
}

extension PicSumImageService {

    func getImages(page: Int, limit: Int, completion: @escaping (Result<[PicSumListDto], APIError>) -> Void) {
        let param = ["page": page,
                     "limit": limit]
        APIHelperNoLibSample.get(
            url: imageListUrl,
            queryParameters: param,
            headers: [:]
        ) { (result: Result<[PicSumListDto], APIError>) in
            completion(result)
        }
    }

    func getImages(page: Int, limit: Int) async -> Result<[PicSumListDto], APIError> {
        await withCheckedContinuation { continuation in
            getImages(page: page, limit: limit) { (result: Result<[PicSumListDto], APIError>) in
                continuation.resume(returning: result)
            }
        }
    }

    func detailImage(imageId: String, completion: @escaping (Result<PicSumDetailDto, APIError>) -> Void) {
        APIHelperNoLibSample.get(
            url: detailImage(imageId: imageId),
            queryParameters: [:],
            headers: [:]
        ) { (result: Result<PicSumDetailDto, APIError>) in
            completion(result)
        }
    }

    func detailImage(imageId: String) async -> Result<PicSumDetailDto, APIError> {
        await withCheckedContinuation { continuation in
            detailImage(imageId: imageId) { (result: Result<PicSumDetailDto, APIError>) in
                continuation.resume(returning: result)
            }
        }
    }
}
