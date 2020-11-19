//
//  Account.swift
//  MusicShareApp
//
//  Created by yanasetakuya on 2020/11/17.
//

import SwiftUI
import Firebase

struct AccountView: View {
    //ユーザーIDとユーザーネームを取得
    let userID = UserDefaults.standard.object(forKey: "userID") as? String
    let userName = UserDefaults.standard.object(forKey: "userName") as? String
    let email = UserDefaults.standard.object(forKey: "email") as? String
    
    var body: some View {
        VStack(spacing: 0) {
            
            Text(userID!)
            Text(userName!)
            Text(email!)
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
