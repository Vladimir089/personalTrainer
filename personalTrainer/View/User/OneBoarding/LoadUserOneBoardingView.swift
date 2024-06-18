//
//  LoadUserOneBoardingView.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 07.06.2024.
//

import UIKit

class LoadUserOneBoardingView: UIView {
    
    let loadImage: UIImageView = {
        let image = UIImage(named: "log")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    
    let progressLabel: UILabel = {
        let progressLabel = UILabel()
        progressLabel.font = .systemFont(ofSize: 17)
        progressLabel.textColor = .primary
        progressLabel.text = "sewrwe"
        return progressLabel
    }()
    

    override init(frame: CGRect) {
        super .init(frame: frame)
        settingsBackground()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func settingsBackground() {
        backgroundColor = .BG
        createInterface()
    }
    
    func createInterface() {
        
        addSubview(loadImage)
        loadImage.snp.makeConstraints { make in
            make.height.equalTo(184)
            make.width.equalTo(254)
            make.centerX.equalToSuperview()
            make.top.equalTo(221)
        }
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .primary
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.height.width.equalTo(30)
            make.centerX.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().inset(100)
        }
        activityIndicator.startAnimating()
        
        addSubview(progressLabel)
        progressLabel.snp.makeConstraints { make in
            make.centerY.equalTo(activityIndicator)
            make.left.equalTo(activityIndicator.snp.right)
        }
    }
}
