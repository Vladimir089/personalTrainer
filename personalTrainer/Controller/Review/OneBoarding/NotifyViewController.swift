//
//  NotifyViewController.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 11.06.2024.
//

import UIKit
import UserNotifications

class NotifyViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    let loadImage: UIImageView = {
        let image = UIImage(named: "notiImage")
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
            button.setTitle("Enable notification", for: .normal)
            button.tintColor = .white
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
            button.layer.cornerRadius = 8
            button.addTarget(self, action: #selector(enableNot), for: .touchUpInside)
            return button
        }()

        view.addSubview(loadImage)
        loadImage.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        let labelRate: UILabel = {
            let label = UILabel()
            label.text = "Don’t miss anything"
            label.font = .systemFont(ofSize: 28, weight: .bold)
            label.textColor = .white
            label.textAlignment = .center
            label.numberOfLines = 2
            return label
        }()
        view.addSubview(labelRate)
        labelRate.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(120)
            make.width.equalTo(150)
        }
        
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().inset(40)
        }
        
        let buttonClose: UIButton = {
            let button = UIButton(type: .system)
            button.backgroundColor = .primary
            let image = UIImage(systemName: "xmark")?.resize(to: CGSize(width: 15, height: 15))
            button.setImage(image, for: .normal)
            button.tintColor = UIColor(red: 235/255, green: 235/255, blue: 245/255, alpha: 0.6)
            button.layer.cornerRadius = 17.5
            return button
        }()
        buttonClose.addTarget(self, action: #selector(skip), for: .touchUpInside)
        view.addSubview(buttonClose)
        buttonClose.snp.makeConstraints { make in
            make.height.width.equalTo(35)
            make.right.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(60)
        }
        
    }
    
    @objc func skip() {
        print(1)
        openWebView()
    }
    
    
    @objc func enableNot() {
        let center = UNUserNotificationCenter.current()
        // Запрашиваем разрешение на отправку уведомлений
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    print("Уведомления разрешены пользователем")
                    UIApplication.shared.registerForRemoteNotifications()
                } else {
                    print("Уведомления не разрешены пользователем")
                }
                // Открываем WebView в любом случае
                self.openWebView()
            }
        }
    }
    
    
    func openWebView() {
        self.navigationController?.setViewControllers([WebViewController()], animated: true)
    }
    

}
