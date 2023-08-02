//
//  Constants.swift
//  KredivoTopupApp
//
//  Created by Nicholaus Adisetyo Purnomo on 02/08/23.
//

import Foundation

struct Constants {
    
    static let storyboard = "Main"
    static let phoneCs = "0807-1-573-348"
    static let emailCs = "support@kredivo.com"
    
    static var platform: String {
        return "IOS"
    }
    
    static var version: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
    
}
