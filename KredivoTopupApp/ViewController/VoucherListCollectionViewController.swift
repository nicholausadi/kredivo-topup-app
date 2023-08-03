//
//  VoucherListCollectionViewController.swift
//  KredivoTopupApp
//
//  Created by Nicholaus Adisetyo Purnomo on 02/08/23.
//

import UIKit
import Combine

class VoucherListCollectionViewController: UICollectionViewController {
    
    static let identifier = "VoucherListCollectionViewController"
    
    // ViewModel
    private let viewModel: VoucherListViewModel = VoucherListViewModel()
    private var cancellable: AnyCancellable?
    
    var vouchers: [VoucherItem] = []
    weak var delegate: TransactionVoucherDelegate?
    
    let contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = contentInset

        // Register Voucher Cell
        collectionView.register(UINib(nibName: VoucherItemCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: VoucherItemCollectionViewCell.identifier)
        
        // Setup navigation bar.
        navigationItem.title = "Voucher Saya"
        setupNavbar()
        setupNavBack()
        setupNavHelp()
        
        // Observe VM State.
        cancellable = viewModel.$state.sink { [weak self] state in
            self?.render(state)
        }
    }
    
    // MARK: Navigation Bar
    
    private func setupNavBack() {
        navigationItem.hidesBackButton = true
        let btnBack = UIBarButtonItem(image: UIImage(named: Asset.Icon.chevronLeft.name), style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem = btnBack
    }
    
    @objc func back(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupNavHelp() {
        let btnHelp = UIBarButtonItem(image: UIImage(named: Asset.Icon.help.name), style: .plain, target: self, action: #selector(help))
        navigationItem.rightBarButtonItem = btnHelp
    }
    
    @objc func help(sender: UIBarButtonItem) {
        // Show FAQ page.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Fetch API vouchers.
        viewModel.fetchVouchers()
    }
    
    // MARK: View Render State
    
    private func render(_ state: VoucherListViewModel.State) {
        switch state {
        case .isLoading:
            // Show empty page.
            break
            
        case .failed(_):
            break
            
        case .loaded(let list):
            vouchers = list
            collectionView.reloadData()
        }
    }

    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vouchers.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VoucherItemCollectionViewCell.identifier, for: indexPath) as? VoucherItemCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.voucher = vouchers[indexPath.item]
        cell.delegate = self
        
        return cell
    }
    
    deinit {
        print(">>> VoucherListViewController deinit")
    }

}

// MARK: UICollectionViewDelegateFlowLayout
extension VoucherListCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width - contentInset.left - contentInset.right
        let height = (width * 0.4) + 65 + 10
        
        return CGSize(width: width, height: height)
    }
    
}

// MARK: VoucherItemCellDelegate
extension VoucherListCollectionViewController: VoucherItemCellDelegate {
    
    func onClickedApply(voucherCode: String) {
        delegate?.applyVoucher(voucherCode: voucherCode)
        navigationController?.popViewController(animated: true)
    }
    
}
