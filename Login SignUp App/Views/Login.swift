//
//  Login.swift
//  Login SignUp App
//
//  Created by Marwan on 19/08/2021.
//

import SwiftUI

struct Login: View {
    @ObservedObject var viewModel = LoginViewModel()
    @Namespace var animation
    
    @State var show = false
    
    var body: some View {
        
        VStack{
            // To change the view we have to use navigationlink
            // After the login success it will change to the HomeView()
            NavigationLink(destination: HomeView(), tag: 1, selection: $viewModel.transition) {
                EmptyView()
            }
            Spacer(minLength: 0)
            
            HStack{
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text("Login")
                        .font(.system(size: 40, weight: .heavy))
                        // for Dark Mode Adoption...
                        .foregroundColor(.primary)
                    
                    Text("Please sign in to continue")
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                }
                
                Spacer(minLength: 0)
            }
            .padding()
            .padding(.leading)
            
            CustomTextField(image: "envelope", title: "EMAIL", value: $viewModel.username,animation: animation)
            
            CustomTextField(image: "lock", title: "PASSWORD", value: $viewModel.password,animation: animation)
                .padding(.top,5)
            
            Button(action: {
                self.viewModel.loginAction()
            }) {
                
                HStack(spacing: 10){
                    
                    Text("LOGIN")
                        .fontWeight(.heavy)
                }
            }
            .padding(.vertical)
            .padding(.horizontal)
            
            if viewModel.isShowLoading {
                ProgressView()
            }
            
            Spacer(minLength: 0)
         
        }
    }
}
