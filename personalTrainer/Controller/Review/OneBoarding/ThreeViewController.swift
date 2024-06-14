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
        let image = UIImage(named: "threeImage")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    private var shadowLayer: CAGradientLayer?

    override func viewDidLoad() {
        super.viewDidLoad()

        createVC()
    }
    

    func createVC() {
        view.backgroundColor = UIColor(red: 8/255, green: 53/255, blue: 100/255, alpha: 1)
        
        let labelRate: UILabel = {
            let label = UILabel()
            label.text = "Rate our app in the AppStore"
            label.font = .systemFont(ofSize: 28, weight: .bold)
            label.textColor = .white
            label.textAlignment = .center
            label.numberOfLines = 2
            return label
        }()
        view.addSubview(labelRate)
        labelRate.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(150)
            make.width.equalTo(350)
            make.height.equalTo(68)
        }
        
        
        let button: UIButton = {
            let button = UIButton(type: .system)
            button.backgroundColor = .primary
            button.setTitle("Next", for: .normal)
            button.tintColor = .white
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
            button.layer.cornerRadius = 8
            button.addTarget(self, action: #selector(rateApp), for: .touchUpInside)
            return button
        }()

        view.addSubview(loadImage)
        loadImage.snp.makeConstraints { make in
            make.height.equalTo(582)
            make.width.equalTo(326)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        
        addShadowLayer()
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().inset(40)
        }
        
    }
    
    
    func addShadowLayer() {
        shadowLayer?.removeFromSuperlayer()

        let newShadowLayer = CAGradientLayer()
        newShadowLayer.colors = [UIColor.clear.cgColor, UIColor(red: 8/255, green: 53/255, blue: 100/255, alpha: 1).cgColor]
        newShadowLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        newShadowLayer.endPoint = CGPoint(x: 0.5, y: 1)
        newShadowLayer.frame = view.bounds

        view.layer.addSublayer(newShadowLayer)
        shadowLayer = newShadowLayer
    }
    
    @objc func rateApp() {
        tap += 1
        if tap == 1 {
            SKStoreReviewController.requestReview()
        }
        if tap == 2 {
            self.navigationController?.setViewControllers([NotifyViewController()], animated: true)
        }

    }

    
    

    

}



