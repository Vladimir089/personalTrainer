//
//  CalendarModel.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 12.06.2024.
//

import Foundation
import UIKit

struct Event: Codable {
    var name: String
    var date: Date
    var time: String
    var location: String
    var discriprion: String
    var players: [Player]
    
    
    init(date: Date, time: String, location: String, discriprion: String, players: [Player], name: String) {
        self.name = name
        self.date = date
        self.time = time
        self.location = location
        self.discriprion = discriprion
        self.players = players
    }
    
    
}
