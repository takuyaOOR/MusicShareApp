//
//  MainView.swift
//  MusicShareApp
//
//  Created by yanasetakuya on 2020/12/28.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

struct MainView: View {
    
    @ObservedObject var getPostData = GetPostData()
    
    var userID = UserDefaults.standard.object(forKey: "userID")
    
    //RealtimeDatabaseリファレンス
    @State var ref = Database.database().reference()
    
    //コメント
    @State var comment = ""
    
    //お気に入りした投稿を一時保保存する配列
    @State var favPost: [String] = []
    
    //キーボードオブザーブ用変数
    @State var value: CGFloat = 0
    
    var body: some View {
        
        VStack {
            
            Image("appName")
                .resizable()
                .frame(width: 250, height: 55)
                .scaledToFit()
                .padding(.top)
            
            ScrollView(.vertical, showsIndicators: false) {
                
                //投稿日時が新しい順に表示
                ForEach(getPostData.postData.reversed()){music in
                    
                    VStack(alignment: .leading) {
                        
                        HStack(spacing: 12) {
                            
                            VStack(alignment: .leading, spacing: 6) {
                                
                                Text(music.userName)
                                
                                Text(music.date)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer(minLength: 0)
                            
                            //メニューボタン
                            if userID as! String == music.userID {
                                
                                Menu(content: {
                                    
                                    Button(action: {
                                        
                                        //自分の投稿を削除
                                        getPostData.deletePostData(ref: ref, autoID: music.autoID)
                                        getPostData.postData.removeAll()
                                    }) {
                                        
                                        HStack {
                                            
                                            Image(systemName: "trash")
                                            
                                            Text("自分の投稿を削除")
                                                
                                            
                                            Spacer()
                                        }
                                    }
                                    
                                }, label: {
                                    
                                    Image("menu")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.gray)
                                })
                                
                            }
                            
                        }
                        
                        HStack {
                            
                            Spacer()
                            
                            WebImage(url: URL(string: music.imageUrl))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 320, height: 320)
                                .cornerRadius(10)
                                .padding(.vertical, 10)
                            
                            Spacer()
                        }
                        
                        HStack(spacing: 20) {
                            
                            //お気に入りボタン
//                            Button(action: {
//                                
//                                //お気に入りボタンが押されていなかったら投稿IDを配列に追加する
//                                if self.favPost.contains("\(music.autoID!)") == false {
//                                    
//                                    self.favPost.append(music.autoID)
//                                    
//                                } else {
//                                    
//                                    //選択済みなら配列から削除
//                                    //選択済みのtrackIDのindexを取得
//                                    let delIndex = favPost.index(of: "\(music.autoID!)")
//                                    self.favPost.remove(at: delIndex!)
//                                }
//                                
//                                print("お気に入り保存用配列：\(self.favPost)")
//                            }) {
//                              
//                                //お気に入り選択済みならハートをピンクにする
//                                if self.favPost.contains(music.autoID) {
//                                    
//                                    Image(systemName: "suit.heart.fill")
//                                        .font(.system(size: 24))
//                                        .foregroundColor(.pink)
//                                } else {
//                                    
//                                    //でなければ普通に表示
//                                    Image(systemName: "suit.heart")
//                                        .font(.system(size: 24))
//                                        .foregroundColor(.gray)
//                                }
//                            }
                            
                            //コメントボタン
//                            Button(action: {
//
//                            }) {
//
//                                Image(systemName: "message")
//                                    .resizable()
//                                    .frame(width: 22, height: 22)
//                                    .foregroundColor(.gray)
//                            }
//
                            //シェアボタン
                            Button(action: {
                                
                                print("お気に入り取得用配列\(self.favPost)")
                                
                                actionSheet(musicName: music.musicName,
                                            artistName: music.artistName,
                                            userName: music.userName,
                                            post: music.post,
                                            imageUrl: music.imageUrl)
                                
                            }) {
                                
                                Image(systemName: "paperplane")
                                    .resizable()
                                    .frame(width: 22, height: 22)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer(minLength: 0)
                        }
                        
                        Text(music.post)
                            .padding(.top, 5)
                        
                        //コメントビュー
//                        HStack(spacing: 15){
//
//                            TextField("コメントを追加", text: self.$comment)
//                                .font(.system(size: 12))
//
//                            Button(action: {
//
//                            }) {
//
//                                Image(systemName: "plus")
//                                    .foregroundColor(.gray)
//                            }
//                        }
//                        .padding(.horizontal)
//                        .padding(.vertical, 6)
//                        .background(Capsule().stroke(Color.gray, lineWidth: 1))
                        
                        Divider()
                            .padding(.top, 5)
                            .padding(.bottom, 30)
                        
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }
            }
            
            Spacer()
            
        }
        //このビューが読み込まれたら投稿データを取得
        .onAppear {
            
            //全投稿データを読み込み
            getPostData.fetchPostData(ref: ref)
            
            //自分のお気に入り投稿を取得
            getPostData.getFavPost(ref: ref, userID: userID as! String)
            
        }
        //このビューが閉じられたらお気に入り情報を登録
        .onDisappear {
            
            //お気に入りボタンを押している投稿だけお気に入りとして登録する
            for i in self.favPost {
                
                let saveFavPost = SaveFavPost(postID: i, userID: self.userID as! String)
                saveFavPost.saveFavPost()
            }
        }
    }
    
    //シェアシート
    func actionSheet(musicName: String, artistName: String, userName: String,post: String, imageUrl: String) {
        //楽曲情報と視聴用URL
        let data: String = "\(artistName) : \(musicName) \n ユーザー名 : \(userName) \n 投稿内容 : \(post)"
        
        //画像
        let imageData = try? Data(contentsOf: URL(string: imageUrl)!)
        let image = UIImage(data: imageData!)
        
        //楽曲情報とimageを配列に保存
        let item = [image, data] as [Any]
        
        let av = UIActivityViewController(activityItems: item, applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

