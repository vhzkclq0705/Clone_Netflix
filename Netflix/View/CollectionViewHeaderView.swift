//
//  CollectionViewHeaderView.swift
//  Netflix
//
//  Created by 권오준 on 2022/05/18.
//

import UIKit
import SnapKit

class CollectionViewHeaderView: UICollectionReusableView {
    
    static let identifier = "headerView"
    
    var headerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setup()
    }
}

extension CollectionViewHeaderView {
    func setup() {
        addSubview(headerLabel)
        
        headerLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(10)
        }
    }
    
    func updateUI(_ section: Section) {
        headerLabel.text = section.title
    }
}
