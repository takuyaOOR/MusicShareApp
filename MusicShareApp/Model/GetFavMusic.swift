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
        //users配下の自分のユーザーIDの音楽情報を取得
        ref.child("users").child(userID).observe(.value) { snapshot in
            for child in snapshot.children {
                let childSnapshot = child as! DataSnapshot
                //現時点で保存されているお気に入りリストを取得
                let musicData = SaveMusicData(snapshot: childSnapshot)
                //favMusicDataの先頭に追加していく
                self.favMusicData.insert(musicData, at: 0)
            }
        }
    }
    
    //お気に入り音楽削除用メソッド(ユニークな値をImageURLで判定)
    func deleteFavoriteMusic(ref: DatabaseReference, userID: String, imageURL: String) {
        //users配下で選択した音楽のImageUrlと一致するReferenceを取得
//        let deleteRef = ref.child("users").child(userID).queryOrdered(byChild: "imageUrl").queryEqual(toValue: imageURL)
//
//        print("--------------------------------------------------")
//        print(deleteRef)
//
//        deleteRef.observe(.value) { (snapshot) in
//            for item in snapshot.children {
//                let key = (item as AnyObject).key as String
//                print(key)
//
//                ref.child("users").child(userID).child(key).removeValue()
//            }
//        }
        
    }
    
}
