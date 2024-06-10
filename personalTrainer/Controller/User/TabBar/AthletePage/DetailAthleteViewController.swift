//
//  DetailAthleteViewController.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 10.06.2024.
//

import UIKit

protocol DetailAthleteViewControllerProtocol: AnyObject {
    func savePlayer(player: Player)
}

class DetailAthleteViewController: UIViewController {
    
    weak var delegate: AthleteViewControllerDelegate?
    
    var athlete: Player?
    
    var index: Int?
    
    var rightButton: UIBarButtonItem?
    
    var playerImage: UIImageView?
    
    var nameLabel, ageLabel, weightLabel, heightLabel, classesLabel, durationLabel: UILabel?
    
    var achivementCollection: UICollectionView?
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.title = "Athlete"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsNavController()
        settingsView()
    }
    
    
    func settingsNavController() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.primary
        
        let imageTrash = UIImage.trash.resize(to: CGSize(width: 20, height: 20))
        rightButton = UIBarButtonItem(image: imageTrash, style: .done, target: self, action: #selector(delPlayer))
        
        let image = UIImage.pencil.resize(to: CGSize(width: 20, height: 20))
        let extraButton = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(editPlayer))
        navigationItem.rightBarButtonItems = [rightButton!, extraButton]
    }
    
    
    @objc func editPlayer() {
        let vc = EditPlayerViewController()
        vc.index = index
        vc.athlete = athlete
        vc.delegate = self  
        navigationController?.topViewController?.navigationItem.title = " "
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func delPlayer() {
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
        delegate?.delPlayer(index: index!)
        navigationController?.popViewController(animated: true)
        
    }
    

    func settingsView() {
        view.backgroundColor = .BG
        
        let topView: UIView = {
            let view = UIView()
            view.backgroundColor = .second
            view.layer.cornerRadius = 12
            return view
        }()
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(130)
            make.height.equalTo(165)
        }
        
        
        playerImage = {
            let image = UIImage(data: athlete?.imageData ?? Data())
            let imageView = UIImageView(image: image)
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 12
            return imageView
        }()
        topView.addSubview(playerImage ?? UIView())
        playerImage?.snp.makeConstraints({ make in
            make.left.top.bottom.equalToSuperview().inset(10)
            make.width.equalTo(130)
        })
        
        
        nameLabel = {
            let label = UILabel()
            label.text = athlete?.name
            label.textColor = .white
            label.font = .systemFont(ofSize: 22, weight: .bold)
            return label
        }()
        topView.addSubview(nameLabel ?? UIView())
        nameLabel?.snp.makeConstraints({ make in
            make.top.equalToSuperview().inset(10)
            make.left.equalTo((playerImage ?? UIView()).snp.right).inset(-10)
        })
        
        
        let separatorRectangle: UIView = {
            let view = UIView()
            view.backgroundColor = .primary
            return view
        }()
        topView.addSubview(separatorRectangle)
        separatorRectangle.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo((nameLabel ?? UIView()).snp.bottom).inset(-10)
            make.left.equalTo((playerImage ?? UIView()).snp.right).inset(-10)
            make.right.equalToSuperview().inset(10)
        }
        
        
        let ageTextlabel = createLabel(text: "Age", font: .systemFont(ofSize: 15), color: .white.withAlphaComponent(0.3))
        topView.addSubview(ageTextlabel)
        ageTextlabel.snp.makeConstraints { make in
            make.left.equalTo(separatorRectangle.snp.left)
            make.top.equalTo(separatorRectangle.snp.bottom).inset(-10)
        }
        
        
        ageLabel = createLabel(text: athlete?.age ?? "", font: .systemFont(ofSize: 15), color: .white)
        topView.addSubview(ageLabel ?? UIView())
        ageLabel?.snp.makeConstraints({ make in
            make.centerY.equalTo(ageTextlabel)
            make.left.equalTo(ageTextlabel.snp.right).inset(-10)
        })
        
        
        let weightTextlabel = createLabel(text: "Weight", font: .systemFont(ofSize: 15), color: .white.withAlphaComponent(0.3))
        topView.addSubview(weightTextlabel)
        weightTextlabel.snp.makeConstraints { make in
            make.left.equalTo(separatorRectangle.snp.left)
            make.top.equalTo(ageTextlabel.snp.bottom).inset(-10)
        }
        
        
        weightLabel = createLabel(text: athlete?.weight ?? "", font: .systemFont(ofSize: 15), color: .white)
        topView.addSubview(weightLabel ?? UIView())
        weightLabel?.snp.makeConstraints({ make in
            make.centerY.equalTo(weightTextlabel)
            make.left.equalTo(weightTextlabel.snp.right).inset(-10)
        })
        
        
        let heightTextlabel = createLabel(text: "Height", font: .systemFont(ofSize: 15), color: .white.withAlphaComponent(0.3))
        topView.addSubview(heightTextlabel)
        heightTextlabel.snp.makeConstraints { make in
            make.left.equalTo(separatorRectangle.snp.left)
            make.top.equalTo(weightTextlabel.snp.bottom).inset(-10)
        }
        
        
        heightLabel = createLabel(text: athlete?.height ?? "", font: .systemFont(ofSize: 15), color: .white)
        topView.addSubview(heightLabel ?? UIView())
        heightLabel?.snp.makeConstraints({ make in
            make.centerY.equalTo(heightTextlabel)
            make.left.equalTo(heightTextlabel.snp.right).inset(-10)
        })
        
        
        let rectangleOne: UIView = {
            let view = UIView()
            view.backgroundColor = .second
            view.layer.cornerRadius = 12
            return view
        }()
        
        let rectangleTwo: UIView = {
            let view = UIView()
            view.backgroundColor = .second
            view.layer.cornerRadius = 12
            return view
        }()
        
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            stackView.spacing = 15
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()

        stackView.addArrangedSubview(rectangleOne)
        stackView.addArrangedSubview(rectangleTwo)
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).inset(-20)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(79)
        }
        
        
        let classesTextLabel = createLabel(text: "Classes per mount", font: .systemFont(ofSize: 15), color: .white.withAlphaComponent(0.3))
        rectangleOne.addSubview(classesTextLabel)
        classesTextLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(15)
        }
        
        classesLabel = createLabel(text: athlete?.classesPerMonth ?? "", font: .systemFont(ofSize: 28, weight: .bold), color: .primary)
        rectangleOne.addSubview(classesLabel ?? UIView())
        classesLabel?.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-12)
        })
        
        
        let durationTextLabel = createLabel(text: "Duration", font: .systemFont(ofSize: 15), color: .white.withAlphaComponent(0.3))
        rectangleTwo.addSubview(durationTextLabel)
        durationTextLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(15)
        }
        
        durationLabel = createLabel(text: athlete?.duration ?? "", font: .systemFont(ofSize: 28, weight: .bold), color: .primary)
        rectangleTwo.addSubview(durationLabel ?? UIView())
        durationLabel?.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-12)
        })
        
        
        achivementCollection = {
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
        view.addSubview(achivementCollection ?? UIView())
        achivementCollection?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(rectangleTwo.snp.bottom).inset(-15)
            make.bottom.equalToSuperview()
        })
        
    }
    
    func createLabel(text: String, font: UIFont, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = color
        return label
    }

}


extension DetailAthleteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return athlete?.achivements?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        cell.backgroundColor = .second
        cell.layer.cornerRadius = 12
        
        var firstLabel = UILabel()
        firstLabel.text = athlete?.achivements?[indexPath.row].mainText
        firstLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        firstLabel.textColor = .primary
        cell.addSubview(firstLabel)
        firstLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(13)
        }
        
        
        var secondLabel = UILabel()
        secondLabel.text = athlete?.achivements?[indexPath.row].secondaryText
        secondLabel.font = .systemFont(ofSize: 15, weight: .regular)
        secondLabel.textColor = .white
        cell.addSubview(secondLabel)
        secondLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(13)
            make.top.equalTo(firstLabel.snp.bottom).inset(-2)
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height: CGFloat = 79
        return CGSize(width: width, height: height)
    }
    
}


extension DetailAthleteViewController: DetailAthleteViewControllerProtocol {
    
    func savePlayer(player: Player) {
        self.athlete = player
        achivementCollection?.reloadData()
        playerImage?.image = UIImage(data: player.imageData ?? Data())
        nameLabel?.text = player.name
        ageLabel?.text = player.age
        weightLabel?.text = player.weight
        heightLabel?.text = player.height
        classesLabel?.text = player.classesPerMonth
        durationLabel?.text = player.duration
        
        delegate?.updatePlayer(index: index!, player: player)
    }
    
}
