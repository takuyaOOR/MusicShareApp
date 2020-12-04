//
//  SearchView.swift
//  MusicShareApp
//
//  Created by yanasetakuya on 2020/11/19.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchView: View {
    
    @State var title = ""
    @State var color = Color.black.opacity(0.7)
    
    //ジェスチャの移動距離用変数
    @State private var translation: CGSize = .zero
    
    @ObservedObject var itunesSearchAPI = ItunesSearchAPI()
    
    @State var alert = false
    @State var error = ""
    
    //キーボードオブザーブ用変数
    @State var value: CGFloat = 0
    
    var body: some View {
        
        VStack(spacing:0) {
            
            //検索フィールド
            HStack(spacing: 15) {
                TextField("アーティスト名を入力してください", text: self.$title, onCommit: {
                    //入力終了時
                    //startParseを実行
                    itunesSearchAPI.startParse(keyword: title)
                    //キーボードを閉じる
                    UIApplication.shared.closeKeyboard()
                    
                    self.title = ""
                    
                })
                    .font(Font.system(size: 13, design: .default))
                    .autocapitalization(.none)
                
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 4).stroke(self.title != "" ? Color("Color3") : self.color,lineWidth: 2))
            .padding(.top, 20)
                
            //MusicCardを表示
            GeometryReader{geometry in
                //検索結果が0じゃないとき
                if itunesSearchAPI.musicData.count != 0 {
                    //ZStackでカードを重ねて表示
                    ZStack {
                        ForEach(itunesSearchAPI.musicData.reversed()) {music in
                            //Card View
                            CardView(musicName: music.musicName,
                                     artistName: music.artistName,
                                     previewUrl: music.previewUrl,
                                     imageUrl: music.imageUrl,
                                     ofset: 0,
                                     frame: geometry.frame(in: .global))
                        }
                    }
                }
            }
            .padding(.top, 20)

        }
        .padding(.horizontal, 25)
    }
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}


