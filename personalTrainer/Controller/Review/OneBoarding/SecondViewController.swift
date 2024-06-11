//
//  SecondViewController.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 11.06.2024.
//

import UIKit

class SecondViewController: UIViewController {
    
    let loadImage: UIImageView = {
        let image = UIImage(named: "logoImage")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    let cupImage: UIImageView = {
        let image = UIImage(named: "cupImage")
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
        
        let button: UIButton = {
            let button = UIButton(type: .system)
            button.backgroundColor = .primary
            button.setTitle("Next", for: .normal)
            button.tintColor = .white
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
            button.layer.cornerRadius = 8
            button.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
            return button
        }()
        
       
        
        view.addSubview(cupImage)
        cupImage.snp.makeConstraints { make in
            make.height.equalTo(480)
            make.left.right.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(30)
        }
        
        view.addSubview(loadImage)
        loadImage.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.width.equalTo(320)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(cupImage.snp.top)
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
    
    @objc func nextVC() {
        self.navigationController?.setViewControllers([ThreeViewController()], animated: true)
    }

}
