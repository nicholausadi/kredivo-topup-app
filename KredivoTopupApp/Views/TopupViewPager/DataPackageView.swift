//
//  DataPackageView.swift
//  KredivoTopupApp
//
//  Created by Nicholaus Adisetyo Purnomo on 8/4/23.
//

import UIKit

class DataPackageView: UIView {
    
    static let identifier = "DataPackageView"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var lblDataPackage: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(DataPackageView.identifier, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
}
