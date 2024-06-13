//
//  SettingsViewController.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 13.06.2024.
//

import UIKit
import StoreKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .BG
        settingsInterface()
    }
    
    
    func settingsInterface() {
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "Settings"
            label.textColor = .white
            label.font = .systemFont(ofSize: 34, weight: .bold)
            return label
        }()
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview().inset(15)
        }
        
        let topView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(red: 35/255, green: 36/255, blue: 43/255, alpha: 1)
            view.layer.cornerRadius = 12
            return view
        }()
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(178)
            make.top.equalTo(titleLabel.snp.bottom).inset(-45)
        }
        
        
        let shareView: UIView = {
            let shareView = UIView()
            shareView.backgroundColor = .clear
            
            let image = UIImage(named: "ShareAppImage")
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            shareView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.height.equalTo(24)
                make.width.equalTo(24)
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().inset(15)
            }
            
            let label = UILabel()
            label.text = "Share app"
            label.textColor = .white
            label.font = .systemFont(ofSize: 16, weight: .bold)
            shareView.addSubview(label)
            label.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalTo(imageView.snp.right).inset(-15)
            }
            
            let secondImage = UIImage(named: "miniArray")
            let secondImageView = UIImageView(image: secondImage)
            shareView.addSubview(secondImageView)
            secondImageView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.height.equalTo(12.73)
                make.width.equalTo(7.62)
                make.right.equalToSuperview().inset(15)
            }
            
            let sepratorView = UIView()
            sepratorView.backgroundColor = .primary
            shareView.addSubview(sepratorView)
            sepratorView.snp.makeConstraints { make in
                make.height.equalTo(1)
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            
            return shareView
        }()
        
        let sharedGesture = UITapGestureRecognizer(target: self, action: #selector(shareApp))
        shareView.addGestureRecognizer(sharedGesture)
        
        let policyView: UIView = {
            let policyView = UIView()
            policyView.backgroundColor = .clear
            
            let image = UIImage(named: "policy")
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            policyView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.height.equalTo(24)
                make.width.equalTo(24)
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().inset(15)
            }
            
            let label = UILabel()
            label.text = "Usage Policy"
            label.textColor = .white
            label.font = .systemFont(ofSize: 16, weight: .bold)
            policyView.addSubview(label)
            label.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalTo(imageView.snp.right).inset(-15)
            }
            
            let secondImage = UIImage(named: "miniArray")
            let secondImageView = UIImageView(image: secondImage)
            policyView.addSubview(secondImageView)
            secondImageView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.height.equalTo(12.73)
                make.width.equalTo(7.62)
                make.right.equalToSuperview().inset(15)
            }
            
            let sepratorView = UIView()
            sepratorView.backgroundColor = .primary
            policyView.addSubview(sepratorView)
            sepratorView.snp.makeConstraints { make in
                make.height.equalTo(1)
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            
            return policyView
        }()
        
        let policyGesture = UITapGestureRecognizer(target: self, action: #selector(usagePolicy))
        policyView.addGestureRecognizer(policyGesture)
        
        
        let rateView: UIView = {
            let rateView = UIView()
            rateView.backgroundColor = .clear
            
            let image = UIImage(named: "bigStar")
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            rateView.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.height.equalTo(24)
                make.width.equalTo(24)
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().inset(15)
            }
            
            let label = UILabel()
            label.text = "Rate app"
            label.textColor = .white
            label.font = .systemFont(ofSize: 16, weight: .bold)
            rateView.addSubview(label)
            label.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalTo(imageView.snp.right).inset(-15)
            }
            
            let secondImage = UIImage(named: "miniArray")
            let secondImageView = UIImageView(image: secondImage)
            rateView.addSubview(secondImageView)
            secondImageView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.height.equalTo(12.73)
                make.width.equalTo(7.62)
                make.right.equalToSuperview().inset(15)
            }
            return rateView
        }()
        
        let rateGesture = UITapGestureRecognizer(target: self, action: #selector(rateApp))
        rateView.addGestureRecognizer(rateGesture)
        
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            stackView.spacing = 0
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()

        stackView.addArrangedSubview(shareView)
        stackView.addArrangedSubview(policyView)
        stackView.addArrangedSubview(rateView)
        
        topView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    

    @objc func shareApp() {
        if let url = URL(string: "https://apps.apple.com/app/ПРИЛОЖЕНИЕ") {
            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @objc func usagePolicy() {
        let vc = UsagePolicyWebView()
        present(vc, animated: true)
    }
    
    @objc func rateApp() {
        SKStoreReviewController.requestReview()
    }



}
