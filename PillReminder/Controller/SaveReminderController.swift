//
//  ViewController.swift
//  PillReminder
//
//  Created by null on 4.12.2022.
//

import RealmSwift
import UIKit
import UserNotifications

class SaveReminderController: UIViewController {

    @IBOutlet weak var pillNameTextField: UITextField!
    @IBOutlet weak var reminderDatePicker: UIDatePicker!
    @IBOutlet weak var ringSwitch: UISwitch!
    @IBOutlet weak var saveButton: UIButton!
    
    let realm = try! Realm()
    
    var reminders: Results<Reminder>?
    
    var saveType = "Add"
    var row = 0
    var pillName: String = ""
    var ring: Bool = true
    var reminderDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        changeAddToUpdate()
        getDataFromRealm()
    }
    
    func getDataFromRealm() {
        reminders = realm.objects(Reminder.self)
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        let name = pillNameTextField.text!
        let date = reminderDatePicker.date
        
        let calendar = Calendar.current
        var component = DateComponents()
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        component.hour = hour
        component.minute = minute
        let reminderDateFormat = calendar.date(from: component)
        
        let ring = ringSwitch.isOn
        
        let reminder = Reminder()
        reminder.reminderDate = reminderDateFormat
        reminder.ring = ring
        reminder.name = name
        
        if ring == true {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    self.createLocalNotification(name: name, hour: hour, minute: minute)
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
        
        if saveType == "Update" {
            if let reminder = reminders?[row] {
                do {
                    try realm.write {
                        reminder.name = name
                        reminder.reminderDate = reminderDateFormat
                        reminder.ring = ring
                        navigationController?.popViewController(animated: true)
                    }
                } catch {
                    print("Error")
                }
            }
        } else if saveType == "Add" {
            do {
                try realm.write {
                    realm.add(reminder)
                    navigationController?.popViewController(animated: true)
                }
            } catch {
                print("Error")
            }
        }
    }
    
    func createLocalNotification(name: String, hour: Int, minute: Int) {
        // Create notification content
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Pill Reminder!"
        notificationContent.body = "Don't forget to take your \(name)."
        notificationContent.sound = .default
        
        // Create trigger
        var dateComponent = DateComponents()
        dateComponent.hour = hour
        dateComponent.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        
        // Send notification request
        let request = UNNotificationRequest(identifier: name, content: notificationContent, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error : Error?) in
            if let notificationError = error {
                print(notificationError.localizedDescription)
            }
        }
    }
    
    func changeAddToUpdate() {
        if (saveType != "Add") {
            saveButton.titleLabel!.text = saveType
            pillNameTextField.text = pillName
            ringSwitch.isOn = ring
            reminderDatePicker.setDate(reminderDate!, animated: true)
        }
    }
}

