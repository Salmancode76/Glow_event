
import UIKit

class CategoriesListVC: UIViewController {
    
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (categoriesCollectionView.frame.width / 2) - 15, height: categoriesCollectionView.frame.width / 3)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 15
        categoriesCollectionView.collectionViewLayout = layout
        
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        categoriesCollectionView.reloadData()
    }
    
    @objc
    func addTapped() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CreateCategoryVC") as! CreateCategoryVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension CategoriesListVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoryManager.shared.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let category = CategoryManager.shared.categories[indexPath.row]
        cell.categoryLbl.text = category.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "EditCategoryVC") as! EditCategoryVC
        vc.category = CategoryManager.shared.categories[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

class CategoryManager {
    static let shared = CategoryManager()
    
    private init() {}
    
    var categories: [Category] = [
        
    ]
}
