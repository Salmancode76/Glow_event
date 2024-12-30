
import UIKit

class DropdownTextField: UITextField {
    
    private var dropdownTableView: UITableView!
    private var dropdownHeight: CGFloat = 200
    private var items: [String] = []
    private var selectedCallback: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        
        // Configure TextField
        borderStyle = .roundedRect
        rightViewMode = .always
        
        // Create and set right view with padding
        let paddedDropdownIndicator = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 20))
        let iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        iconView.image = UIImage(systemName: "chevron.down")
        iconView.tintColor = .systemGray
        iconView.contentMode = .center
        paddedDropdownIndicator.addSubview(iconView)
        iconView.center = paddedDropdownIndicator.center
        rightView = paddedDropdownIndicator
        
        // Make textfield non-editable
        isUserInteractionEnabled = true
        isEnabled = true
        // This prevents keyboard from showing up but allows tap gestures
        inputView = UIView()
        
        // Create TableView for dropdown
        dropdownTableView = UITableView(frame: .zero, style: .plain)
        dropdownTableView.backgroundColor = .black
        dropdownTableView.layer.cornerRadius = 8
        dropdownTableView.layer.masksToBounds = true
        dropdownTableView.delegate = self
        dropdownTableView.dataSource = self
        dropdownTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        dropdownTableView.isHidden = true
        dropdownTableView.layer.borderWidth = 0.5
        dropdownTableView.layer.borderColor = UIColor.systemGray3.cgColor
        dropdownTableView.rowHeight = 40 // Smaller cell height
        dropdownTableView.separatorColor = .lightGray // More visible separator for dark theme
        
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldTapped))
        addGestureRecognizer(tapGesture)
    }
    
    func setup(items: [String], selectedCallback: @escaping (String) -> Void) {
        self.items = items
        self.selectedCallback = selectedCallback
        
        // Important: Remove existing dropdownTableView if it exists
        dropdownTableView.removeFromSuperview()
        
        if let parentView = superview {
            parentView.backgroundColor = .black
            parentView.addSubview(dropdownTableView)
            dropdownTableView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                dropdownTableView.topAnchor.constraint(equalTo: bottomAnchor, constant: 4),
                dropdownTableView.leftAnchor.constraint(equalTo: leftAnchor),
                dropdownTableView.rightAnchor.constraint(equalTo: rightAnchor),
                dropdownTableView.heightAnchor.constraint(equalToConstant: dropdownHeight)
            ])
            
            // Ensure the dropdown is above other views
            parentView.bringSubviewToFront(dropdownTableView)
            
        }
        
        // Reload table data after setting items
        dropdownTableView.reloadData()
        
    }
    
    @objc private func textFieldTapped() {
        dropdownTableView.isHidden.toggle()
        
        // Rotate the chevron
        if let paddedView = rightView, let imageView = paddedView.subviews.first as? UIImageView {
            UIView.animate(withDuration: 0.3) {
                imageView.transform = self.dropdownTableView.isHidden ? .identity : CGAffineTransform(rotationAngle: .pi)
            }
        }
    }
    
    // Hide dropdown when clicking outside
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if let window = window {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideDropdown))
            tapGesture.cancelsTouchesInView = false
            window.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc private func hideDropdown() {
        if !dropdownTableView.frame.contains(convert(bounds, to: nil)) {
            dropdownTableView.isHidden = true
            if let paddedView = rightView, let imageView = paddedView.subviews.first as? UIImageView {
                UIView.animate(withDuration: 0.3) {
                    imageView.transform = .identity
                }
            }
        }
    }
    
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension DropdownTextField: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .fieldBG
        cell.selectionStyle = .default
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.row]
        DispatchQueue.main.async { [weak self] in
            self?.text = selectedItem
            self?.selectedCallback?(selectedItem)
            print("Selected item: \(selectedItem)")
        }
        hideDropdown()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
