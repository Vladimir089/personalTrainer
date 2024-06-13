//
//  CreateRatingViewController.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 13.06.2024.
//

import UIKit

class CreateRatingViewController: UIViewController {
    
    var forAthlete: Bool?
    
    weak var delegate: NewRatingViewControllerDelegate?
    
    var rating: [Rating] = []
    
    var rightButton: UIBarButtonItem?
    
    var nameTextField: UITextField?
    
    var selectedRating = 0
    
    var oneButton, twoButton, threeButton, fourButton, fiveButton: UIButton?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BG
        settingsNavController()
        addNewRating()
        createInterfae()
    }
    
    
    func settingsNavController() {
        if forAthlete == true {
            title = "For athlete"
        } else {
            title = "For team"
        }
    }
    
    
    func addNewRating() {
        rightButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(addButtonTapped))
        rightButton?.isEnabled = false
        navigationItem.rightBarButtonItems = [rightButton ?? UIBarButtonItem()]
    }
    
    
    @objc func addButtonTapped() {
        let newRating = Rating(name: nameTextField?.text ?? "", rate: selectedRating)
        rating.append(newRating)
        
        do {
            let data = try JSONEncoder().encode(rating)
            try saveRatingArrToFile(data: data)
            delegate?.saveRating(rating: rating)
            navigationController?.popViewController(animated: true)
        } catch {
            print("Failed to encode or save trainingArr: \(error)")
        }
        
        
    }
    
    
    func saveRatingArrToFile(data: Data) throws {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("rating.plist")
            try data.write(to: filePath)
        } else {
            throw NSError(domain: "SaveError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to get document directory"])
        }
    }
    
    
    func createInterfae() {
        
        nameTextField = generateTextFields(labelText: "Executor")
        view.addSubview(nameTextField ?? UITextField())
        nameTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(44)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
        })
        
        let activityLabel = UILabel()
        activityLabel.text = "Activity rating"
        activityLabel.textColor = .white
        activityLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        
        view.addSubview(activityLabel)
        activityLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo((nameTextField ?? UIView()).snp.bottom).inset(-15)
        }
        
        oneButton = createButton(tag: 1)
        view.addSubview(oneButton ?? UIView())
        oneButton?.snp.makeConstraints({ make in
            make.width.height.equalTo(24)
            make.centerY.equalTo(activityLabel)
            make.left.equalTo(activityLabel.snp.right).inset(-10)
        })
        
        twoButton = createButton(tag: 2)
        view.addSubview(twoButton ?? UIView())
        twoButton?.snp.makeConstraints({ make in
            make.width.height.equalTo(24)
            make.centerY.equalTo(activityLabel)
            make.left.equalTo((oneButton ?? UIView()).snp.right).inset(-10)
        })
        
        threeButton = createButton(tag: 3)
        view.addSubview(threeButton ?? UIView())
        threeButton?.snp.makeConstraints({ make in
            make.width.height.equalTo(24)
            make.centerY.equalTo(activityLabel)
            make.left.equalTo((twoButton ?? UIView()).snp.right).inset(-10)
        })
        
        fourButton = createButton(tag: 4)
        view.addSubview(fourButton ?? UIView())
        fourButton?.snp.makeConstraints({ make in
            make.width.height.equalTo(24)
            make.centerY.equalTo(activityLabel)
            make.left.equalTo((threeButton ?? UIView()).snp.right).inset(-10)
        })
        
        fiveButton = createButton(tag: 5)
        view.addSubview(fiveButton ?? UIView())
        fiveButton?.snp.makeConstraints({ make in
            make.width.height.equalTo(24)
            make.centerY.equalTo(activityLabel)
            make.left.equalTo((fourButton ?? UIView()).snp.right).inset(-10)
        })
        
        
        
    }
    
    
    @objc func clickButton(_ button: UIButton) {
        switch button.tag {
        case 1:
            UIView.animate(withDuration: 0.3) {
                self.oneButton?.tintColor = .primary
                self.twoButton?.tintColor = .white.withAlphaComponent(0.3)
                self.threeButton?.tintColor = .white.withAlphaComponent(0.3)
                self.fourButton?.tintColor = .white.withAlphaComponent(0.3)
                self.fiveButton?.tintColor = .white.withAlphaComponent(0.3)
            }
        case 2:
            UIView.animate(withDuration: 0.3) {
                self.oneButton?.tintColor = .primary
                self.twoButton?.tintColor = .primary
                self.threeButton?.tintColor = .white.withAlphaComponent(0.3)
                self.fourButton?.tintColor = .white.withAlphaComponent(0.3)
                self.fiveButton?.tintColor = .white.withAlphaComponent(0.3)
            }
        case 3:
            UIView.animate(withDuration: 0.3) {
                self.oneButton?.tintColor = .primary
                self.twoButton?.tintColor = .primary
                self.threeButton?.tintColor = .primary
                self.fourButton?.tintColor = .white.withAlphaComponent(0.3)
                self.fiveButton?.tintColor = .white.withAlphaComponent(0.3)
            }
        case 4:
            UIView.animate(withDuration: 0.3) {
                self.oneButton?.tintColor = .primary
                self.twoButton?.tintColor = .primary
                self.threeButton?.tintColor = .primary
                self.fourButton?.tintColor = .primary
                self.fiveButton?.tintColor = .white.withAlphaComponent(0.3)
            }
        case 5:
            UIView.animate(withDuration: 0.3) {
                self.oneButton?.tintColor = .primary.withAlphaComponent(1)
                self.twoButton?.tintColor = .primary.withAlphaComponent(1)
                self.threeButton?.tintColor = .primary.withAlphaComponent(1)
                self.fourButton?.tintColor = .primary.withAlphaComponent(1)
                self.fiveButton?.tintColor = .primary.withAlphaComponent(1)
            }
        default:
            return
        }
        
        selectedRating = button.tag
        checkFill()
    }
    

    func generateTextFields(labelText: String) -> UITextField {
        var textField = UITextField()
        textField.backgroundColor = .BG
        var placeholderText = "Enter"
        if labelText == "Athlete" {
            placeholderText = "Choose"
        } else {
            placeholderText = "Enter"
        }
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
    
    
    func createButton(tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "star.fill")?.resize(to: CGSize(width: 24, height: 24))
        button.setImage(image, for: .normal)
        button.tintColor = .white.withAlphaComponent(0.3)
        button.tag = tag
        button.addTarget(self, action: #selector(clickButton(_:)), for: .touchUpInside)
        return button
    }
    
    func checkFill() {
        if selectedRating != 0 && nameTextField?.text != "" {
            rightButton?.isEnabled = true
        } else {
            rightButton?.isEnabled = false
        }
    }
    
  

}


extension CreateRatingViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        checkFill()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkFill()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkFill()
        return true
    }
    
}
