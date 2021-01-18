//
//  ExpandableView.swift
//  ExpandableView
//
//  Created by Yehor Sorokin on 18.01.2021.
//

import UIKit


final class ExpandableView: UIView {
    
    enum ButtonState {
        case expanded
        case hidden
    }
    

    // MARK: Subviews
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = UIColor.systemGreen
        label.tintColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    lazy var noteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = UIColor.systemYellow
        label.tintColor = UIColor.black
        label.textAlignment = .center
        return label
    }()
    
    lazy var expandButton: UIButton = {
        let button = UIButton(type: .infoLight)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor.systemBlue
        button.addTarget(self, action: #selector(handleTouch(_:)), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: Properties
    var state: ExpandableView.ButtonState = .hidden
    var originalFrame: CGRect?
    
    private var noteHeightConstraint: NSLayoutConstraint?
    private var messageBottomConstraint: NSLayoutConstraint?
    private var noteHeight: CGFloat {
        frame.height * 3
    }
    
    
    // MARK: Inititialization
    convenience init(message: String, note: String) {
        super.init(frame: CGRect.zero)
        commonInit()
        messageLabel.text = message
        noteLabel.text = note
        
    }
    
    init(frame: CGRect, message: String, note: String) {
        super.init(frame: frame)
        commonInit()
        messageLabel.text = message
        noteLabel.text = note
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() -> Void {
        setupSubviews()
        setupConstraints()
        originalFrame = frame
    }
    
    
    // MARK: Methods
    @objc private func handleTouch(_ sender: UIButton) {
        switch state {
        case .hidden:
            showNotification(animated: true)
        case .expanded:
            hideNotification(animated: true)
        }
    }
    
    
    private func showNotification(animated: Bool) -> Void {
        noteHeightConstraint!.constant = noteHeight
        state = .expanded
        if animated {
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                guard let self = self, let oFrame = self.originalFrame else {
                    return
                }
                self.frame = CGRect(origin: oFrame.origin,
                                    size: CGSize(width: oFrame.width, height: oFrame.height + self.noteHeight))
                self.layoutIfNeeded()
            })
            return
        }
        layoutIfNeeded()
    }
    
    private func hideNotification(animated: Bool) -> Void {
        noteHeightConstraint!.constant = 0
        state = .hidden
        if animated {
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                guard let self = self, let oFrame = self.originalFrame else {
                    return
                }
                self.frame = oFrame
                self.layoutIfNeeded()
            })
            return
        }
        layoutIfNeeded()
    }
    
    func setupSubviews() -> Void {
        addSubview(messageLabel)
        addSubview(noteLabel)
        addSubview(expandButton)
    }
    
    func setupConstraints() -> Void  {
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            messageLabel.topAnchor.constraint(equalTo: topAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: noteLabel.topAnchor),
            
            noteLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            noteLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            noteLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            expandButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: frame.width * 0.01),
            expandButton.topAnchor.constraint(equalTo: topAnchor, constant: frame.width * 0.01),
            expandButton.widthAnchor.constraint(equalToConstant: frame.height * 0.4),
            expandButton.heightAnchor.constraint(equalToConstant: frame.height * 0.4)
        ])
        noteHeightConstraint = noteLabel.heightAnchor.constraint(equalToConstant: 0)
        noteHeightConstraint?.isActive = true
    }

}
