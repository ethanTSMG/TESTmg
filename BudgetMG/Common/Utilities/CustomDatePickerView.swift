//
//  CustomDatePickerView.swift
//  Date PickerView
//
//  Created by hmarker on 2021/2/15.
//

import UIKit

class CustomDatePickerView: UIView {
    public typealias ConfirmClosure = (Date) -> ()
    public var confirmClosure: ConfirmClosure?
    lazy var blackBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return view
    }()
    
    lazy var pickerBgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var toolView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = createButton(title: "取消", titleColor: .gray)
        button.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = createButton(title: "确定", titleColor: .blue)
        button.addTarget(self, action: #selector(confirmClick), for: .touchUpInside)
        return button
    }()
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.setDate(Date(), animated: true)
        picker.minimumDate = Date()
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .date
        return picker
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // MARK: - layout subViews
    */
    private func configSubviews() {
        addSubview(blackBgView)
        blackBgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(tapClick))
        addGestureRecognizer(gesture)
        blackBgView.addSubview(pickerBgView)
        pickerBgView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(329)
            make.bottom.equalToSuperview().offset(329)
        }
        pickerBgView.addSubview(toolView)
        toolView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(60)
        }
        toolView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(19)
        }
        toolView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(19)
        }
    }
    
    private func createButton(title: String, titleColor: UIColor) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(titleColor, for: .normal)
        return button
    }
    
    @objc private func cancelClick() {
        dimiss()
    }
    
    @objc private func confirmClick() {
        confirmClosure?(datePicker.date)
        dimiss()
    }
    
    @objc private func tapClick() {
        dimiss()
    }
    
    private func showOrHide(show: Bool) {
        if show == true {
            UIView.animate(withDuration: 0.3, delay: 0, animations: {
                self.pickerBgView.snp.updateConstraints { (make) in
                    make.bottom.equalToSuperview()
                }
                self.layoutIfNeeded()
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.25, delay: 0, animations: {
                self.pickerBgView.snp.updateConstraints { (make) in
                    make.bottom.equalToSuperview().offset(329)
                }
                self.layoutIfNeeded()
            }, completion: { finish in
                self.removeFromSuperview()
            })
        }
        
    }

}

/*
// MARK: - public func
*/
extension CustomDatePickerView {
    public func show() {
        pickerBgView.addSubview(datePicker)
        datePicker.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(toolView.snp.bottom)
        }
        layoutIfNeeded()
        showOrHide(show: true)
    }
    public func dimiss() {
        showOrHide(show: false)
    }
}

