//
//  Register.swift
//  Login SignUp App
//
//  Created by Marwan on 19/08/2021.
//

import SwiftUI
import Firebase

struct Register: View {
    
    @State var email = ""
    @State var password = ""
    @State var name = ""
    
    @Binding var show : Bool
    
    @Namespace var animation
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false, content: {
            
            VStack{
                
                HStack{
                    
                    Button(action: {show.toggle()}) {
                        
                        Image(systemName: "arrow.left")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                .padding()
                .padding(.leading)
                
                HStack{
                    
                    Text("Create Account")
                        .font(.system(size: 40))
                        .fontWeight(.heavy)
                        .foregroundColor(.primary)
                    
                    Spacer(minLength: 0)
                }
                .padding()
                .padding(.leading)
                
                CustomTextField(image: "person", title: "FULL NAME", value: $name, animation: animation)
                
                CustomTextField(image: "envelope", title: "EMAIL", value: $email, animation: animation)
                    .padding(.top,5)
                
                CustomTextField(image: "lock", title: "PASSWORD", value: $password, animation: animation)
                    .padding(.top,5)
                
                HStack{
                    
                    Spacer()
                    
                    Button(action: {
                        let db = Firestore.firestore()
                        if name == "" || name == " "{
                            return
                        }
                        Auth.auth().createUser(withEmail: email, password: password) { result, error in
                            guard result != nil, error == nil else{
                                print(error!.localizedDescription)
                                return
                            }
                            if (result?.user != nil) {
                                db.collection("users").document(result?.user.uid ?? "").setData([
                                    "FullName":name,
                                    "UID":result?.user.uid ?? "",
                                    "isVerified" : false
                                ])
                            }
                        }
                    }) {
                        
                        Text("SIGN UP")
                            .fontWeight(.heavy)

                    }
                }
                .padding()
                .padding(.top)
                .padding(.trailing)
                
                HStack{
                    
                    Text("Already have a account?")
                        .fontWeight(.heavy)
                        .foregroundColor(.gray)
                    
                    Button(action: {show.toggle()}) {
                        
                        Text("sign in")
                            .fontWeight(.heavy)
                    }
                }
                .padding()
                .padding(.top,10)
                
            }
        })
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}
