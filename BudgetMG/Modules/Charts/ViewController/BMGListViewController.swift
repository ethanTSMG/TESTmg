//
//  BMGListViewController.swift
//  Historical Transactions Rate List
//
//  Created by hmarker on 2021/2/16.
//

import UIKit

class BMGListViewController: BMGBaseViewController {
    
    private(set) var listItem: ListItem?
    private(set) var tableView: UITableView!
    
    /*
    // MARK: - create Subviews
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInitialization()
        layoutInitialization()
        loadData()
    }
    
    func commonInitialization() {
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
    
    /*
    // MARK: - Layout Subviews
    */
    func layoutInitialization() {
        tableView.snp.makeConstraints({ $0.edges.equalToSuperview() })
    }
    
    /*
    // MARK: - Data & Networking
    */
    func loadData() {
        /// config access key
        Networker.baseParametersClosure =  { (_) -> BaseReqParameters in
            return BaseReqParameters(accessKey: "b41c306282590bcd0317dd5c508dee5e")
        }
        
        self.view.pk.beginLoading(offset: -20)
        Networker.send(HistoricalRequest(), { (resp) in
            self.view.pk.endLoading()
            if let item = resp.result as? ListItem {
                self.listItem = item
                self.tableView.reloadData()
            }
        }, nil)
        
    }
}

/*
// MARK: - UITableViewDelegate
*/
extension BMGListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listItem?.quotes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ListTableViewCell.cellWithTableView(tableView)
        cell.item = self.listItem?.quotes?[indexPath.row]
        return cell
    }
}


