import UIKit

class LetterButton: UIButton {
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
        titleLabel?.font = UIFont.systemFont(ofSize: isPad ? 26 : 18, weight: .regular)
        backgroundColor = .whiteDN
        layer.cornerRadius = isPad ? 4 : 3
        translatesAutoresizingMaskIntoConstraints = false
    }
}
