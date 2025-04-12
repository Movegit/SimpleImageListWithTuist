//
//  DetailHeaderView.swift
//  SimpleImageList
//
//  Created by 배정환 on 3/30/25.
//

import Foundation
import UIKit
import JHUtil

class DetailHeaderView: UIView {

    var onBackButtonTapped: (() -> Void)?
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "naviLeft"), for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.accessibilityIdentifier = "DetailBackButton"

        return button
    }()

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

extension DetailHeaderView {
    private func setUp() {
        addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalTo(80)
        }

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }

    @objc private func backButtonTapped() {
        onBackButtonTapped?()
    }
}
