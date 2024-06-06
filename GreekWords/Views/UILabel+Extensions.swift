import UIKit

extension UILabel {
    static func customLabel(font: UIFont, backgroundColor: UIColor = .whiteDN, 
                            textAlignment: NSTextAlignment = .center) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = UIColor(resource: .blackDN)
        label.backgroundColor = backgroundColor
        label.textAlignment = textAlignment
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
