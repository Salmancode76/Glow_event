
import UIKit

class SettingsTabVC: UIViewController {
    
    @IBOutlet weak var manageUsersView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Update the title of the TabBarVC
        if let tabBarVC = self.tabBarController as? TabBarVC {
            tabBarVC.title = "Settings"
        }
    }
    
    @IBAction func manageUsersTapped(_ sender: Any) {
        
    }
    
    @IBAction func manageCategoriesTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CategoriesListVC") as! CategoriesListVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func manageReportsTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ReportsListVC") as! ReportsListVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func manageOrganizersTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "OrganizersListVC") as! OrganizersListVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
