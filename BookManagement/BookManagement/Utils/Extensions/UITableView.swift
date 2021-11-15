import UIKit

enum TableViewCellNames: String {
    case cellDashboardBook = "CellDashboardBook"
    case cellPurchaseHistory = "CellPurchaseHistory"
}

extension UITableView {
    // Set Text,Image For Empty Data To UITableView
    func setNoDataView(_ image: UIImage = #imageLiteral(resourceName: "error"), message: String, color: UIColor = .black) {
        let noResultView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        let imag = UIImageView(frame: CGRect(x: 17, y: 100, width: 100, height: 100))
        imag.center.x = noResultView.center.x
        imag.center.y = noResultView.center.y - 60
        imag.image = image
        imag.contentMode = .scaleAspectFit
        imag.clipsToBounds = true
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 300, width: self.frame.size.width, height: 45))
        messageLabel.text = message
        messageLabel.center.x = noResultView.center.x
        messageLabel.center.y = noResultView.center.y
        messageLabel.textColor = color
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        noResultView.addSubview(imag)
        noResultView.addSubview(messageLabel)
        self.backgroundView = noResultView
    }

    /// Register Cell
    func registerCell(cellId: TableViewCellNames) {
        let cellNib = UINib(nibName: cellId.rawValue, bundle: nil)
        register(cellNib, forCellReuseIdentifier: cellId.rawValue)
    }

    func reloadDataAtIndex(index: Int) {
        self.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }

    func register<T: UITableViewCell>(_: T.Type, reuseIdentifier: String? = nil) {
        self.register(T.self, forCellReuseIdentifier: reuseIdentifier ?? String(describing: T.self))
    }

    func dequeue<T: UITableViewCell>(_ obj: T.Type, for indexPath: IndexPath) -> T {
        guard
            let cell = dequeueReusableCell(withIdentifier: String(describing: T.self),
                                           for: indexPath) as? T
            else { fatalError("Could not deque cell with type \(T.self)") }
        return cell
    }

    func dequeueCell(reuseIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        return dequeueReusableCell(
            withIdentifier: identifier,
            for: indexPath
        )
    }

    func reloadData(_ completion: @escaping () -> Void) {
        reloadData()
        DispatchQueue.main.async { completion() }
    }
}
