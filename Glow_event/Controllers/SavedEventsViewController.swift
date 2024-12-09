//
//  SavedEventsViewController.swift
//  Glow_event
//
//  Created by Thuraya AlSatrawi on 09/12/2024.
//

import UIKit

class SavedEventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var eventsTableView:UITableView!
    
    var eventName = ["Calvin Harris Live", "SZA Live"]
    var Dates = ["Fri, Nov 20 - 6:00 PM","Fri, Nov 21 - 8:00 PM" ]
    var locations = ["Al Dana Amphitheatre • Bahrain", "Bahrain Grand Prix"]
    var pic = "eventPic"

    override func viewDidLoad() {
        super.viewDidLoad()
        eventsTableView.backgroundColor = .clear
        
        let nib = UINib(nibName: "SavedEventsTableViewCell", bundle: nil)
        eventsTableView.register(nib, forCellReuseIdentifier: "customEvent")
        // Do any additional setup after loading the view.
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

extension SavedEventsViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customEvent", for: indexPath) as? SavedEventsTableViewCell
        cell?.eventInit(Dates[indexPath.row], pic, eventName[indexPath.row], locations[indexPath.row])
        cell?.backgroundColor = .clear
        cell?.contentView.backgroundColor = .clear
        return cell!
        
    }
    
}
