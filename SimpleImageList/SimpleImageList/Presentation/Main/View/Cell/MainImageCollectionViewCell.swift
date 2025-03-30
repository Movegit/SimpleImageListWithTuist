//
//  MainImageCollectionViewCell.swift
//  SimpleImageList
//
//  Created by 배정환 on 3/30/25.
//

import Foundation
import UIKit
import Kingfisher

class MainImageCollectionViewCell: UICollectionViewCell {
    static let cellReuseIdentifier: String = "MainImageCollectionViewCell"

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true

        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(.Body1)
        label.textColor = UIColor.customColor(.pink100)

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        accessibilityIdentifier = "MainImageCollectionViewCell"
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
}

extension MainImageCollectionViewCell {
    private func setUp() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(10)
            make.width.equalTo(70)
        }

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { [weak self] make in
            guard let self else { return }
            make.top.trailing.equalToSuperview().inset(15)
            make.leading.equalTo(self.imageView.snp.trailing).offset(15)
        }
    }

    func bindingCell(data: PicSumItem) {
        titleLabel.text = "\(data.id). \(data.author)"
        imageView.kf.setImage(with: URL(string: data.downloadUrl))
    }
}
