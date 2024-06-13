//
//  RatingModel.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 13.06.2024.
//

import Foundation

struct Rating: Codable {
    var name: String
    var rate: Int
    
    
    init(name: String, rate: Int) {
        self.name = name
        self.rate = rate
    }

}
