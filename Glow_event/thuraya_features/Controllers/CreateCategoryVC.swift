
import UIKit

class CreateCategoryVC: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func createCategoryTapped(_ sender: Any) {
        guard let name = nameTF.text, !name.isEmpty else { return }
        
        let newCategory = Category(id: UUID(), name: name, type: name)
        CategoryManager.shared.categories.append(newCategory)
        navigationController?.popViewController(animated: true)
    }
    
}
