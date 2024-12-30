
import UIKit

extension UIView {
    
    @IBInspectable
    var roundShape: Bool {
        get {
            return self.roundShape
        }
        set {
            layer.cornerRadius = newValue ? frame.height/2 : 0
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
}

//@IBDesignable extension UITextField {
//    
//    @IBInspectable var setLabel: String {
//        get {
//            return ""
//        }
//        set {
//            let label: UILabel = UILabel(frame: CGRect(x: 20, y: 0, width: 50, height: 20))
//            label.text = newValue
//            label.textColor = .white
//            self.leftView = label
//            self.leftViewMode = UITextField.ViewMode.always
//        }
//    }
//}


@IBDesignable extension UITextField {
    
    @IBInspectable var setLabel: String {
        get {
            return ""
        }
        set {
            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 110, height: 20)) // Increased width to accommodate padding
            
            let label = UILabel(frame: CGRect(x: 15, y: 0, width: 90, height: 20))
            label.text = newValue
            label.textColor = .white
            
            containerView.addSubview(label)
            self.leftView = containerView
            self.leftViewMode = .always
        }
    }
    
    @IBInspectable var setLabelLarge: String {
        get {
            return ""
        }
        set {
            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 130, height: 20)) // Increased width to accommodate padding
            
            let label = UILabel(frame: CGRect(x: 15, y: 0, width: 110, height: 20))
            label.text = newValue
            label.textColor = .white
            
            containerView.addSubview(label)
            self.leftView = containerView
            self.leftViewMode = .always
        }
    }
    
    @IBInspectable var setRightLabel: String {
        get {
            return ""
        }
        set {
            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 110, height: 20)) // Increased width to accommodate padding
            
            let label = UILabel(frame: CGRect(x: 15, y: 0, width: 90, height: 20))
            label.text = newValue
            label.textColor = .white
            
            containerView.addSubview(label)
            self.rightView = containerView
            self.rightViewMode = .always
        }
    }
    
    @IBInspectable var setRightImage: String {
        get {
            return ""
        }
        set {
            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 110, height: 20)) // Increased width to accommodate padding
            
            let img = UIImageView(frame: CGRect(x: 15, y: 0, width: 90, height: 20))
            img.image = UIImage(named: newValue)
            img.contentMode = .scaleAspectFit
            img.tintColor = .white
//            
//            let label = UILabel(frame: CGRect(x: 15, y: 0, width: 90, height: 20))
//            label.text = newValue
//            label.textColor = .white
            
            containerView.addSubview(img)
            self.rightView = containerView
            self.rightViewMode = .always
        }
    }
    
    // Add padding for text content
    @IBInspectable var textPadding: CGFloat {
        get {
            return 0
        }
        set {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: self.frame.height))
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    }
}


extension UITextField {

   func addInputViewDatePicker(target: Any, selector: Selector) {

    let screenWidth = UIScreen.main.bounds.width

    //Add DatePicker as inputView
    let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
    datePicker.datePickerMode = .date
    self.inputView = datePicker

    //Add Tool Bar as input AccessoryView
    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
    let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
    toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)

    self.inputAccessoryView = toolBar
 }

   @objc func cancelPressed() {
     self.resignFirstResponder()
   }
}
