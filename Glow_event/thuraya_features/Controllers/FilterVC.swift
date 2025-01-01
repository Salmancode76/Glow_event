
import UIKit

class FilterVC: UIViewController {
    
    @IBOutlet weak var categoryTF: DropdownTextField!
    @IBOutlet weak var ageTF: DropdownTextField!
    @IBOutlet weak var locationTF: DropdownTextField!
    @IBOutlet weak var statusTF: DropdownTextField!
    @IBOutlet weak var sortTF: DropdownTextField!
    
    @IBOutlet weak var startDateBtn: UIButton!
    
    @IBOutlet weak var endDateBtn: UIButton!
    
    @IBOutlet weak var timeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let categories = CategoryManager.shared.categories.map(\.name)
        
        categoryTF.setup(items: categories) { [weak self] selected in
            print("Selected category: \(selected)")
        }
        
        ageTF.setup(items: ["Any", "Under 12", "12 - 17", "18+"]) { [weak self] selected in
            print("Selected category: \(selected)")
        }
        
        locationTF.setup(items: ["Any", "Muharraq", "Manama", "Riffa", "Hamad Town", "Isa Town"]) { [weak self] selected in
            print("Selected category: \(selected)")
        }
        
        statusTF.setup(items: ["Any", "On-going", "Completed", "Canceled", "Postponed"]) { [weak self] selected in
            print("Selected category: \(selected)")
        }
        
        sortTF.setup(items: ["Any", "Cheapest to Highest", "Highest to Cheapest"]) { [weak self] selected in
            print("Selected category: \(selected)")
        }
    }
    
    @IBAction func startDateTapped(_ sender: UIButton) {
        showDatePicker(for: sender, mode: .date)
    }
    
    @IBAction func endDateTapped(_ sender: UIButton) {
        showDatePicker(for: sender, mode: .date)
    }
    
    @IBAction func timeTapped(_ sender: UIButton) {
        showDatePicker(for: sender, mode: .time)
    }
    
    private func showDatePicker(for button: UIButton, mode: UIDatePicker.Mode) {
        let pickerVC = UIViewController()
        pickerVC.modalPresentationStyle = .formSheet
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = mode
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonStack = UIStackView()
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 8
        
        let confirmButton = UIButton(type: .system)
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.addAction(UIAction { [weak self] _ in
            let formatter = DateFormatter()
            if mode == .date {
                formatter.dateStyle = .medium
                formatter.timeStyle = .none
            } else {
                formatter.dateStyle = .none
                formatter.timeStyle = .short
            }
            let selectedDate = formatter.string(from: datePicker.date)
            button.setTitle(selectedDate, for: .normal)
            pickerVC.dismiss(animated: true)
        }, for: .touchUpInside)
        
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addAction(UIAction { _ in
            pickerVC.dismiss(animated: true)
        }, for: .touchUpInside)
        
        buttonStack.addArrangedSubview(cancelButton)
        buttonStack.addArrangedSubview(confirmButton)
        
        stackView.addArrangedSubview(datePicker)
        stackView.addArrangedSubview(buttonStack)
        
        pickerVC.view.addSubview(stackView)
        pickerVC.view.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: pickerVC.view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: pickerVC.view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: pickerVC.view.trailingAnchor, constant: -16)
        ])
        
        present(pickerVC, animated: true)
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        
    }
    
}
