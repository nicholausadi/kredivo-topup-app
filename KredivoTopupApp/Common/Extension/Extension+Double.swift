//
//  Extension+Double.swift
//  KredivoTopupApp
//
//  Created by Nicholaus Adisetyo Purnomo on 03/08/23.
//

import Foundation

extension Double {
    
    func formatCurrency(locale: Locale = Locale(identifier: "id_ID"),
                        currencySymbol: String? = "Rp",
                        maximumFractionDigits: Int = 0) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currencyAccounting
        numberFormatter.locale = locale
        numberFormatter.currencyGroupingSeparator = "."
        numberFormatter.currencyDecimalSeparator = ","
        numberFormatter.currencySymbol = currencySymbol ?? ""
        numberFormatter.roundingMode = .halfEven
        numberFormatter.maximumFractionDigits = maximumFractionDigits
        
        return numberFormatter.string(for: self) ?? ""
    }
    
}
