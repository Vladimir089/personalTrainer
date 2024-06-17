//
//  EditAndNewEventViewController.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 12.06.2024.
//

import UIKit

class EditAndNewEventViewController: UIViewController {
    
    var isNew: Bool?
    
    var event: Event?
    
    var index: Int?
    
    var events: [Event] = []
    
    var players: [Player] = []
    
    weak var delegate: CalendarViewControllerDelegate?
    
    weak var editDelegate: DetailCalendarViewControllerDelegate?
    
    var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.backgroundColor = UIColor(red: 118/255, green: 118/255, blue: 128/255, alpha: 0.24)
        picker.layer.cornerRadius = 6
        picker.tintColor = .primary
        picker.clipsToBounds = true
        picker.overrideUserInterfaceStyle = .dark
        return picker
    }()
    
    
    
    
    var timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.backgroundColor = UIColor(red: 118/255, green: 118/255, blue: 128/255, alpha: 0.24)
        picker.layer.cornerRadius = 6
        picker.tintColor = .primary
        picker.clipsToBounds = true
        picker.overrideUserInterfaceStyle = .dark
        let locale = Locale(identifier: "en_US_POSIX")
        picker.locale = locale
        return picker
    }()
    
    var nameTextField, locationTextField, descriptionTextField, athleteTextField: UITextField?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isNew == false {
            editDelegate?.dein()
        }
        print(32)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        settingsNavController()
         
        var gestureHideKeyboard = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureHideKeyboard)
        view.backgroundColor = .BG
        creaeInterface()
        if isNew == true {
            title = "For personal events"
            addNewTraining()
        } else {
            title = "Edit"
            editTraining()
        }
    }
    
   


    
    @objc func hideKeyboard() {
        view.endEditing(true)
        print(12)
    }
    

    func settingsNavController() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.primary

    }
    
    
    func addNewTraining() {
        let rightButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(addButtonTapped))
        rightButton.isEnabled = false
        navigationItem.rightBarButtonItems = [rightButton]
    }
    
    
    func editTraining() {
        
        let rightButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(editButtonTapped))
        rightButton.isEnabled = false
        navigationItem.rightBarButtonItems = [rightButton]
        
        nameTextField?.text = event?.name ?? ""
        locationTextField?.text = event?.location ?? ""
        descriptionTextField?.text = event?.discriprion ?? ""
        players = event?.players ?? [Player]()
        datePicker.date = event?.date ?? Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a" // Формат строки даты для "12:00 AM"
        
        if let eventTime = event?.time, let eventDate = dateFormatter.date(from: eventTime) {
            timePicker.date = eventDate
        } else {
            timePicker.date = Date()
        }
        updateAthleteTextField()
    }
    
    
    @objc func editButtonTapped() {
        
        let event = Event(date: datePicker.date, time: getTimeFromPicker(), location: locationTextField?.text ?? "", discriprion: descriptionTextField?.text ?? "", players: players, name: nameTextField?.text ?? "")
        
        events[index!] = event
        
        do {
            let data = try JSONEncoder().encode(events)
            try saveEventArrToFile(data: data)
            editDelegate?.updateArr(events: events, event: event)
            navigationController?.popViewController(animated: true)
        } catch {
            print("Failed to encode or save trainingArr: \(error)")
        }
        
    }
    
    
    @objc func addButtonTapped() {
        
        let event = Event(date: datePicker.date, time: getTimeFromPicker(), location: locationTextField?.text ?? "", discriprion: descriptionTextField?.text ?? "", players: players, name: nameTextField?.text ?? "")

        events.append(event)

        do {
            let data = try JSONEncoder().encode(events)
            try saveEventArrToFile(data: data)
            delegate?.updateArr(events: events)
            navigationController?.popViewController(animated: true)
        } catch {
            print("Failed to encode or save trainingArr: \(error)")
        }
    }
    
    
    func getTimeFromPicker() -> String {
        let date = timePicker.date
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a" // "h" для 12-часового формата и "a" для AM/PM
        let timeString = formatter.string(from: date)
        return timeString
    }
    
    
    func saveEventArrToFile(data: Data) throws {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("eventAr.plist")
            try data.write(to: filePath)
        } else {
            throw NSError(domain: "SaveError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to get document directory"])
        }
    }
    
    
    func creaeInterface() {
        
        
        nameTextField = generateTextFields(labelText: "Name")
        view.addSubview(nameTextField ?? UITextField())
        nameTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(44)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
        })
        
        
        let dateAndTimeLabel: UILabel = {
            let label = UILabel()
            label.text = "Date and Time"
            label.textColor = .white
            label.font = .systemFont(ofSize: 15)
            return label
        }()
        view.addSubview(dateAndTimeLabel)
        dateAndTimeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo((nameTextField ?? UIView()).snp.bottom).inset(-20)
        }
        
        
      
        view.addSubview(datePicker)
        datePicker.snp.makeConstraints({ make in
            make.height.equalTo(34)
            make.left.equalTo(dateAndTimeLabel.snp.right).inset(-15)
            make.centerY.equalTo(dateAndTimeLabel)
        })
        
        
        view.addSubview(timePicker)
        timePicker.snp.makeConstraints { make in
            make.height.equalTo(34)
            make.centerY.equalTo(dateAndTimeLabel)
            make.left.equalTo(datePicker.snp.right).inset(-10)
        }
        
        
        locationTextField = generateTextFields(labelText: "Location")
        view.addSubview(locationTextField ?? UITextField())
        locationTextField?.snp.makeConstraints({ make in
            make.height.equalTo(44)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(timePicker.snp.bottom).inset(-15)
        })
        
        
        descriptionTextField = generateTextFields(labelText: "Description")
        view.addSubview(descriptionTextField ?? UITextField())
        descriptionTextField?.snp.makeConstraints({ make in
            make.height.equalTo(44)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo((locationTextField ?? UIView()).snp.bottom).inset(-15)
        })
        
        athleteTextField = generateTextFields(labelText: "Athlete")
        view.addSubview(athleteTextField ?? UITextField())
        athleteTextField?.snp.makeConstraints({ make in
            make.height.equalTo(44)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo((descriptionTextField ?? UIView()).snp.bottom).inset(-15)
        })
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
    
    deinit {
        print(1213)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print(2312)
    }
    
    
    @objc func showPlayersWindow() {
        let alertController = UIAlertController(title: "Select Players", message: nil, preferredStyle: .actionSheet)

        for player in playersArr {
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
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func togglePlayerSelection(player: Player) {
        if let index = players.firstIndex(where: { $0.name == player.name }) {
            players.remove(at: index)
        } else {
            players.append(player)
        }
        updateAthleteTextField()
        hideKeyboard()
    }
    
    
    func updateAthleteTextField() {
        let playerNames = players.map { $0.name }.joined(separator: ", ")
        athleteTextField?.text = playerNames
        updateSaveButtonState()
    }
    
    
    func validateFields() -> Bool {
        guard let name = nameTextField?.text, !name.isEmpty,
              let location = locationTextField?.text, !location.isEmpty,
              let description = descriptionTextField?.text, !description.isEmpty,
              let athlete = athleteTextField?.text, !athlete.isEmpty else {
            return false
        }
        return true
    }
    
    
    func updateSaveButtonState() {
        if let rightButton = navigationItem.rightBarButtonItems?.first {
            rightButton.isEnabled = validateFields()
        }
    }

}


extension EditAndNewEventViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
 
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == athleteTextField {
            showPlayersWindow()
            textField.resignFirstResponder()
            hideKeyboard()
            return false
        }
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        defer {
            updateSaveButtonState()
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == athleteTextField {
            showPlayersWindow()
            textField.resignFirstResponder()
        }
        updateSaveButtonState()
    }
}
