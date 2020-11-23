//
//  CardView.swift
//  MusicShareApp
//
//  Created by yanasetakuya on 2020/11/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct CardView: View {
    
    @State var musicName: String
    @State var artistName: String
    @State var previewURL: String
    @State var imageURL: String
    
    @State var ofset: CGFloat
    
    var frame: CGRect
    
    var body: some View {
        ZStack {
            VStack {
                //画像表示
                WebImage(url: URL(string: String(imageURL)))
                    .padding(.top, 25)
                
                Spacer()
                
                //楽曲情報表示
                VStack(spacing: 15) {
                    HStack {
                        VStack(alignment: .leading, spacing: 12) {
                            //アーティスト名
                            Text(musicName)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(Color("Color1"))

                            Text(artistName)
                                .fontWeight(.bold)
                                .foregroundColor(Color("Color1"))
                        }

                        Spacer(minLength: 0)
                    }

                    HStack(spacing: 35) {
    
                        Spacer()
    
                        //Xボタン
                        Button(action: {
                            
                            withAnimation(Animation.easeIn(duration: 0.8)) {
                                //左に動かす
                                self.ofset = -500
                            }
    
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .padding(20)
                                .background((Color("Color3")))
                                .clipShape(Circle())
                        }
    
                        //◯ボタン
                        Button(action: {
                            
                            withAnimation(Animation.easeIn(duration: 0.8)) {
                                //右に動かす
                                self.ofset = 500
                            }
    
                        }) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .padding(20)
                                .background((Color.green))
                                .clipShape(Circle())
                        }
    
                        Spacer(minLength: 0)
                    }
                }
                .padding()
                
            }
            .frame(width: frame.size.width, height: frame.size.height - 65)
            .background(Color.white)
            .cornerRadius(15)
            .offset(x: self.ofset)
            //回転して動かす
            .rotationEffect(.init(degrees: (self.ofset) == 0 ? 0 : (self.ofset > 0 ? 12 : -12)))
            .gesture(
                DragGesture()
                    .onChanged({ (value) in
                        withAnimation(.default){
                            self.ofset = value.translation.width
                        }
                    })
                    .onEnded({ (value) in
                        withAnimation(.easeIn){
                            if self.ofset > 150{
                                self.ofset = 500
                            }
                            else if self.ofset < -150{
                                self.ofset = -500
                            }
                            else{
                                self.ofset = 0
                            }
                        }
                    })
            )
            
        }
    }
}

