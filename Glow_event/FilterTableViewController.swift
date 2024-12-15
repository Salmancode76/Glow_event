//
//  FilterTableViewController.swift
//  Glow_event
//
//  Created by BP-36-201-09 on 14/12/2024.
//

import UIKit
// Declare the protocol to be used for passing data back to SearchEventOrgViewController
protocol FilterTableViewControllerDelegate: AnyObject {
    func applyFilterWith(events: [Event])
}

class FilterTableViewController: UITableViewController {
    @IBOutlet weak var AnyDateSW: UISwitch!
    
    var selectedEventCategory: String = "Any"
    var selectedAge:String = "Any"
    var selectedVenu : String = "Any"
    var selectedStatus:String = "Any"
    var events: [Event] = [] // Events passed from SearchEventOrgViewController
    var filteredEvents: [Event] = []
    var FromDate : Date?
    var ToDate : Date?
    @IBOutlet weak var ToEventPKR: UIDatePicker!
    @IBOutlet weak var EventCatgory: UIButton!
    @IBOutlet weak var EventAge: UIButton!
    @IBOutlet weak var EventVen: UIButton!
    @IBOutlet weak var EventStatusBtn: UIButton!
    @IBOutlet weak var FromEventPKR: UIDatePicker!
    
    weak var delegate: FilterTableViewControllerDelegate? // Delegate reference
    
    
    @IBAction func OptionFilterStatus(_ sender: UIAction) {
        // Directly access sender.title since it's a non-optional String
        self.selectedStatus = sender.title
        self.EventStatusBtn.setTitle(selectedStatus, for: .normal)
        
        print("Filtered events: ", self.selectedStatus)
    }


    @IBAction func OptionFilterAge(_ sender: UIAction) {
        // Directly access sender.title since it's a non-optional String
        self.selectedAge = sender.title
        self.EventAge.setTitle(selectedAge, for: .normal)
        
        print("Filtered events: ", self.selectedAge )
    }
    @IBAction func OptionFilterLocation(_ sender: UIAction) {
        // Directly access sender.title since it's a non-optional String
        self.selectedVenu = sender.title
        self.EventVen.setTitle(selectedVenu, for: .normal)
        
        print("Filtered events: ", self.selectedVenu  )
    }
    
    
    @IBAction func ApplyFilter(_ sender: Any) {
        // First, apply the category filter (if any)
        let filteredByCategory = selectedEventCategory != "Any" ?
            events.filter {
                $0.EventCategory?.lowercased() == selectedEventCategory.lowercased()
            } : events

        // Apply the date range filter based on switch state
        var filteredByDate: [Event] = filteredByCategory

        if AnyDateSW.isOn {
            // If the switch is ON, we don't use the date range for filtering
            print("Date filtering is disabled because the switch is ON")
        } else {
            // If the switch is OFF, use the date range for filtering
            guard let fromDate = self.FromDate, let toDate = self.ToDate else {
                print("Invalid FromDate or ToDate")
                return
            }

            filteredByDate = filteredByCategory.filter { event in
                return event.startDate >= fromDate && event.endDate <= toDate
            }
        }

        // Apply the age group filter
        let filteredByAge = filteredByDate.filter { event in
            return selectedAge == "Any" || event.AgeGroup?.lowercased() == selectedAge.lowercased()
        }

        // Apply the location filter
        let filteredByLocation = filteredByAge.filter { event in
            return selectedVenu == "Any" || event.venu_options.lowercased() == selectedVenu.lowercased()
        }

        // Apply the status filter
        let filteredByStatus: [Event]
        if selectedStatus == "Any" {
            // If status is "Any", skip the status filter
            filteredByStatus = filteredByLocation
        } else {
            filteredByStatus = filteredByLocation.filter { event in
                return event.EventStatus.lowercased() == selectedStatus.lowercased()
            }
        }

        // Print filtered events for debugging purposes
        print("Filtered events: ", filteredByStatus)

        // Pass the filtered events to the delegate
        delegate?.applyFilterWith(events: filteredByStatus)

        // Pop back to the previous view controller
        navigationController?.popViewController(animated: true)
    }




    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        
        
        func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return 1
        }
        
       
        print(events);

    }
    
    
    @IBAction func AnyDateSwitchChanged(_ sender: UISwitch) {
          // Toggle the date pickers' enabled state based on the switch
          toggleDatePickersState()
      }
      
      // MARK: - Helper Methods
      private func toggleDatePickersState() {
          // Disable date pickers if switch is OFF, enable if switch is ON
          let isSwitchOff = !AnyDateSW.isOn
          FromEventPKR.isEnabled = isSwitchOff
          ToEventPKR.isEnabled = isSwitchOff
          
          // Optionally, change the background color or appearance to indicate disabled state
          FromEventPKR.alpha = isSwitchOff ? 1.0 : 0.5
          ToEventPKR.alpha = isSwitchOff ? 1.0 : 0.5
          
          // Reset the dates if the switch is off
          if !isSwitchOff {
              FromEventPKR.date = Date()
              ToEventPKR.date = Date()
              FromDate = nil
              ToDate = nil
          }
      }
}
