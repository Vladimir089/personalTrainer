//
//  AddNewPlayerViewController.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 08.06.2024.
//

import UIKit

protocol AddNewPlayerViewControllerDelegate: AnyObject {
    func selectImage()
    func toggleButton(isOn: Bool)
}


class AddNewPlayerViewController: UIViewController {
    
    var athleteArr: [Player] = []
    
    var mainView: NewAthleteView?
    
    var rightButton: UIBarButtonItem?
    
    var delegate: AthleteViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = NewAthleteView()
        self.view = mainView
        mainView?.delegate = self
        self.title = "New athlete"
        settingsNavController()
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
            self.mainView?.imageView.snp.updateConstraints({ make in
                make.top.equalToSuperview().inset(-10)
            })
            self.mainView?.layoutIfNeeded()
            self.mainView?.imageView.alpha = 0
            self.mainView?.selectButtonImage.alpha = 0
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.mainView?.imageView.snp.updateConstraints({ make in
                make.top.equalToSuperview().inset(100)
            })
            self.mainView?.layoutIfNeeded()
            self.mainView?.imageView.alpha = 1
            self.mainView?.selectButtonImage.alpha = 1
        }
    }
    
    
    func settingsNavController() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.primary
        
        rightButton = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addButtonTapped))
        rightButton?.isEnabled = false
        
        let image = UIImage.plus.resize(to: CGSize(width: 20, height: 20))
        let extraButton = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(extraButtonTapped))
        navigationItem.rightBarButtonItems = [rightButton!, extraButton]
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
        mainView?.achivements.append(achivement)
    }
    
    
    @objc func addButtonTapped() {
        let player = Player(name: mainView?.nameTextField?.text ?? "", age: mainView?.ageTextField?.text ?? "", height: mainView?.heightTextField?.text ?? "", weight: mainView?.weightTextField?.text ?? "", classesPerMonth: mainView?.classesTextField?.text ?? "", duration: mainView?.durationTextField?.text ?? "", image: mainView?.imageView.image ?? UIImage(), achivements: mainView?.achivements)
        
        athleteArr.append(player)
        
        // Сериализация массива в Data
        do {
            let data = try JSONEncoder().encode(athleteArr)
            try saveAthleteArrToFile(data: data)
            delegate?.updateArr(athleteArr: athleteArr)
            navigationController?.popViewController(animated: true)
        } catch {
            print("Failed to encode or save athleteArr: \(error)")
        }
    }
    
    
    func saveAthleteArrToFile(data: Data) throws {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("athleteArr.plist")
            try data.write(to: filePath)
        } else {
            throw NSError(domain: "SaveError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to get document directory"])
        }
    }
    
    
    func checkIfInputsAreValid() {
        let isValid = (mainView?.nameTextField?.text?.isEmpty == false) &&
        (mainView?.ageTextField?.text?.isEmpty == false) &&
        (mainView?.weightTextField?.text?.isEmpty == false) &&
        (mainView?.heightTextField?.text?.isEmpty == false) &&
        (mainView?.classesTextField?.text?.isEmpty == false) &&
        (mainView?.durationTextField?.text?.isEmpty == false) &&
        (mainView?.imageView.image != nil)
        
        toggleSaveButton(isOn: isValid)
    }

    func toggleSaveButton(isOn: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = isOn
    }

    
}


extension UINavigationController {
    func setTitleColor(_ color: UIColor) {
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
    }
}


extension AddNewPlayerViewController: AddNewPlayerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func toggleButton(isOn: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = isOn
    }
    
    
    func selectImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any] ) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            mainView?.imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
        
        checkIfInputsAreValid()
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

