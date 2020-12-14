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
    
    @State var selected: [UIImage] = []
    @State var data: [Images] = []
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
                
                Spacer()
                
            }
            
            if self.show {

                CustomPicker(selected: self.$selected, data: self.$data, show: self.$show)
            }
        }
    }
}

struct CustomPicker: View {
    
    @Binding var selected: [UIImage]
    @Binding var data: [Images]
    @Binding var show: Bool
    
    @State var grid: [Int] = []
    
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
                        
                        ForEach(getFavMusic.favMusicData){music in
                            Text(music.musicName)
                        }
                        
                    }
                    .frame(width: UIScreen.main.bounds.width - 40,
                           height: UIScreen.main.bounds.height / 1.5)
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(12)
                    
                    Spacer()
                }
                
                Spacer()
            }
        }
        .background(Color.white.edgesIgnoringSafeArea(.all)
            .onTapGesture {
                self.show.toggle()
        })
        
        //このビューが読み込まれたらお気に入り情報から画像を取得
        .onAppear {
            getAllFavImage()
        }
            
        
    }
    
    //お気に入り音楽の画像をすべて取得する
    func getAllFavImage() {

        getFavMusic.fetchFavoriteMusic(ref: ref, userID: userID as! String)
        
    }
    
    //grid取得
    func getGrid() {
        
        for i in stride(from: 0, to: self.data.count, by: 3) {
            
            self.grid.append(i)
        }
    }
    
}

//選択された画像用
struct Images {
    var imageUrl: String
    var selected: Bool
}
