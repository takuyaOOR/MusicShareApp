//
//  GetPostData.swift
//  MusicShareApp
//
//  Created by yanasetakuya on 2021/01/07.
//

import Foundation
import Firebase

class GetPostData: ObservableObject {
    
    //投稿データ保存用配列
    @Published var postData = [SavePostData]()
    
    //お気に入り投稿データ保存用配列
    @Published var favPostData = [String]()
    
    //投稿データ取得用関数
    func fetchPostData(ref: DatabaseReference) {
        
        //配列を初期化
        postData.removeAll()
        
        ref.child("posts").observe(.value) { (snapshot) in
            
            for child in snapshot.children {

                let childSnapshot = child as! DataSnapshot

                //postDataを保存
                let postData = SavePostData(postSnapshot: childSnapshot)
                self.postData.append(postData)
            }
        }
    }
    
    //投稿データ削除
    func deletePostData(ref: DatabaseReference, autoID: String) {
        
        let deleteRef = ref.child("posts").child(autoID)
        deleteRef.removeValue()
    }
    
    //お気に入り投稿取得
    func getFavPost(ref: DatabaseReference, userID: String) {
        
        ref.child("favoritePosts").child(userID).observe(.value) { (snapshot) in
            for child in snapshot.children {
                
                let childSnapshot = child as! DataSnapshot
                let favPostID = childSnapshot.value as? [String:Any]
                self.favPostData.append(favPostID!["postID"] as! String)
            }
        }
    }
}
