//
//  RatingViewController.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 13.06.2024.
//

import UIKit

protocol RatingViewControllerDelegate: AnyObject {
    func createRating()
    func saveRating(rating: [Rating])
}

class RatingViewController: UIViewController {
    
    var mainView: RatingView?
    
    var rating: [Rating] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = RatingView()
        
        if let loadedRatingArr = loadRatingArrFromFile() {
            self.rating = loadedRatingArr
            print(rating)
            DispatchQueue.main.async {
                self.mainView?.rating = self.rating
                self.mainView?.checkArray()
            }
        } else {
            print("No existing eventArr found or failed to load.")
        }
        mainView?.delegate = self
        self.view = mainView
    }
    
    
    func loadRatingArrFromFile() -> [Rating]? {
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to get document directory")
            return nil
        }
        let filePath = documentDirectory.appendingPathComponent("rating.plist")
        do {
            let data = try Data(contentsOf: filePath)
            let rating = try JSONDecoder().decode([Rating].self, from: data)
            return rating
        } catch {
            print("Failed to load or decode events: \(error)")
            self.mainView?.checkArray()
            //self.mainView?.collectionView?.reloadData()
            return nil
        }
    }
    
    
    func saveRatingArrToFile(data: Data) throws {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("rating.plist")
            try data.write(to: filePath)
        } else {
            throw NSError(domain: "SaveError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to get document directory"])
        }
    }
    


}

extension RatingViewController: RatingViewControllerDelegate {
    
    
    func saveRating(rating: [Rating]) {
        self.rating = rating
        mainView?.rating = rating
        self.mainView?.checkArray()
    }
    
    
    func createRating() {
        let vc = NewRatingViewController()
        navigationController?.topViewController?.navigationItem.title = " "
        vc.delegate = self
        vc.rating = rating
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   
}
