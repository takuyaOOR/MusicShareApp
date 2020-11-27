//
//  FavoriteView.swift
//  MusicShareApp
//
//  Created by yanasetakuya on 2020/11/26.
//

import SwiftUI
import Firebase

struct FavoriteView: View {
    
    //ユーザーIDとユーザーネームをUserdefaultから取得
    var userID = UserDefaults.standard.object(forKey: "userID")
    var userName = UserDefaults.standard.object(forKey: "userName")
    
    //RealtimeDatabaseリファレンス
    var ref = Database.database().reference()
    
    @ObservedObject var getFavMusic = GetFavMusic()
    
    //お気に位置リスト用配列
    @State var favMusicList = [SaveMusicData]()
    
    var body: some View {
        VStack {
            ForEach(getFavMusic.favMusicData) {music in
                Text(music.artistName)
                Text(music.musicName)
                Text("-----------------")
            }
        }
        .onAppear {
            getFavMusic.fetchFavoriteMusic(ref: ref, userID: userID as! String)
        }
        
        
    }
    
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
    }
}
