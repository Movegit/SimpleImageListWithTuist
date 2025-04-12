//
//  PicSumListDto.swift
//  SimpleImageList
//
//  Created by 배정환 on 3/30/25.
//

import Foundation

// MARK: - PicSum Model
public struct PicSumListDto: Decodable {
    public var id: String?
    public var author: String?
    public var width: Int?
    public var height: Int?
    public var url: String?
    public var downloadUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case author
        case width
        case height
        case url
        case downloadUrl = "download_url"
    }
}
