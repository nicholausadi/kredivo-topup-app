//
//  TopupHomeViewController.swift
//  KredivoTopupApp
//
//  Created by Nicholaus Adisetyo Purnomo on 02/08/23.
//

import UIKit

// TODO: call api voucher items.
// TODO: call api pulsa items, after 4 digits phone number.
// TODO: click price button -> goto transaction screen, send phone number
// TODO: click promo items -> goto promo detail screen, send promo id
// TODO: click get contact
// TODO: promo card width 80% screen, aspect ratio 2:1

class TopupHomeViewController: UIViewController {
    
    static let string = "TopupHomeViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup navigation bar.
        navigationItem.title = "Top Up"
        setupNavbar()
        
        view.backgroundColor = Asset.Color.grayEBEDFA.color
    }
    
    // TODO: Remove this!
    @IBAction func onClickedTransaction(_ sender: Any) {
        goToTransaction()
    }
    
    // TODO: Remove this!
    @IBAction func onClickedVoucherDetail(_ sender: Any) {
        let voucher = VoucherItem(
            name: "Discount 20% at Kedai Hape Original, Mall Kota Kasablanka",
            number: 4,
            percentage: 10,
            iterator: 0,
            imageUrl: "https://placehold.co/1000x400/239CEC/FFFFFF/png",
            minTransactionAmount: 50000,
            endDate: "1548867600000",
            id: 4111,
            termsAndCondition: "Promo berlaku untuk transaksi yang dilakukan diaplikasi terbaru Bukalapak.\nGunakan kode BIRTHDAY9 untuk dapatkan cashback sebesar 3%.\nPromo hanya berlaku untuk transaksi yang menggunakan metode pengiriman J&T Express dan Ninja Xpress (REG dan FAST).\nSetiap pengguna bisa menggunakan promo sebanyak 1 (satu) kali per hari dan maksimal 2 (dua) kali selama periode Promo.\nPromo bisa digunakan untuk belanja produk kategori apa saja yang ada di Bukalapak, kecuali kategori tiket dan voucher, produk virtual (pulsa, paket data, voucher game, listrik prabayar & pascabayar, tiket event, tiket pesawat, tiket kereta, pembayaran zakat online, pembayaran tagihan listrik, air PDAM, dan BPJS) dan produk keuangan (BukaEmas dan BukaReksa).",
            howToUse: "text",
            usageCount: 2,
            startDate: "1547053200000",
            maxDiscount: 20000,
            voucherCode: "BIRTHDAY9")
        
        goToVoucherDetail(voucher: voucher)
    }
    
    // Go to Transaction
    func goToTransaction() {
        guard let vc = UIStoryboard(name: Constants.storyboard, bundle: nil).instantiateViewController(withIdentifier: TransactionViewController.string) as? TransactionViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // Go to Voucher Detail
    func goToVoucherDetail(voucher: VoucherItem) {
        guard let vc = UIStoryboard(name: Constants.storyboard, bundle: nil).instantiateViewController(withIdentifier: VoucherDetailViewController.string) as? VoucherDetailViewController else { return }
        
        vc.voucher = voucher
        navigationController?.pushViewController(vc, animated: true)
    }
    
    deinit {
        print(">>> TopupHomeViewController deinit")
    }
}
