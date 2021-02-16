//
//  BMGInputToolView.swift
//  input the value view
//
//  Created by hmarker on 2021/2/15.
//

import UIKit

class BMGInputToolView: UIView {

    public var textFieldFinishClosure: ((String) -> ())?
    
    /*
    // MARK: - Create SubViews
    */
    private lazy var contentView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: self.frame.size.height, width: UIScreen.main.bounds.width, height: 100))
        view.backgroundColor = .gray
        view.isUserInteractionEnabled = true
        return view
    }()
    
    public lazy var textField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        textField.enablesReturnKeyAutomatically = true
        textField.keyboardType = .numbersAndPunctuation
        textField.returnKeyType = .done
        textField.delegate = self
        return textField
    }()
    
    lazy var dateButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd"
        let strNowTime = timeFormatter.string(from: date)
        button.setTitle(strNowTime, for: .normal)
        return button
    }()
    
    lazy var currencyButton: UIButton = {
        let button = UIButton()
        button.setTitle("USD", for: .normal)
        button.backgroundColor = .black
        return button
    }()
    
    /*
    // MARK: - override funs
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        let tap = UITapGestureRecognizer(target: self, action: #selector(hiddenKeyBoardTap))
        addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        configSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // MARK: - layout subviews
    */
    private func configSubview() {
        addSubview(contentView)
        contentView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(10)
        }
        contentView.addSubview(currencyButton)
        currencyButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(textField.snp.bottom).offset(20)
        }
        contentView.addSubview(dateButton)
        dateButton.snp.makeConstraints { make in
            make.right.equalTo(currencyButton.snp.left).offset(-20)
            make.top.equalTo(currencyButton)
        }
        
    }
    
    /*
    // MARK: - kvo KeyBoard
    */
    @objc func hiddenKeyBoardTap() {
        textField.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo
        let keyboardRect = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = keyboardRect.origin.y
        var frame = self.contentView.frame
        frame.origin.y = y - contentView.frame.size.height - 40
        UIView.animate(withDuration: 0.25, animations: {
            self.contentView.frame = frame
        })
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.25, animations: {
            self.contentView.frame = CGRect(x: 0, y: self.frame.size.height, width: UIScreen.main.bounds.width, height: 100)
        })
    }
}

/*
// MARK: - UITextFieldDelegate
*/
extension BMGInputToolView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            textFieldFinishClosure?(text)
            textField.resignFirstResponder()
        }
        return true
    }
}

