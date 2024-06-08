//
//  PlayerModel.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 08.06.2024.
//

import Foundation
import UIKit

struct Player: Codable {
    var name: String
    var age: Int
    var height: Double
    var weight: Double
    var classesPerMonth: Int
    var duration: Double
    var imageData: Data
    var achivements: [Achivement]
    
    
    init(name: String, age: Int, height: Double, weight: Double, classesPerMonth: Int, duration: Double, image: UIImage, achivements: [Achivement]) {
        self.name = name
        self.age = age
        self.height = height
        self.weight = weight
        self.classesPerMonth = classesPerMonth
        self.duration = duration
        self.imageData = image.jpegData(compressionQuality: 1.0)! // или PNG -> imageData = image.pngData()!
        self.achivements = achivements
    }
    
    
    func getImage() -> UIImage? {
        return UIImage(data: self.imageData)
    }
}


struct Achivement: Codable {
    var mainText: String
    var secondaryText: String?
}
