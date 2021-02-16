//
//  BMGTransactionsTableViewCell.swift
//  Transactions TableViewCell
//
//  Created by hmarker on 2021/2/16.
//

import UIKit

public class TodayTableViewCell: BMGBaseTableViewCell {

    public var item: TransactionsItem? {
        didSet {
            entityUpdates()
        }
    }
    
    private(set) var dateLabel: UILabel!
    private(set) var categoryLabel: UILabel!
    private(set) var currencyLabel: UILabel!
    private(set) var valueLabel: UILabel!
    private(set) var bottomLine: UIView!
    
    override func commonInitialization() {
        dateLabel = UILabel()
        dateLabel.textAlignment = .left
        dateLabel.font = UIFont.pk.fontName(.courierNewPSMT, size: 10)
        dateLabel.textColor = .black
        contentView.addSubview(dateLabel)
        
        categoryLabel = UILabel()
        categoryLabel.textAlignment = .left
        categoryLabel.numberOfLines = 0
        categoryLabel.font = UIFont.pk.fontName(.pingFangSC, style: .light, size: 16)
        contentView.addSubview(categoryLabel)
        
        currencyLabel = UILabel()
        currencyLabel.textAlignment = .right
        currencyLabel.font = UIFont.pk.fontName(.gillSans, style: .boldItalic, size: 18)
        currencyLabel.textColor = UIColor.pk.random(.cooler)
        contentView.addSubview(currencyLabel)
        
        valueLabel = UILabel()
        valueLabel.textAlignment = .right
        valueLabel.font = UIFont.pk.fontName(.gillSans, style: .boldItalic, size: 18)
        valueLabel.textColor = UIColor.pk.random(.cooler)
        contentView.addSubview(valueLabel)
        
        bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        contentView.addSubview(bottomLine)
    }

    override func layoutInitialization() {
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.bottom.equalTo(-5)
        }
        
        categoryLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(10)
        }
        
        currencyLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.centerY.equalToSuperview()
        }
        
        valueLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        valueLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-80)
            make.centerY.equalToSuperview()
        }
        
        bottomLine.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.bottom.equalToSuperview()
            make.height.equalTo(1 / UIScreen.main.scale)
        }
    }
    
    func entityUpdates() {
        currencyLabel.text = item?.currency
        categoryLabel.text = item?.category
        dateLabel.text = item?.date
        valueLabel.text = item?.value
    }
}

