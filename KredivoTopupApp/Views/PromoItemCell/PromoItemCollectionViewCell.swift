//
//  PromoItemCollectionViewCell.swift
//  KredivoTopupApp
//
//  Created by Nicholaus Adisetyo Purnomo on 8/4/23.
//

import UIKit
import Kingfisher

protocol PromoItemCellDelegate: AnyObject {
    func onClicked(promo: VoucherItem)
}

class PromoItemCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PromoItemCollectionViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    
    weak var delegate: PromoItemCellDelegate?
    var promo: VoucherItem? {
        didSet {
            setupView()
        }
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        layer.cornerRadius = 8
        clipsToBounds = true
    }

    func setupView() {
        guard let promo = promo else { return }
        
        // Setup Image with Kingfisher
        let url = URL(string: promo.imageUrl)
        imageView.kf.setImage(with: url)
        imageView.contentMode = .scaleAspectFill
    }

}
