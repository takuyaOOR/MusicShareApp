//
//  SaveFavPost.swift
//  MusicShareApp
//
//  Created by yanasetakuya on 2021/01/17.
//

import Foundation
import Firebase

class SaveFavPost {
    
    var postID: String!
    var userID: String!
    
    let ref: DatabaseReference
    
    //イニシャライザー
    init(postID: String, userID: String) {
        
        self.postID = postID
        
        ref = Database.database().reference().child("favoritePosts").child(userID).childByAutoId()
    }
    
    //お気に入り保存
    func saveFavPost() {
        
        ref.setValue(["postID": self.postID, "userID": self.userID])
    }
}
