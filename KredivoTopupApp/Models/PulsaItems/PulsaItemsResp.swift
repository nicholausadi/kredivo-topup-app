//
//  PulsaItemsResp.swift
//  KredivoTopupApp
//
//  Created by Nicholaus Adisetyo Purnomo on 02/08/23.
//

import Foundation
import CodableWrappers

struct PulsaItemsResp: Decodable {
    
    /// Default `status` is enum FAILED.
    var status: PulsaItemsStatus { return PulsaItemsStatus(rawValue: _status) ?? .FAILED }
    
    @Immutable @FallbackDecoding<EmptyString>
    private var _status: String
    
    @Immutable @FallbackDecoding<EmptyString>
    var message: String
    
    @Immutable @FallbackDecoding<EmptyArray>
    var products: [PulsaItem]
    
    private enum CodingKeys: String, CodingKey {
        case _status = "status"
        case message
        case products
    }
}

enum PulsaItemsStatus: String, Decodable {
    case OK
    case FAILED
}
