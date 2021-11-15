import Foundation
import UIKit

extension String {
    /// Return the string after trimming
    func trimming() -> String {
        let strText = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return strText
    }

    func safelyLimitedTo(length len: Int) -> String {
        if self.count <= len {
            return self
        }
        return String( Array(self).prefix(upTo: len) )
    }

}

//Added date extension 
extension Date {

 static func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.dateFormatDDMMYYYY
        return dateFormatter.string(from: Date())
    }
}
