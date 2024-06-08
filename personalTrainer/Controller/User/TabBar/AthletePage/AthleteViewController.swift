//
//  AthleteViewController.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 08.06.2024.
//

import UIKit


protocol AthleteViewControllerDelegate: AnyObject {
    func showEditView(amountLabel: UILabel, totalLabel: UILabel)
    func addNewPlayer()
}


class AthleteViewController: UIViewController {
    
    var mainView: AthleteView?
    
    var athleteArr: [Player] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = AthleteView()
        mainView?.delegate = self
        self.view = mainView
        checkAthleteArr()
    }
    
    
    func checkAthleteArr() {
        if let data = UserDefaults.standard.data(forKey: "athleteArr") {
            do {
                let decoder = JSONDecoder()
                athleteArr = try decoder.decode([Player].self, from: data)
                mainView?.athleteArr = athleteArr
            } catch {
                print("Не удалось декодировать массив игроков: \(error)")
            }
        } else {
            athleteArr = []
        }
    }
    
    
}


extension AthleteViewController: AthleteViewControllerDelegate {
    
    func addNewPlayer() {
        let vc = AddNewPlayerViewController()
        vc.athleteArr = self.athleteArr
        
        // Устанавливаем текст кнопки "Back" в предыдущем контроллере
        navigationController?.topViewController?.navigationItem.title = " "
        navigationController?.pushViewController(vc, animated: true)
    }

    
    
    func showEditView(amountLabel: UILabel, totalLabel: UILabel) {
        let vc = EditStatisticViewController(amountLabel: amountLabel, totalLabel: totalLabel)
        self.present(vc, animated: true)
    }
    
}
