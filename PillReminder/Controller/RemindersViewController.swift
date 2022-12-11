//
//  ViewController.swift
//  PillReminder
//
//  Created by null on 4.12.2022.
//

import RealmSwift
import UIKit

class RemindersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placeholder: UIImageView!
    
    let realm = try! Realm()
    
    var reminders: Results<Reminder>?
    
    var selectedReminderRow = 0
    var selectedPillName = ""
    var selectedRingInfo = true
    var selectedReminderDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableReminderCell")
                
        getDataFromRealm()

        self.navigationController?.navigationBar.tintColor = UIColor.systemIndigo
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        
        if self.tableView.numberOfRows(inSection: 0) > 0 {
            placeholder.isHidden = true
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToReminderDetailsVC" {
            let destinationVC = segue.destination as! SaveReminderController
            destinationVC.pillName = selectedPillName
            destinationVC.ring = selectedRingInfo
            destinationVC.row = selectedReminderRow
            destinationVC.reminderDate = selectedReminderDate
            destinationVC.saveType = "Update"
        }
    }

    func getDataFromRealm() {
        reminders = realm.objects(Reminder.self)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension RemindersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableReminderCell", for: indexPath) as! TableViewCell
        
        if let reminder = reminders?[indexPath.row] {
            cell.pillName.text = reminder.name
            
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            cell.reminderDate.text = formatter.string(from: reminder.reminderDate!)
        }

        return cell
    }
}

extension RemindersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let reminder = reminders?[indexPath.row] {
            selectedPillName = reminder.name
            selectedRingInfo = reminder.ring
            selectedReminderDate = reminder.reminderDate
            selectedReminderRow = indexPath.row
        }
        performSegue(withIdentifier: "goToReminderDetailsVC", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let reminderToDelete = self.reminders?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(reminderToDelete)
                        self.tableView.reloadData()
                        if self.tableView.numberOfRows(inSection: 0) == 0 {
                            placeholder.isHidden = false
                        }
                    }
                } catch {
                    print("Error")
                }
            }
        }
    }
}

