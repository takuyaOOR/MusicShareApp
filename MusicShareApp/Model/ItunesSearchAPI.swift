//
//  ItunesSearchAPI.swift
//  MusicShareApp
//
//  Created by yanasetakuya on 2020/11/21.
//

import Foundation
import Alamofire
import SwiftyJSON
import PKHUD

class ItunesSearchAPI: ObservableObject {
    
    var keyword: String
    
    init(keyword: String) {
        self.keyword = keyword
        startParse(keyword: keyword)
    }
    
    func startParse(keyword:String){
        
        HUD.show(.progress)
        
        //iTubesSearchAPI
        let urlString = "https://itunes.apple.com/search?term=\(keyword)&country=jp"
        
        //APIをエンコード
        let encodeUrlString:String = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        //Alamofireでリクエストを投げる
        AF.request(encodeUrlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{
            (response) in
            
            print(response)
            
            HUD.hide()
            
//            switch response.result{
//
//            case .success:
//
//                let json:JSON = JSON(response.data as Any)
//
//                var resultCount:Int = json["resultCount"].int!
//
//                for i in 0 ..< resultCount{
//
//                    var artWorkUrl = json["results"][i]["artworkUrl60"].string
//                    let previewUrl = json["results"][i]["previewUrl"].string
//                    let artistName = json["results"][i]["artistName"].string
//                    let trackCensoredName = json["results"][i]["trackCensoredName"].string
//
//                    if let range = artWorkUrl!.range(of:"60x60bb"){
//
//                        artWorkUrl?.replaceSubrange(range, with: "320x320bb")
//                    }
//
//                }
//
//                HUD.hide()
//
//            case .failure(let error):
//
//
//                print(error)
//                HUD.hide()
//
//        }
        
    }
    
        
        //ここ
        
        
    }
}
