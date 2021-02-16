//
//  BMGChartsViewController.swift
//  first tab
//  overview with charts
//
//  Created by hmarker on 2021/2/15.
//

import UIKit
import SnapKit

class BMGChartsViewController: BMGBaseViewController {
    
    /*
    // MARK: - create SubViews
    */
    lazy var incomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Income"
        return label
    }()
    
    lazy var incomeValueLabel: UILabel = {
        let label = UILabel()
        label.text = "0 $"
        return label
    }()
    
    lazy var expenseLabel: UILabel = {
        let label = UILabel()
        label.text = "Expenses"
        return label
    }()
    
    lazy var expenseValueLabel: UILabel = {
        let label = UILabel()
        label.text = "0 $"
        return label
    }()
    
    lazy var addNoteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add One Note", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(addNote), for: .touchUpInside)
        return button
    }()
    
    lazy var listButton: UIButton = {
        let button = UIButton()
        button.setTitle("exchange rates", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(rateList), for: .touchUpInside)
        return button
    }()
    
    /*
    // MARK: - override
    */
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupSubViews()
        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Layout Subviews
    */
    func setupSubViews() {
        view.addSubview(expenseLabel)
        expenseLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
        }
        
        view.addSubview(expenseValueLabel)
        expenseValueLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(expenseLabel.snp.bottom).offset(30)
        }
        
        view.addSubview(incomeLabel)
        incomeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(expenseValueLabel.snp.bottom).offset(30)
        }
        
        view.addSubview(incomeValueLabel)
        incomeValueLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(incomeLabel.snp.bottom).offset(30)
        }
        
        view.addSubview(addNoteButton)
        addNoteButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(incomeValueLabel.snp.bottom).offset(40)
        }
        
        view.addSubview(listButton)
        listButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(incomeValueLabel.snp.bottom).offset(75)
        }
    }
    
    /*
    // MARK: - Actions
    */
    @objc func addNote() {
        print("add note")
        navigationController?.pushViewController(BMGAddNoteViewController(), animated: true)
    }

    @objc func rateList() {
        navigationController?.pushViewController(BMGListViewController(), animated: true)
    }
    
}

