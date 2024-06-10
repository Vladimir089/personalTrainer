//
//  EditPlayerViewController.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 10.06.2024.
//

import UIKit

class EditPlayerViewController: UIViewController {
    
    weak var delegate: DetailAthleteViewControllerProtocol?
    
    var athlete: Player?
    
    var index: Int?
    
    var rightButton: UIBarButtonItem?
    
    var nameTextField, ageTextField, weightTextField, heightTextField, classesTextField, durationTextField: UITextField?
    
    var achivements: [Achivement]? = []
    
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
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BG
        createInterface()
        settingsNavController()
        achivements = athlete?.achivements ?? nil
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.imageView.snp.updateConstraints({ make in
                make.top.equalToSuperview().inset(-10)
            })
            self.view.layoutIfNeeded()
            self.imageView.alpha = 0
            self.selectButtonImage.alpha = 0
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.imageView.snp.updateConstraints({ make in
                make.top.equalToSuperview().inset(100)
            })
            self.view.layoutIfNeeded()
            self.imageView.alpha = 1
            self.selectButtonImage.alpha = 1
        }
    }
    

    func settingsNavController() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.primary
        
        rightButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(savePlayer))
        
        let image = UIImage.plus.resize(to: CGSize(width: 20, height: 20))
        let extraButton = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(extraButtonTapped))
        navigationItem.rightBarButtonItems = [rightButton!, extraButton]
        self.title = "Edit"
    }
    
    
    func checkIfInputsAreValid() {
        let isValid = (nameTextField?.text?.isEmpty == false) &&
                      (ageTextField?.text?.isEmpty == false) &&
                      (weightTextField?.text?.isEmpty == false) &&
                      (heightTextField?.text?.isEmpty == false) &&
                      (classesTextField?.text?.isEmpty == false) &&
                      (durationTextField?.text?.isEmpty == false) &&
                      (imageView.image != nil)
        
        toggleSaveButton(isOn: isValid)
    }

    func toggleSaveButton(isOn: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = isOn
    }
    
    
    @objc func extraButtonTapped() {
        let alert = UIAlertController(title: "Add new achivement", message: "Please enter the details", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Achivement"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Detail"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak alert] _ in
            guard let textFields = alert?.textFields else { return }
            let field1Text = textFields[0].text ?? ""
            let field2Text = textFields[1].text ?? ""
            
            self.saveData(field1: field1Text, field2: field2Text)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func saveData(field1: String, field2: String) {
        print("First field: \(field1), Second field: \(field2)")
        let achivement = Achivement(mainText: field1, secondaryText: field2)
        achivements?.append(achivement)
        
    }
    
    
    @objc func savePlayer() {
        let player = Player(name: nameTextField?.text ?? "", age: ageTextField?.text ?? "", height: heightTextField?.text ?? "", weight: weightTextField?.text ?? "", classesPerMonth: classesTextField?.text ?? "", duration: durationTextField?.text ?? "", image: imageView.image ?? UIImage(), achivements: achivements)
        
        delegate?.savePlayer(player: player)
        navigationController?.popViewController(animated: true)
    }
    
    
    func createInterface() {
        
        var image = UIImage(data: athlete?.imageData ?? Data())
        imageView.image = image
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(100)
            make.height.equalTo(118)
        }
        
        
        view.addSubview(selectButtonImage)
        selectButtonImage.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        selectButtonImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(imageView.snp.centerY)
            make.height.width.equalTo(imageView)
        }
        
        
        nameTextField = generateTextFields(labelText: "Name")
        nameTextField?.text = athlete?.name
        view.addSubview(nameTextField ?? UIView())
        nameTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(imageView.snp.bottom).inset(-15)
            make.height.equalTo(44)
        })
        
        
        ageTextField = generateTextFields(labelText: "Age")
        ageTextField?.text = athlete?.age
        view.addSubview(ageTextField ?? UIView())
        ageTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(nameTextField!.snp.bottom).inset(-15)
            make.height.equalTo(44)
        })
        
        
        weightTextField = generateTextFields(labelText: "Weight")
        weightTextField?.text = athlete?.weight
        view.addSubview(weightTextField ?? UIView())
        weightTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(ageTextField!.snp.bottom).inset(-15)
            make.height.equalTo(44)
        })
        
        
        heightTextField = generateTextFields(labelText: "Height")
        heightTextField?.text = athlete?.height
        view.addSubview(heightTextField ?? UIView())
        heightTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(weightTextField!.snp.bottom).inset(-15)
            make.height.equalTo(44)
        })
        
        classesTextField = generateTextFields(labelText: "Classes per month")
        classesTextField?.text = athlete?.classesPerMonth
        view.addSubview(classesTextField ?? UIView())
        classesTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(heightTextField!.snp.bottom).inset(-15)
            make.height.equalTo(44)
        })
        
        
        durationTextField = generateTextFields(labelText: "Duration")
        durationTextField?.text = athlete?.duration
        view.addSubview(durationTextField ?? UIView())
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
        selectImage1()
    }
}

extension EditPlayerViewController: UITextFieldDelegate {
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
           !duration.isEmpty,
           imageView.image != nil {
            toggleButton(isOn: true)
        } else {
            toggleButton(isOn: false)
        }
        return true
    }
    
}

extension EditPlayerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func toggleButton(isOn: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = isOn
    }
    
    
    func selectImage1() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any] ) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
        
        checkIfInputsAreValid()
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
