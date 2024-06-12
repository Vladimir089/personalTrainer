//
//  CalendarViewController.swift
//  personalTrainer
//
//  Created by Владимир Кацап on 12.06.2024.
//

import UIKit

protocol CalendarViewControllerDelegate: AnyObject {
    func createEditVC()
    func updateArr(events: [Event])
    func showDetail(item: Event, index: Int)
    func deleteItem(idnex: Int, item: Event)
}

class CalendarViewController: UIViewController {
    
    var mainView: CalendarView?
    
    var events: [Event] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = CalendarView()
        mainView?.delegate = self
        if let loadedEventArr = loadEventsArrFromFile() {
            self.events = loadedEventArr
            print(events)
            DispatchQueue.main.async {
                self.mainView?.events = self.events
                self.mainView?.eventsByDate = self.mainView?.groupEventsByDate(self.events) ?? [(date: String, events: [Event])]()
                self.mainView?.checkArray()
            }
        } else {
            print("No existing eventArr found or failed to load.")
        }
        self.view = mainView
    }
    

    func loadEventsArrFromFile() -> [Event]? {
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to get document directory")
            return nil
        }
        let filePath = documentDirectory.appendingPathComponent("eventAr.plist")
        do {
            let data = try Data(contentsOf: filePath)
            let events = try JSONDecoder().decode([Event].self, from: data)
            return events
        } catch {
            print("Failed to load or decode events: \(error)")
            self.mainView?.checkArray()
            self.mainView?.collectionView?.reloadData()
            return nil
        }
    }
    
    
    func saveEventArrToFile(data: Data) throws {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("eventAr.plist")
            try data.write(to: filePath)
        } else {
            throw NSError(domain: "SaveError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to get document directory"])
        }
    }


}


extension CalendarViewController: CalendarViewControllerDelegate {
    func deleteItem(idnex: Int, item: Event) {
        events.remove(at: idnex)
        do {
            let data = try JSONEncoder().encode(events)
            try saveEventArrToFile(data: data)
        } catch {
            print("Failed to encode or save events: \(error)")
        }
        
        if let loadEventsArr = loadEventsArrFromFile() {
            self.events = loadEventsArr
            DispatchQueue.main.async {
                self.mainView?.events = self.events
                self.mainView?.checkArray()
                
            }
        } else {
            print("No existing athleteArr found or failed to load.")
        }
        updateArr(events: events)
        mainView?.collectionView?.reloadData()
    }
    
    
    
    func showDetail(item: Event, index: Int) {
        let vc = DetailCalendarViewController()
        navigationController?.topViewController?.navigationItem.title = " "
        vc.delegate = self
        vc.event = item
        vc.index = index
        vc.events = events
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func updateArr(events: [Event]) {
        self.events = events
        mainView?.events = events
        mainView?.eventsByDate = mainView?.groupEventsByDate(events) ?? [(date: String, events: [Event])]()
        self.mainView?.checkArray()
    }
    
   
    
    
    
    func createEditVC() {
        let vc = EditAndNewEventViewController()
        navigationController?.topViewController?.navigationItem.title = " "
        vc.delegate = self
        vc.isNew = true
        vc.events = events
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    
}
