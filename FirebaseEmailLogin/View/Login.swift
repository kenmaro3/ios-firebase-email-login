import SwiftUI
import FirebaseAuth

struct AuthenticationView: View {
    @AppStorage("loginStatus") var app_storage_login_status: Bool = false
    
    @State  var email:String = ""
    @State  var password:String = ""
    
    var body: some View {
        NavigationView{
            
            VStack{
                TextField("mail address", text: $email).padding().textFieldStyle(.roundedBorder).disableAutocorrection(true)
                TextField("password", text: $password).padding().textFieldStyle(.roundedBorder)
                
                Button(action: {
                    Auth.auth().signIn(withEmail: email, password: password) { result, error in
                        if let user = result?.user {
                            // ログイン時に閲覧できる画面として画面遷移させる
                            print("ログインしました。")
                            app_storage_login_status = true
                        }
                    }
                  
                }, label: {
                    Text("ログイン")
                }).padding()
                
                NavigationLink(destination: PasswordResetView(), label: {
                    Text("パスワードリセット")
                })
                
                NavigationLink(destination: EntryAuthView(), label: {
                    Text("未登録の方はこちら")
                })
            }
        }
    }
}
