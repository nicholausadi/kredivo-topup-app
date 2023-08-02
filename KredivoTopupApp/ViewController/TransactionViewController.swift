//
//  TransactionViewController.swift
//  KredivoTopupApp
//
//  Created by Nicholaus Adisetyo Purnomo on 02/08/23.
//

import UIKit

// TODO: goto voucher list
// TODO: after input pin, click bayar goto screen payment status
// TODO: show error message if pin not filled
// TODO: voucher state selected, not selected, clear button
// TODO: pin show/hide
// TODO: custom back button - arrow

class TransactionViewController: UIViewController {
    
    static let string = "TransactionViewController"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup navigation bar.
        navigationItem.title = "Konfirmasi Pembayaran"
        setupNavbar()
    }
    
    @IBAction func onClickedVoucher(_ sender: Any) {
        goToVoucherList()
    }
    
    @IBAction func onClickedPayment(_ sender: Any) {
        goToPaymentStatus()
    }
    
    // Go to Voucher List
    func goToVoucherList() {
        guard let vc = UIStoryboard(name: Constants.storyboard, bundle: nil).instantiateViewController(withIdentifier: VoucherListViewController.string) as? VoucherListViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // Go to Payment Status
    func goToPaymentStatus() {
        guard let vc = UIStoryboard(name: Constants.storyboard, bundle: nil).instantiateViewController(withIdentifier: PaymentStatusViewController.string) as? PaymentStatusViewController else { return }
        
        // TODO: remove this dummy!
        vc.phoneNumber = "0812 3400 0001"
        vc.voucherCode = "VOUCHER_CODE_99"
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    deinit {
        print(">>> TransactionViewController deinit")
    }

}
