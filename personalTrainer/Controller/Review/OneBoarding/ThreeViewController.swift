//
//  ThreeViewController.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 11.06.2024.
//

import UIKit
import StoreKit

class ThreeViewController: UIViewController {
    
    var tap = 0
    let loadImage: UIImageView = {
        let image = UIImage(named: "secondImage")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        createVC()
    }
    

    func createVC() {
        view.backgroundColor = UIColor(red: 8/255, green: 53/255, blue: 100/255, alpha: 1)
        
        view.addSubview(loadImage)
        loadImage.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        let labelRate: UILabel = {
            let label = UILabel()
            label.text = "Rate our app in the \n AppStore"
            label.font = .systemFont(ofSize: 28, weight: .bold)
            label.textColor = .white
            label.textAlignment = .center
            label.numberOfLines = 2
            return label
        }()
        loadImage.addSubview(labelRate)
        labelRate.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(100)
            make.width.equalTo(370)
            make.height.equalTo(68)
        }
        
        
        let button: UIButton = {
            let button = UIButton(type: .system)
            button.backgroundColor = .primary
            button.setTitle("Next", for: .normal)
            button.tintColor = .white
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
            button.layer.cornerRadius = 8
            return button
        }()
        button.addTarget(self, action: #selector(rateApp), for: .touchUpInside)

      
        
        
        
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().inset(30)
        }
        
    }
    
    
   
    
    @objc func rateApp() {
        tap += 1
        
        if tap == 1 {
            DispatchQueue.main.async {
                SKStoreReviewController.requestReview()
                print("Requested review")
            }
            
        }
        if tap == 2 {
            self.navigationController?.setViewControllers([NotifyViewController()], animated: true)
        }
        
    }

    
    

    

}



