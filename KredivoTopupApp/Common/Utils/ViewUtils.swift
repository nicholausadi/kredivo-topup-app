//
//  ViewUtils.swift
//  KredivoTopupApp
//
//  Created by Nicholaus Adisetyo Purnomo on 03/08/23.
//

import Foundation

class ViewUtils {
    
    static func dateBetweenString(startDate: Date, endDate: Date) -> String {
        let startComponents = startDate.get(.month, .year)
        let endComponents = endDate.get(.month, .year)
        
        if startComponents.year == endComponents.year {
            if startComponents.month == endComponents.month {
                return "\(startDate.string(format: "d")) - \(endDate.string(format: "d MMMM yyyy"))"
            } else {
                return "\(startDate.string(format: "d MMMM")) - \(endDate.string(format: "d MMMM yyyy"))"
            }
        }
        
        return "\(startDate.string(format: "d MMMM yyyy")) - \(endDate.string(format: "d MMMM yyyy"))"
    }
    
}
