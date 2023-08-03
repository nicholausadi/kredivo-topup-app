//
//  MerchantDetail.swift
//  KredivoTopupApp
//
//  Created by Nicholaus Adisetyo Purnomo on 02/08/23.
//

import Foundation
import CodableWrappers

struct MerchantDetail: Decodable {
    
    @Immutable @FallbackDecoding<EmptyString>
    var logoUrl: String

    @Immutable @FallbackDecoding<EmptyString>
    var name: String
    
    private enum CodingKeys: String, CodingKey {
        case logoUrl = "logo_url"
        case name
    }
    
}
