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
    func openDetailPlayerVC(player: Player, indexPatch: Int)
    func delPlayer(index: Int)
    func updatePlayer(index: Int, player: Player)
    
}


class AthleteViewController: UIViewController {
    
    var mainView: AthleteView?
    
    var athleteArr: [Player] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = AthleteView()
        mainView?.delegate = self
        if let loadedAthleteArr = loadAthleteArrFromFile() {
            self.athleteArr = loadedAthleteArr
            DispatchQueue.main.async {
                self.mainView?.athleteArr = self.athleteArr
                self.mainView?.checkArray()
                playersArr = self.athleteArr
            }
        } else {
            print("No existing athleteArr found or failed to load.")
        }
        
        self.view = mainView
    }
    
    

    
    func loadAthleteArrFromFile() -> [Player]? {
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to get document directory")
            return nil
        }
        let filePath = documentDirectory.appendingPathComponent("athleteArr.plist")
        do {
            let data = try Data(contentsOf: filePath)
            let athleteArr = try JSONDecoder().decode([Player].self, from: data)
            return athleteArr
        } catch {
            print("Failed to load or decode athleteArr: \(error)")
            return nil
        }
    }
    
    
    func saveAthleteArrToFile(data: Data) throws {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("athleteArr.plist")
            try data.write(to: filePath)
        } else {
            throw NSError(domain: "SaveError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to get document directory"])
        }
    }
    
    
}


extension AthleteViewController: AthleteViewControllerDelegate {
    
    func updatePlayer(index: Int, player: Player) {
        athleteArr[index] = player
        do {
            let data = try JSONEncoder().encode(athleteArr)
            try saveAthleteArrToFile(data: data)
        } catch {
            print("Failed to encode or save athleteArr: \(error)")
        }
        
        if let loadedAthleteArr = loadAthleteArrFromFile() {
            self.athleteArr = loadedAthleteArr
            DispatchQueue.main.async {
                self.mainView?.athleteArr = self.athleteArr
                self.mainView?.checkArray()
            }
        } else {
            print("No existing athleteArr found or failed to load.")
        }
        playersArr = self.athleteArr
        mainView?.collectionView?.reloadData()
    }
    
    
    func delPlayer(index: Int) {
        athleteArr.remove(at: index)
        do {
            let data = try JSONEncoder().encode(athleteArr)
            try saveAthleteArrToFile(data: data)
        } catch {
            print("Failed to encode or save athleteArr: \(error)")
        }
        
        if let loadedAthleteArr = loadAthleteArrFromFile() {
            self.athleteArr = loadedAthleteArr
            DispatchQueue.main.async {
                self.mainView?.athleteArr = self.athleteArr
                self.mainView?.checkArray()
            }
        } else {
            print("No existing athleteArr found or failed to load.")
        }
        playersArr = self.athleteArr
        mainView?.collectionView?.reloadData()
    }
    
    
    
    
    
    func openDetailPlayerVC(player: Player, indexPatch: Int) {
        print(player, indexPatch)
        let vc = DetailAthleteViewController()
        vc.index = indexPatch
        vc.athlete = player
        navigationController?.topViewController?.navigationItem.title = " "
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    func updateArr(athleteArr: [Player]) {
        self.athleteArr = athleteArr
        mainView?.athleteArr = athleteArr
        self.mainView?.checkArray()
    }
    
    
    func addNewPlayer() {
        let vc = AddNewPlayerViewController()
        vc.athleteArr = self.athleteArr
        vc.delegate = self
        navigationController?.topViewController?.navigationItem.title = " "
        navigationController?.pushViewController(vc, animated: true)
    }

    
    
    func showEditView(amountLabel: UILabel, totalLabel: UILabel) {
        let vc = EditStatisticViewController(amountLabel: amountLabel, totalLabel: totalLabel)
        self.present(vc, animated: true)
    }
    
    
    
}
