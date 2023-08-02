//
//  PaymentStatusResp.swift
//  KredivoTopupApp
//
//  Created by Nicholaus Adisetyo Purnomo on 02/08/23.
//

import Foundation
import CodableWrappers

struct PaymentStatusResp: Decodable {
    
    /// Default `status` is enum FAILED.
    var status: PaymentStatusStatus { return PaymentStatusStatus(rawValue: _status) ?? .FAILED }
    
    @Immutable @FallbackDecoding<EmptyString>
    private var _status: String
    
    @Immutable @FallbackDecoding<EmptyString>
    var message: String
    
    @Immutable
    var transactionContext: TransactionContext?
    
    private enum CodingKeys: String, CodingKey {
        case _status = "status"
        case message
        case transactionContext = "transaction_context"
    }
}

enum PaymentStatusStatus: String, Decodable {
    case OK
    case FAILED
}
