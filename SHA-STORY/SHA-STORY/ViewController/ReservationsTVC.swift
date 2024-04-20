import UIKit
import Firebase

class ReservationsTVC: UITableViewController {
    
    var reservations: [(tableName: String, date: String, time: String)] = []
    let db = Firestore.firestore()
    let username = AppDelegate.username// Replace with the actual username
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load reservations data
        fetchReservations()
    }
    
    func fetchReservations() {
        db.collection("Table_Reservation")
            .getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching reservations: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No reservations found")
                return
            }
            
            // Process the documents here
            for document in documents {
                print(document.data())
                if let username = document.data()["username"] as? String, username == self.username ,
                let reservedTables = document.data()["reservedTables"] as? [String],
                   let date = document.data()["date"] as? String,
                   let time = document.data()["time"] as? String {
                    for tableName in reservedTables {
                        self.reservations.append((tableName: tableName, date: date, time: time))
                    }
                }
            }
            
            // Reload the table view after fetching data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reservationCell", for: indexPath)

        let reservation = reservations[indexPath.row]
        cell.textLabel?.text = reservation.tableName
        cell.detailTextLabel?.text = "\(reservation.date) at \(reservation.time)"
        
        return cell
    }
}
