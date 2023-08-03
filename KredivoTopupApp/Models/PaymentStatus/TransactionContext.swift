//
//  TransactionContext.swift
//  KredivoTopupApp
//
//  Created by Nicholaus Adisetyo Purnomo on 02/08/23.
//

import UIKit
import CodableWrappers

struct TransactionContext: Decodable {
    
    @Immutable @FallbackDecoding<EmptyInt>
    private var _transactionStatus: Int
    
    /// Default `transactionStatus` is enum UNKNOWN.
    var transactionStatus: TransactionStatusEnum { return TransactionStatusEnum(rawValue: _transactionStatus) ?? .UNKNOWN }
    
    @Immutable
    var merchantDetail: MerchantDetail?

    @Immutable @FallbackDecoding<EmptyString>
    var _appliedPaymentType: String
    
    /// Default `appliedPaymentType` is enum UNKNOWN.
    var appliedPaymentType: AppliedPaymentTypeEnum { return AppliedPaymentTypeEnum(rawValue: _appliedPaymentType) ?? .UNKNOWN }
    
    @Immutable @FallbackDecoding<EmptyString>
    var checkoutAmount: String

    @Immutable @FallbackDecoding<EmptyString>
    var orderId: String
    
    @Immutable @FallbackDecoding<EmptyArray>
    var itemList: [TransactionItem]

    @Immutable @FallbackDecoding<EmptyString>
    var expirationTime: String

    @Immutable @FallbackDecoding<EmptyString>
    var amount: String

    @Immutable @FallbackDecoding<EmptyString>
    var transactionToken: String
    
    private enum CodingKeys: String, CodingKey {
        case _transactionStatus = "transaction_status"
        case merchantDetail = "merchant_details"
        case _appliedPaymentType = "applied_payment_type"
        case checkoutAmount = "checkout_amount"
        case orderId = "order_id"
        case itemList = "item_list"
        case expirationTime = "expiration_time"
        case amount
        case transactionToken = "transaction_token"
    }
    
}

enum TransactionStatusEnum: Int {
    
    case UNKNOWN
    case FAILED
    case PENDING
    case EXPIRED
    case SUCCESS
    
    func string() -> String {
        switch self {
        case .FAILED:
            return "Transaksi Gagal"
            
        case .PENDING:
            return "Menunggu Pembayaran"
            
        case .EXPIRED:
            return "Transaksi Expired"
            
        case .SUCCESS:
            return "Transaksi Berhasil"
            
        case .UNKNOWN:
            return "Transaksi Error"
        }
    }
    
    func textColor() -> UIColor {
        switch self {
        case .FAILED, .EXPIRED, .UNKNOWN:
            return UIColor.systemRed
        
        case .PENDING:
            return UIColor.systemYellow
            
        case .SUCCESS:
            return UIColor.systemGreen
        }
    }
}

enum AppliedPaymentTypeEnum: String {
    case DAYS_30 = "30_days"
    case UNKNOWN = ""
    
    func string() -> String {
        switch self {
        case .DAYS_30:
            return "30 hari"
            
        default:
            return "UNKNOWN"
        }
    }
}
