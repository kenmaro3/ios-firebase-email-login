import SwiftUI
import FirebaseAuth
import LocalAuthentication

struct AuthenticationView: View {
    @AppStorage("loginStatus") var app_storage_login_status: Bool = false
    @AppStorage("isUseBiometrics") var is_use_biometrics: Bool = true
    @AppStorage("name") var app_storage_name: String = ""
    @AppStorage("email") var app_storage_email: String = ""
    @AppStorage("password") var app_storage_password: String = ""
    @State var isUseBiometrics: Bool = true
    
    @State  var email:String = ""
    @State  var password:String = ""
    
    var body: some View {
        NavigationView{
            
            VStack{
                TextField("mail address", text: $email).padding().textFieldStyle(.roundedBorder).disableAutocorrection(true)
                TextField("password", text: $password).padding().textFieldStyle(.roundedBorder)
                
                Button(action: {
                    firebaseEmailLogin()
                  
                }, label: {
                    Text("ログイン")
                }).padding()
                
                Toggle(isOn: $isUseBiometrics) {
                    Text(isUseBiometrics ? "次回から生体認証ログインを使用する" : "生体認証ログインは使用しない")
                }.padding()
                
                NavigationLink(destination: PasswordResetView(), label: {
                    Text("パスワードリセット")
                })
                
                NavigationLink(destination: EntryAuthView(), label: {
                    Text("未登録の方はこちら")
                })
            }
            .onChange(of: isUseBiometrics){ newValue in
                is_use_biometrics = isUseBiometrics
            }
            .onAppear{
                print("here")
                Task.detached{ @MainActor in
                    print("will start on appear main")
                    if(is_use_biometrics){
                        faceIdAuthentication()
                    }
                    
                }
            }
        }
    }
    
    func firebaseEmailLogin(){
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let user = result?.user {
                // ログイン時に閲覧できる画面として画面遷移させる
                print("ログインしました。")
                app_storage_login_status = true
                app_storage_name = user.displayName!
                app_storage_email = email
                app_storage_password = password
                is_use_biometrics = isUseBiometrics
                
            }
        }
    }
    
    func faceIdAuthentication(){
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "Authenticate to access the app"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){ success, authenticationError in
                if success{
                    print("successed")
                    Auth.auth().signIn(withEmail: app_storage_email, password: app_storage_password) { result, error in
                        if let user = result?.user {
                            // ログイン時に閲覧できる画面として画面遷移させる
                            print("ログインしました。")
                            app_storage_login_status = true
                            app_storage_name = user.displayName!
                            
                        }
                    }
                }else{
                    print("failed")
                    app_storage_login_status = false
                }
            }
        }else{
            // Device does not support Face ID or Touch ID
            print("Biometric authentication unavailable")
        }
    }
}
