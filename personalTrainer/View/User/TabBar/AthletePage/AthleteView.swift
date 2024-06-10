//
//  AthleteView.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 08.06.2024.
//

import UIKit

class AthleteView: UIView {
    
    var topView: UIView?
    
    var collectionView: UICollectionView?
    
    weak var delegate: AthleteViewControllerDelegate?
    
    var athleteArr: [Player] = []
    
    var collectionAthleteArr: [(String, UIImage)] = []
    
    var amountPlayersLabel: UILabel = {
        let label = UILabel()
        let amount = UserDefaults.standard.integer(forKey: "amount")
        label.text = "\(amount)"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .primary
        return label
    }()
    
    var totalSalaryLabel: UILabel = {
        let label = UILabel()
        let total = UserDefaults.standard.integer(forKey: "total")
        label.text = "$\(total)"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .primary
        return label
    }()
    
    var editView: UIView = {
        let view = UIView()
        view.backgroundColor = .BG.withAlphaComponent(0.1)
        view.clipsToBounds = true
        return view
    }()
    
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
        createComponents()
    }
    
    
    func createComponents() {
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "Athlete"
            label.textColor = .white
            label.font = .systemFont(ofSize: 34, weight: .bold)
            return label
        }()
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(40)
            make.left.equalToSuperview().inset(15)
        }
        
        
        topView = UIView()
        topView?.backgroundColor = .second
        topView?.layer.cornerRadius = 12
        addSubview(topView ?? UIView())
        topView?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(titleLabel.snp.bottom).inset(-20)
            make.height.equalTo(128)
        })
        
        
        let statisticLabel: UILabel = {
            let label = UILabel()
            label.text = "Statistic"
            label.textColor = .white
            label.font = .systemFont(ofSize: 20, weight: .semibold)
            return label
        }()
        topView?.addSubview(statisticLabel)
        statisticLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(10)
        }
        
        
        let editStatisticButton: UIButton = {
            let button = UIButton()
            button.setTitle("Edit", for: .normal)
            button.setImage(UIImage(named: "pencil")?.resize(to: CGSize(width: 20, height: 20)), for: .normal)
            button.semanticContentAttribute = .forceLeftToRight
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
            button.setTitleColor(.primary, for: .normal)
            button.addTarget(self, action: #selector(showEditStatisticView), for: .touchUpInside)
            return button
        }()
        topView?.addSubview(editStatisticButton)
        editStatisticButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(10)
            make.centerY.equalTo(statisticLabel.snp.centerY)
            make.width.equalTo(70)
        }
        
        
        //MARK: -TopView 2 Rectangle
        
        
        let rectangleOne: UIView = {
            let view = UIView()
            view.backgroundColor = .second
            view.layer.cornerRadius = 12
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
            return view
        }()
        
        let rectangleTwo: UIView = {
            let view = UIView()
            view.backgroundColor = .second
            view.layer.cornerRadius = 12
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
            return view
        }()
        
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            stackView.spacing = 20
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()

        stackView.addArrangedSubview(rectangleOne)
        stackView.addArrangedSubview(rectangleTwo)
        
        topView?.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(statisticLabel.snp.bottom).inset(-15)
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
        
        
        //MARK: -Next components
        
        
        rectangleOne.addSubview(amountPlayersLabel)
        amountPlayersLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-8)
        }
        
        
        let amountTextLabel: UILabel = {
            let label = UILabel()
            label.text = "Amount players"
            label.textColor = UIColor.white.withAlphaComponent(0.3)
            label.font = .systemFont(ofSize: 15)
            return label
        }()
        rectangleOne.addSubview(amountTextLabel)
        amountTextLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(14)
        }
        
        
        rectangleTwo.addSubview(totalSalaryLabel)
        totalSalaryLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-8)
        }
        
        
        let totalTextLabel: UILabel = {
            let label = UILabel()
            label.text = "Total salary"
            label.textColor = UIColor.white.withAlphaComponent(0.3)
            label.font = .systemFont(ofSize: 15)
            return label
        }()
        rectangleTwo.addSubview(totalTextLabel)
        totalTextLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(14)
        }
        
        
        let playersLabel: UILabel = {
            let label = UILabel()
            label.text = "Players"
            label.font = .systemFont(ofSize: 28, weight: .bold)
            label.textColor = .white
            return label
        }()
        addSubview(playersLabel)
        playersLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo((topView ?? UIView()).snp.bottom).inset(-50)
        }
        
        
        let secondaryPlayerLabel: UILabel = {
            let label = UILabel()
            label.text = "Your athletes will be represented here"
            label.font = .systemFont(ofSize: 15)
            label.textColor = .white.withAlphaComponent(0.3)
            label.textAlignment = .center
            label.numberOfLines = 2
            return label
        }()
        addSubview(secondaryPlayerLabel)
        secondaryPlayerLabel.snp.makeConstraints { make in
            make.width.equalTo(228)
            make.centerX.equalToSuperview()
            make.top.equalTo(playersLabel.snp.bottom).inset(-5)
        }
        
        
        let addPlayerButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Click to add new players", for: .normal)
            button.setImage(UIImage(named: "plus")?.resize(to: CGSize(width: 20, height: 20)), for: .normal)
            button.semanticContentAttribute = .forceLeftToRight
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
            button.addTarget(self, action: #selector(addNewPlayer), for: .touchUpInside)
            button.backgroundColor = .primary
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
            button.tintColor = .white
            button.layer.cornerRadius = 12
            return button
        }()
        addSubview(addPlayerButton)
        addPlayerButton.snp.makeConstraints { make in
            make.width.equalTo(228)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.top.equalTo(secondaryPlayerLabel.snp.bottom).inset(-10)
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
            make.top.equalTo((topView ?? UIView()).snp.bottom).inset(-10)
        })
        
        addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.right.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(60)
        }
        
        
        
        checkArray()
        
        
    }
    
    
    func checkArray() {
        print(athleteArr)
        collectionAthleteArr.removeAll()
        if athleteArr.count == 0 {
            collectionView?.alpha = 0
            addButton.alpha = 0
        } else {
            collectionView?.alpha = 1
            addButton.addTarget(self, action: #selector(addNewPlayer), for: .touchUpInside)
            addButton.alpha = 1
            
            for i in athleteArr {
                let image = UIImage(data: i.imageData ?? Data())
                collectionAthleteArr.append((i.name, image!))
            }
            
            collectionView?.reloadData()
            
        }
    }
    
    
    @objc func showEditStatisticView() {
        delegate?.showEditView(amountLabel: amountPlayersLabel, totalLabel: totalSalaryLabel)
    }
    
    
    @objc func addNewPlayer() {
        delegate?.addNewPlayer()
    }
    
    
    //
}

extension AthleteView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionAthleteArr.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .second
        cell.layer.cornerRadius = 12
        cell.subviews.forEach { $0.removeFromSuperview() }
        
        //MARK: -settings cell
        
        let label = UILabel()
        label.text = collectionAthleteArr[indexPath.row].0
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        cell.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(15)
            make.height.equalTo(20)
        }
        
        let image = collectionAthleteArr[indexPath.row].1
        let imageView = UIImageView(image: image)
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        cell.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview().inset(10)
            make.bottom.equalTo(label.snp.top).inset(-15)
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAthleteName = collectionAthleteArr[indexPath.item].0

        if let playerIndex = athleteArr.firstIndex(where: { $0.name == selectedAthleteName }) {
            let selectedPlayer = athleteArr[playerIndex]
            delegate?.openDetailPlayerVC(player: selectedPlayer, indexPatch: playerIndex)
        } else {
            print("Player not found")
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Определяем количество ячеек в ряду
        let numberOfItemsPerRow: CGFloat = 2
        let totalSpacing = (numberOfItemsPerRow - 1) * 10
        let itemWidth = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow
        return CGSize(width: itemWidth, height: itemWidth)
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
    
    
}
