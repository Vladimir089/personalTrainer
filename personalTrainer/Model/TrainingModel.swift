//
//  TrainingModel.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 11.06.2024.
//

import Foundation
import UIKit


struct Training: Codable {
    var name: String
    var imageData: Data?
    var repetitions: String
    var approaches: String
    var players: [Player]?
    var exercises: [Exercises]?
    
    init(name: String, image: UIImage? = nil, repetitions: String, approaches: String, players: [Player]? = nil, exercises: [Exercises]? = nil) {
        self.name = name
        self.repetitions = repetitions
        self.approaches = approaches
        self.players = players
        self.exercises = exercises
        self.imageData = image?.jpegData(compressionQuality: 0.5)!

    }
    
}

struct Exercises: Codable {
    var name: String
    var repetitions: String
    var approaches: String
    var weight: String
}
