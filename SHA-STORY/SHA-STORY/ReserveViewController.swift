//
//  ReserveViewController.swift
//  SHA-STORY
//
//  Created by Sai Ram Muthyala on 3/27/24.
//

import UIKit
import Eureka

class ReserveViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section("Date") {
            $0 <<< DateRow() {
                $0.title = "Select Date"
                $0.value = Date()
            }
        }
        form +++ Section("Time") {
            $0 <<< TimeRow() {
                $0.title = "Select Time"
                $0.value = Date()
            }
        }
        
        form +++ Section("Number of People") {
            $0 <<< StepperRow() {
                $0.title = "Party Size"
                $0.value = 1
            }
        }
        
        form +++ Section() {
            $0 <<< ButtonRow() {
                $0.title = "Book"
            }.onCellSelection { _, _ in
                self.makeReservation()
            }
        }
        <<< TextRow() {
                $0.title = "Click on book to select tables"
            $0.cellSetup { cell, _ in
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.textAlignment = .center
                cell.textLabel?.textColor = UIColor(red: 143/255, green: 27/255, blue: 85/255, alpha: 1)

                          }
            }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let stepperRow = form.rowBy(tag: "PartySize") as? StepperRow {
            if let stepperValue = stepperRow.value {
                stepperRow.cell.detailTextLabel?.text = "\(Int(stepperValue))"
            }
        }
    }
    
    func makeReservation() {
        // Retrieve values from form
        let values = form.values()
        
        // Access date, time, and number of people
        if let selectedDate = values["Select Date"] as? Date,
           let selectedTime = values["Select Time"] as? Date,
           let numberOfPeople = values["Number of People"] as? Int {
            // Perform reservation logic here
            print("Reservation Date: \(selectedDate)")
            print("Reservation Time: \(selectedTime)")
            print("Number of People: \(numberOfPeople)")
        }
    }

}
