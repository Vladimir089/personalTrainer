//
//  CalendarView.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 12.06.2024.
//

import UIKit

class CalendarView: UIView {
    
    var firstView: UIView?
    
    weak var delegate: CalendarViewControllerDelegate?
    
    var events: [Event] = []
    
    var eventsByDate: [(date: String, events: [Event])] = []
    
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
    
    
    func groupEventsByDate(_ events: [Event]) -> [(date: String, events: [Event])] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let groupedEvents = Dictionary(grouping: events) { event in
            dateFormatter.string(from: event.date)
        }
        
        let sortedKeys = groupedEvents.keys.sorted()
        
        return sortedKeys.map { key in
            (date: key, events: groupedEvents[key] ?? [])
        }
    }
    
    
    func settingsView() {
        backgroundColor = .BG
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "Calendar"
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
            label.text = "Calendar of events"
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
            label.text = "Events for athletes will be recorded there"
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
            make.left.right.equalToSuperview().inset(18)
        }
        
        
        let addTrainingButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Click to add new events", for: .normal)
            button.setImage(UIImage(named: "plus")?.resize(to: CGSize(width: 20, height: 20)), for: .normal)
            button.semanticContentAttribute = .forceLeftToRight
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
            button.addTarget(self, action: #selector(createEditEvent), for: .touchUpInside)
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
        
        
        addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.right.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(60)
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
            collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
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
        if events.count == 0 {
            collectionView?.alpha = 0
            addButton.alpha = 0
        } else {
            collectionView?.alpha = 1
            addButton.addTarget(self, action: #selector(createEditEvent), for: .touchUpInside)
            addButton.alpha = 1
            collectionView?.reloadData()
            
        }
    }
    
    
    @objc func createEditEvent() {
        delegate?.createEditVC()
    }
    
    func indexOfEvent(named name: String) -> Int? {
        return events.firstIndex { $0.name == name }
    }
    
    
}


extension CalendarView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return eventsByDate.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventsByDate[section].events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        
        let event = eventsByDate[indexPath.section].events[indexPath.item]
        
        let labelName: UILabel = {
            let label = UILabel()
            label.text = event.name
            label.textColor = .white
            label.font = .systemFont(ofSize: 17, weight: .bold)
            return label
        }()
        cell.addSubview(labelName)
        labelName.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(10)
        }
        
        
        let timeLabel: UILabel = {
            let label = UILabel()
            label.text = event.time
            label.textColor = .white
            label.font = .systemFont(ofSize: 17, weight: .bold)
            return label
        }()
        cell.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(10)
        }
        
        
        let separtorView = UIView()
        separtorView.backgroundColor = .primary
        cell.addSubview(separtorView)
        separtorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.right.equalToSuperview()
            make.left.equalTo(labelName.snp.left)
            make.top.equalTo(labelName.snp.bottom).inset(-10)
        }
        
        
        let discritionLabel: UILabel = {
            let label = UILabel()
            label.text = event.discriprion
            label.font = .systemFont(ofSize: 13)
            label.textColor = .white.withAlphaComponent(0.5)
            label.numberOfLines = 2
            return label
        }()
        cell.addSubview(discritionLabel)
        discritionLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(5)
            make.height.equalTo(36)
        }
        
        cell.backgroundColor = UIColor(red: 35/255, green: 36/255, blue: 43/255, alpha: 1)
        cell.layer.cornerRadius = 10
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
            header.subviews.forEach { $0.removeFromSuperview() }
            
            let label = UILabel()
            label.textColor = .white
            label.font = .systemFont(ofSize: 20, weight: .bold)
            label.text = eventsByDate[indexPath.section].date
            
            header.addSubview(label)
            label.snp.makeConstraints { make in
                make.centerY.equalTo(header).offset(5)
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
        return CGSize(width: collectionView.frame.width, height: 88)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let event = eventsByDate[indexPath.section].events[indexPath.item]
        if let eventIndex = indexOfEvent(named: event.name) {
            print(eventIndex)
            delegate?.showDetail(item: event, index: eventIndex)
        } else {
            print("Event not found")
        }
    }
}
