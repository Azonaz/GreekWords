import UIKit

class OptionButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }

    private func setupButton() {
        setTitle("", for: .normal)
        setTitleColor(UIColor(resource: .blackDN), for: .normal)
        layer.borderWidth = 1
        layer.borderColor = UIColor(resource: .blackDN).cgColor
        layer.cornerRadius = 12
        translatesAutoresizingMaskIntoConstraints = false
    }
}
