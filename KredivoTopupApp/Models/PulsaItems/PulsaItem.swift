//
//  PulsaItem.swift
//  KredivoTopupApp
//
//  Created by Nicholaus Adisetyo Purnomo on 02/08/23.
//

import Foundation
import CodableWrappers

struct PulsaItem: Decodable {
    
    @Immutable @FallbackDecoding<EmptyString>
    var productCode: String
    
    @Immutable @FallbackDecoding<EmptyString>
    var billType: String
    
    @Immutable @FallbackDecoding<EmptyString>
    var label: String
    
    @Immutable @FallbackDecoding<EmptyString>
    var phoneOperator: String
    
    @Immutable @FallbackDecoding<EmptyString>
    var nominal: String
    
    @Immutable @FallbackDecoding<EmptyString>
    var desc: String
    
    @Immutable @FallbackDecoding<EmptyInt>
    var sequence: Int
    
    @Immutable @FallbackDecoding<EmptyDouble>
    var price: Double
    
    private enum CodingKeys: String, CodingKey {
        case productCode = "product_code"
        case billType = "bill_type"
        case label
        case phoneOperator = "operator"
        case nominal
        case desc = "description"
        case sequence
        case price
    }
    
}
