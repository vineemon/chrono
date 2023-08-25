//
//  LoginView.swift
//  ChronoService
//
//  Created by Vineet Nadella on 8/25/23.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @State var email = ""
    @State var password = ""
    @State var isLoginActive = false
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Email", text: $email)
                SecureField("Password", text: $password)
                Button(action: login) {
                    Text("Sign In")
                }.buttonStyle(.borderedProminent)
            }.padding().navigationDestination(isPresented: $isLoginActive) {
                ContentView().navigationBarHidden(true)
            }
        }
    }
        
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                self.isLoginActive = true
                print("success")
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
