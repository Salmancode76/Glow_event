
import UIKit

class SearchTabVC: UIViewController {
    
    @IBOutlet weak var searchTableview: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTableview.delegate = self
        searchTableview.dataSource = self
    }
    
    @objc func closeButtonClicked(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "OrganizerProfileVC") as! OrganizerProfileVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let image = UIImage(systemName: "person.circle")
        image?.applyingSymbolConfiguration(.init(pointSize: 27, weight: .bold, scale: .large))
          let barButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(closeButtonClicked(_:)))
        tabBarController?.navigationItem.rightBarButtonItem = barButtonItem
        tabBarController?.navigationItem.rightBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem = barButtonItem
        
        // Update the title of the TabBarVC
        if let tabBarVC = self.tabBarController as? TabBarVC {
            tabBarVC.title = "Search"
        }
    }
    
    @objc
    func addTapped() {
    }
    
    @IBAction func filterTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension SearchTabVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedEventCell", for: indexPath) as! SavedEventCell
        cell.saveBtn.setImage(UIImage(systemName: "bookmark"), for: .normal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 126
    }
    
}
