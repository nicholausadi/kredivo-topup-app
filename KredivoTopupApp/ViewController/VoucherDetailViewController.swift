//
//  VoucherDetailViewController.swift
//  KredivoTopupApp
//
//  Created by Nicholaus Adisetyo Purnomo on 02/08/23.
//

import UIKit
import Kingfisher

class VoucherDetailViewController: UIViewController {
    
    static let identifier = "VoucherDetailViewController"

    // Outlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValidDateTitle: UILabel!
    @IBOutlet weak var lblValidDate: UILabel!
    @IBOutlet weak var lblVoucherCodeTitle: UILabel!
    @IBOutlet weak var stackVoucherCode: UIStackView!
    @IBOutlet weak var lblVoucherCode: UILabel!
    @IBOutlet weak var btnCopy: UIButton!
    @IBOutlet weak var lblTermsTitle: UILabel!
    @IBOutlet weak var lblTerms: UILabel!
    
    // Param
    var voucher: VoucherItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup navigation bar.
        navigationItem.title = "Merchant Promo"
        setupNavbar()
        setupNavBack()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Setup UI
        setupView()
    }
    
    private func setupNavBack() {
        navigationItem.hidesBackButton = true
        let btnBack = UIBarButtonItem(image: UIImage(named: Asset.Icon.arrowLeft.name), style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem = btnBack
    }
    
    @objc func back(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    func setupView() {
        guard let voucher = voucher else {
            return
        }

        // Setup Image with Kingfisher
        let url = URL(string: voucher.imageUrl)
        imageView.kf.setImage(with: url)
        
        // Setup Title Voucher
        lblTitle.text = voucher.name
        lblTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        lblTitle.textColor = Asset.Color.gray535353.color
        lblTitle.numberOfLines = 0
        
        // Setup Valid Date
        lblValidDateTitle.text = "Valid Date"
        lblValidDateTitle.font = .systemFont(ofSize: 12)
        lblValidDateTitle.textColor = Asset.Color.grayAEAEAE.color

        // Setup date between from startDate and endDate
        lblValidDate.font = .systemFont(ofSize: 14)
        lblValidDate.textColor = Asset.Color.gray535353.color
        if let startMillis = Int64(voucher.startDate), let endMillis = Int64(voucher.endDate) {
            let startDate = Date(milliseconds: startMillis)
            let endDate = Date(milliseconds: endMillis)
            
            let dateBetween = ViewUtils.dateBetweenString(startDate: startDate, endDate: endDate)
            lblValidDate.text = dateBetween
        } else {
            lblValidDate.text = "-"
        }
        
        // Setup Voucher code
        lblVoucherCodeTitle.text = "Voucher Code"
        lblVoucherCodeTitle.font = .systemFont(ofSize: 12)
        lblVoucherCodeTitle.textColor = Asset.Color.grayAEAEAE.color
        setupVoucherBox()

        // Setup Terms and conditions
        lblTermsTitle.text = "Term & Conditions"
        lblTermsTitle.font = .systemFont(ofSize: 12)
        lblTermsTitle.textColor = Asset.Color.grayAEAEAE.color
        
        lblTerms.numberOfLines = 0
        setupTermPoint(termsAndCondition: voucher.termsAndCondition)
    }
    
    // MARK: - Voucher Code
    private func setupVoucherBox() {
        
        // Setup Voucher StackView (Box)
        stackVoucherCode.backgroundColor = Asset.Color.grayF9F9F9.color
        stackVoucherCode.layer.borderWidth = 1
        stackVoucherCode.layer.borderColor = Asset.Color.grayDCDCDC.color.cgColor
        stackVoucherCode.layer.cornerRadius = 4
        
        // Setup Label Voucher
        lblVoucherCode.text = voucher?.voucherCode
        lblVoucherCode.textAlignment = .center
        lblVoucherCode.font = .systemFont(ofSize: 18, weight: .semibold)
        lblVoucherCode.textColor = Asset.Color.gray535353.color
        
        // Setup Btn Copy
        btnCopy.setTitle("COPY", for: .normal)
        btnCopy.setTitleColor(Asset.Color.secondary.color, for: .normal)
        btnCopy.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        btnCopy.backgroundColor = .white
    }
    
    @IBAction func onClickedCopy(_ sender: Any) {
        guard let voucherCode = voucher?.voucherCode else { return }

        let pasteboard = UIPasteboard.general
        pasteboard.string = voucherCode
    }
    
    // MARK: - Terms
    private func setupTermPoint(termsAndCondition: String) {
        lblTerms.text = ""
        DispatchQueue.global().async { [weak self] in
            
            let terms = termsAndCondition.split(separator: "\n")
            let bullet: String = "\u{2022}"
            let textColor = Asset.Color.gray535353.color
            let font = UIFont.systemFont(ofSize: 14)
            
            let bulletAttributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: textColor]
            
            let fullAttrString = NSMutableAttributedString(string: "", attributes: bulletAttributes)
            let paragraphStyle = self?.createParagraphStyle() ?? NSParagraphStyle.default
            
            for (index, term) in terms.enumerated() {
                let formattedString = "\(bullet) \(term)\(terms.count - 1 == index ? "" : "\n")"
                let attrString = NSMutableAttributedString(string: formattedString)
                
                attrString.addAttributes(
                    [NSAttributedString.Key.paragraphStyle: paragraphStyle,
                     NSAttributedString.Key.foregroundColor: textColor],
                    range: NSMakeRange(0, attrString.length))
                
                fullAttrString.append(attrString)
            }
            
            DispatchQueue.main.async {
                self?.lblTerms.attributedText = fullAttrString
            }
        }
    }
    
    private func createParagraphStyle() -> NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15, options: [:])]
        paragraphStyle.defaultTabInterval = 15
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = 12
        paragraphStyle.paragraphSpacing = 8
        
        return paragraphStyle
    }
    
}
