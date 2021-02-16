//
//  BMGListViewCell.swift
//  BudgetMG
//
//  Created by hmarker on 2021/2/15.
//

import UIKit

public class ListTableViewCell: BMGBaseTableViewCell {

    public var item: QuoteMapItem? {
        didSet {
            entityUpdates()
        }
    }
    
    private(set) var nameLabel: UILabel!
    private(set) var quoteLabel: UILabel!
    
    override func commonInitialization() {
        nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 1
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.font = UIFont.pk.fontName(.pingFangSC, style: .light, size: 18)
        nameLabel.textColor = .black
        contentView.addSubview(nameLabel)
        
        quoteLabel = UILabel()
        quoteLabel.textAlignment = .right
        quoteLabel.numberOfLines = 1
        quoteLabel.lineBreakMode = .byTruncatingTail
        quoteLabel.font = UIFont.pk.fontName(.gillSans, style: .boldItalic, size: 18)
        quoteLabel.textColor = UIColor.pk.random(.cooler)
        contentView.addSubview(quoteLabel)
    }

    /*
    // MARK: - layout subviews
    */
    override func layoutInitialization() {
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(25)
            make.bottom.equalTo(-25)
        }
        
        quoteLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.centerY.equalToSuperview()
        }
    }
    
    func entityUpdates() {
        nameLabel.text = item?.key
        quoteLabel.text = item?.doubleValue.pk.stringValue()
    }
}
