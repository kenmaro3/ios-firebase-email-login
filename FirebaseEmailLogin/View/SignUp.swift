import SwiftUI
import FirebaseAuth

struct EntryAuthView: View {
    
    @State  var name:String = ""
    @State  var email:String = ""
    @State  var password:String = ""
    
    @AppStorage("name") var app_storage_name: String = ""
    @AppStorage("email") var app_storage_email: String = ""
    @AppStorage("password") var app_storage_password: String = ""
    
    
    var body: some View {
        NavigationView{
            
            VStack{
                TextField("name", text: $name).padding().textFieldStyle(.roundedBorder).disableAutocorrection(true)
                TextField("email address", text: $email).padding().textFieldStyle(.roundedBorder).disableAutocorrection(true)
                TextField("password", text: $password).padding().textFieldStyle(.roundedBorder)
                
                Button(action: {
                    Auth.auth().createUser(withEmail: email, password: password) { result, error in
                        if let user = result?.user {
                            let request = user.createProfileChangeRequest()
                            request.displayName = name
                            request.commitChanges { error in
                                if error == nil {
                                    user.sendEmailVerification() { error in
                                        if error == nil {
                                            app_storage_name = name
                                            app_storage_email = email
                                            app_storage_password = password
                                        }
                                    }
                                }
                            }
                        }
                    }
                }, label: {
                    Text("新規登録")
                }).padding()
                
                NavigationLink(destination: AuthenticationView(), label: {
                    Text("ログインはこちら")
                })
            }
        }
    }
}
