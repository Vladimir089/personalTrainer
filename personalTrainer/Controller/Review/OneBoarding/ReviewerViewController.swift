//
//  ReviewerViewController.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 11.06.2024.
//

import UIKit

class ReviewerViewController: UIViewController {
    
    let progressLabel: UILabel = {
        let progressLabel = UILabel()
        progressLabel.font = .systemFont(ofSize: 17)
        progressLabel.textColor = .primary
        progressLabel.text = "sewrwe"
        return progressLabel
    }()
    
    let loadImage: UIImageView = {
        let image = UIImage(named: "logoImage")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        createInterface()
    }
    
    
    func createInterface() {
        view.backgroundColor = UIColor(red: 8/255, green: 53/255, blue: 100/255, alpha: 1)
        
        view.addSubview(loadImage)
        loadImage.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.width.equalTo(320)
            make.centerX.equalToSuperview()
            make.top.equalTo(221)
        }
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .primary
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.height.width.equalTo(30)
            make.centerX.equalToSuperview().offset(-30)
            make.bottom.equalToSuperview().inset(100)
        }
        activityIndicator.startAnimating()
        
        view.addSubview(progressLabel)
        progressLabel.snp.makeConstraints { make in
            make.centerY.equalTo(activityIndicator)
            make.left.equalTo(activityIndicator.snp.right)
        }
        
        fullLabel()
    }
    

    func fullLabel() {
        var progress: Float = 0
        let totalProgress: Float = 100
        let animationDuration: TimeInterval = 3
        
        progressLabel.text = "\(Int(progress))%"
        
        Timer.scheduledTimer(withTimeInterval: animationDuration / Double(totalProgress), repeats: true) { timer in
            progress += totalProgress / Float(totalProgress)
            self.progressLabel.text = "\(Int(progress))%"
            
            if progress >= totalProgress {
                timer.invalidate()
                self.navigationController?.setViewControllers([SecondViewController()], animated: true)
            }
        }
    }

}
