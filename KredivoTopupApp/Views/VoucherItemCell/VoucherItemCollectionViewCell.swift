//
//  VoucherItemCollectionViewCell.swift
//  KredivoTopupApp
//
//  Created by Nicholaus Adisetyo Purnomo on 03/08/23.
//

import UIKit
import Kingfisher

protocol VoucherItemCellDelegate: AnyObject {
    func onClickedApply(voucherCode: String)
}

class VoucherItemCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "VoucherItemCollectionViewCell"
    
    // Outlet voucher card
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    // Outlet box new
    @IBOutlet weak var containerNew: UIView!
    @IBOutlet weak var lblNew: UILabel!
    
    // Outlet voucher info
    @IBOutlet weak var lblVoucherCode: UILabel!
    @IBOutlet weak var lblValidDate: UILabel!
    @IBOutlet weak var btnApply: UIButton!
    
    // Outlet bottom box
    @IBOutlet weak var viewBottom: UIView!
    
    weak var delegate: VoucherItemCellDelegate?
    var voucher: VoucherItem? {
        didSet {
            setupView()
        }
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        lblVoucherCode.text = nil
        lblValidDate.text = nil
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        container.layer.borderWidth = 1
        container.layer.borderColor = Asset.Color.grayDCDCDC.color.cgColor
        container.layer.cornerRadius = 4
        container.clipsToBounds = true
        
        // Box new
        containerNew.layer.borderWidth = 1
        containerNew.layer.borderColor = Asset.Color.grayDCDCDC.color.cgColor
        containerNew.layer.cornerRadius = 4
        containerNew.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        containerNew.clipsToBounds = true
        lblNew.text = "Baru"
        lblNew.font = .systemFont(ofSize: 12, weight: .medium)
        lblNew.textColor = .red
        
        // View Bottom
        viewBottom.layer.borderWidth = 1
        viewBottom.layer.borderColor = Asset.Color.grayDCDCDC.color.cgColor
        viewBottom.layer.cornerRadius = 4
        viewBottom.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        viewBottom.clipsToBounds = true
        
        // Voucher Code
        lblVoucherCode.font = .systemFont(ofSize: 14, weight: .semibold)
        lblVoucherCode.textColor = .black
        
        // Button Apply
        btnApply.backgroundColor = Asset.Color.secondary.color
        btnApply.setTitle("Pakai", for: .normal)
        btnApply.setTitleColor(.white, for: .normal)
        btnApply.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btnApply.layer.cornerRadius = 4
    }
    
    func setupView() {
        guard let voucher = voucher else { return }
        
        // Setup Image with Kingfisher
        let url = URL(string: voucher.imageUrl)
        imageView.kf.setImage(with: url)
        
        // Voucher Info
        lblVoucherCode.text = voucher.voucherCode
        
        // Valid End Date
        if let endMillis = Int64(voucher.endDate) {
            let endDate = Date(milliseconds: endMillis)
            
            let attrString = NSMutableAttributedString(
                string: "Berlaku hingga ",
                attributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
                ])
            
            let endDateAttrStr = NSAttributedString(
                string: endDate.string(format: "d MMM yyyy"),
                attributes: [
                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .bold),
                ])
            attrString.append(endDateAttrStr)
            
            lblValidDate.attributedText = attrString
        }
    }
    
    // Send voucher code.
    @IBAction func onClickedApply(_ sender: Any) {
        guard let voucherCode = voucher?.voucherCode else { return }
        delegate?.onClickedApply(voucherCode: voucherCode)
    }
    
}
