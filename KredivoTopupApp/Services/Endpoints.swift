//
//  Endpoints.swift
//  KredivoTopupApp
//
//  Created by Nicholaus Adisetyo Purnomo on 03/08/23.
//

import Foundation
import Alamofire

struct BaseUrl {
    #if DEBUG
    // stg
    static let url = "https://api.stg.kredivo.com"
    
    #else
    // prd
    static let url = "https://api.kredivo.com"
    #endif
}

enum Endpoints {
    case pulsaItems
    case voucherItems
    case paymentStatus
    
    public var url: String {
        switch self {
        case .pulsaItems: return "\(BaseUrl.url)/pulsa/items"
        case .voucherItems: return "\(BaseUrl.url)/voucher/items"
        case .paymentStatus: return "\(BaseUrl.url)/payment/status"
        }
    }
}
