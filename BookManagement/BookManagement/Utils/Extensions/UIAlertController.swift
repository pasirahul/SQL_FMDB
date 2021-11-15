import UIKit
typealias ClosureType = () -> Void

extension UIAlertController {
    class func showAlertDialog(_ viewController: UIViewController, message: String, title: String = "Book Management", btnTitle: String = "OK", clickAction: ClosureType? = nil ) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.message = message
        alertView.title = title
        alertView.addAction(UIAlertAction(title: btnTitle, style: .default, handler: { (_: UIAlertAction!) in
            clickAction?()
        }))
        viewController.present(alertView, animated: true, completion: nil)
    }

    class func showAlertDialogWithMultipleOption(_ viewController: UIViewController, message: String, title: String = "", okTitle: String = "", clickAction: ClosureType? = nil, cancelAction: ClosureType? = nil) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.message = message
        alertView.title = title
        alertView.addAction(UIAlertAction(title: okTitle, style: .default, handler: { (_: UIAlertAction!) in
            clickAction?()
        }))
        alertView.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_: UIAlertAction!) in
            cancelAction?()
        }))
        viewController.present(alertView, animated: true, completion: nil)
    }

    func popOver(view: UIView) {
        if let popoverPresentationController = self.popoverPresentationController {
            popoverPresentationController.sourceView = view
            popoverPresentationController.sourceRect = CGRect(x: view.bounds.size.width / 2.0, y: view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        }
    }
}
