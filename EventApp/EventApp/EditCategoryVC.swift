
import UIKit

class EditCategoryVC: UIViewController {
    
    @IBOutlet weak var categoryTF: DropdownTextField!
    @IBOutlet weak var nameTF: UITextField!
    
    var category: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let category = category {
            categoryTF.text = category.type
            nameTF.text = category.name
        }
        
        // Setup dropdown with items
        let categories = CategoryManager.shared.categories.map(\.name)
        categoryTF.setup(items: categories) { [weak self] selected in
            print("Selected category: \(selected)")
        }
        
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        guard let index = CategoryManager.shared.categories.firstIndex(where: { $0.id == category?.id }) else { return }
        CategoryManager.shared.categories[index].name = nameTF.text ?? ""
        CategoryManager.shared.categories[index].type = categoryTF.text ?? ""
        navigationController?.popViewController(animated: true)
    }
    
}
