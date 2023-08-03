//
//  TransactionViewController.swift
//  KredivoTopupApp
//
//  Created by Nicholaus Adisetyo Purnomo on 02/08/23.
//

import UIKit
import TinyConstraints
import MaterialComponents.MaterialTextControls_OutlinedTextFields

protocol TransactionVoucherDelegate: AnyObject {
    func applyVoucher(voucherCode: String)
}

class TransactionViewController: UIViewController {
    
    static let identifier = "TransactionViewController"
    
    // Outlet PhoneNumber
    @IBOutlet weak var imageOperator: UIImageView!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    
    // Outlet Price Breakdown
    @IBOutlet weak var lblBreakdownTitle: UILabel!
    @IBOutlet weak var stackBreakdown: UIStackView!
    
    // Outlet Voucher
    @IBOutlet weak var lblVoucherTitle: UILabel!
    
    // Outlet Voucher - No voucher
    @IBOutlet weak var containerNoVoucher: UIView!
    @IBOutlet weak var stackNoVoucher: UIStackView!
    @IBOutlet weak var imageNoVoucher: UIImageView!
    @IBOutlet weak var lblNoVoucher: UILabel!
    @IBOutlet weak var btnSeeVoucher: UIButton!
    
    // Outlet Voucher - With voucher
    @IBOutlet weak var containerWithVoucher: UIView!
    @IBOutlet weak var stackWithVoucher: UIStackView!
    @IBOutlet weak var imageWithVoucher: UIImageView!
    @IBOutlet weak var lblVoucherCode: UILabel!
    @IBOutlet weak var lblVoucherDesc: UILabel!
    @IBOutlet weak var btnRemoveVoucher: UIButton!
    
    // Outlet PIN
    @IBOutlet weak var containerPinTxtfields: UIView!
    @IBOutlet weak var lblPinTitle: UILabel!
    @IBOutlet weak var lblPinTnc: UILabel!
    
    // Outlet Button Pay
    @IBOutlet weak var containerBtnPay: UIView!
    @IBOutlet weak var btnPay: UIButton!
    
    var pinTextfield: MDCOutlinedTextField?
    
    var phoneNumber: String = "0857 6999 9999 9"
    var product: PulsaItem?
    
    var voucherCode: String? {
        didSet {
            // Update price breakdown
            setupPriceBreakdown()
            
            // Update voucher
            let hasVoucher = voucherCode?.isEmpty == false
            containerNoVoucher.isHidden = hasVoucher
            containerWithVoucher.isHidden = !hasVoucher
            lblVoucherCode.text = voucherCode
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup navigation bar.
        navigationItem.title = "Konfirmasi Pembayaran"
        setupNavbar()
        setupNavBack()
        
        view.backgroundColor = .white
        
        // Setup UI
        setupView()
    }
    
    func setupView() {
        // Setup phoneNumber card
        imageOperator.image = Asset.Logo.telkomsel.image
        imageOperator.rounded()
        
        lblPhoneNumber.text = phoneNumber
        lblPhoneNumber.font = .systemFont(ofSize: 16)
        
        // Price breakdown
        lblBreakdownTitle.text = "Rincian Pembayaran"
        lblBreakdownTitle.font = .systemFont(ofSize: 16, weight: .semibold)
        setupPriceBreakdown()
        
        // Voucher
        lblVoucherTitle.text = "Voucher"
        lblVoucherTitle.font = .systemFont(ofSize: 16, weight: .semibold)
        setupVoucher()
        
        // PIN Textfield
        lblPinTitle.text = "PIN Kredivo"
        lblPinTitle.font = .systemFont(ofSize: 16, weight: .semibold)
        setupPinKredivo()
        
        // Button Pay
        containerBtnPay.backgroundColor = Asset.Color.secondary.color
        btnPay.setTitle("Bayar", for: .normal)
        btnPay.setTitleColor(.white, for: .normal)
        btnPay.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        btnPay.backgroundColor = Asset.Color.secondary.color
    }
    
    // MARK: Price Breakdown
    
    func setupPriceBreakdown() {
        // Clear all arranged subviews.
        stackBreakdown.removeAllArrangedSubviews()
        
        var hasVoucherCode = false
        if let voucherCode = voucherCode, !voucherCode.isEmpty {
            hasVoucherCode = true
        }
        
        var breakdown: [TransactionBreakdown] = [
            TransactionBreakdown(name: "Indosat Rp 50.000 (+62-85769999999)", totalAmount: 50000, multipier: 1),
            TransactionBreakdown(name: "Diskon Tambahan", totalAmount: 1000, multipier: -1),
        ]
        
        if hasVoucherCode {
            breakdown.insert(TransactionBreakdown(name: "Biaya Layanan", totalAmount: 490, multipier: 1), at: 1)
        }
        
        var subtotalAmount = 0.0
        for item in breakdown {
            let stackView = createStackBreakdown(name: item.name, amount: item.totalAmount, top: 0, bottom: 10)
            subtotalAmount += (Double(item.multipier) * item.totalAmount)
            
            stackBreakdown.addArrangedSubview(stackView)
        }
        
        // Line
        let line = UIView()
        line.backgroundColor = Asset.Color.grayDCDCDC.color
        line.height(1)
        stackBreakdown.addArrangedSubview(line)
        
        // Add Subtotal
        let stackSubtotal = createStackBreakdown(name: "Subtotal", amount: subtotalAmount, top: 14, bottom: 14)
        stackBreakdown.addArrangedSubview(stackSubtotal)
        
        // Dash Line
        let dashLine = DashLineView()
        dashLine.lineColor = Asset.Color.grayDCDCDC.color
        dashLine.backgroundColor = .clear
        dashLine.lineWidth = 5
        dashLine.height(1)
        stackBreakdown.addArrangedSubview(dashLine)
        
        // Add Kredivo Diskon
        if hasVoucherCode {
            let stackDiscount = createStackBreakdown(name: "Kredivo Diskon", amount: 0, top: 14, bottom: 14, isDisc: true)
            stackBreakdown.addArrangedSubview(stackDiscount)
            
            // Line Discount
            let lineDisc = UIView()
            lineDisc.backgroundColor = Asset.Color.grayDCDCDC.color
            lineDisc.height(1)
            stackBreakdown.addArrangedSubview(lineDisc)
        }
        
        // Pay Within days
        let stackPayWithin = createStackBreakdown(name: "Bayar dalam 30 hari", amount: subtotalAmount, top: 14, bottom: 16, isPaylater: true)
        stackBreakdown.addArrangedSubview(stackPayWithin)
    }
    
    func createStackBreakdown(name: String, amount: Double, top: CGFloat, bottom: CGFloat, isDisc: Bool = false, isPaylater: Bool = false) -> UIStackView {
        let title = UILabel()
        title.text = name
        title.font = .systemFont(ofSize: 14, weight: isPaylater ? .semibold : .regular)
        title.numberOfLines = 2
        title.setContentHuggingPriority(.defaultLow, for: .horizontal)
        title.setContentHuggingPriority(.defaultLow, for: .vertical)
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        title.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        let price = UILabel()
        price.text = "\(isDisc ? "-" : "")\(amount.formatCurrency())"
        price.font = .systemFont(ofSize: 14, weight: isPaylater ? .semibold : .regular)
        price.textColor = isPaylater ? Asset.Color.secondary.color : .black
        price.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        price.setContentHuggingPriority(.defaultHigh, for: .vertical)
        price.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        price.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        let stackView = UIStackView(arrangedSubviews: [title, price])
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.layoutMargins = UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        return stackView
    }
    
    // MARK: Voucher
    
    func setupVoucher() {
        // Setup view no voucher
        stackNoVoucher.layer.borderWidth = 1
        stackNoVoucher.layer.borderColor = Asset.Color.grayDCDCDC.color.cgColor
        stackNoVoucher.layer.cornerRadius = 4
        stackNoVoucher.clipsToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapSeeVoucher(_:)))
        stackNoVoucher.addGestureRecognizer(tap)
        
        imageNoVoucher.image = Asset.Icon.disc.image
        lblNoVoucher.text = "Voucher untukmu"
        lblNoVoucher.font = .systemFont(ofSize: 12, weight: .semibold)
        lblNoVoucher.textColor = Asset.Color.gray535353.color
        
        btnSeeVoucher.setTitle("Lihat", for: .normal)
        btnSeeVoucher.setTitleColor(Asset.Color.secondary.color, for: .normal)
        btnSeeVoucher.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        btnSeeVoucher.backgroundColor = Asset.Color.orangeFFF1EA.color
        btnSeeVoucher.layer.cornerRadius = 4
        
        // Setup view with voucher
        stackWithVoucher.backgroundColor = Asset.Color.greenD0FAE0.color
        stackWithVoucher.layer.borderWidth = 1
        stackWithVoucher.layer.borderColor = Asset.Color.green3ADA8A.color.cgColor
        stackWithVoucher.layer.cornerRadius = 4
        stackWithVoucher.clipsToBounds = true
        
        imageWithVoucher.image = Asset.Icon.checkmark.image
        lblVoucherCode.font = .systemFont(ofSize: 14, weight: .semibold)
        lblVoucherCode.textColor = Asset.Color.gray535353.color
        
        lblVoucherDesc.text = "Yeay! Kamu mendapatkan promo cicilan 0%"
        lblVoucherDesc.font = .systemFont(ofSize: 14)
        lblVoucherDesc.textColor = Asset.Color.gray535353.color
        
        // Hide view with voucher, and show view no voucher
        containerNoVoucher.isHidden = false
        containerWithVoucher.isHidden = true
    }
    
    // MARK: PIN Kredivo
    
    func setupPinKredivo() {
        // Setup textfield
        let textField = MDCOutlinedTextField(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 40))
        textField.label.text = "PIN"
        
        let outlineColor = Asset.Color.primary.color
        let labelColor = Asset.Color.gray535353.color
        textField.setOutlineColor(outlineColor, for: .normal)
        textField.setOutlineColor(outlineColor, for: .editing)
        textField.setNormalLabelColor(labelColor, for: .normal)
        textField.setFloatingLabelColor(labelColor, for: .editing)
        pinTextfield = textField
        
        let hideButton = UIButton(type: .custom)
        hideButton.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        hideButton.setImage(Asset.Icon.characterHidden.image.withRenderingMode(.alwaysTemplate), for: .normal)
        hideButton.setImage(Asset.Icon.characterShown.image.withRenderingMode(.alwaysTemplate), for: .selected)
        hideButton.addTarget(self, action: #selector(onClickedShowHidePIN), for: .touchUpInside)
        hideButton.tintColor = Asset.Color.grayAEAEAE.color
        textField.trailingView = hideButton
        textField.trailingViewMode = .always
        textField.isSecureTextEntry = true
        textField.sizeToFit()
        
        containerPinTxtfields.addSubview(textField)
        
        // Setup PIN term and condition.
        let font = UIFont.systemFont(ofSize: 12)
        let textColor = Asset.Color.gray535353.color
        let blueColor = Asset.Color.primary.color
        
        let normalAttr = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: textColor
        ]
        let blueAttr = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: blueColor,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ] as [NSAttributedString.Key : Any]
        
        let fullAttrString = NSMutableAttributedString(string: "Dengan melanjutkan saya setuju dengan ", attributes: normalAttr)
        let tncAttrString = NSAttributedString(string: "Perjanjian Pinjaman Kredivo", attributes: blueAttr)
        fullAttrString.append(tncAttrString)
        lblPinTnc.attributedText = fullAttrString
        lblPinTnc.numberOfLines = 0
    }
    
    @objc func onClickedShowHidePIN(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        pinTextfield?.isSecureTextEntry = !sender.isSelected
    }
    
    // MARK: Navigation Bar
    
    private func setupNavBack() {
        navigationItem.hidesBackButton = true
        let btnBack = UIBarButtonItem(image: UIImage(named: Asset.Icon.arrowLeft.name), style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem = btnBack
    }
    
    @objc func back(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    // Go to Voucher List
    @IBAction func onClickedVoucher(_ sender: Any) {
        goToVoucherList()
    }
    
    @objc func handleTapSeeVoucher(_ sender: UITapGestureRecognizer? = nil) {
        goToVoucherList()
    }
    
    // Go to Voucher List
    func goToVoucherList() {
        guard let vc = UIStoryboard(name: Constants.storyboard, bundle: nil).instantiateViewController(withIdentifier: VoucherListCollectionViewController.identifier) as? VoucherListCollectionViewController else { return }
        vc.delegate = self
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // Go to Payment Status
    @IBAction func onClickedPayment(_ sender: Any) {
        // Check PIN first or show error message!
        if pinTextfield?.text?.isEmpty == true {
            let alert = UIAlertController(title: "Empty PIN", message: "Tolong input PIN Kredivo anda untuk melanjutkan pembayaran.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        guard let vc = UIStoryboard(name: Constants.storyboard, bundle: nil).instantiateViewController(withIdentifier: PaymentStatusViewController.identifier) as? PaymentStatusViewController else { return }
        vc.phoneNumber = phoneNumber
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func onClickedRemoveVoucher(_ sender: Any) {
        voucherCode = nil
    }
    
    deinit {
        print(">>> TransactionViewController deinit")
    }

}

extension TransactionViewController: TransactionVoucherDelegate {
    
    func applyVoucher(voucherCode: String) {
        self.voucherCode = voucherCode
    }
    
}

struct TransactionBreakdown {
    var name: String = ""
    var totalAmount: Double = 0
    var multipier: Int = 1
}
