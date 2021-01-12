//
//  SavePostData.swift
//  MusicShareApp
//
//  Created by yanasetakuya on 2021/01/12.
//

import Foundation
import Firebase

class SavePostData: Identifiable {
    
    var trackID:String! = ""
    var artistName:String! = ""
    var musicName:String! = ""
    var imageUrl:String! = ""
    var userID:String! = ""
    var userName:String! = ""
    var post: String! = ""
    
    //投稿日時
    var date: String! = ""
    
    let ref:DatabaseReference!
    
    //イニシャライザ
    init(trackID:String,artistName:String,musicName:String,imageUrl:String,userID:String,userName:String,post: String, date: String) {
        
        self.trackID = trackID
        self.artistName = artistName
        self.musicName = musicName
        self.imageUrl = imageUrl
        self.userID = userID
        self.userName = userName
        self.post = post
        self.date = date
        
        ref = Database.database().reference().child("posts").childByAutoId()
    }
    
    //投稿データ取得用イニシャライザー
    init(postSnapshot: DataSnapshot) {
        
        ref = postSnapshot.ref
        
        if let value = postSnapshot.value as? [String:Any] {
            
            trackID = value["trackID"] as? String
            artistName =  value["artistName"] as? String
            musicName =  value["musicName"] as? String
            imageUrl =  value["imageUrl"] as? String
            userID =  value["userID"] as? String
            userName =  value["userName"] as? String
            post = value["post"] as? String
            date = value["date"] as? String
        }
    }
    
    //投稿データ保存
    func savePost() {
        
        ref.setValue(["trackID":trackID!,"artistName":artistName!,"musicName":musicName!,
                      "imageUrl":imageUrl!,
                      "userID": userID!,"userName":userName!,"date":date!,"post":post!])
    }
}
