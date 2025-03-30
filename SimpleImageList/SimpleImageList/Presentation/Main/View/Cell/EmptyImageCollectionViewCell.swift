//
//  EmptyImageCollectionViewCell.swift
//  SimpleImageList
//
//  Created by 배정환 on 3/30/25.
//

import Foundation
import UIKit

class EmptyImageCollectionViewCell: UICollectionViewCell {
    static let cellReuseIdentifier: String = "EmptyImageCollectionViewCell"

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "No data in server response"
        label.font = UIFont.customFont(.Body1_Bold)
        label.textAlignment = .center
        label.textColor = UIColor.black

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        accessibilityIdentifier = "EmptyImageCollectionViewCell"
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
}

extension EmptyImageCollectionViewCell {
    private func setUp() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
