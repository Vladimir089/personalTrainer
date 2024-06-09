//
//  NewAthleteView.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 08.06.2024.
//

import UIKit

class NewAthleteView: UIView {
    
    
    weak var delegate: AddNewPlayerViewControllerDelegate?
    
    
    var nameTextField, ageTextField, weightTextField, heightTextField, classesTextField, durationTextField: UITextField?
    
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white.withAlphaComponent(0.3)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    let selectButtonImage: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.photo.resize(to: CGSize(width: 24, height: 20)), for: .normal)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        settingsElements()
        backgroundColor = .BG
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func settingsElements() {
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(100)
            make.height.equalTo(118)
        }
        
        
        addSubview(selectButtonImage)
        selectButtonImage.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        selectButtonImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(imageView.snp.centerY)
            make.height.width.equalTo(imageView)
        }
        
        
        nameTextField = generateTextFields(labelText: "Name")
        addSubview(nameTextField ?? UIView())
        nameTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(imageView.snp.bottom).inset(-15)
            make.height.equalTo(44)
        })
        
        
        ageTextField = generateTextFields(labelText: "Age")
        addSubview(ageTextField ?? UIView())
        ageTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(nameTextField!.snp.bottom).inset(-15)
            make.height.equalTo(44)
        })
        
        
        weightTextField = generateTextFields(labelText: "Weight")
        addSubview(weightTextField ?? UIView())
        weightTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(ageTextField!.snp.bottom).inset(-15)
            make.height.equalTo(44)
        })
        
        
        heightTextField = generateTextFields(labelText: "Height")
        addSubview(heightTextField ?? UIView())
        heightTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(weightTextField!.snp.bottom).inset(-15)
            make.height.equalTo(44)
        })
        
        classesTextField = generateTextFields(labelText: "Classes per month")
        addSubview(classesTextField ?? UIView())
        classesTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(heightTextField!.snp.bottom).inset(-15)
            make.height.equalTo(44)
        })
        
        
        durationTextField = generateTextFields(labelText: "Duration")
        addSubview(durationTextField ?? UIView())
        durationTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(classesTextField!.snp.bottom).inset(-15)
            make.height.equalTo(44)
        })
    }
    
    
    func generateTextFields(labelText: String) -> UITextField {
        var textField = UITextField()
        textField.backgroundColor = .BG
        let placeholderText = "Enter"
        let placeholderColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        textField.textColor = .white
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.textFieldBorder.cgColor
        textField.layer.borderWidth = 1
        let label = UILabel()
        label.text = labelText
        label.textColor = .white
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        textField.delegate = self
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: label.intrinsicContentSize.width + 30, height: label.intrinsicContentSize.height))
        label.frame = CGRect(x: 15, y: 0, width: label.intrinsicContentSize.width, height: label.intrinsicContentSize.height)
        paddingView.addSubview(label)
        
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
        
    }
    
    
    @objc func selectImage() {
        delegate?.selectImage()
    }
    
}



extension NewAthleteView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        
        if let name = (textField == nameTextField ? currentText : nameTextField?.text),
           let age = (textField == ageTextField ? currentText : ageTextField?.text),
           let weight = (textField == weightTextField ? currentText : weightTextField?.text),
           let height = (textField == heightTextField ? currentText : heightTextField?.text),
           let classes = (textField == classesTextField ? currentText : classesTextField?.text),
           let duration = (textField == durationTextField ? currentText : durationTextField?.text),
           !name.isEmpty,
           !age.isEmpty,
           !weight.isEmpty,
           !height.isEmpty,
           !classes.isEmpty,
           !duration.isEmpty {
            delegate?.toggleButton(isOn: true)
        } else {
            delegate?.toggleButton(isOn: false)
        }
        return true
    }
}



