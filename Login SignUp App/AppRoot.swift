//
//  Login_SignUp_AppApp.swift
//  Login SignUp App
//
//  Created by Marwan on 19/08/2021.
//

import SwiftUI

@main
struct AppRoot: App {
    var body: some Scene {
        WindowGroup {
            NavigationView{
                Login()
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}
