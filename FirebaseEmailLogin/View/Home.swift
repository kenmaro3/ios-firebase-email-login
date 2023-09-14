
import SwiftUI
import FirebaseAuth

struct Home: View {
    @AppStorage("loginStatus") var app_storage_login_status: Bool = false
    @AppStorage("isUseBiometrics") var is_use_biometrics: Bool = false
    @AppStorage("name") var app_storage_name: String = ""
    @AppStorage("email") var app_storage_email: String = ""
    @AppStorage("password") var app_storage_password: String = ""
    var body: some View {
        Text("Hello, \(app_storage_name)")
        
        Button(action: {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                app_storage_login_status = false
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
            
        }, label: {
            Text("ログアウト")
        }).padding()
        
        Button(action: {
            let user = Auth.auth().currentUser
            
            user?.delete { error in
                if let error = error {
                    // エラー発生
                } else {
                    // 退会成功
                    app_storage_login_status = false
                    is_use_biometrics = false
                    app_storage_name = ""
                    app_storage_email = ""
                    app_storage_password = ""
                }
            }
        }, label: {
            Text("アカウントの削除")
        }).padding()
    }
}

#Preview {
    Home()
}
