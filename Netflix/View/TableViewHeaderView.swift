//
//  TableViewHeaderView.swift
//  Netflix
//
//  Created by 권오준 on 2022/05/19.
//

import UIKit

class TableViewHeaderView: UITableViewHeaderFooterView {

    static let identifier = "headerView"
    
    var headerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.text = "저장한 콘텐츠 목록"
        
        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .black
        setup()
    }
}

extension TableViewHeaderView {     // About UI Setup
    func setup() {
        addSubview(headerLabel)
        
        headerLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(10)
        }
    }
}
