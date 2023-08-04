//
//  TopupHomeViewModel.swift
//  KredivoTopupApp
//
//  Created by Nicholaus Adisetyo Purnomo on 02/08/23.
//

import Foundation
import Alamofire
import CodableWrappers

final class TopupHomeViewModel: ObservableObject {
    
    enum State {
        case isLoading
        case failed(Error)
        case loaded
    }
    
    @Published private(set) var state = State.isLoading
    
    @Published private(set) var pulsa: [PulsaItem] = []
    @Published private(set) var promos: [VoucherItem] = []
    
    func fetchPromos() {
        AF.request(Endpoints.voucherItems.url).response { [weak self] response in
            guard let data = response.value as? Data, let value = VoucherItemsResp.init(from: data) else { return }
            self?.promos = value.data
        }
    }
    
    func fetchPulsa(phoneNumber: String) {
        if phoneNumber.count > 3 {
            AF.request(Endpoints.pulsaItems.url).response { [weak self] response in
                guard let data = response.value as? Data, let value = PulsaItemsResp.init(from: data) else { return }
                self?.pulsa = value.products
            }
        } else {
            self.pulsa = []
        }
    }
    
}
