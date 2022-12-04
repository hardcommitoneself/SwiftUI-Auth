//
//  ViewModel.swift
//  Login SignUp App
//
//  Created by HOANDHTB on 27/05/2022.
//

import UIKit
import Combine

class BaseViewModel: ObservableObject {
    let service = BaseService()
    var cancellables = Set<AnyCancellable>()
    let activityIndicator = ActivityIndicator()
    let errorIndicator = ErrorIndicator()
    
    @Published var isShowLoading: Bool = false
    @Published var error: Error? = nil
    
    init() {
        activityIndicator.loading.receive(on: RunLoop.main).sink { isLoading in
            self.isShowLoading = isLoading
        }.store(in: &cancellables)
        
        errorIndicator.errors.receive(on: RunLoop.main).sink { error in
            self.error = error
        }.store(in: &cancellables)
    }
}
