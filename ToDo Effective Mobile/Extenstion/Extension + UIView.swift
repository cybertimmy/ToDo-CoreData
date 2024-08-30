import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        views.forEach{(
            self.addSubview($0)
        )}
    }
}
