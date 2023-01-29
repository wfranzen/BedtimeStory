import Foundation
import SwiftUI

struct LibraryView: View {
    @State var loggedIn: Bool = true
    var body: some View {
        if loggedIn {
            VStack {
                Text("Hello, World!")
                
                Text("You are signed in")
                
                Button(action: {
                    let AppView = AppViewModel()
                    AppView.signOut()
                    loggedIn = false
                }, label: {
                    Text("Sign Out")
                        .foregroundColor(Color.blue)
                        .padding()
                })
            }
        }else{
            SignInView()
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
