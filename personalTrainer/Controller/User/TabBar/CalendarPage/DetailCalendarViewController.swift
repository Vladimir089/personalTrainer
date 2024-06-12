//
//  DetailCalendarViewController.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 12.06.2024.
//

import UIKit

protocol DetailCalendarViewControllerDelegate: AnyObject {
    func updateArr(events: [Event], event: Event)
    func dein()
}

class DetailCalendarViewController: UIViewController {
    
    weak var delegate: CalendarViewControllerDelegate?
    
    var event: Event?
    
    var index: Int?
    
    var events: [Event] = []
    
    var collectionView: UICollectionView?
    
    var nameLabel, dateLabel, timeLabel, locationLabel, descriptionLabel, athleteLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .BG
        settingsView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Events"
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.primary

        let imageTrash = UIImage.trash.resize(to: CGSize(width: 20, height: 20))
        let rightButton = UIBarButtonItem(image: imageTrash, style: .done, target: self, action: #selector(delEvent))
        
        let image = UIImage.pencil.resize(to: CGSize(width: 20, height: 20))
        let extraButton = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(editPlayer))
        navigationItem.rightBarButtonItems = [rightButton, extraButton]
    }
    
    @objc func editPlayer() {
        let vc = EditAndNewEventViewController()
        vc.index = index
        vc.events = events
        vc.event = event
        vc.editDelegate = self
        vc.isNew = false
        navigationController?.topViewController?.navigationItem.title = ""
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func delEvent() {
        let alertController = UIAlertController(title: "Delete", message: "Are you sure you want to delete?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.deleteSelectedPlayer()
        }
        
        let cancelAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteSelectedPlayer() {
        delegate?.deleteItem(idnex: index!, item: event!)
        navigationController?.popViewController(animated: true)
        
    }
    
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }

 
    func settingsView() {
        
        nameLabel = createLabel(text: event?.name ?? "", isBlue: false, font: .systemFont(ofSize: 34, weight: .bold))
        view.addSubview(nameLabel ?? UIView())
        nameLabel?.textAlignment = .left
        nameLabel?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
        })
        
        let dateTextLabel = createLabel(text: "Date", isBlue: false, font: .systemFont(ofSize: 20, weight: .bold))
        view.addSubview(dateTextLabel)
        dateTextLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo((nameLabel ?? UIView()).snp.bottom).inset(-15)
        }
        
        dateLabel = createLabel(text: "• \(formatDate(event?.date ?? Date()))", isBlue: true, font: .systemFont(ofSize: 20, weight: .bold))
        view.addSubview(dateLabel ?? UIView())
        dateLabel?.snp.makeConstraints({ make in
            make.bottom.equalTo(dateTextLabel.snp.bottom)
            make.left.equalTo(dateTextLabel.snp.right).inset(-5)
        })
        
        
        let timeTextLabel = createLabel(text: "Time", isBlue: false, font: .systemFont(ofSize: 20, weight: .bold))
        view.addSubview(timeTextLabel)
        timeTextLabel.snp.makeConstraints { make in
            make.left.equalTo((dateLabel ?? UIView()).snp.right).inset(-25)
            make.bottom.equalTo(dateTextLabel.snp.bottom)
        }
        
        
        timeLabel = createLabel(text: "• \(event?.time ?? "")", isBlue: true, font: .systemFont(ofSize: 20, weight: .bold))
        view.addSubview(timeLabel ?? UIView())
        timeLabel?.snp.makeConstraints({ make in
            make.bottom.equalTo(timeTextLabel.snp.bottom)
            make.left.equalTo(timeTextLabel.snp.right).inset(-5)
        })
        
        
        let locationTextLabel = createLabel(text: "Location", isBlue: false, font: .systemFont(ofSize: 20, weight: .bold))
        view.addSubview(locationTextLabel)
        locationTextLabel.snp.makeConstraints { make in
            make.top.equalTo(dateTextLabel.snp.bottom).inset(-15)
            make.left.equalToSuperview().inset(15)
        }
        
        
        locationLabel = createLabel(text: "• \(event?.location ?? "")", isBlue: true, font: .systemFont(ofSize: 20, weight: .bold))
        view.addSubview(locationLabel ?? UIView())
        locationLabel?.textAlignment = .left
        locationLabel?.numberOfLines = 0
        locationLabel?.snp.makeConstraints({ make in
            make.bottom.equalTo(locationTextLabel.snp.bottom)
            make.left.equalTo(locationTextLabel.snp.right).inset(-5)
            make.right.equalToSuperview().inset(15)
        })
        
        
        let descriptionTextLabel = createLabel(text: "Description", isBlue: true, font: .systemFont(ofSize: 17, weight: .semibold))
        view.addSubview(descriptionTextLabel)
        descriptionTextLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo((locationLabel ?? UIView()).snp.bottom).inset(-25)
        }
        
        
        descriptionLabel = createLabel(text: event?.discriprion ?? "", isBlue: false, font: .systemFont(ofSize: 15, weight: .regular))
        view.addSubview(descriptionLabel ?? UIView())
        descriptionLabel?.numberOfLines = 2
        descriptionLabel?.textAlignment = .left
        descriptionLabel?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(descriptionTextLabel.snp.bottom).inset(-15)
        })
        
        
        athleteLabel = createLabel(text: athleteOrTeamText(), isBlue: true, font: .systemFont(ofSize: 17, weight: .semibold))
        view.addSubview(athleteLabel ?? UIView())
        athleteLabel?.snp.makeConstraints({ make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo((descriptionLabel ?? UIView()).snp.bottom).inset(-25)
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
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo((athleteLabel ?? UIView()).snp.bottom).inset(-15)
            make.bottom.equalToSuperview()
        })
        
    }
    
    
    func athleteOrTeamText() -> String {
        var text = ""
        if event?.players.count ?? 0 <= 1 {
            text = "Athlete"
        } else {
            text = "Team"
        }
        return text
    }
    
    
    func createLabel(text: String, isBlue: Bool, font: UIFont) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        if isBlue == true {
            label.textColor = .primary
        } else {
            label.textColor = .white
        }
        return label
    }
    
    
    
}

extension DetailCalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return event?.players.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        
        cell.backgroundColor = UIColor(red: 35/255, green: 36/255, blue: 43/255, alpha: 1)
        cell.layer.cornerRadius = 12
        
        let image = UIImage(data: event?.players[indexPath.row].imageData ?? Data())
        let imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = 22.5
        imageView.clipsToBounds = true
        cell.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(45)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(20)
        }
        
        let nameLabel = UILabel()
        nameLabel.text = event?.players[indexPath.row].name
        nameLabel.font = .systemFont(ofSize: 17)
        nameLabel.textColor = .white
        cell.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(imageView.snp.right).inset(-10)
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 65)
    }
    
    
}


extension DetailCalendarViewController: DetailCalendarViewControllerDelegate {
    
    func updateArr(events: [Event], event: Event) {
        delegate?.updateArr(events: events)
        self.event = event
        collectionView?.reloadData()
        nameLabel?.text = event.name
        dateLabel?.text = "• \(formatDate(event.date))"
        timeLabel?.text = "• \(event.time)"
        locationLabel?.text = "• \(event.location )"
        descriptionLabel?.text = event.discriprion
        athleteLabel?.text = athleteOrTeamText()
    }
    
    func dein() {
        title = "Edit"
    }
    
}
