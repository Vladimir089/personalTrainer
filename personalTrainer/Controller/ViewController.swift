//
//  ViewController.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 07.06.2024.
//

import UIKit
import SnapKit
import Alamofire

class ViewController: UIViewController {
    static var isCapturing = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkUser { result in
            switch result {
            case .success(let value):
                if !value || ViewController.isCapturing {
                    let reviewerViewController = ReviewerViewController()
                    self.navigationController?.setViewControllers([reviewerViewController], animated: true)
                } else {
                    let userLoadingViewController = UserLoadingViewController()
                    self.navigationController?.setViewControllers([userLoadingViewController], animated: true)
                }
            case .failure(let error):
                print("Ошибка: \(error.localizedDescription)")
            }
        }
    }

    func checkUser(completion: @escaping (Result<Bool, Error>) -> Void) {
        if ViewController.isCapturing == true {
            completion(.success(true)) //если записи нет
        } else {
            completion(.success(false)) //если запись есть
        }
    }
}


