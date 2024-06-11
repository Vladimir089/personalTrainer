//
//  TrainingView.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 11.06.2024.
//

import UIKit

class TrainingView: UIView {

    var firstView: UIView?
    
    var trainingArr: [Training] = []
    
    var collectionTrainingArr: [(String, UIImage)] = []
    
    weak var delegate: TrainingViewControllerDelegate?
    
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
        backgroundColor = .BG
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func settingsView() {
        
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "Training"
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
        
        
        let trainingProgramsLabel: UILabel = {
            let label = UILabel()
            label.text = "Training programs"
            label.textColor = .white
            label.font = .systemFont(ofSize: 28, weight: .semibold)
            return label
        }()
        firstView?.addSubview(trainingProgramsLabel)
        trainingProgramsLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        let psLabel: UILabel = {
            let label = UILabel()
            label.text = "Here will be your training programs for sportsman"
            label.numberOfLines = 2
            label.textColor = .white.withAlphaComponent(0.3)
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 15)
            return label
        }()
        firstView?.addSubview(psLabel)
        psLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(trainingProgramsLabel.snp.bottom).inset(-5)
            make.left.right.equalToSuperview().inset(18)
        }
        
        
        let addTrainingButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Click to add new training", for: .normal)
            button.setImage(UIImage(named: "plus")?.resize(to: CGSize(width: 20, height: 20)), for: .normal)
            button.semanticContentAttribute = .forceLeftToRight
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
            button.addTarget(self, action: #selector(newTraining), for: .touchUpInside)
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
        
        addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.right.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(60)
        }
        

    }
    
    @objc func newTraining() {
        delegate?.createTraining()
    }
    
    
    func checkArray() {
        collectionTrainingArr.removeAll()
        if trainingArr.count == 0 {
            collectionView?.alpha = 0
            addButton.alpha = 0
        } else {
            collectionView?.alpha = 1
            addButton.addTarget(self, action: #selector(newTraining), for: .touchUpInside)
            addButton.alpha = 1
            
            for i in trainingArr {
                let image = UIImage(data: i.imageData ?? Data())
                collectionTrainingArr.append((i.name, image!))
            }
            
            collectionView?.reloadData()
            
        }
    }
    
    
    
}

extension TrainingView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionTrainingArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        cell.backgroundColor = .second
        cell.layer.cornerRadius = 12
        
        let image = collectionTrainingArr[indexPath.row].1
        let imageView = UIImageView(image: image)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        cell.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.leading.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(45)
        }
        
        let nameLabel = UILabel()
        nameLabel.text = collectionTrainingArr[indexPath.row].0
        nameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        nameLabel.textColor = .white
        cell.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(13)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.showDetail(training: trainingArr[indexPath.row], index: indexPath.row)
    }
    

    
    
}
 
