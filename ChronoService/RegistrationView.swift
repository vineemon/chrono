//
//  SignUpView.swift
//  ChronoService
//
//  Created by Vineet Nadella on 8/25/23.
//

import SwiftUI
import Firebase

struct RegistrationView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    @State var email = ""
    @State var password = ""
    @State var isRegistrationActive = false
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Email", text: $email)
                SecureField("Password", text: $password)
                Button(action: register) {
                    Text("Create Account")
                }.buttonStyle(.borderedProminent)
            }.padding().navigationDestination(isPresented: $isRegistrationActive) {
                LoginView().environmentObject(firestoreManager).navigationBarHidden(true)
            }
        }
    }
        
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "")
            } else {
                self.isRegistrationActive = true
                print("success")
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
