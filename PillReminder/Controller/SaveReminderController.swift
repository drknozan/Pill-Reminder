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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

