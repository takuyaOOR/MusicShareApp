//
//  CardView.swift
//  MusicShareApp
//
//  Created by yanasetakuya on 2020/11/23.
//

import SwiftUI
import AVKit
import SDWebImageSwiftUI
import Firebase

struct CardView: View {
    
    //音楽情報受け取り用変数
    @State var trackID: String
    @State var musicName: String
    @State var artistName: String
    @State var previewUrl: String
    @State var imageUrl: String
    @State var ofset: CGFloat
    
    var frame: CGRect
    
    //ユーザーIDとユーザーネーム
    var userID = UserDefaults.standard.object(forKey: "userID")
    var userName = UserDefaults.standard.object(forKey: "userName")
    
    //音楽再生用変数
    @State var player:AVPlayer?
    
    //Databaseリファレンス
    var ref = Database.database().reference()
    
    var body: some View {
        
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            
            VStack {
                
                //画像表示
                WebImage(url: URL(string: String(imageUrl)))
                
                //楽曲情報表示
                VStack(spacing: 15) {
                    HStack {
                        
                        VStack(spacing: 12) {
                            //アーティスト名
                            Text(musicName)
                                .font(.headline)
                                .fontWeight(.bold)
                                .lineLimit(3)
                                .foregroundColor(Color("Color1"))

                            Text(artistName)
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .lineLimit(3)
                                .foregroundColor(Color("Color1"))
                        }

                    }

                    HStack(spacing: 35) {
    
                        Spacer()
    
                        //nextボタン
                        Button(action: {
                            
                            withAnimation(Animation.easeIn(duration: 0.8)) {
                                //左に動かす
                                self.ofset = -500
                            }
                            //音楽を止める
                            player?.pause()
    
                        }) {
                            Image(systemName: "arrowshape.turn.up.left")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color.blue)
                                .padding(20)
                                .background((Color("Color1")))
                                .clipShape(Circle())
                        }
                        
                        //再生ボタン
                        Button(action: {
                            
                            //音楽を再生する
                            playMusic(url: previewUrl)
                            
                        }) {
                            Image(systemName: "play")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color.green)
                                .padding(20)
                                .background(Color("Color1"))
                                .clipShape(Circle())
                        }
    
                        //◯ボタン
                        Button(action: {
                            
                            withAnimation(Animation.easeIn(duration: 0.8)) {
                                //右に動かす
                                self.ofset = 500
                            }
                            //音楽を止める
                            player?.pause()
                            //お気に入り処理
                            saveMusic(trackID: trackID, artistName: artistName,
                                      musicName: musicName,
                                      previewUrl: previewUrl, imageUrl: imageUrl,
                                      userID: userID as! String, userName: userName as! String)
    
                        }) {
                            Image(systemName: "heart")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color("Color3"))
                                .padding(20)
                                .background(Color("Color1"))
                                .clipShape(Circle())
                        }
    
                        Spacer(minLength: 0)
                    }
                }
                .padding()
                
            }
            .frame(width: frame.size.width, height: frame.size.height - 45)
            //カードの移動距離でカード自体の色を変える
            .background((self.ofset == 0 ? Color.white : (self.ofset > 0 ? Color("Color3") : Color.blue)
                            .opacity(self.ofset != 0 ? 0.7 : 0)))
            
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color("Color1"), lineWidth: 1)
            )
            .offset(x: self.ofset)
            //回転して動かす
            .rotationEffect(.init(degrees: (self.ofset) == 0 ? 0 : (self.ofset > 0 ? 12 : -12)))
            //ロングタップで動かせるようにする
            .gesture(
                DragGesture()
                    .onChanged({ (value) in
                        withAnimation(.default){
                            self.ofset = value.translation.width
                        }
                    })
                    .onEnded({ (value) in
                        withAnimation(.easeIn){
                            //Likedジェスチャー
                            if self.ofset > 150{
                                self.ofset = 500
                                //音楽を止める
                                player?.pause()
//                                //お気に入り処理
                                saveMusic(trackID: trackID, artistName: artistName,
                                          musicName: musicName,
                                          previewUrl: previewUrl, imageUrl: imageUrl,
                                          userID: userID as! String,
                                          userName: userName as! String)
                                
                            }
                            //Rejectedジャスチャー
                            else if self.ofset < -150{
                                self.ofset = -500
                                //音楽を止める
                                player?.pause()
                            }
                            else{
                                self.ofset = 0
                            }
                        }
                    })
            )
            
        }
        
    }
    
    //音楽再生用メソッド
    func playMusic(url: String) {
        print("------------------------------------------------------")
        print(url)
        
        let url = URL(string: url)
        
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
        
    }
    
    func saveMusic(trackID:String, artistName: String, musicName: String,
                   previewUrl: String, imageUrl: String,
                   userID: String, userName: String) {
        
        let saveMusicData = SaveMusicData(trackID: trackID,artistName: artistName,
                                          musicName: musicName,previewUrl: previewUrl,
                                          imageUrl: imageUrl,
                                          userID: userID, userName: userName)
        
        saveMusicData.save()
        
    }
    
}

