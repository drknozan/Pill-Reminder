//
//  Reminder.swift
//  PillReminder
//
//  Created by null on 4.12.2022.
//

import Foundation

class Reminder: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var reminderDate: Date?
    @objc dynamic var ring: Bool = false
}
