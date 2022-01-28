//
//  BottomFilterView.swift
//
//

import UIKit

class BottomFilterView: UIView {
    
    enum FilterType {
        case basic // will show one button only
        case advanced
    }

    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var containerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak private var separatorView: UIView!
    @IBOutlet weak private var normalFilterView: UIView!
    
    weak var delegate: EarningsFilterDelegate?
    
    // MARK: - Init methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 24
        containerView.layer.borderColor = UIColor(red: 156/255.0, green: 157/255.0, blue: 178/255.0, alpha: 0.2).cgColor
        containerView.layer.borderWidth = 1.0
        containerView.layer.masksToBounds = false
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 0.20
        containerView.layer.shadowOffset = CGSize(width: 0, height: 10)
        containerView.layer.shadowColor = UIColor.gray.cgColor//UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
    }

    func commonInit() {
        Bundle.main.loadNibNamed("BottomFilterView", owner: self, options: nil)
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layoutAttachAll(to: self)
    }
    
    func setup(_ filterType: FilterType) {
        switch filterType {
        case .basic:
            separatorView.isHidden = true
            normalFilterView.isHidden = true
            containerViewWidthConstraint.constant = 114.0
        case .advanced: break
        }
    }

    @IBAction func actionDateFilter(_ sender: UIButton) {
        self.delegate?.actionDateFilter()
    }
    
    @IBAction func actionNormalFilter(_ sender: UIButton) {
        self.delegate?.actionNormalFilter()
    }
}
