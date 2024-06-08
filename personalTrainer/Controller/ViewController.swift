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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkUser { result in
            switch result {
            case .success(let value):
                if value == false {
                    //тут для ревьювера
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
        completion(.success(true))
    }
    
}


