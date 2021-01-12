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
    
    var userID = UserDefaults.standard.object(forKey: "userID")
    
    //お気に入り音楽取得メソッド
    func fetchFavoriteMusic(ref: DatabaseReference, userID: String) {
        //お気に入りリストを初期化
        favMusicData.removeAll()
        //users配下の自分のユーザーIDの音楽情報を取得
        ref.child("users").child(userID).observe(.value) { snapshot in
            for child in snapshot.children {
                let childSnapshot = child as! DataSnapshot
                //現時点で保存されているお気に入りリストを取得
                let musicData = SaveMusicData(snapshot: childSnapshot)
                //favMusicDataの先頭に追加していく
                self.favMusicData.append(musicData)
                
            }
        }
    }
    
    //お気に入り音楽削除用メソッド(ユニークな値をtrackIDで判定)
    func deleteFavoriteMusic(ref: DatabaseReference, userID: String, trackID: String) {
        print("---------------------------")
        print("削除しました")
        //users配下で選択した音楽のImageUrlと一致するReferenceを取得
        let deleteRef = ref.child("users").child(userID).child(trackID)
        
        deleteRef.removeValue()
        
    }
    
    
}
