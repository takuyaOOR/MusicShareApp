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
    
    //投稿データ取得用関数
    func fetchPostData(ref: DatabaseReference) {
        
        //配列を初期化
        postData.removeAll()
        
        ref.child("posts").observe(.value) { (snapshot) in
            
            for child in snapshot.children {

                let childSnapshot = child as! DataSnapshot

                let postData = SavePostData(postSnapshot: childSnapshot)
                self.postData.append(postData)
                
            }
            print(self.postData)
        }
    }
}
