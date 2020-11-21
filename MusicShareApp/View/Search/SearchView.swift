//
//  SearchView.swift
//  MusicShareApp
//
//  Created by yanasetakuya on 2020/11/19.
//

import SwiftUI
import PKHUD


struct SearchView: View {
    
    @State var title = ""
    @State var color = Color.black.opacity(0.7)
    
    
    var body: some View {
        
        VStack(spacing:0) {
            
            //検索フィールド
            HStack(spacing: 15) {
                TextField("アーティスト・曲名を入力してください", text: self.$title, onCommit: {
                    //入力終了時
                    ItunesSearchAPI(keyword: title)
                })
                    .font(Font.system(size: 13, design: .default))
                
                Button(action: {
                    //入力終了時
                    ItunesSearchAPI(keyword: title)
                }) {
                    Image(systemName: "magnifyingglass.circle")
                        .foregroundColor(self.color)
                        .frame(width: 15, height: 15)
                        
                }
                
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 4).stroke(self.title != "" ? Color("Color3") : self.color,lineWidth: 2))
            .padding(.top, 25)
            
            Spacer()
            
        }
        .padding(.horizontal, 25)
        
    }
    
}



struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}


