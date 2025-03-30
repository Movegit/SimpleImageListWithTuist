//
//  PicSumListDto.swift
//  SimpleImageList
//
//  Created by 배정환 on 3/30/25.
//

import Foundation

// MARK: - PicSum Model
struct PicSumListDto: Decodable {
    var id: String?
    var author: String?
    var width: Int?
    var height: Int?
    var url: String?
    var downloadUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case author
        case width
        case height
        case url
        case downloadUrl = "download_url"
    }
}
