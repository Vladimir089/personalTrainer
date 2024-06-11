//
//  TrainingViewController.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 11.06.2024.
//

import UIKit


protocol TrainingViewControllerDelegate: AnyObject {
    func createTraining()
    func updateArr(trainingArr: [Training])
    func showDetail(training: Training, index: Int)
    func deleteItem(idnex: Int, item: Training)
    func updateTraining(index: Int, training: Training)
}

class TrainingViewController: UIViewController {
    
    var mainView: TrainingView?
    
    var trainingArr: [Training] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = TrainingView()
        if let loadedTrainingArr = loadTrainingArrFromFile() {
            self.trainingArr = loadedTrainingArr
            print(trainingArr)
            DispatchQueue.main.async {
                self.mainView?.trainingArr = self.trainingArr
                self.mainView?.checkArray()
            }
        } else {
            print("No existing trainingArr found or failed to load.")
        }
        mainView?.delegate = self
        self.view = mainView
    }
    
    
    
    
    
    func loadTrainingArrFromFile() -> [Training]? {
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to get document directory")
            return nil
        }
        let filePath = documentDirectory.appendingPathComponent("triningArr.plist")
        do {
            let data = try Data(contentsOf: filePath)
            let trainingArr = try JSONDecoder().decode([Training].self, from: data)
            return trainingArr
        } catch {
            print("Failed to load or decode triningArr: \(error)")
            return nil
        }
    }
    
    
    func saveTrainingArrToFile(data: Data) throws {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("triningArr.plist")
            try data.write(to: filePath)
        } else {
            throw NSError(domain: "SaveError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to get document directory"])
        }
    }

 

}


extension TrainingViewController: TrainingViewControllerDelegate {
    
    func updateTraining(index: Int, training: Training) {
        trainingArr[index] = training
        do {
            let data = try JSONEncoder().encode(trainingArr)
            try saveTrainingArrToFile(data: data)
        } catch {
            print("Failed to encode or save athleteArr: \(error)")
        }
        
        if let loadTrainingArr = loadTrainingArrFromFile() {
            self.trainingArr = loadTrainingArr
            DispatchQueue.main.async {
                self.mainView?.trainingArr = self.trainingArr
                self.mainView?.checkArray()
            }
        } else {
            print("No existing athleteArr found or failed to load.")
        }
        
        mainView?.collectionView?.reloadData()
    }
    
    
    
    func deleteItem(idnex: Int, item: Training) {
        trainingArr.remove(at: idnex)
        do {
            let data = try JSONEncoder().encode(trainingArr)
            try saveTrainingArrToFile(data: data)
        } catch {
            print("Failed to encode or save athleteArr: \(error)")
        }
        
        if let loadTrainingArr = loadTrainingArrFromFile() {
            self.trainingArr = loadTrainingArr
            DispatchQueue.main.async {
                self.mainView?.trainingArr = self.trainingArr
                self.mainView?.checkArray()
            }
        } else {
            print("No existing athleteArr found or failed to load.")
        }
        mainView?.collectionView?.reloadData()
    }
    
    
    func showDetail(training: Training, index: Int) {
        let vc = DetailTrainingViewController()
        navigationController?.topViewController?.navigationItem.title = " "
        vc.training = training
        vc.index = index
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func createTraining() {
        let vc = NewTrainingViewController()
        navigationController?.topViewController?.navigationItem.title = " "
        vc.delegate = self
        vc.isNew = true
        vc.trainingArr = self.trainingArr
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateArr(trainingArr: [Training]) {
        self.trainingArr = trainingArr
        mainView?.trainingArr = trainingArr
        self.mainView?.checkArray()
    }
    
    
}
