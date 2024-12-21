//
//  EditEventTableViewController.swift
//  Glow_event
//
//  Created by BP-36-201-17 on 21/12/2024.
//

import UIKit
import SwiftUI

class EditEventTableViewController: UITableViewController {

    @IBOutlet weak var EditName: UITextField!

    @IBOutlet weak var EventStartDate: UIDatePicker!
    @IBOutlet weak var EventDate: UIDatePicker!
    
    @IBOutlet weak var EditPrice: UITextField!
    @IBOutlet weak var EditCategory: UIButton!
    @IBOutlet weak var EditLocation: UIButton!
    @IBOutlet weak var EditAgeGrp: UIButton!
    @IBOutlet weak var EventDes: UITextView!
    @IBOutlet weak var EditStatus: UIButton!
    @IBOutlet weak var EditCap: UITextField!
    @IBOutlet weak var EditImage: UIImageView!
    var eventName: String = ""
    var eventUrl : String = ""
    var eventPrice :Double = 0
    var eventCap :Int = 0
    var eventLocation :String = ""
    var eventCategory : String = ""
    var eventAge : String = ""
    var eventDes : String = ""
    var eventStatus : String = ""
    var eventStartDate : Date
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EditCategory.setTitle(eventCategory, for: .normal) 
        EditName.text = eventName
        
        EditPrice.text = String(eventPrice)
        EditLocation.setTitle(eventLocation, for: .normal)
        
        EditCap.text = String(eventCap)
        
        EditAgeGrp.setTitle(eventAge, for: .normal)

        EventDes.text = eventDes
        
        EditStatus.setTitle(eventStatus, for: .normal)
        EventStartDate.tintColor = UIColor.white
       
            
        EventDate.tintColor = UIColor.white
        if #available(iOS 14.0, *) {
            EventStartDate.setValue(UIColor.white, forKeyPath: "textColor")
            EventDate.setValue(UIColor.white, forKeyPath: "textColor")
        }
        
        
        if let imageUrl = URL(string: eventUrl) {
            CloudinarySetup.DownloadEventyImage(from: eventUrl) { image in
                DispatchQueue.main.async {
                    self.EditImage.image = image
                }
            }
        } else {
            EditImage.image = UIImage(systemName: "photo.fill") // Placeholder image
        }

    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        
        // Set the background color of the header to white
        header.contentView.backgroundColor = .black
        
        // Set the text color of the header to black
        header.textLabel?.textColor = .white
        
        tableView.tableFooterView = UIView()
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 12
        
        
        
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0  // Set the footer height to 0 to hide the footer
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    



}
