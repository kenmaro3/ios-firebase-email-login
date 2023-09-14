//
//  ContentView.swift
//  FirebaseEmailLogin
//
//  Created by Kentaro Mihara on 2023/09/14.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("email") var app_storage_email: String = ""
    @AppStorage("loginStatus") var app_storage_login_status: Bool = false
    var body: some View {
        if(app_storage_email == ""){
            EntryAuthView()
        }else{
            if(app_storage_login_status){
                Home()
            }else{
                AuthenticationView()
            }
        }
    }
}

#Preview {
    ContentView()
}
