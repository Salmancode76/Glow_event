
import UIKit

class OrganizerProfileVC: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var websiteURLTF: UITextField!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userImgView: UIImageView!
    
    var isEdit: Bool = false {
        didSet {
            if isEdit {
                navigationItem.rightBarButtonItem = nil
                emailTF.inputView = UIView()
                websiteURLTF.inputView = UIView()
            } else {
                emailTF.inputView = nil
                websiteURLTF.inputView = nil
                emailTF.isEnabled = true
                websiteURLTF.isEnabled = true
                navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(addTapped))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.inputView = UIView()
        websiteURLTF.inputView = UIView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(addTapped))
    }
    
    @objc
    func addTapped() {
        isEdit = !isEdit
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        
    }
    
    
}
