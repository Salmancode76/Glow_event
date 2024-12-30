
import UIKit

class ReportDetailVC: UIViewController {
    
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var deleteBtn: UIButton!
    
    @objc func doneButtonPressed() {
        if let  datePicker = self.dateTF.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            self.dateTF.text = dateFormatter.string(from: datePicker.date)
        }
        self.dateTF.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateTF.addInputViewDatePicker(target: self, selector: #selector(doneButtonPressed))
        
    }
    
}
