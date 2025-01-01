
import UIKit

class LoginVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        let tabBarVC = storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! TabBarVC
        navigationController?.pushViewController(tabBarVC, animated: true)
        
        
//        // Wrap the TabBarVC in a navigation controller if not already done in storyboard
//        let navigationController = UINavigationController(rootViewController: tabBarVC)
//        navigationController.navigationBar.isTranslucent = true
//        
//        // Set as root view controller
//        UIApplication.shared.windows.first?.rootViewController = navigationController
        
    }
    
}
