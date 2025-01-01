
import UIKit

class ReportsListVC: UIViewController {
    
    @IBOutlet weak var reportsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reportsTableView.delegate = self
        reportsTableView.dataSource = self
    }
    
}

extension ReportsListVC: UITableViewDelegate, UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ReportDetailVC") as! ReportDetailVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
