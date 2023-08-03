//
//  VoucherListViewController.swift
//  KredivoTopupApp
//
//  Created by Nicholaus Adisetyo Purnomo on 02/08/23.
//

import UIKit

// TODO: custom right button help
// TODO: custom back button - chevron
// TODO: collection view voucher list
// TODO: click pakai back to prev and apply voucher

class VoucherListViewController: UIViewController {
    
    static let string = "VoucherListViewController"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup navigation bar.
        navigationItem.title = "Voucher Saya"
        setupNavbar()
    }
    
    @IBAction func onClickedPrev(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    deinit {
        print(">>> VoucherListViewController deinit")
    }
    
}
