//
//  SectionHeaderView.swift
//  Netflix
//
//  Created by 권오준 on 2022/05/10.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
    
    static let identifier = "headerView"
    
    @IBOutlet weak var headerLabel: UILabel!
    
    var headerLabel2: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(headerLabel2)
        
        headerLabel2.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(5)
        }
    }
}
