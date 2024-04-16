//
//  ReserveViewController.swift
//  SHA-STORY
//
//  Created by Sai Ram Muthyala on 3/27/24.
//

import UIKit
import Eureka

class ReserveVC: FormViewController {
    var selectedTimeButton: ButtonRow?
    var selectedDate: Date = Date()
    var numberOfPeople: Int = 1
    override func viewDidLoad() {
        print("username: \(AppDelegate.username)")
        super.viewDidLoad()
        form +++ Section("Date") {
            $0 <<< DateRow() {
                $0.title = "Select Date"
                $0.value = Date()
                $0.minimumDate = Date()
            }.cellUpdate { cell, _ in
                cell.textLabel?.textColor = UIColor(red: 143/255, green: 27/255, blue: 85/255, alpha: 1)
                cell.detailTextLabel?.textColor =  UIColor(red: 143/255, green: 27/255, blue: 85/255, alpha: 1)
            }.cellSetup { cell, _ in
                cell.textLabel?.textColor = UIColor(red: 143/255, green: 27/255, blue: 85/255, alpha: 1)
                cell.detailTextLabel?.textColor =  UIColor(red: 143/255, green: 27/255, blue: 85/255, alpha: 1)
            }.onChange { [weak self] row in
                self?.selectedDate = row.value ?? Date()
            }
        }
        form +++ Section("Select Time") {
                   $0 <<< ButtonRow() {
                       $0.tag = "7:00 PM"
                       $0.title = "7:00 PM"
                   }.cellSetup { cell, _ in
                       cell.tintColor = UIColor(red: 143/255, green: 27/255, blue: 85/255, alpha: 1) // Initial tint color
                   }.onCellSelection { cell, _ in
                       self.selectTimeButton(cell: cell)
                   }
                   <<< ButtonRow() {
                       $0.tag = "8:00 PM"
                       $0.title = "8:00 PM"
                   }.cellSetup { cell, _ in
                       cell.tintColor = UIColor(red: 143/255, green: 27/255, blue: 85/255, alpha: 1) // Initial tint color
                   }.onCellSelection { cell, _ in
                       self.selectTimeButton(cell: cell)
                   }
                   <<< ButtonRow() {
                       $0.tag = "9:00 PM"
                       $0.title = "9:00 PM"
                   }.cellSetup { cell, _ in
                       cell.tintColor = UIColor(red: 143/255, green: 27/255, blue: 85/255, alpha: 1) // Initial tint color
                   }.onCellSelection { cell, _ in
                       self.selectTimeButton(cell: cell)
                   }
                   <<< ButtonRow() {
                       $0.tag = "10:00 PM"
                       $0.title = "10:00 PM"
                   }.cellSetup { cell, _ in
                       cell.tintColor = UIColor(red: 143/255, green: 27/255, blue: 85/255, alpha: 1)// Initial tint color
                   }.onCellSelection { cell, _ in
                       self.selectTimeButton(cell: cell)
                   }
                   <<< ButtonRow() {
                       $0.tag = "11:00 PM"
                       $0.title = "11:00 PM"
                   }.cellSetup { cell, _ in
                       cell.tintColor = UIColor(red: 143/255, green: 27/255, blue: 85/255, alpha: 1) // Initial tint color
                   }.onCellSelection { cell, _ in
                       self.selectTimeButton(cell: cell)
                   }
               }
        form +++ Section("Number of People") {
            $0 <<< StepperRow("PartySize") {
                $0.title = "Party Size"
                $0.value = 1
                $0.cellUpdate { cell, _ in
                    cell.textLabel?.textColor = UIColor(red: 143/255, green: 27/255, blue: 85/255, alpha: 1)
                    cell.detailTextLabel?.textColor =  UIColor(red: 143/255, green: 27/255, blue: 85/255, alpha: 1)
                    cell.valueLabel?.textColor = UIColor(red: 143/255, green: 27/255, blue: 85/255, alpha: 1)
                }
                $0.onChange { row in
                    self.numberOfPeople = Int(row.value!)
                }
                $0.displayValueFor = { value in
                    return "\(Int(value ?? 0))"
                }
            }
        }

                
        form +++ Section() {
            $0 <<< ButtonRow() {
                $0.title = "Select seats"
            }.cellUpdate { cell, _ in
                cell.textLabel?.textColor =  UIColor(red: 143/255, green: 27/255, blue: 85/255, alpha: 1)
                cell.detailTextLabel?.textColor =  UIColor(red: 143/255, green: 27/255, blue: 85/255, alpha: 1)// Change title color to red
            }.cellSetup { cell, _ in
                cell.textLabel?.textColor =  UIColor(red: 143/255, green: 27/255, blue: 85/255, alpha: 1)
                cell.detailTextLabel?.textColor =  UIColor(red: 143/255, green: 27/255, blue: 85/255, alpha: 1)// Change title color to red
            }.onCellSelection { _, _ in
                self.makeReservation()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func selectTimeButton(cell: ButtonCellOf<String>) {
          // Deselect previous button
          if let prevSelectedButton = selectedTimeButton {
              prevSelectedButton.cell.textLabel?.textColor = UIColor(red: 143/255, green: 27/255, blue: 85/255, alpha: 1)
          }
          
          // Select current button
          cell.textLabel?.textColor = .black
          selectedTimeButton = cell.row as? ButtonRow
      }
      
    func selectTime(time: String) {
           // Handle time selection
           print("Selected Time: \(time)")
       }
    
    func makeReservation() {
        // Retrieve values from form
        let values = form.values()
        print(selectedTimeButton?.title as Any)
        print(selectedDate as Any)
        print(numberOfPeople as Any)
        if(selectedTimeButton?.title == nil){
            let alertController = UIAlertController(title: "Error", message: "Please select a time", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
        else{
            performSegue(withIdentifier: "reserveTable", sender: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reserveTable"{
            if let navigationController = segue.destination as? UINavigationController,
               let tableBookingVC = navigationController.topViewController as? TableBookingVC {
                tableBookingVC.selectedDate = selectedDate
                tableBookingVC.selectedTime = selectedTimeButton?.title ?? "7:00 PM"
                tableBookingVC.numberOfPeople = numberOfPeople
            }
        }
    }

}
