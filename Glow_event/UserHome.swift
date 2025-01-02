//
//  UserHome.swift
//  Glow_event
//
//  Created by PRINTANICA on 02/01/2025.
//

import UIKit
import FirebaseDatabase


class UserHome: UIViewController , UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    var events: [Event] = []
        let databaseRef = Database.database().reference().child("events")


    override func viewDidLoad() {
        super.viewDidLoad()
        
        Glow_event.fetchEvents { [weak self] fetchedEvents in
                       self?.events = fetchedEvents
                       DispatchQueue.main.async {
                           self?.tableView.reloadData()
                          }
            
            
        }

        // Do any additional setup after loading the view.
    }
    
    
    

        // MARK: - Table View Data Source
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return events.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventTableViewCell
            let event = events[indexPath.row]

            cell.configure(with: event)

            return cell
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
