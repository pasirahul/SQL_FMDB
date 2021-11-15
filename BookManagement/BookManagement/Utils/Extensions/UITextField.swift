import Foundation
import UIKit

private var maxLengths = [UITextField: Int]()
private var charSet = [UITextField: NSCharacterSet]()

extension UITextField {
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }

    @IBInspectable var maxLength: Int {
        get {
            guard let maxL = maxLengths[self] else {
                return 128 // (global default-limit. or just, Int.max)
            }
            return maxL
        }
        set {
            maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }

    @objc func fix(textField: UITextField) {
        let text = textField.text
        textField.text = text?.safelyLimitedTo(length: maxLength)
    }

    //Usage: objTextfield.showDoneButtonOnKeyboard
    func showDoneButtonOnKeyboard() {
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(resignFirstResponder))

        var toolBarItems = [UIBarButtonItem]()
        toolBarItems.append(flexSpace)
        toolBarItems.append(doneButton)

        let doneToolbar = UIToolbar()
        doneToolbar.items = toolBarItems
        doneToolbar.sizeToFit()

        inputAccessoryView = doneToolbar
    }
    func datePicker<T>(target: T,
                       doneAction: Selector,
                       cancelAction: Selector,
                       datePickerMode: UIDatePicker.Mode = .date) {
        let screenWidth = UIScreen.main.bounds.width

        func buttonItem(withSystemItemStyle style: UIBarButtonItem.SystemItem) -> UIBarButtonItem {
            let buttonTarget = style == .flexibleSpace ? nil : target
            let action: Selector? = {
                switch style {
                case .cancel:
                    return cancelAction
                case .done:
                    return doneAction
                default:
                    return nil
                }
            }()

            let barButtonItem = UIBarButtonItem(barButtonSystemItem: style,
                                                target: buttonTarget,
                                                action: action)

            return barButtonItem
        }

        let datePicker = UIDatePicker(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: screenWidth,
                                                    height: 216))
        datePicker.datePickerMode = datePickerMode
        self.inputView = datePicker

        let toolBar = UIToolbar(frame: CGRect(x: 0,
                                              y: 0,
                                              width: screenWidth,
                                              height: 44))
        toolBar.setItems([buttonItem(withSystemItemStyle: .cancel),
                          buttonItem(withSystemItemStyle: .flexibleSpace),
                          buttonItem(withSystemItemStyle: .done)],
                         animated: true)
        self.inputAccessoryView = toolBar
    }
}
