//
//  ContentView.swift
//  bedtimestory
//
//  Created by Hunter Welch on 1/29/23.
//

import Foundation
import SwiftUI
import FirebaseAuth
struct MainLibraryView: View {
    var body: some View {
        NavigationView {
            VStack {
            Text("Library")
                HStack {
                    VStack{
                        Image("HackathonBook").resizable().frame(width: 300, height: 300)
                        Text("Hackathon Book")
                    }
                    VStack {
                        Image("bears").resizable().frame(width: 300, height: 300)
                        Text("Three Bears")
                    }
                }
            }

                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        NavigationLink(
                            /// 2
                            destination:  RecordingView(newBookID: 9462),
                            /// 3
                            label: {
                                Text("Record")
                                    .font(.system(size:25, weight: .heavy))
                            })
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                    
                        NavigationLink(
                            /// 2
                            destination:  PlaybackView(newBookID: 9462),
                            /// 3
                            label: {
                                Text("Playback")
                                    .font(.system(size:25, weight: .heavy))
                        })
                    }
                }
            Text("test 2")
        }.navigationViewStyle(StackNavigationViewStyle())

    }
}
class AppViewModel: ObservableObject {
    
    let auth = Auth.auth()
    
    @Published var signedIn = false
    
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email,
                    password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            DispatchQueue.main.async {
                //Success
                self?.signedIn = true
            }
        }
    }
    
    func signUp(email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            DispatchQueue.main.async {
                //Success
                self?.signedIn = true
            }
        }
    }
    
    func signOut() {
        try? auth.signOut()
        
        self.signedIn = false
    }
}


struct ContentView: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        NavigationView {
            if viewModel.signedIn {
                MainLibraryView()
                VStack {
                    Text("You are signed in")
                    
                    Button(action: {
                        viewModel.signOut()
                    }, label: {
                        Text("Sign Out")
                            .foregroundColor(Color.blue)
                            .padding()
                    })
                }
            }
            else {
                SignInView()
            }
            
        }.onAppear {
            viewModel.signedIn = viewModel.isSignedIn
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SignInView: View {
    @State var email = ""
    @State var password = ""
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            
            VStack {
                TextField("Email Address", text: $email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                SecureField("Password", text: $password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                Button(action: {
                    
                    guard !email.isEmpty, !password.isEmpty else {
                        return
                    }
                    
                    viewModel.signIn(email: email, password: password)
                    
                }, label: {
                    Text("Sign in")
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 200)
                        .background(Color.blue)
                        .cornerRadius(8)
                })
                NavigationLink("Create Account", destination: SignUpView())
                    .padding()
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("Sign In")
    }
}


struct SignUpView: View {
    @State var email = ""
    @State var password = ""
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            
            VStack {
                TextField("Email Address", text: $email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                SecureField("Password", text: $password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                Button(action: {
                    
                    guard !email.isEmpty, !password.isEmpty else {
                        return
                    }
                    
                    viewModel.signUp(email: email, password: password)
                    
                }, label: {
                    Text("Create Account")
                        .foregroundColor(Color.white)
                        .frame(width: 200, height: 200)
                        .background(Color.blue)
                        .cornerRadius(8)
                })
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("Create Account")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .preferredColorScheme(.dark)
    }
}
