import SwiftUI
import FirebaseAuth

struct PasswordResetView: View {
    
    @State    var email:String = ""
    
    var body: some View {
        VStack{
            TextField("mail address", text: $email).padding().textFieldStyle(.roundedBorder).disableAutocorrection(true)
            Button(action: {
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    // ...
                }
            }, label: {
                Text("メール送信")
            })
        }
    }
}
