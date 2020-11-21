//
//  SaveProfile.swift
//  MusicShareApp
//
//  Created by yanasetakuya on 2020/11/19.
//

import Foundation
import Firebase

class SaveProfile{
    
    //Firebaseに値を渡す
    var userID:String! = ""
    var userName:String! = ""
    var email:String! = ""
    var ref: DatabaseReference!
    
    init(userID: String, userName: String, email: String) {
        self.userID = userID
        self.userName = userName
        self.email = email
        
        //ログインのときにuidを先頭につけて送信する。受信のときもuidから取得
        ref = Database.database().reference().child("profile").child(userID)
    }
    
//    init (snapShot: DataSnapshot) {
//        
//        ref = snapShot.ref
//        if let value = snapShot.value as? [String:Any] {
//            userID = value["userID"] as? String
//            userName = value["userName"] as? String
//        }
//        
//    }
    
    //ユーザー情報（userID,userEmail）を保存するメソッド
    func saveProfile() {
        ref.setValue(toContents())
    }
    
    func toContents()->[String:Any]{
        
        return ["userName":userName!,"email":email!]
        
    }
    
}
