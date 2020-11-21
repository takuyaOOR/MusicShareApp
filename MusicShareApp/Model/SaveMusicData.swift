//
//  MusicDataModel.swift
//  MusicShareApp
//
//  Created by yanasetakuya on 2020/11/19.
//

import Foundation
import Firebase

class SaveMusicData {
    
    var artistName:String! = ""
    var musicName:String! = ""
    var preViewURL:String! = ""
    var imageString:String! = ""
    var userID:String! = ""
    var userName:String! = ""
    var artistViewUrl:String! = ""
    let ref:DatabaseReference!
    
    var key:String! = ""
    
    init(artistName:String,musicName:String,preViewURL:String,imageString:String,userID:String,userName:String){
        
        self.artistName = artistName
        self.musicName = musicName
        self.preViewURL = preViewURL
        self.imageString = imageString
        self.userID = userID
        self.userName = userName
        
        //ログインのときに拾えるuidを先頭につけて送信　受信するときもuidから引っ張ってくる
        
        ref = Database.database().reference().child("users").child(userID)
        
    }
    
//    init(snapshot:DataSnapshot){
//
//
//        ref = snapshot.ref
//        if let value = snapshot.value as? [String:Any]{
//
//            artistName =  value["artistName"] as? String
//            musicName =  value["musicName"] as? String
//            imageString =  value["imageString"] as? String
//            preViewURL =  value["preViewURL"] as? String
//            userID =  value["userID"] as? String
//            userName =  value["userName"] as? String
//        }
//
//    }
    
    
    func toContents()->[String:Any]{
        
        return ["artistName":artistName!,"musicName":musicName!,"preViewURL":preViewURL!,"imageString":imageString!,"userID":userID!,"userName":userName!]
        
    }
    
    
    func save(){
        ref.setValue(toContents())
    }
    
}

