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
        backgroundColor = .whiteDN
        layer.cornerRadius = 3
        translatesAutoresizingMaskIntoConstraints = false
    }
}
