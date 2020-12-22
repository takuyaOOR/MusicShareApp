//
//  PostView.swift
//  MusicShareApp
//
//  Created by yanasetakuya on 2020/12/06.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct PostView: View {
    
    @State var selected: [favMusics] = []
    @State var show: Bool = false
    
    var body: some View {
        
        ZStack {
            
            VStack {
                
                HStack(spacing: 20) {
                    
                    Spacer()

                    Text("Post")
                        .font(.title)
                        .fontWeight(.heavy)

                    Spacer()
                }
                .padding(.top, 30)
                
                Spacer()
                
                //選択済みの画像が空じゃなかったら
                if !self.selected.isEmpty {

                    ScrollView(.horizontal, showsIndicators: false) {

                        HStack {
                            
                            ForEach(self.selected) {music in
                                
                                VStack {
                                    
                                    WebImage(url: URL(string: music.imageUrl))
                                        .resizable()
                                        .frame(width: 250, height: 250)
                                        .cornerRadius(15)
                                        
                                    Text(music.musicName)
                                        .font(.system(size: 17))
                                        .foregroundColor(Color("Color1"))
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .lineLimit(3)
                                        .multilineTextAlignment(.center)

                                    Text(music.artistName)
                                        .font(.system(size: 14))
                                        .foregroundColor(Color("Color1"))
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .lineLimit(3)
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                Button(action: {
                    
                    self.selected.removeAll()
                    self.show.toggle()
                }) {
                    
                    Text("お気に入りを選択")
                        .foregroundColor(Color.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width / 2)
                }
                .background(Color("Color3"))
                .clipShape(Capsule())
                
                //画像が選択されていたら次へボタンを表示
                if !self.selected.isEmpty {
                    
                    Button(action: {
                        
                    }) {
                        
                        Text("次へ")
                            .foregroundColor(Color.white)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width / 2)
                    }
                    .background(Color("Color1"))
                    .clipShape(Capsule())
                    
                }
                
                Spacer()
            }
            
            
            
            if self.show {

                CustomPicker(selected: self.$selected, show: self.$show)
            }
        }
    }
}

struct CustomPicker: View {
    
    //選択された画像を受け果たすための配列
    @Binding var selected: [favMusics]
    @Binding var show: Bool
    
    //すでに選択済みか判定するための配列
    @State var selectedMusic: [String] = []
    
    //選択済みの音楽情報を一時保存する配列
    @State var favItem: [favMusics] = []
    
    //ユーザーIDとユーザーネームをUserdefaultから取得
    var userID = UserDefaults.standard.object(forKey: "userID")
    var userName = UserDefaults.standard.object(forKey: "userName")
    
    //RealtimeDatabaseリファレンス
    @State var ref = Database.database().reference()
    
    @ObservedObject var getFavMusic = GetFavMusic()
    
    var body: some View {
            
        GeometryReader {_ in
            
            VStack {
                
                Spacer()
                
                HStack {
                    
                    Spacer()
                    
                    VStack {
                        
                        Text("お気に入り音楽を選択")
                            .font(.system(size: 20))
                            .font(.title)
                            .fontWeight(.heavy)
                            .padding(.top, 10)
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            
                            ForEach(getFavMusic.favMusicData){music in
                                
                                HStack {
                                    
                                    Button(action: {
                                        
                                        
                                        //選択済みに追加していく
                                        //未選択なら配列に追加
                                        if self.selectedMusic.contains("\(music.trackID!)") == false {

                                            //選択済みか判定用配列にtrackIDを代入
                                            self.selectedMusic.append(music.trackID)
                                            
                                            //変数に一時保存
                                            let item = favMusics(trackID: music.trackID,
                                                                 musicName: music.musicName,
                                                                 artistName: music.artistName,
                                                                 imageUrl: music.imageUrl)
                                        
                                            //選択済み用配列に保存
                                            self.favItem.append(item)

                                        } else {

                                            //選択済みなら配列から削除
                                            //選択済みのtrackIDのindexを取得
                                            let delIndex = selectedMusic.index(of: "\(music.trackID!)")

                                            //selectedMusicとselectedからdelIndexの要素を削除
                                            self.selectedMusic.remove(at: delIndex!)
                                            self.favItem.remove(at: delIndex!)
                                            print(delIndex!)
                                        }
                                        
                                        print("-----------------------------------")
                                        print(self.selectedMusic)
                                        print(self.favItem)
                                    }) {
                                        
                                        //画像が選択済みならチェックマークを重ねる
                                        if self.selectedMusic.contains(music.trackID) {

                                            ZStack {

                                                WebImage(url: URL(string: music.imageUrl))
                                                    .resizable()
                                                    .frame(width: 150, height: 150)
                                                    .cornerRadius(12)
                                                    .opacity(0.5)

                                                Image(systemName: "checkmark")
                                                    .resizable()
                                                    .frame(width: 75, height: 75)
                                                    .foregroundColor(Color.black)

                                            }

                                        } else {

                                            //選択済みでなければ普通に表示
                                            WebImage(url: URL(string: music.imageUrl))
                                                .resizable()
                                                .frame(width: 150, height: 150)
                                                .cornerRadius(12)
                                        }
                                        
                                    }
                                    
                                    HStack {
                                        
                                        Spacer()
                                        
                                        VStack {
                                            
                                            Text(music.musicName)
                                                .font(.system(size: 15))
                                                .foregroundColor(Color("Color1"))
                                                .font(.headline)
                                                .fontWeight(.bold)
                                                .lineLimit(3)
                                                .multilineTextAlignment(.center)

                                            Text(music.artistName)
                                                .font(.system(size: 12))
                                                .foregroundColor(Color("Color1"))
                                                .font(.subheadline)
                                                .fontWeight(.bold)
                                                .lineLimit(3)
                                                .multilineTextAlignment(.center)
                                            
                                        }
                                        
                                        Spacer()
                                    }
                                    
                                    Spacer()
                                }
                            }
                        }
                        
                        Button(action: {
                            
                            self.show.toggle()
                        }) {
                            
                            Text("選択")
                                .foregroundColor(Color.white)
                                .padding(.vertical, 10)
                                .frame(width: UIScreen.main.bounds.width / 3)
                                
                        }
                        .background(Color("Color3"))
                        .clipShape(Capsule())
                        .padding(.bottom, 10)
                        
                    }
                    .frame(width: UIScreen.main.bounds.width - 40,
                           height: UIScreen.main.bounds.height / 1.5)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(12)
                    
                    Spacer()
                }
                
                Spacer()
            }
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
        
        //このビューが読み込まれたらお気に入り情報から画像を取得
        .onAppear {
            
            getAllFavImage()
        }
        //このビューが閉じられたらBinding配列に選択済みの音楽情報を代入にて受け渡す
        .onDisappear {
            
            self.selected = self.favItem
        }
    }
    
    //お気に入り音楽の画像をすべて取得する
    func getAllFavImage() {

        getFavMusic.fetchFavoriteMusic(ref: ref, userID: userID as! String)
    }
}

//選択された画像用
struct favMusics: Identifiable {
    var id = UUID()
    var trackID: String
    var musicName: String
    var artistName: String
    var imageUrl: String
}

