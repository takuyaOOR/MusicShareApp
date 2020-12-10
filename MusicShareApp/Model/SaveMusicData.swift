//
//  MusicDataModel.swift
//  MusicShareApp
//
//  Created by yanasetakuya on 2020/11/19.
//

import Foundation
import Firebase

class SaveMusicData: Identifiable{
    
    var trackID:String! = ""
    var artistName:String! = ""
    var musicName:String! = ""
    var previewUrl:String! = ""
    var imageUrl:String! = ""
    var userID:String! = ""
    var userName:String! = ""
    let ref:DatabaseReference!
    
    
    //お気に入り保存用イニシャライザー
    init(trackID:String,artistName:String,musicName:String,previewUrl:String,imageUrl:String,userID:String,userName:String){
        
        self.trackID = trackID
        self.artistName = artistName
        self.musicName = musicName
        self.previewUrl = previewUrl
        self.imageUrl = imageUrl
        self.userID = userID
        self.userName = userName
        
        //ログインのときに拾えるuidを先頭につけて送信　受信するときもuidから引っ張ってくる
        //users配下にuserIDでお気に入り音楽分ける
        //更にtrackIdで曲を分ける
        ref = Database.database().reference().child("users").child(userID).child(trackID)
        
    }
    
    //お気に入り取得用イニシャライザー
    init(snapshot:DataSnapshot){

        ref = snapshot.ref
        if let value = snapshot.value as? [String:Any]{
            
            trackID = value["trackID"] as? String
            artistName =  value["artistName"] as? String
            musicName =  value["musicName"] as? String
            imageUrl =  value["imageUrl"] as? String
            previewUrl =  value["previewUrl"] as? String
            userID =  value["userID"] as? String
            userName =  value["userName"] as? String
        }

    }
    
    //保存用の値に変換
    func toContents()->[String:Any]{
        
        return ["trackID":trackID!,"artistName":artistName!,"musicName":musicName!,
                "previewUrl":previewUrl!,"imageUrl":imageUrl!,
                "userID": userID!,"userName":userName!]
        
    }
    
    //保存
    func save(){
        ref.setValue(toContents())
    }
    
}

