//
//  NewRatingViewController.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 13.06.2024.
//

import UIKit

protocol NewRatingViewControllerDelegate: AnyObject {
    func saveRating(rating: [Rating])
}

class NewRatingViewController: UIViewController {
    
    var rating: [Rating] = []
    
    weak var delegate: RatingViewControllerDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        title = "New rating"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .BG
        settingsNavController()
        createInterface()
    }
    
    
    func settingsNavController() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.primary
    }
    
    func createInterface() {
        
        let athleteButton = createButton(title: "For athlete")
        athleteButton.addTarget(self, action: #selector(fotAthleteVC), for: .touchUpInside)
        let teamButton = createButton(title: "For team")
        teamButton.addTarget(self, action: #selector(fotTeamVC), for: .touchUpInside)
        
        view.addSubview(athleteButton)
        athleteButton.snp.makeConstraints { make in
            make.height.equalTo(38)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        
        view.addSubview(teamButton)
        teamButton.snp.makeConstraints { make in
            make.height.equalTo(38)
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(athleteButton.snp.bottom).inset(-15)
        }
    }
    
    
    @objc func fotTeamVC() {
        let vc = CreateRatingViewController()
        navigationController?.topViewController?.navigationItem.title = " "
        vc.delegate = self
        vc.forAthlete = false
        vc.rating = rating
        self.navigationController?.pushViewController(vc, animated: true)
    }
 
    
    @objc func fotAthleteVC() {
        let vc = CreateRatingViewController()
        navigationController?.topViewController?.navigationItem.title = " "
        vc.delegate = self
        vc.forAthlete = true
        vc.rating = rating
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 15)
        let image = UIImage(named: "array")?.resize(to: CGSize(width: 17, height: 22))
        button.setImage(image, for: .normal)
        button.backgroundColor = UIColor(red: 35/255, green: 36/255, blue: 43/255, alpha: 1)
        button.layer.cornerRadius = 12
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
       
        button.imageView?.snp.makeConstraints({ make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
            make.height.equalTo(22)
            make.width.equalTo(17)
        })
        
        button.titleLabel?.snp.makeConstraints({ make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(15)
            make.right.equalToSuperview().inset(-50)
        })
        
        return button
    }

}


extension NewRatingViewController: NewRatingViewControllerDelegate {
    
    func saveRating(rating: [Rating]) {
        delegate?.saveRating(rating: rating)
        navigationController?.popViewController(animated: true)
    }
    
}
