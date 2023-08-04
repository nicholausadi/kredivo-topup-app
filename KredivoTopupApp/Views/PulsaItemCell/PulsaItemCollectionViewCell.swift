//
//  PulsaItemCollectionViewCell.swift
//  KredivoTopupApp
//
//  Created by Nicholaus Adisetyo Purnomo on 8/4/23.
//

import UIKit

protocol PulsaItemDelegate: AnyObject {
    func onClickPulsa(pulsa: PulsaItem)
}

class PulsaItemCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PulsaItemCollectionViewCell"
    
    @IBOutlet weak var lblNominalTitle: UILabel!
    @IBOutlet weak var lblNominalPulsa: UILabel!
    @IBOutlet weak var btnPrice: UIButton!
    @IBOutlet weak var separator: UIView!
    
    weak var delegate: PulsaItemDelegate?
    var pulsa: PulsaItem? {
        didSet {
            setupView()
        }
    }
    
    override func prepareForReuse() {
        lblNominalPulsa.text = nil
        UIView.performWithoutAnimation {
            btnPrice.setTitle(nil, for: .normal)
            btnPrice.layoutIfNeeded()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        lblNominalTitle.text = "Nominal :"
        lblNominalTitle.font = .systemFont(ofSize: 16)
        lblNominalPulsa.font = .systemFont(ofSize: 18, weight: .medium)
        
        // Button Price
        btnPrice.backgroundColor = Asset.Color.primary.color
        btnPrice.setTitleColor(.white, for: .normal)
        btnPrice.layer.cornerRadius = 4
    }

    func setupView() {
        guard let pulsa = pulsa else { return }
        
        // Set nominal pulsa
        let nominal = Double(pulsa.nominal)
        lblNominalPulsa.text = nominal?.formatCurrency(currencySymbol: "")
        
        // Button Price
        let price = pulsa.price.formatCurrency(currencySymbol: "Rp ")
        UIView.performWithoutAnimation {
            btnPrice.setTitle(price, for: .normal)
            btnPrice.layoutIfNeeded()
        }
    }

    @IBAction func onClickedPulsa(_ sender: Any) {
        guard let pulsa = pulsa else { return }
        delegate?.onClickPulsa(pulsa: pulsa)
    }
}
