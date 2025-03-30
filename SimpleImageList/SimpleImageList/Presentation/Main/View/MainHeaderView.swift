//
//  MainHeaderView.swift
//  SimpleImageList
//
//  Created by 배정환 on 3/30/25.
//

import Foundation
import UIKit
import SnapKit

class MainHeaderView: UIView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(.H3)
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.backgroundColor = .clear

        return label
    }()

    private override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }

    init(title: String) {
        super.init(frame: .zero)
        setUp()

        titleLabel.text = title
    }
}

extension MainHeaderView {
    func setUp() {
        backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
        accessibilityIdentifier = "MainHeaderView"
        addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(24)
        }
    }
}
