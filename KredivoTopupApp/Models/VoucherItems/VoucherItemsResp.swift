//
//  VoucherItemsResp.swift
//  KredivoTopupApp
//
//  Created by Nicholaus Adisetyo Purnomo on 02/08/23.
//

import Foundation
import CodableWrappers

struct VoucherItemsResp: Decodable {
    
    /// Default `status` is enum FAILED.
    var status: VoucherItemsStatus { return VoucherItemsStatus(rawValue: _status) ?? .FAILED }
    
    @Immutable @FallbackDecoding<EmptyString>
    private var _status: String
    
    @Immutable @FallbackDecoding<EmptyArray>
    var data: [VoucherItem]
    
    private enum CodingKeys: String, CodingKey {
        case _status = "status"
        case data
    }
}

enum VoucherItemsStatus: String, Decodable {
    case OK
    case FAILED
}
