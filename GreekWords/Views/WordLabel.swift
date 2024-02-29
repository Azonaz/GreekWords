import UIKit

class WordLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLabel()
    }

    private func setupLabel() {
        text = ""
        textColor = UIColor(resource: .blackDN)
        textAlignment = .center
        font = UIFont.systemFont(ofSize: 20, weight: .regular)
        backgroundColor = .whiteDN
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 5
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}

