//
//  VoucherListViewModel.swift
//  KredivoTopupApp
//
//  Created by Nicholaus Adisetyo Purnomo on 03/08/23.
//

import Foundation
import Alamofire
import CodableWrappers

final class VoucherListViewModel: ObservableObject {
    
    enum State {
        case isLoading
        case failed(Error)
        case loaded([VoucherItem])
    }
    
    @Published private(set) var state = State.isLoading
    
    func fetchVouchers() {
        AF.request(Endpoints.voucherItems.url).response { [weak self] response in
            guard let data = response.value as? Data, let value = VoucherItemsResp.init(from: data) else { return }
            self?.state = .loaded(value.data)
        }
    }
    
}
