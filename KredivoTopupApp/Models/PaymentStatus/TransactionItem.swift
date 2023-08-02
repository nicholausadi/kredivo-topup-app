//
//  TransactionItem.swift
//  KredivoTopupApp
//
//  Created by Nicholaus Adisetyo Purnomo on 02/08/23.
//

import Foundation
import CodableWrappers

struct TransactionItem: Decodable {
    
    @Immutable @FallbackDecoding<EmptyString>
    var aggregatedPrice: String

    @Immutable @FallbackDecoding<EmptyInt>
    var quantity: Int
    
    /// Default `status` is enum UNKNOWN, to handle new enum status that cannot handle by this app version.
    var status: TransactionItemStatus { return TransactionItemStatus(rawValue: _status) ?? .UNKNOWN }
    
    @Immutable @FallbackDecoding<EmptyString>
    private var _status: String
    
    @Immutable @FallbackDecoding<EmptyString>
    var unitPrice: String

    @Immutable @FallbackDecoding<EmptyString>
    var totalAmount: String

    @Immutable @FallbackDecoding<EmptyInt>
    var pId: Int

    @Immutable @FallbackDecoding<EmptyInt>
    var skuType: Int

    @Immutable @FallbackDecoding<EmptyString>
    var name: String

    @Immutable @FallbackDecoding<EmptyString>
    var category: String

    @Immutable @FallbackDecoding<EmptyString>
    var sku: String
    
    private enum CodingKeys: String, CodingKey {
        case aggregatedPrice = "aggregated_price"
        case quantity
        case _status = "status"
        case unitPrice = "unit_price"
        case totalAmount = "total_amount"
        case pId = "p_id"
        case skuType = "sku_type"
        case name
        case category
        case sku
    }
    
}

enum TransactionItemStatus: String, Decodable {
    case SETTLED
    case UNKNOWN
}
