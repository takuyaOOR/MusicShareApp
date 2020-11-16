//
//  HomescreenView.swift
//  MusicShareApp
//
//  Created by yanasetakuya on 2020/11/15.
//

import SwiftUI
import Firebase

struct HomescreenView : View {
    
    @State var index = 0
    
    var body: some View{
        
        VStack(spacing: 0){
        //ログアウト処理
//            Button(action: {
//                //ログアウト
//                try! Auth.auth().signOut()
//                UserDefaults.standard.set(false, forKey: "status")
//                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
//
//            }) {
//                Text("ログアウト")
//                    .foregroundColor(.white)
//                    .padding(.vertical)
//                    .frame(width: UIScreen.main.bounds.width - 50)
//            }
//            .background(Color("Color3"))
//            .cornerRadius(10)
//            .padding(.top, 25)
            
            ZStack {
                //タブ切り替え
                if self.index == 0 {
                    Color.red
                } else if self.index == 1 {
                    Color.blue
                } else if self.index == 2 {
                    Color.green
                } else{
                    Color.yellow
                }
                
            }
            .padding(.bottom, -35)
            
            CustomTabsView(index: self.$index)
            
        }
        
    }
}
