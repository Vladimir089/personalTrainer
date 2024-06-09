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
    var age: String
    var height: String
    var weight: String
    var classesPerMonth: String
    var duration: String
    var imageData: Data?
    var achivements: [Achivement]?
    
    
    init(name: String, age: String, height: String, weight: String, classesPerMonth: String, duration: String, image: UIImage? = nil, achivements: [Achivement]? = nil) {
        self.name = name
        self.age = age
        self.height = height
        self.weight = weight
        self.classesPerMonth = classesPerMonth
        self.duration = duration
        self.imageData = image?.jpegData(compressionQuality: 0.1)!
        
        
        self.achivements = achivements
    }
    
    
}


struct Achivement: Codable {
    var mainText: String
    var secondaryText: String?
}
