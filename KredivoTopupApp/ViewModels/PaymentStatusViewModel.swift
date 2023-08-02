//
//  PaymentViewModel.swift
//  KredivoTopupApp
//
//  Created by Nicholaus Adisetyo Purnomo on 03/08/23.
//

import Foundation
import Alamofire
import CodableWrappers

final class PaymentStatusViewModel: ObservableObject {
    
    enum State {
        case isLoading
        case failed(Error)
        case loaded(TransactionContext)
    }
    
    @Published private(set) var state = State.isLoading
    
    func fetchPaymentStatus(param: PaymentStatusParams) {
        AF.request(Endpoints.paymentStatus.url).response { [weak self] response in
            guard let data = response.value as? Data, let value = PaymentStatusResp.init(from: data) else { return }
            
            if let trx = value.transactionContext {
                self?.state = .loaded(trx)
            }
        }
    }
    
}
