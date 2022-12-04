//
//  LoginViewModel.swift
//  Login SignUp App
//
//  Created by HOANDHTB on 27/05/2022.
//

import Combine
import Foundation

class LoginViewModel: BaseViewModel {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var transition: Int? = 0
    
    func loginAction() {
        print(username, password)
        service.getItem(AuthencationTargetType.signIn(username: username, password: password), type: LoginModel.self)
            .trackActivity(activityIndicator)
            .trackError(errorIndicator)
            .receive(on: RunLoop.main).sink { data in
                print(data)
                if self.transition != nil {
                    self.transition! += 1
                }
        }.store(in: &cancellables)

    }
    
    deinit {
        print("dsadas")
    }
}
