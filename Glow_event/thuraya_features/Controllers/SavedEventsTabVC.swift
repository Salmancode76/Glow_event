
import UIKit

class SavedEventsTabVC: UIViewController {
    
    @IBOutlet weak var savedEventsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savedEventsTableView.delegate = self
        savedEventsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationItem.rightBarButtonItem = nil
        
        // Update the title of the TabBarVC
        if let tabBarVC = self.tabBarController as? TabBarVC {
            tabBarVC.title = "Saved"
        }
    }
    
}

extension SavedEventsTabVC: UITableViewDelegate, UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedEventCell", for: indexPath) as! SavedEventCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 126
    }
    
}
