//
//  GetFavMusic.swift
//  MusicShareApp
//
//  Created by yanasetakuya on 2020/11/27.
//

import Foundation
import Firebase

class GetFavMusic: ObservableObject {
    
    //お気に入り音楽情報保存用配列
    @Published var favMusicData = [SaveMusicData]()
    
    //お気に入り音楽取得メソッド
    func fetchFavoriteMusic(ref: DatabaseReference, userID: String) {
        print("fetchFavoriteMusic実行中")
        //users配下の自分のユーザーIDの音楽情報を取得
        ref.child("users").child(userID).observe(.value) { snapshot in
            for child in snapshot.children {
                print(child)
                let childSnapshot = child as! DataSnapshot
                //現時点で保存されているお気に入りリストを取得
                let musicData = SaveMusicData(snapshot: childSnapshot)
                //favMusicDataの戦闘に追加していく
                self.favMusicData.insert(musicData, at: 0)
                print(self.favMusicData)
            }
        }
    }
    
}
