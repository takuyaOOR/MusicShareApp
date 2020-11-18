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
    var ref: DatabaseReference!
    
    init(userID: String, userName: String) {
        self.userID = userID
        self.userName = userName
        
        //ログインのときにuidを先頭につけて送信する。受信のときもuidから取得
        ref = Database.database().reference().child("profile").childByAutoId()
    }
    
    init (snapShot: DataSnapshot) {
        
        ref = snapShot.ref
        if let value = snapShot.value as? [String:Any] {
            userID = value["userID"] as? String
            userName = value["userName"] as? String
        }
        
    }
    
    //ユーザー情報（userID,userEmail）を保存するメソッド
    func saveProfile() {
        ref.setValue(toContents())
        //ユーザーデフォルトにautoIDとしてユニークな値を保存
        UserDefaults.standard.setValue(ref.key, forKey: "autoID")
    }
    
    func toContents()->[String:Any]{
        
        return ["userID":userID!,"userName":userName as Any]
        
    }
    
}
