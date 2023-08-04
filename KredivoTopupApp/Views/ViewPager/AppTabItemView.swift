//
//  AppTabItemView.swift
//  KredivoTopupApp
//
//  Created by Nicholaus Adisetyo Purnomo on 8/4/23.
//

import UIKit

class AppTabItemView: UIView, TabItemProtocol {
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    private let title: String
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = Asset.Color.grayAEAEAE.color
        label.text = title
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var borderView: UIView = {
        let view = UIView()
        view.backgroundColor = Asset.Color.secondary.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func onSelected() {
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = Asset.Color.secondary.color
        
        if borderView.superview == nil {
            self.addSubview(borderView)
            
            NSLayoutConstraint.activate([
                borderView.leftAnchor.constraint(equalTo: self.leftAnchor),
                borderView.rightAnchor.constraint(equalTo: self.rightAnchor),
                borderView.heightAnchor.constraint(equalToConstant: 5),
                borderView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        }
    }
    
    func onNotSelected() {
        titleLabel.font = .systemFont(ofSize: 18, weight: .regular)
        titleLabel.textColor = Asset.Color.grayAEAEAE.color
        
        layer.shadowOpacity = 0
        
        borderView.removeFromSuperview()
    }
    
    
    // MARK: - UI Setup
    private func setupView() {
        self.backgroundColor = .clear
        self.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
}
