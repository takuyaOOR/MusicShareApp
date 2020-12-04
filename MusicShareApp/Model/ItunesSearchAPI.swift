//
//  ItunesSearchAPI.swift
//  MusicShareApp
//
//  Created by yanasetakuya on 2020/11/21.
//

import SwiftUI
import Foundation
import Alamofire
import SwiftyJSON
import PKHUD
import Combine

class ItunesSearchAPI: ObservableObject {
    
    //楽曲情報保存用配列
    @Published var musicNameArray = [String]()
    @Published var artistNameArray = [String]()
    @Published var previewUrlArray = [String]()
    @Published var imageStringArray = [String]()
    
    @Published var musicData = [MusicItem]()
    
    //JSONパースメソッド
    func startParse(keyword:String){
        
        //インディケーターを回す
        HUD.show(.progress)
        
        //配列の初期化
        musicNameArray = [String]()
        artistNameArray = [String]()
        previewUrlArray = [String]()
        imageStringArray = [String]()
        
        musicData = [MusicItem]()
        
        //iTubesSearchAPI
        //itzyで落ちるため曲名検索のみにした
        //後で直す
        let urlString = "https://itunes.apple.com/search?term=\(keyword)&media=music&entity=song&attribute=artistTerm&country=jp"
        
        //APIのURLをエンコード
        let encodeUrlString:String = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        //Alamofireでリクエストを投げる
        AF.request(encodeUrlString, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON{ [self]
            (response) in
            
            //resposeの結果によって処理を分ける
            switch response.result{
            
            //成功した場合
            case .success:
                
                let json:JSON = JSON(response.data as Any)
                
                let resultCount:Int = json["resultCount"].int!
                
                //検索件数分繰り返す
                for i in 0 ..< resultCount{
                    
                    var artWorkUrl = json["results"][i]["artworkUrl100"].string
                    let previewUrl = json["results"][i]["previewUrl"].string
                    let artistName = json["results"][i]["artistName"].string
                    let trackCensoredName = json["results"][i]["trackCensoredName"].string
                    
                    //画像のリサイズ
                    if let range = artWorkUrl!.range(of:"100x100bb"){
                        artWorkUrl?.replaceSubrange(range, with: "320x320bb")
                    }
                    
                    //保存用配列に代入
                    self.musicNameArray.append(trackCensoredName!)
                    self.artistNameArray.append(artistName!)
                    self.previewUrlArray.append(previewUrl!)
                    self.imageStringArray.append(artWorkUrl!)
                    
                    musicData.append(MusicItem(musicName: trackCensoredName!,
                                               artistName: artistName!,
                                               previewUrl: previewUrl!,
                                               imageUrl: artWorkUrl!))
                    
                }
                
                //インディケーターを隠す
                HUD.hide()
                
            //失敗した場合
            case .failure(let error):
                
                print(error)
                //インディケーターを隠す
                HUD.hide()
                
            }
            
        }
        
    }
}

