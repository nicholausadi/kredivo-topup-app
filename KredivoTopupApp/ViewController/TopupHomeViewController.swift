//
//  TopupHomeViewController.swift
//  KredivoTopupApp
//
//  Created by Nicholaus Adisetyo Purnomo on 02/08/23.
//

import UIKit
import Combine

class TopupHomeViewController: UIViewController {
    
    static let identifier = "TopupHomeViewController"
    
    let view1 = PulsaView()
    let view2 = DataPackageView()
    
    lazy var viewPager: ViewPager = {
        let viewPager = ViewPager(
            tabSizeConfiguration: .fillEqually(height: 60, spacing: 0)
        )
        
        viewPager.tabbedView.tabs = [
            AppTabItemView(title: "Pulsa"),
            AppTabItemView(title: "Data Package"),
        ]
        viewPager.pagedView.pages = [
            view1,
            view2
        ]
        
        viewPager.translatesAutoresizingMaskIntoConstraints = false
        return viewPager
    }()
    
    // ViewModel
    private let viewModel: TopupHomeViewModel = TopupHomeViewModel()
    private var cancelPulsa: AnyCancellable?
    private var cancelPromo: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup navigation bar.
        navigationItem.title = "Top Up"
        setupNavbar()
        
        // Add ViewPager
        view.addSubview(viewPager)
        viewPager.edgesToSuperview(excluding: .bottom, usingSafeArea: true)
        viewPager.bottomToSuperview(usingSafeArea: false)
        
        view1.delegate = self
        
        // Observe array pulsa in VM.
        cancelPulsa = viewModel.$pulsa.sink { [weak self] pulsa in
            self?.view1.pulsa = pulsa
        }
        
        // Observe array promos in VM.
        cancelPromo = viewModel.$promos.sink { [weak self] promos in
            self?.view1.promos = promos
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Fetch promo at start
        viewModel.fetchPromos()
    }
    
    // Go to Transaction
    func goToTransaction(product: PulsaItem) {
        guard let vc = UIStoryboard(name: Constants.storyboard, bundle: nil).instantiateViewController(withIdentifier: TransactionViewController.identifier) as? TransactionViewController else { return }
        vc.phoneNumber = "0812 3400 0001"
        vc.product = product
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // Go to Voucher Detail
    func goToVoucherDetail(promo: VoucherItem) {
        guard let vc = UIStoryboard(name: Constants.storyboard, bundle: nil).instantiateViewController(withIdentifier: VoucherDetailViewController.identifier) as? VoucherDetailViewController else { return }
        
        vc.voucher = promo
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension TopupHomeViewController: PulsaViewDelegate {
    
    func textFieldDidChange(text: String) {
        viewModel.fetchPulsa(phoneNumber: text)
    }
    
    func onClickedPulsa(pulsa: PulsaItem) {
        goToTransaction(product: pulsa)
    }
    
    func onClickedPromo(promo: VoucherItem) {
        goToVoucherDetail(promo: promo)
    }
    
}
