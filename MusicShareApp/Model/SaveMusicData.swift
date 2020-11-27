//
//  MusicDataModel.swift
//  MusicShareApp
//
//  Created by yanasetakuya on 2020/11/19.
//

import Foundation
import Firebase

class SaveMusicData: Identifiable{
    
    var artistName:String! = ""
    var musicName:String! = ""
    var previewUrl:String! = ""
    var imageUrl:String! = ""
    var userID:String! = ""
    var userName:String! = ""
    let ref:DatabaseReference!
    
    var key:String! = ""
    
    //お気に入り保存用イニシャライザー
    init(artistName:String,musicName:String,previewUrl:String,imageUrl:String,userID:String,userName:String){
        
        self.artistName = artistName
        self.musicName = musicName
        self.previewUrl = previewUrl
        self.imageUrl = imageUrl
        self.userID = userID
        self.userName = userName
        
        //ログインのときに拾えるuidを先頭につけて送信　受信するときもuidから引っ張ってくる
        
        ref = Database.database().reference().child("users").child(userID).childByAutoId()
        
    }
    
    //お気に入り取得用イニシャライザー
    init(snapshot:DataSnapshot){

        ref = snapshot.ref
        if let value = snapshot.value as? [String:Any]{

            artistName =  value["artistName"] as? String
            musicName =  value["musicName"] as? String
            imageUrl =  value["imageUrl"] as? String
            previewUrl =  value["previewUrl"] as? String
            userID =  value["userID"] as? String
            userName =  value["userName"] as? String
        }

    }
    
    
    func toContents()->[String:Any]{
        
        return ["artistName":artistName!,"musicName":musicName!,
                "previewUrl":previewUrl!,"imageUrl":imageUrl!,
                "userID": userID!,"userName":userName!]
        
    }
    
    func save(){
        ref.setValue(toContents())
    }
    
}

