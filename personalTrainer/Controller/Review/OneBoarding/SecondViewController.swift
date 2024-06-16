//
//  SecondViewController.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 11.06.2024.
//

import UIKit

class SecondViewController: UIViewController {
    
    let loadImage: UIImageView = {
        let image = UIImage(named: "logoFullImage")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
   
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
        
       
        
       
        
        view.addSubview(loadImage)
        loadImage.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
       
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().inset(30)
        }
        
    }
    
    
    
    
    
    
    @objc func nextVC() {
        self.navigationController?.setViewControllers([ThreeViewController()], animated: true)
    }

}
