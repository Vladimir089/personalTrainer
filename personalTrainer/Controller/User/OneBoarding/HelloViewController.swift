//
//  HelloViewController.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 07.06.2024.
//

import UIKit

protocol HelloViewControllerDelegate: AnyObject {
    func updateDots()
    func nextPage(page: Int)
    func increment()
}

class HelloViewController: UIViewController {
    
    var mainView: HelloView?

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = HelloView()
        mainView?.delegate = self
        self.view = mainView
        updateDots()
    }
    
    
}

extension HelloViewController: HelloViewControllerDelegate {
    
    func increment() {
        mainView?.currentIndex += 1
        nextPage(page: mainView?.currentIndex ?? 0)
    }
    
    func updateDots() {
        for (index, dot) in mainView!.dots.enumerated() {
            if index == mainView?.currentIndex {
                dot.backgroundColor = .primary
            } else {
                dot.backgroundColor = .primary.withAlphaComponent(0.5)
            }
        }
    }
    
    
    func nextPage(page: Int) {
        switch page {
        case 0:
            mainView?.mainLabel?.text = "Track the results"
            mainView?.secondaryLabel?.text = "Your athletes and teams"
            setImageWithConstraints(imageName: "phone1")
        case 1:
            mainView?.mainLabel?.text = "Create workouts"
            mainView?.secondaryLabel?.text = "for your athletes or the whole team"
            setImageWithConstraints(imageName: "phone2")
        case 2:
            mainView?.mainLabel?.text = "Record events"
            mainView?.secondaryLabel?.text = "Don't miss a single competition"
            setImageWithConstraints(imageName: "phone3")
        case 3:
            self.navigationController?.setViewControllers([TabBarViewController()], animated: true)
        default:
            break
        }
        updateDots()
    }

    private func setImageWithConstraints(imageName: String) {
        let image = UIImage(named: imageName)
        mainView?.phoneImageView?.image = image
        
        mainView?.phoneImageView?.snp.remakeConstraints({ make in
            if imageName == "phone2" {
                // Если изображение "phone2", то уменьшаем размеры и устанавливаем отступы от краев экрана
                let padding: CGFloat = 30
                make.top.equalTo((mainView?.secondaryLabel ?? UIView()).snp.bottom).offset(padding)
                make.left.equalToSuperview().offset(padding)
                make.right.equalToSuperview().inset(padding)
                make.height.equalTo(mainView!.phoneImageView!.snp.width).multipliedBy(2)
            } else {
                // Для всех других изображений масштабируем до краев экрана
                make.top.equalTo((mainView?.secondaryLabel ?? UIView()).snp.bottom).offset(-30)
                make.centerX.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalTo(mainView!.phoneImageView!.snp.width).multipliedBy(2)
            }
        })
        mainView?.layoutIfNeeded() // Перестраиваем макет после изменения ограничений
    }
}


