//
//  VoucherItem.swift
//  KredivoTopupApp
//
//  Created by Nicholaus Adisetyo Purnomo on 02/08/23.
//

import Foundation
import CodableWrappers

struct VoucherItem: Decodable {
    
    @Immutable @FallbackDecoding<EmptyString>
    var name: String

    @Immutable @FallbackDecoding<EmptyInt>
    var number: Int

    @Immutable @FallbackDecoding<EmptyInt>
    var percentage: Int

    @Immutable @FallbackDecoding<EmptyInt>
    var iterator: Int

    @Immutable @FallbackDecoding<EmptyString>
    var imageUrl: String

    @Immutable @FallbackDecoding<EmptyInt>
    var minTransactionAmount: Int

    @Immutable @FallbackDecoding<EmptyString>
    var endDate: String

    @Immutable @FallbackDecoding<EmptyInt>
    var id: Int

    @Immutable @FallbackDecoding<EmptyString>
    var termsAndCondition: String

    @Immutable @FallbackDecoding<EmptyString>
    var howToUse: String

    @Immutable @FallbackDecoding<EmptyInt>
    var usageCount: Int

    @Immutable @FallbackDecoding<EmptyString>
    var startDate: String

    @Immutable @FallbackDecoding<EmptyInt>
    var maxDiscount: Int

    @Immutable @FallbackDecoding<EmptyString>
    var voucherCode: String
    
    private enum CodingKeys: String, CodingKey {
        case name
        case number
        case percentage
        case iterator
        case imageUrl = "image_url"
        case minTransactionAmount = "min_transaction_amount"
        case endDate = "end_date"
        case id
        case termsAndCondition = "terms_and_condition"
        case howToUse = "how_to_use"
        case usageCount = "usage_count"
        case startDate = "start_date"
        case maxDiscount = "max_discount"
        case voucherCode = "voucher_code"
    }
    
}
