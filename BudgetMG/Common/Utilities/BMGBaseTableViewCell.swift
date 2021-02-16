//
//  BMGBaseTableViewCell.swift
//  BudgetMG
//
//  Created by hmarker on 2021/2/16.
//

import UIKit

public class BMGBaseTableViewCell: UITableViewCell {

    public class func cellWithTableView(_ tableView: UITableView) -> Self {
        let identifier = String(describing: self)
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = _makeSelf(identifier)
        }
        return cell as! Self
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.backgroundColor = .white
        commonInitialization()
        layoutInitialization()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInitialization()
        layoutInitialization()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func commonInitialization() {
        
        // Initialize subviews
    }
    
    func layoutInitialization() {
        
        // Configure the view layout
    }
}

fileprivate extension UITableViewCell {
    
    class func _makeSelf(_ identifier: String) -> Self {
        return Self.init(style: .default, reuseIdentifier: identifier)
    }
}
