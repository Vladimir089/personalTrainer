//
//  DetailTrainingViewController.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 11.06.2024.
//

import UIKit

protocol DetailTrainingViewControllerDelegate : AnyObject {
    func saveTraining(index: Int, training: Training)
    func changeTitle()
}

class DetailTrainingViewController: UIViewController {
    
    var training: Training?
    
    var index: Int?
    
    var imageView: UIImageView?
    
    var repetitionsLabel, approachesLabel, repetitionsTextLabel, approachesTextLabel: UILabel?
    
    var collectionView: UICollectionView?
    
    weak var delegate: TrainingViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BG
        settingsView()
        title = training?.name
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Восстанавливаем заголовок
        title = training?.name
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.primary

        let imageTrash = UIImage.trash.resize(to: CGSize(width: 20, height: 20))
        let rightButton = UIBarButtonItem(image: imageTrash, style: .done, target: self, action: #selector(delPlayer))
        
        let image = UIImage.pencil.resize(to: CGSize(width: 20, height: 20))
        let extraButton = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(editPlayer))
        navigationItem.rightBarButtonItems = [rightButton, extraButton]
    }
    
    
    @objc func editPlayer() {
        let vc = NewTrainingViewController()
        vc.index = index
        vc.training = training
        vc.editDelegate = self
        vc.isNew = false
        navigationController?.topViewController?.navigationItem.title = ""
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
        delegate?.deleteItem(idnex: index!, item: training!)
        navigationController?.popViewController(animated: true)
        
    }
    
    
    func settingsView() {
        
        imageView = {
            let image = UIImage(data: training?.imageData ?? Data())
            let imageView = UIImageView(image: image)
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 12
            return imageView
        }()
        view.addSubview(imageView ?? UIView())
        imageView?.snp.makeConstraints({ make in
            make.top.equalToSuperview().inset(130)
            make.height.equalTo(118)
            make.left.right.equalToSuperview().inset(15)
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
            make.top.equalTo((imageView ?? UIView()).snp.bottom).inset(-10)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(79)
        }
        
        
        repetitionsLabel = {
            let label = UILabel()
            label.text = training?.repetitions
            label.textColor = .primary
            label.font = .systemFont(ofSize: 28, weight: .bold)
            return label
        }()
        rectangleOne.addSubview(repetitionsLabel ?? UIView())
        repetitionsLabel?.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-12)
        })
        
        repetitionsTextLabel = {
            let label = UILabel()
            label.text = "Repetitions"
            label.textColor = .white.withAlphaComponent(0.3)
            label.font = .systemFont(ofSize: 15)
            return label
        }()
        rectangleOne.addSubview(repetitionsTextLabel ?? UIView())
        repetitionsTextLabel?.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(15)
        })
        
        
        approachesLabel = {
            let label = UILabel()
            label.text = training?.approaches
            label.textColor = .primary
            label.font = .systemFont(ofSize: 28, weight: .bold)
            return label
        }()
        rectangleTwo.addSubview(approachesLabel ?? UIView())
        approachesLabel?.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-12)
        })
        
        approachesTextLabel = {
            let label = UILabel()
            label.text = "Approaches"
            label.textColor = .white.withAlphaComponent(0.3)
            label.font = .systemFont(ofSize: 15)
            return label
        }()
        rectangleTwo.addSubview(approachesTextLabel ?? UIView())
        approachesTextLabel?.snp.makeConstraints({ make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(15)
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
            collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
            return collectionView
        }()
        view.addSubview(collectionView ?? UIView())
        collectionView?.snp.makeConstraints({ make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(stackView.snp.bottom).inset(-10)
        })
    }
    
    
    
    
    
}



extension DetailTrainingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return training?.players?.count ?? 0
        } else {
            return training?.exercises?.count ?? 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        cell.backgroundColor = .second
        
        if indexPath.section == 0 {
            let image = UIImage(data: training?.players?[indexPath.row].imageData ?? Data())
            let imageView = UIImageView(image: image)
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 22.5
            cell.layer.cornerRadius = 12
            cell.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().inset(20)
                make.width.height.equalTo(46)
            }
            
            let label = UILabel()
            label.text = training?.players?[indexPath.row].name
            label.textColor = .white
            label.font  = .systemFont(ofSize: 17)
            cell.addSubview(label)
            label.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalTo(imageView.snp.right).inset(-10)
            }
            
            
        } else {
            let nameLabel = UILabel()
            cell.layer.cornerRadius = 12
            nameLabel.text = training?.exercises?[indexPath.row].name ?? ""
            nameLabel.textColor = .white
            nameLabel.font = .systemFont(ofSize: 20, weight: .bold)
            cell.addSubview(nameLabel)
            nameLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(25)
                make.top.equalToSuperview().inset(15)
            }
            
            let rectangleOne: UIView = {
                let view = UIView()
                let label = UILabel()
                label.text = training?.exercises?[indexPath.row].repetitions ?? ""
                label.font = .systemFont(ofSize: 28, weight: .bold)
                label.textColor = .primary
                view.addSubview(label)
                label.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.centerY.equalToSuperview().offset(-15)
                }
                let textLabel = UILabel()
                textLabel.text = "Repetitions"
                textLabel.textColor = .white.withAlphaComponent(0.3)
                textLabel.font = .systemFont(ofSize: 15)
                view.addSubview(textLabel)
                textLabel.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.centerY.equalToSuperview().offset(15)
                }
                let sepView = UIView()
                sepView.backgroundColor = .white.withAlphaComponent(0.3)
                view.addSubview(sepView)
                sepView.snp.makeConstraints { make in
                    make.height.equalTo(48)
                    make.width.equalTo(1)
                    make.right.equalToSuperview()
                    make.centerY.equalToSuperview().offset(-3)
                }
                return view
            }()
            
            
            let rectangleTwo: UIView = {
                let view = UIView()
                let label = UILabel()
                label.text = training?.exercises?[indexPath.row].approaches ?? ""
                label.font = .systemFont(ofSize: 28, weight: .bold)
                label.textColor = .primary
                view.addSubview(label)
                label.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.centerY.equalToSuperview().offset(-15)
                }
                let textLabel = UILabel()
                textLabel.text = "Approaches"
                textLabel.textColor = .white.withAlphaComponent(0.3)
                textLabel.font = .systemFont(ofSize: 15)
                view.addSubview(textLabel)
                textLabel.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.centerY.equalToSuperview().offset(15)
                }
                
                return view
            }()
            
            let rectangleThree: UIView = {
                let view = UIView()
                let label = UILabel()
                label.text = training?.exercises?[indexPath.row].weight ?? ""
                label.font = .systemFont(ofSize: 28, weight: .bold)
                label.textColor = .primary
                view.addSubview(label)
                label.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.centerY.equalToSuperview().offset(-15)
                }
                let textLabel = UILabel()
                textLabel.text = "Weight"
                textLabel.textColor = .white.withAlphaComponent(0.3)
                textLabel.font = .systemFont(ofSize: 15)
                view.addSubview(textLabel)
                textLabel.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.centerY.equalToSuperview().offset(15)
                }
                let sepView = UIView()
                sepView.backgroundColor = .white.withAlphaComponent(0.3)
                view.addSubview(sepView)
                sepView.snp.makeConstraints { make in
                    make.height.equalTo(48)
                    make.width.equalTo(1)
                    make.left.equalToSuperview().inset(3)
                    make.centerY.equalToSuperview().offset(-3)
                }
                return view
            }()
            
            let stackView: UIStackView = {
                let stackView = UIStackView()
                stackView.axis = .horizontal
                stackView.alignment = .fill
                stackView.distribution = .fillEqually
                stackView.spacing = 1
                stackView.translatesAutoresizingMaskIntoConstraints = false
                stackView.layoutMargins = UIEdgeInsets.zero
                stackView.isLayoutMarginsRelativeArrangement = false
                return stackView
            }()
            
            stackView.addArrangedSubview(rectangleOne)
            stackView.addArrangedSubview(rectangleTwo)
            stackView.addArrangedSubview(rectangleThree)
            
            cell.addSubview(stackView)
            stackView.snp.makeConstraints { make in
                make.top.equalTo(nameLabel.snp.bottom).inset(-10)
                make.right.left.equalToSuperview().inset(10)
                make.height.equalTo(59)
            }
            
            
        }
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
            // Удаление всех подвидов, чтобы избежать наложения
            header.subviews.forEach { $0.removeFromSuperview() }
            
            let label = UILabel()
            label.textColor = .white
            label.font = .systemFont(ofSize: 20, weight: .bold)
            
            if indexPath.section == 0 {
                label.text = "Players" // Заголовок для секции Players
            } else {
                label.text = "Exercises" // Заголовок для секции Exercises
            }
            
            header.addSubview(label)
            label.snp.makeConstraints { make in
                make.centerY.equalTo(header)
                make.leading.equalTo(header)
            }
            
            return header
        }
        return UICollectionReusableView()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.width, height: 65)
        } else {
            return CGSize(width: collectionView.frame.width, height: 114)
        }
    }
    
    
}


extension DetailTrainingViewController: DetailTrainingViewControllerDelegate {
    func changeTitle() {
        title = training?.name
    }
    
   
    
    
    func saveTraining(index: Int, training: Training) {
        delegate?.updateTraining(index: index, training: training)
        self.training = training
        title = training.name
        
        UIView.animate(withDuration: 0.5) { [self] in
            imageView?.image = UIImage(data: training.imageData ?? Data())
            playersArr = training.players ?? [Player]()
            repetitionsLabel?.text = training.repetitions 
            approachesLabel?.text = training.approaches
            collectionView?.reloadData()
        }
    }
    
    
}

