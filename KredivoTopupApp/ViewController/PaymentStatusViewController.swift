//
//  PaymentStatusViewController.swift
//  KredivoTopupApp
//
//  Created by Nicholaus Adisetyo Purnomo on 02/08/23.
//

import UIKit
import Combine
import TinyConstraints

class PaymentStatusViewController: UIViewController {
    
    static let identifier = "PaymentStatusViewController"

    // Outlet Order Detail
    @IBOutlet weak var stackOrderDetail: UIStackView!
    @IBOutlet weak var imageOperator: UIImageView!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblOrderDetailTitle: PaddingLabel!
    @IBOutlet weak var lblStatusTitle: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblOrderIdTitle: UILabel!
    @IBOutlet weak var lblOrderId: UILabel!
    
    // Outlet Payment Detail
    @IBOutlet weak var stackPaymentDetail: UIStackView!
    @IBOutlet weak var lblPaymentDetailTitle: PaddingLabel!
    
    // Outlet CS
    @IBOutlet weak var viewCs: UIView!
    @IBOutlet weak var lblCs: UILabel!
    
    // Outlet Btn Done
    @IBOutlet weak var containerBtnDone: UIView!
    @IBOutlet weak var btnDone: UIButton!
    
    // ViewModel
    private let viewModel: PaymentStatusViewModel = PaymentStatusViewModel()
    private var cancellable: AnyCancellable?
    
    // Param
    var phoneNumber: String = "0812 3400 0001"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup navigation bar.
        navigationItem.title = "Detail Pembayaran"
        setupNavbar()
        setupNavBack()
        
        // Setup UI
        setupView()
        
        // Observe VM State.
        cancellable = viewModel.$state.sink { [weak self] state in
            self?.render(state)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Fetch API payment status.
        let param = PaymentStatusParams(phoneNumber: phoneNumber)
        viewModel.fetchPaymentStatus(param: param)
    }
    
    private func setupNavBack() {
        navigationItem.hidesBackButton = true
        let btnBack = UIBarButtonItem(image: UIImage(named: Asset.Icon.close.name), style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem = btnBack
    }
    
    @objc func back(sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: View Render State
    
    private func render(_ state: PaymentStatusViewModel.State) {
        switch state {
        case .isLoading:
            // Show empty view at first.
            showHideView(isHidden: true)
            
        case .failed(_):
            break
            
        case .loaded(let trx):
            // Show view payment status and populate with trx data.
            showHideView(isHidden: false)
            
            // Show image operator
            imageOperator.image = Asset.Logo.telkomsel.image
            imageOperator.rounded()
            
            lblStatus.text = trx.transactionStatus.string()
            lblStatus.textColor = trx.transactionStatus.textColor()
            lblOrderId.text = trx.orderId
            
            // Add payment breakdown
            addPaymentBreakdown(list: trx.itemList, amount: trx.amount, type: trx.appliedPaymentType)
        }
    }
    
    private func setupView() {
        // Section Order Detail
        setupOrderDetail()
        
        // Section Payment Detail
        setupPaymentDetail()
        
        // Section CS
        setupSectionCs()
        
        // Button Done
        containerBtnDone.backgroundColor = Asset.Color.secondary.color
        btnDone.setTitle("Oke", for: .normal)
        btnDone.setTitleColor(.white, for: .normal)
        btnDone.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        btnDone.backgroundColor = Asset.Color.secondary.color
    }
    
    private func setupOrderDetail() {
        stackOrderDetail.backgroundColor = .white
        stackOrderDetail.layer.borderWidth = 1
        stackOrderDetail.layer.borderColor = Asset.Color.grayDCDCDC.color.cgColor
        stackOrderDetail.layer.cornerRadius = 4
        
        lblOrderDetailTitle.text = "Detail Pesanan"
        setupSectionTitle(label: lblOrderDetailTitle)
        
        lblPhoneNumber.text = phoneNumber
        lblPhoneNumber.font = .systemFont(ofSize: 14)
        
        lblStatusTitle.text = "Status"
        lblStatusTitle.font = .systemFont(ofSize: 12)
        
        lblStatus.text = ""
        lblStatus.font = .systemFont(ofSize: 12)
        
        lblOrderIdTitle.text = "Order ID"
        lblOrderIdTitle.font = .systemFont(ofSize: 12)
        
        lblOrderId.text = ""
        lblOrderId.font = .systemFont(ofSize: 12)
    }
    
    private func setupPaymentDetail() {
        stackPaymentDetail.backgroundColor = .white
        stackPaymentDetail.layer.borderWidth = 1
        stackPaymentDetail.layer.borderColor = Asset.Color.grayDCDCDC.color.cgColor
        stackPaymentDetail.layer.cornerRadius = 4
        
        lblPaymentDetailTitle.text = "Detail Pembayaran"
        setupSectionTitle(label: lblPaymentDetailTitle)
    }
    
    private func addPaymentBreakdown(list: [TransactionItem], amount: String, type: AppliedPaymentTypeEnum) {
        if list.isEmpty { return }
        
        for (index, item) in list.enumerated() {
            let stackView = createStackBreakdown(name: item.name, amount: item.totalAmount, isFirst: index == 0)
            stackPaymentDetail.addArrangedSubview(stackView)
        }
        
        // Add Subtotal
        let stackSubtotal = createStackBreakdown(name: "Subtotal", amount: amount, isLast: true)
        stackPaymentDetail.addArrangedSubview(stackSubtotal)
        
        // Dash Line
        let dashLine = DashLineView()
        dashLine.lineColor = Asset.Color.grayDCDCDC.color
        dashLine.backgroundColor = .clear
        dashLine.lineWidth = 5
        dashLine.height(1)
        stackPaymentDetail.addArrangedSubview(dashLine)
        
        // Pay within
        let stackPayWithin = createPayWithin(type: type, amount: amount)
        stackPaymentDetail.addArrangedSubview(stackPayWithin)
    }
    
    func createStackBreakdown(name: String, amount: String, isFirst: Bool = false, isLast: Bool = false) -> UIStackView {
        let title = UILabel()
        title.text = name
        title.font = .systemFont(ofSize: 12)
        title.numberOfLines = 2
        title.setContentHuggingPriority(.defaultLow, for: .horizontal)
        title.setContentHuggingPriority(.defaultLow, for: .vertical)
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        title.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        let price = UILabel()
        price.text = "Rp\(amount)"
        price.font = .systemFont(ofSize: 12)
        price.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        price.setContentHuggingPriority(.defaultHigh, for: .vertical)
        price.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        price.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        let stackView = UIStackView(arrangedSubviews: [title, price])
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.layoutMargins = UIEdgeInsets(top: isFirst ? 16 : 6, left: 16, bottom: isLast ? 16 : 6, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        return stackView
    }
    
    func createPayWithin(type: AppliedPaymentTypeEnum, amount: String) -> UIStackView {
        let title = UILabel()
        title.text = "Bayar dalam \(type.string())"
        title.font = .systemFont(ofSize: 18, weight: .semibold)
        title.numberOfLines = 2
        title.setContentHuggingPriority(.defaultLow, for: .horizontal)
        title.setContentHuggingPriority(.defaultLow, for: .vertical)
        title.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        title.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        let price = UILabel()
        price.text = "Rp \(amount)"
        price.font = .systemFont(ofSize: 18, weight: .semibold)
        price.textColor = Asset.Color.secondary.color
        price.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        price.setContentHuggingPriority(.defaultHigh, for: .vertical)
        price.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        price.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        let stackView = UIStackView(arrangedSubviews: [title, price])
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.spacing = 16
        stackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        return stackView
    }
    
    private func setupSectionTitle(label: PaddingLabel) {
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.backgroundColor = Asset.Color.blueF4F8FE.color
        label.paddingLeft = 16
        label.paddingTop = 16
        label.paddingRight = 16
        label.paddingBottom = 16
    }
    
    // Setup section CS
    private func setupSectionCs() {
        viewCs.backgroundColor = Asset.Color.grayE7E7E7.color
        viewCs.layer.borderWidth = 1
        viewCs.layer.borderColor = Asset.Color.grayDCDCDC.color.cgColor
        viewCs.layer.cornerRadius = 4
        
        let font = UIFont.systemFont(ofSize: 12)
        let textColor = UIColor.black
        let blueColor = Asset.Color.primary.color
        
        let normalAttr = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: textColor
        ]
        let blueAttr = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: blueColor
        ]
        
        let fullAttrString = NSMutableAttributedString(string: "Jika kamu punya kendala terkait transaksimu, pastikan untuk menghubungi customer service kami di ", attributes: normalAttr)
        
        let phoneAttrString = NSMutableAttributedString(
            string: Constants.phoneCs,
            attributes: blueAttr)
        fullAttrString.append(phoneAttrString)
        
        let midAttrString = NSMutableAttributedString(
            string: " atau ",
            attributes: normalAttr)
        fullAttrString.append(midAttrString)
        
        let emailAttrString = NSMutableAttributedString(
            string: Constants.emailCs,
            attributes: blueAttr)
        fullAttrString.append(emailAttrString)
        
        let endAttrString = NSMutableAttributedString(
            string: ".",
            attributes: normalAttr)
        fullAttrString.append(endAttrString)
        
        lblCs.numberOfLines = 0
        lblCs.attributedText = fullAttrString
    }
    
    private func showHideView(isHidden: Bool) {
        stackOrderDetail.isHidden = isHidden
        stackPaymentDetail.isHidden = isHidden
        viewCs.isHidden = isHidden
        containerBtnDone.isHidden = isHidden
    }
    
    @IBAction func onClickedDone(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}
