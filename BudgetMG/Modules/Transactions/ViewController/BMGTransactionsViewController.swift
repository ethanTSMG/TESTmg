//
//  TransactionsViewController.swift
//  BudgetMG
//
//  Created by hmarker on 2021/2/15.
//

import UIKit

class TransactionsViewController: BMGBaseViewController {

    private(set) var dataList: [TransactionsItem?]?
    private(set) var tableView: UITableView!
    
    /*
    // MARK: - override func
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInitialization()
        layoutInitialization()
        reloadData()
    }

    /*
    // MARK: - Layout Subviews
    */
    func commonInitialization() {

        let vc = BMGAddNoteViewController()
        vc.saveClosure = { self.reloadData() }
        
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 108
        tableView.estimatedSectionHeaderHeight = 55
        tableView.contentInset = .zero
        tableView.pk.eatAutomaticallyAdjustsInsets()
        view.addSubview(tableView)
    }
    
    func layoutInitialization() {
        tableView.snp.makeConstraints({ $0.edges.equalToSuperview() })
    }
    
    /*
    // MARK: - Get Data From DB
    */
    func reloadData() {
        DBManager.default.read { (anyObj) in
            if let value = [TransactionsItem].deserialize(from: anyObj), !value.isEmpty {
                self.dataList = value
            } else {
                self.dataList = self.defaultList()
            }
            self.tableView.reloadData()
        }
    }
    
    /*
    // MARK: - Set default data
    */
    func defaultList() -> [TransactionsItem?]? {
         let date = Date().pk.toString(format: "yyyy-MM-dd HH:mm")
        return [TransactionsItem(date: date, category: "Subway", currency: "NZD", value: "200")]
    }
}

/*
// MARK: - UITableViewDelegate
*/
extension TransactionsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TodayTableViewCell.cellWithTableView(tableView)
        cell.item = dataList?[indexPath.row]
        return cell
    }
}

extension TransactionsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


