//
//  BMGAddNoteViewController.swift
//  edit a transaction’s date, time, value, currency and category.
//
//  Created by hmarker on 2021/2/15.
//

import UIKit

class BMGAddNoteViewController: BMGBaseViewController {
       
    public var saveClosure: (() -> (Void))?

    /*
    // MARK: - Create SubViews
    */
    lazy var tabelView: UITableView = {
        let table = UITableView()
        table.register(BMGAddNoteTableViewCell.self, forCellReuseIdentifier: "BMGAddNoteTableViewCell")
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 30, y: 0, width: UIScreen.main.bounds.width - 60, height: 100))
        textField.placeholder = "please input amount"
        textField.textColor = .blue
        textField.keyboardType = .numbersAndPunctuation
        textField.becomeFirstResponder()
        return textField
    }()
    
    lazy var datePickerView: CustomDatePickerView = {
        let pickerview = CustomDatePickerView()
        return pickerview
    }()
    
    lazy var currencyPicker: CustomPickerView = {
        let pickerview = CustomPickerView()
        return pickerview
    }()
    
    lazy var categoryPicker: CustomPickerView = {
        let pickerview = CustomPickerView()
        return pickerview
    }()
    
    /*
    // MARK: - Layout Subviews
    */
    func setupSubviews() {
        view.addSubview(tabelView)
        tabelView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addClick))
    }
    
    func currencySelect() {
        view.addSubview(currencyPicker)
        let cell = tabelView.cellForRow(at: IndexPath(row: 1, section: 0)) as? BMGAddNoteTableViewCell
        currencyPicker.confirmClosure = { string in
            print("string==\(string)")
//            self.requestCurrencyConvert(from: cell?.rightLabel.text ?? "USD", to: string, amount: Float(self.textField.text ?? "0.00") ?? 0.00, date: self.datePickerView.datePicker.date)
            self.currencyvalue = string
            cell?.rightLabel.text = string
        }
        currencyPicker.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        currencyPicker.set(currencySource)
        currencyPicker.show()
    }
    
    func categorySelect() {
        view.addSubview(categoryPicker)
        let cell = tabelView.cellForRow(at: IndexPath(row: 0, section: 0)) as? BMGAddNoteTableViewCell
        categoryPicker.confirmClosure = { string in
            print("string==\(string)")
            cell?.rightLabel.text = string
            self.categoryvalue = string
        }
        categoryPicker.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        categoryPicker.set(categorySource)
        categoryPicker.show()
    }
    /*
    // MARK: - Set Test Data
    */
    private var categorySource: [String] = ["Travel", "Sports", "Taxi", "Games", "Telephone", "Education", "Medical"]
    
    private var currencySource: [String] = ["USD", "NZD"]
    
    private var dataSource: [String] = ["category", "currency", "date"]
    
    private var categoryvalue: String = "Travel";
    
    private var currencyvalue: String = "NZD";

    private var timevalue: String = "2020-11-23";
    
    private var datavalue: String = "23";

    /*
    // MARK: - Override viewDidLoad
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Note"
        view.backgroundColor = .white
        setupSubviews()
    
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Actions
    // Save in DB
    */
    @objc func addClick() {
        self.datavalue = self.textField.text ?? "230"
        //保存到数据库
        DBManager.default.inset(category:self.categoryvalue, value: self.datavalue, currency: self.currencyvalue, date: self.timevalue){ (_) in
            self.view.pk.showAlert(text: "success")
            
            DispatchQueue.pk.asyncAfter(delay: 0.5) {
                self.saveClosure?()
                self.textField.resignFirstResponder()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    /*
    // MARK: - Actions
    */
    func dateSelect() {
        view.addSubview(datePickerView)
        let cell = tabelView.cellForRow(at: IndexPath(row: 2, section: 0)) as? BMGAddNoteTableViewCell
        datePickerView.confirmClosure = { [weak self] date in
            print("date==\(date)")
            cell?.rightLabel.text = self?.formatteDate(date)
            self?.timevalue = self?.formatteDate(date) ?? "2020-11-23"
        }
        datePickerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        datePickerView.show()
    }
    
    /*
    // MARK: - formatte Date
    */
    private func formatteDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
}

/*
// MARK: - UITableViewDelegate
*/
extension BMGAddNoteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BMGAddNoteTableViewCell") as? BMGAddNoteTableViewCell {
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            let title = dataSource[indexPath.row]
            cell.leftLabel.text = title
            switch indexPath.row {
            case 0:
                cell.rightLabel.text = categorySource[0]
            case 1:
                cell.rightLabel.text = currencySource[0]
            default:
                cell.rightLabel.text = formatteDate(Date())
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textField.resignFirstResponder()
        switch indexPath.row {
        case 0:
            categorySelect()
        case 1:
            currencySelect()
        default:
            dateSelect()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return textField
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
}

