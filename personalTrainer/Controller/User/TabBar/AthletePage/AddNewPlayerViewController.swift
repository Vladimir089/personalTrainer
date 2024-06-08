//
//  AddNewPlayerViewController.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 08.06.2024.
//

import UIKit

protocol AddNewPlayerViewControllerDelegate: AnyObject {
    func selectImage()
}


class AddNewPlayerViewController: UIViewController {
    
    var athleteArr: [Player] = []
    
    var mainView: NewAthleteView?
    
    var rightButton: UIBarButtonItem?
    
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -100)
            self.mainView?.imageView.alpha = 0
            self.mainView?.selectButtonImage.alpha = 0
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = .identity
            self.mainView?.imageView.alpha = 1
            self.mainView?.selectButtonImage.alpha = 1
        }
    }
    
    
    func settingsNavController() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.primary
        rightButton = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addButtonTapped))
        rightButton?.isEnabled = false
        navigationItem.rightBarButtonItem = rightButton
    }
    
    
    @objc func addButtonTapped() {
        //ДОДЕЛАТЬ ДОБАВЛЕНИЕ ИГРОКА И АКТИВАЦИЮ КНОПКИ ЕСЛИ ВСЕ ДАННЫЕ ЗАПОЛНЕНЫ
    }
    
    
}


extension UINavigationController {
    func setTitleColor(_ color: UIColor) {
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: color]
    }
}


extension AddNewPlayerViewController: AddNewPlayerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func selectImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any] ) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // Обновляем imageView с выбранным изображением
            mainView?.imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

