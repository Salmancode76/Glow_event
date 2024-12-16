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
    var selectedSort : String = "Any"
    var events: [Event] = [] // Events passed from SearchEventOrgViewController
    var filteredEvents: [Event] = []
    var FromDate : Date?
    var ToDate : Date?
    @IBOutlet weak var EventCatgory: UIButton!
    @IBOutlet weak var EventAge: UIButton!
    @IBOutlet weak var EventVen: UIButton!
    @IBOutlet weak var EventStatusBtn: UIButton!
    @IBOutlet weak var FromEventPKR: UIDatePicker!
    @IBOutlet weak var EventSortPriceBtn: UIButton!
    @IBOutlet weak var ToEventPKR: UIDatePicker!

    
    weak var delegate: FilterTableViewControllerDelegate? // Delegate reference
    
    @IBAction func OptionSortPrice(_ sender: UIAction) {
        self.selectedSort = sender.title
        
        self.EventSortPriceBtn.setTitle(selectedSort, for: .normal)
        
    }
    
    @IBAction func OptionFilterCategory(_ sender: UIAction) {
        // Directly access sender.title since it's a non-optional String
        self.selectedEventCategory = sender.title
        self.EventCatgory.setTitle(selectedEventCategory, for: .normal)
        
        print("Filtered events: ", self.selectedStatus)
    }
    @IBAction func OptionFilterStatus(_ sender: UIAction) {
        // Directly access sender.title since it's a non-optional String
        self.selectedStatus = sender.title
        self.EventStatusBtn.setTitle(selectedStatus, for: .normal)
        
        print("Filtered events: ", self.selectedStatus)
    }
    
    @IBAction func OptionFilterDateFrom(_ sender: UIDatePicker) {
        // Directly access sender.title since it's a non-optional String
        self.FromDate = sender.date
    }
    @IBAction func OptionFilterDateTo(_ sender: UIDatePicker) {
        // Directly access sender.title since it's a non-optional String
        self.ToDate = sender.date
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

        if !AnyDateSW.isOn {
            // If the switch is OFF, use the date range for filtering
            guard let fromDate = self.FromDate, let toDate = self.ToDate else {
                // Either FromDate or ToDate is nil, so we return early or handle it
                print("FromDate or ToDate is nil")
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
        
        let Sorted : [Event]
        
        print(selectedSort)
     
         if selectedSort == "Highest"{
            Sorted = filteredByStatus.sorted { event1, event2 in
                   return event2.price > event1.price
               }
         }else if selectedSort == "Lowest"{
             Sorted = filteredByStatus.sorted { event1, event2 in
                    return event2.price < event1.price
                }
         }else{
             Sorted = filteredByStatus
         }

        // Print filtered events for debugging purposes

        // Pass the filtered events to the delegate
        delegate?.applyFilterWith(events: Sorted)

        // Pop back to the previous view controller
        navigationController?.popViewController(animated: true)
    }



    @IBAction func ResetFilters(_ sender: Any) {

           AnyDateSW.setOn(true, animated: true)
           
     
           FromEventPKR.date = Date()
           ToEventPKR.date = Date()
           FromDate = nil
           ToDate = nil
           
      
           EventCatgory.setTitle("Any", for: .normal)
           EventAge.setTitle("Any", for: .normal)
           EventVen.setTitle("Any", for: .normal)
           EventStatusBtn.setTitle("Any", for: .normal)
           EventSortPriceBtn.setTitle("Any", for: .normal)
           
          
           selectedEventCategory = "Any"
           selectedAge = "Any"
           selectedVenu = "Any"
           selectedStatus = "Any"
           selectedSort = "Any"
           
        
           filteredEvents = events
           
      
           tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        

        
        FromEventPKR.backgroundColor = UIColor.black
        
        
        ToEventPKR.backgroundColor = UIColor.black
        
        
        FromEventPKR.tintColor = UIColor.white
        ToEventPKR.tintColor = UIColor.black
        
        // Customize section header color
        // MARK: - TableView Delegate Method to Customize Header Appearance
  
        
        
        if #available(iOS 14.0, *) {
            FromEventPKR.setValue(UIColor.white, forKeyPath: "textColor")
            ToEventPKR.setValue(UIColor.white, forKeyPath: "textColor")
        }
        
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
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
       guard let header = view as? UITableViewHeaderFooterView else { return }
       
       // Set the background color of the header to white
       header.contentView.backgroundColor = .black
       
       // Set the text color of the header to black
       header.textLabel?.textColor = .white
       
        tableView.tableFooterView = UIView(frame: .zero)
        
        // Set the separator color to gray
        tableView.separatorColor = UIColor.white
       //tableView.separatorStyle = .none

  
   }
    
    
    @IBAction func AnyDateSwitchChanged(_ sender: UISwitch) {
          // Toggle the date pickers' enabled state based on the switch
          toggleDatePickersState()
      }
      
      // MARK: - Helper Methods
      private func toggleDatePickersState() {
          // Disable date pickers if switch is OFF, enable if switch is ON
          
          print("pressed")
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
