//
//  RatingView.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 13.06.2024.
//

import UIKit

class RatingView: UIView {
    
    var firstView: UIView?
    
    var rating: [Rating] = []
    
    weak var delegate: RatingViewControllerDelegate?
    
    var collectionView: UICollectionView?
    
    var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.plus, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        settingsView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func settingsView() {
        backgroundColor = .BG
        
        addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.right.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(60)
        }
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "Rating"
            label.textColor = .white
            label.font = .systemFont(ofSize: 34, weight: .bold)
            return label
        }()
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(40)
            make.left.equalToSuperview().inset(15)
        }
        
        
        firstView = {
            let view = UIView()
            view.backgroundColor = .clear
            return view
        }()
        addSubview(firstView ?? UIView())
        firstView?.snp.makeConstraints({ make in
            make.width.equalTo(228)
            make.height.equalTo(130)
            make.centerY.centerX.equalToSuperview()
        })
        
        
        let calendarLabel: UILabel = {
            let label = UILabel()
            label.text = "Rating athletes"
            label.textColor = .white
            label.font = .systemFont(ofSize: 28, weight: .semibold)
            return label
        }()
        firstView?.addSubview(calendarLabel)
        calendarLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        let psLabel: UILabel = {
            let label = UILabel()
            label.text = "Here you can leave ratings for athletes"
            label.numberOfLines = 2
            label.textColor = .white.withAlphaComponent(0.3)
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 15)
            return label
        }()
        firstView?.addSubview(psLabel)
        psLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(calendarLabel.snp.bottom).inset(-5)
            make.left.right.equalToSuperview().inset(25)
        }
        
        
        let addTrainingButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Click to add new rating", for: .normal)
            button.setImage(UIImage(named: "plus")?.resize(to: CGSize(width: 20, height: 20)), for: .normal)
            button.semanticContentAttribute = .forceLeftToRight
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
            button.addTarget(self, action: #selector(newRating), for: .touchUpInside)
            button.backgroundColor = .primary
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
            button.tintColor = .white
            button.layer.cornerRadius = 12
            return button
        }()
        firstView?.addSubview(addTrainingButton)
        addTrainingButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(40)
            make.left.right.equalToSuperview()
        }
        
        
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
        addSubview(collectionView ?? UIView())
        collectionView?.snp.makeConstraints({ make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(titleLabel.snp.bottom).inset(-15)
        })
        
        
    }
    
    
    func checkArray() {
        if rating.count == 0 {
            collectionView?.alpha = 0
            addButton.alpha = 0
        } else {
            collectionView?.alpha = 1
            addButton.addTarget(self, action: #selector(newRating), for: .touchUpInside)
            addButton.alpha = 1
            collectionView?.reloadData()
            
        }
    }
    
    
    @objc func newRating() {
        delegate?.createRating()
    }
    
    
    
}


extension RatingView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rating.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        cell.backgroundColor = UIColor(red: 35/255, green: 36/255, blue: 43/255, alpha: 1)
        cell.layer.cornerRadius = 12
        
        
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        nameLabel.textColor = .white
        nameLabel.text = rating[indexPath.row].name
        cell.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(10)
        }
        
        let ratingTextLabel = UILabel()
        ratingTextLabel.text = "Activity rating"
        ratingTextLabel.font = .systemFont(ofSize: 13)
        ratingTextLabel.textColor = .white
        cell.addSubview(ratingTextLabel)
        ratingTextLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(nameLabel.snp.bottom).inset(-8)
        }
        
        
        let image = UIImage(systemName: "star.fill")?.resize(to: CGSize(width: 24, height: 23))?.withRenderingMode(.alwaysTemplate)
        
        
        var oneImageView = UIImageView(image: image)
        oneImageView.tintColor = .white.withAlphaComponent(0.3)
        var twoImageView = UIImageView(image: image)
        twoImageView.tintColor = .white.withAlphaComponent(0.3)
        var threeImageView = UIImageView(image: image)
        threeImageView.tintColor = .white.withAlphaComponent(0.3)
        var fourImageView = UIImageView(image: image)
        fourImageView.tintColor = .white.withAlphaComponent(0.3)
        var fiveImageView = UIImageView(image: image)
        fiveImageView.tintColor = .white.withAlphaComponent(0.3)
        
        
        cell.addSubview(oneImageView)
        oneImageView.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(23)
            make.left.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(10)
        }
        
        cell.addSubview(twoImageView)
        twoImageView.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(23)
            make.left.equalTo(oneImageView.snp.right).inset(-5)
            make.bottom.equalToSuperview().inset(10)
        }
        
        cell.addSubview(threeImageView)
        threeImageView.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(23)
            make.left.equalTo(twoImageView.snp.right).inset(-5)
            make.bottom.equalToSuperview().inset(10)
        }
        
        cell.addSubview(fourImageView)
        fourImageView.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(23)
            make.left.equalTo(threeImageView.snp.right).inset(-5)
            make.bottom.equalToSuperview().inset(10)
        }
        
        cell.addSubview(fiveImageView)
        fiveImageView.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(23)
            make.left.equalTo(fourImageView.snp.right).inset(-5)
            make.bottom.equalToSuperview().inset(10)
        }
        
        
        switch rating[indexPath.row].rate {
        case 1:
            oneImageView.tintColor = .primary
            twoImageView.tintColor = .white.withAlphaComponent(0.3)
            threeImageView.tintColor = .white.withAlphaComponent(0.3)
            fourImageView.tintColor = .white.withAlphaComponent(0.3)
            fiveImageView.tintColor = .white.withAlphaComponent(0.3)
        case 2:
            oneImageView.tintColor = .primary
            twoImageView.tintColor = .primary
            threeImageView.tintColor = .white.withAlphaComponent(0.3)
            fourImageView.tintColor = .white.withAlphaComponent(0.3)
            fiveImageView.tintColor = .white.withAlphaComponent(0.3)
        case 3:
            oneImageView.tintColor = .primary
            twoImageView.tintColor = .primary
            threeImageView.tintColor = .primary
            fourImageView.tintColor = .white.withAlphaComponent(0.3)
            fiveImageView.tintColor = .white.withAlphaComponent(0.3)
        case 4:
            oneImageView.tintColor = .primary
            twoImageView.tintColor = .primary
            threeImageView.tintColor = .primary
            fourImageView.tintColor = .primary
            fiveImageView.tintColor = .white.withAlphaComponent(0.3)
        case 5:
            oneImageView.tintColor = .primary
            twoImageView.tintColor = .primary
            threeImageView.tintColor = .primary
            fourImageView.tintColor = .primary
            fiveImageView.tintColor = .primary
        default:
            break
        }
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 94)
    }
}
