//
//  BMGAddNoteTableViewCell.swift
//  AddNote TableViewCell
//
//  Created by hmarker on 2021/2/15.
//

import UIKit

class BMGAddNoteTableViewCell: UITableViewCell {
    
    lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    /*
    // MARK: - override
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // MARK: - layout subViews
    */
    func configSubviews() {
        addSubview(leftLabel)
        leftLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.centerY.equalToSuperview()
        }
        addSubview(rightLabel)
        rightLabel.snp.makeConstraints { make in
            make.left.equalTo(leftLabel.snp.right).offset(50)
            make.centerY.equalToSuperview()
        }
    }

}

