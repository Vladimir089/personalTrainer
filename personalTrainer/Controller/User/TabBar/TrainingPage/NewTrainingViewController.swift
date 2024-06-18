//
//  NewTrainingViewController.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 11.06.2024.
//

import UIKit

class NewTrainingViewController: UIViewController {
    
    weak var delegate: TrainingViewControllerDelegate?
    
    var isNew: Bool?
    
    var training: Training?
    
    var nameTrainingTextField, repetitionsTextField, ApproachesTextFiel: UITextField?
    
    var exercisesLabel: UILabel?
    
    var collectionView: UICollectionView?
    
    var exercisesArr: [Exercises] = [Exercises(name: "", repetitions: "", approaches: "", weight: "")]
    
    var trainingArr: [Training] = []
    
    var players: [Player] = []
    
    var index: Int?
    
    weak var editDelegate: DetailTrainingViewControllerDelegate?
    
    
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
    
   
    

    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        editDelegate?.changeTitle()

    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        
        UIView.animate(withDuration: 0.3) {
            self.collectionView?.contentInset = insets
            self.collectionView?.scrollIndicatorInsets = insets
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let insets = UIEdgeInsets.zero
        
        UIView.animate(withDuration: 0.3) {
            self.collectionView?.contentInset = insets
            self.collectionView?.scrollIndicatorInsets = insets
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        settingsNavController()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BG
        
        if isNew == true {
            title = "New personal program"
            addNewTraining()
        } else {
            title = training?.name
            editTraining()
        }
        var gestureHideKeyboard = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureHideKeyboard)
        createInterface()
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
        print(12)
    }
    
    
    func settingsNavController() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.primary

    }
    
    
    @objc func showPlayersWindow() {
        let alertController = UIAlertController(title: "Select Players", message: nil, preferredStyle: .actionSheet)

        for player in playersArr {
            print(player.name)
            let action = UIAlertAction(title: player.name, style: .default) { _ in
                self.togglePlayerSelection(player: player)
            }
            if players.contains(where: { $0.name == player.name }) {
                action.setValue(UIImage(systemName: "checkmark"), forKey: "image")
            }
            alertController.addAction(action)
        }
            
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        // Настройка места отображения для iPad
        if let popoverController = alertController.popoverPresentationController {
            popoverController.barButtonItem = self.navigationItem.rightBarButtonItems?.last // или другой UIBarButtonItem, откуда должен появиться ActionSheet
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
            
        present(alertController, animated: true, completion: nil)
    }
    
    
    func togglePlayerSelection(player: Player) {
        if let index = players.firstIndex(where: { $0.name == player.name }) {
            players.remove(at: index)
        } else {
            players.append(player)
        }
    }
    
    
    
    
    func addNewTraining() {
        let rightButton = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addButtonTapped))
        rightButton.isEnabled = false
        
        let image = UIImage.plus.resize(to: CGSize(width: 20, height: 20))
        
        let extraButton = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(extraButtonTapped))
        
        let playersButton = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(showPlayersWindow))

        navigationItem.rightBarButtonItems = [rightButton, extraButton, playersButton]
    }
    
    
    func editTraining() {
        let rightButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButton))
        rightButton.isEnabled = true
        
        let image = UIImage.plus.resize(to: CGSize(width: 20, height: 20))
        let extraButton = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(extraButtonTapped))
        
        let playersButton = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(showPlayersWindow))
        
        navigationItem.rightBarButtonItems = [rightButton, extraButton, playersButton]
        
        exercisesArr = training?.exercises ?? [Exercises(name: "", repetitions: "", approaches: "", weight: "")]
        
        players = training?.players ?? [Player]()
        
       
    }
    
   
    
    @objc func saveButton() {
        let training = Training(name: nameTrainingTextField?.text ?? "", image: imageView.image ?? UIImage(), repetitions: repetitionsTextField?.text ?? "", approaches: ApproachesTextFiel?.text ?? "", players: players, exercises: exercisesArr)
        
        editDelegate?.saveTraining(index: index!, training: training)
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func addButtonTapped() {
       
        let training = Training(name: nameTrainingTextField?.text ?? "", image: imageView.image ?? UIImage(), repetitions: repetitionsTextField?.text ?? "", approaches: ApproachesTextFiel?.text ?? "", players: players, exercises: exercisesArr)

        trainingArr.append(training)

        // Сериализация массива в Data
        do {
            let data = try JSONEncoder().encode(trainingArr)
            try saveTrainingArrToFile(data: data)
            delegate?.updateArr(trainingArr: trainingArr)
            navigationController?.popViewController(animated: true)
        } catch {
            print("Failed to encode or save trainingArr: \(error)")
        }
    }
    
    
    func saveTrainingArrToFile(data: Data) throws {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("triningArr.plist")
            try data.write(to: filePath)
        } else {
            throw NSError(domain: "SaveError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to get document directory"])
        }
    }

    
    
    
    
    @objc func extraButtonTapped() { //добавление
        let newExercise = Exercises(name: "", repetitions: "", approaches: "", weight: "")
        exercisesArr.append(newExercise)
        collectionView?.reloadData()
    }
    
    
    func createInterface() {
        
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
        
        
        nameTrainingTextField = generateTextFields(labelText: "Name")
        view.addSubview(nameTrainingTextField ?? UIView())
        nameTrainingTextField?.snp.makeConstraints({ make in
            make.left.right.equalTo(imageView)
            make.height.equalTo(44)
            make.top.equalTo(imageView.snp.bottom).inset(-15)
        })
        
        repetitionsTextField = generateTextFields(labelText: "Repetitions")
        ApproachesTextFiel = generateTextFields(labelText: "Approaches")
        
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            stackView.spacing = 15
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()

        stackView.addArrangedSubview(repetitionsTextField ?? UIView())
        stackView.addArrangedSubview(ApproachesTextFiel ?? UIView())
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo((nameTrainingTextField ?? UIView()).snp.bottom).inset(-15)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(44)
        }
        
        
        exercisesLabel = {
            let label = UILabel()
            label.text = "Exercises"
            label.textColor = .white
            label.font = .systemFont(ofSize: 22, weight: .bold)
            return label
        }()
        view.addSubview(exercisesLabel ?? UIView())
        exercisesLabel?.snp.makeConstraints({ make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(stackView.snp.bottom).inset(-15)
        })
        
        
        collectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.backgroundColor = .white
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.backgroundColor = .BG
            collectionView.showsVerticalScrollIndicator = false
            return collectionView
        }()
        view.addSubview(collectionView ?? UIView())
        collectionView?.snp.makeConstraints({ make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo((exercisesLabel ?? UIView()).snp.bottom).inset(-15)
        })
        
        
        nameTrainingTextField?.text = training?.name ?? ""
        
        repetitionsTextField?.text = training?.repetitions ?? ""
        
        ApproachesTextFiel?.text = training?.approaches ?? ""
        
        imageView.image = UIImage(data: training?.imageData ?? Data())
        
    }
    
    
    
    
    
    @objc func selectImage() {
        selectImage1()
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

}


extension NewTrainingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
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
        checkIfInputsAreValid()
    }
    
    
    func checkIfInputsAreValid() {
            // Проверка, установлено ли изображение
            guard imageView.image != nil else {
                navigationItem.rightBarButtonItem?.isEnabled = false
                return
            }
            
            // Проверка, заполнены ли все текстовые поля
            if let name = nameTrainingTextField?.text, name.isEmpty == false,
               let repetitions = repetitionsTextField?.text, repetitions.isEmpty == false,
               let approaches = ApproachesTextFiel?.text, approaches.isEmpty == false {
                
                for exercise in exercisesArr {
                    if exercise.name.isEmpty || exercise.repetitions.isEmpty ||
                       exercise.approaches.isEmpty || exercise.weight.isEmpty {
                        navigationItem.rightBarButtonItem?.isEnabled = false
                        return
                    }
                }
                
                // Если все текстовые поля заполнены, включаем кнопку
                navigationItem.rightBarButtonItem?.isEnabled = true
            } else {
                navigationItem.rightBarButtonItem?.isEnabled = false
            }
        }
}



extension NewTrainingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        checkIfInputsAreValid()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let index = textField.tag / 4
        let fieldIndex = textField.tag % 4
        
        switch fieldIndex {
        case 0:
            exercisesArr[index].name = textField.text ?? ""
        case 1:
            exercisesArr[index].repetitions = textField.text ?? ""
        case 2:
            exercisesArr[index].approaches = textField.text ?? ""
        case 3:
            exercisesArr[index].weight = textField.text ?? ""
        default:
            break
        }
        checkIfInputsAreValid()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkIfInputsAreValid()
        return true
    }
    
}


extension NewTrainingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exercisesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        
        let nameTextField = generateTextFields(labelText: "Name")
        nameTextField.text = exercisesArr[indexPath.item].name
        nameTextField.delegate = self
        nameTextField.tag = indexPath.item * 4 + 0
        cell.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        let repetitionsTextField = generateTextFields(labelText: "Repetitions")
        repetitionsTextField.text = exercisesArr[indexPath.item].repetitions
        repetitionsTextField.delegate = self
        repetitionsTextField.tag = indexPath.item * 4 + 1
        cell.addSubview(repetitionsTextField)
        repetitionsTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.left.right.equalToSuperview()
            make.top.equalTo(nameTextField.snp.bottom).inset(-15)
        }
        
        let approachesTextField = generateTextFields(labelText: "Approaches")
        approachesTextField.text = exercisesArr[indexPath.item].approaches
        approachesTextField.delegate = self
        approachesTextField.tag = indexPath.item * 4 + 2
        cell.addSubview(approachesTextField)
        approachesTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.left.right.equalToSuperview()
            make.top.equalTo(repetitionsTextField.snp.bottom).inset(-15)
        }
        
        let weightTextField = generateTextFields(labelText: "Weight")
        weightTextField.text = exercisesArr[indexPath.item].weight
        weightTextField.delegate = self
        weightTextField.tag = indexPath.item * 4 + 3
        cell.addSubview(weightTextField)
        weightTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.left.right.equalToSuperview()
            make.top.equalTo(approachesTextField.snp.bottom).inset(-15)
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 240)
    }
    
}
