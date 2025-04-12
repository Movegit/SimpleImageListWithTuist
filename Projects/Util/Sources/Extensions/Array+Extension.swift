//
//  Array+Extension.swift
//  SimpleImageList
//
//  Created by 배정환 on 3/30/25.
//

import Foundation

extension Array {
    public subscript (safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
