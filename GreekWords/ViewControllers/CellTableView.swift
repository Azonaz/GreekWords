import UIKit

final class CellTableView: UITableViewCell {
    static let reuseIdentifier = "cellTableView"

    func configure(with title: String, isFirstRow: Bool, isLastRow: Bool) {
        textLabel?.text = title
        textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        textLabel?.textColor = UIColor(resource: .blackDN)
        backgroundColor = UIColor(resource: .whiteDN)
        layer.masksToBounds = true
        layer.cornerRadius = 16
        selectionStyle = .default
        accessoryType = .disclosureIndicator
        if isFirstRow && isLastRow {
            layer.cornerRadius = 16
        } else if isFirstRow {
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if isLastRow {
            layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            layer.cornerRadius = 0
        }
    }
}
