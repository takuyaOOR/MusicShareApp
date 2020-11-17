//
//  Account.swift
//  MusicShareApp
//
//  Created by yanasetakuya on 2020/11/17.
//

import SwiftUI
import Firebase

struct AccountView: View {
    var body: some View {
        VStack(spacing: 0) {
            //ログアウト処理
            Button(action: {
                //ログアウト
                try! Auth.auth().signOut()
                UserDefaults.standard.set(false, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
            }) {
                Text("ログアウト")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
            }
            .background(Color("Color3"))
            .cornerRadius(10)
            .padding(.top, 25)
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
