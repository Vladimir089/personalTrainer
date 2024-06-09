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
    func updateArr(athleteArr: [Player])
}


class AthleteViewController: UIViewController {
    
    var mainView: AthleteView?
    
    var athleteArr: [Player] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAthleteArr()
        mainView = AthleteView()
        mainView?.delegate = self
        self.view = mainView
    }
    
    
    func checkAthleteArr() {
        if let data = UserDefaults.standard.data(forKey: "athleteArr") {
            do {
                athleteArr = try JSONDecoder().decode([Player].self, from: data)
            } catch {
                print("Failed to decode athleteArr: \(error)")
            }
        }
    }
    
    
    
}


extension AthleteViewController: AthleteViewControllerDelegate {
    
    func updateArr(athleteArr: [Player]) {
        self.athleteArr = athleteArr
        //обновляем коллецию в мэин вью
    }
    
    
    func addNewPlayer() {
        let vc = AddNewPlayerViewController()
        vc.athleteArr = self.athleteArr
        vc.delegate = self
        // Устанавливаем текст кнопки "Back" в предыдущем контроллере
        navigationController?.topViewController?.navigationItem.title = " "
        navigationController?.pushViewController(vc, animated: true)
    }

    
    
    func showEditView(amountLabel: UILabel, totalLabel: UILabel) {
        let vc = EditStatisticViewController(amountLabel: amountLabel, totalLabel: totalLabel)
        self.present(vc, animated: true)
    }
    
}
