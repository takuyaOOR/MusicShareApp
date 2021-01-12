//
//  MainView.swift
//  MusicShareApp
//
//  Created by yanasetakuya on 2020/12/28.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

struct MainView: View {
    
    @ObservedObject var getPostData = GetPostData()
    
    //RealtimeDatabaseリファレンス
    @State var ref = Database.database().reference()
    
    var body: some View {
        
        VStack() {
            
            Image("appName")
                .resizable()
                .frame(width: 250, height: 55)
                .scaledToFit()
                .padding(.top)
            
            
            ForEach(getPostData.postData){music in
                
                Text(music.artistName)
            }
            
            Spacer()
            
        }
        //このビューが読み込まれたら投稿データを取得
        .onAppear {
            
            
            getPostData.fetchPostData(ref: ref)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
