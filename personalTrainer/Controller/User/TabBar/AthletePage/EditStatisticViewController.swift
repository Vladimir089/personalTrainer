//
//  EditStatisticViewController.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 08.06.2024.
//

import UIKit

class EditStatisticViewController: UIViewController {
    
    var amountLabel: UILabel
    
    var totalLabel: UILabel
    
    var amountTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .BG
        
        let placeholderText = "Enter"
        let placeholderColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        textField.textColor = .white
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.textFieldBorder.cgColor
        textField.layer.borderWidth = 1
        let label = UILabel()
        label.text = "Amount players"
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: label.intrinsicContentSize.width + 30, height: label.intrinsicContentSize.height))
        label.frame = CGRect(x: 15, y: 0, width: label.intrinsicContentSize.width, height: label.intrinsicContentSize.height)
        paddingView.addSubview(label)
        
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }()
    
    var totalTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .BG
        let placeholderText = "Enter"
        let placeholderColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        textField.textColor = .white
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.textFieldBorder.cgColor
        textField.layer.borderWidth = 1
        let label = UILabel()
        label.text = "Total salary"
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: label.intrinsicContentSize.width + 30, height: label.intrinsicContentSize.height))
        label.frame = CGRect(x: 15, y: 0, width: label.intrinsicContentSize.width, height: label.intrinsicContentSize.height)
        paddingView.addSubview(label)
        
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }()
    
    var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundColor(.primary, forState: .normal)
        button.layer.cornerRadius = 12
        button.setTitleColor(UIColor.white.withAlphaComponent(0.6), for: .disabled)
        button.clipsToBounds = true
        button.setBackgroundColor(UIColor.primary.withAlphaComponent(0.5), forState: .disabled)
        button.isEnabled = false
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        return button
    }()
    
    
    init(amountLabel: UILabel, totalLabel: UILabel) {
        self.amountLabel = amountLabel
        self.totalLabel = totalLabel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createInterface()
    }
    

    func createInterface() {
        view.backgroundColor = .BG
        
        let hideView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.3)
            view.layer.cornerRadius = 2.5
            return view
        }()
        view.addSubview(hideView)
        hideView.snp.makeConstraints { make in
            make.height.equalTo(5)
            make.width.equalTo(36)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(5)
        }
        
        
        let editLabel: UILabel = {
            let label = UILabel()
            label.text = "Edit statistic"
            label.font = .systemFont(ofSize: 15, weight: .bold)
            label.textColor = .white
            return label
        }()
        view.addSubview(editLabel)
        editLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(hideView.snp.bottom).inset(-20)
        }
        
        
        let rectangle: UIView = {
            let view = UIView()
            view.backgroundColor = .darkGray.withAlphaComponent(0.3)
            return view
        }()
        view.addSubview(rectangle)
        rectangle.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.top.equalTo(editLabel.snp.bottom).inset(-20)
            make.left.right.equalToSuperview()
        }
        
        
        view.addSubview(amountTextField)
        amountTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.left.right.equalToSuperview().inset(10)
            make.top.equalTo(rectangle.snp.bottom).inset(-20)
        }
        amountTextField.delegate = self
        
        
        view.addSubview(totalTextField)
        totalTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.left.right.equalToSuperview().inset(10)
            make.top.equalTo(amountTextField.snp.bottom).inset(-15)
        }
        totalTextField.delegate = self
        
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(40)
            make.top.equalTo(totalTextField.snp.bottom).inset(-15)
        }
    }
    
    
    @objc func save() {
        amountLabel.text = amountTextField.text
        totalLabel.text = "$\(totalTextField.text ?? "$0")"
        UserDefaults.standard.set(amountTextField.text, forKey: "amount")
        UserDefaults.standard.set(totalTextField.text, forKey: "total")
    }
    
}

extension EditStatisticViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""

        updateAddButtonState()

        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        
        return allowedCharacters.isSuperset(of: characterSet) || string.isEmpty
    }

    func updateAddButtonState() {
        let isAmountTextFieldFilled = !(amountTextField.text?.isEmpty ?? true)
        let isTotalTextFieldFilled = !(totalTextField.text?.isEmpty ?? true)
        
        addButton.isEnabled = isAmountTextFieldFilled && isTotalTextFieldFilled
    }
}



extension UIButton {
    func setBackgroundColor(_ color: UIColor, forState: UIControl.State) {
        let minimumSize: CGSize = CGSize(width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(minimumSize)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.setFillColor(color.cgColor)
        context.fill(CGRect(origin: .zero, size: minimumSize))
        
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }
}
