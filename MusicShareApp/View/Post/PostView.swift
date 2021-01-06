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
    
    //お気に入り音楽情報を受け取って保存する配列
    @State var selected: [favMusics] = []
    
    //お気に入り選択画面を表示、非表示するための変数
    @State var show: Bool = false
    
    //コメント投稿画面を表示、非表示するための変数
    @State var showCommentView = false
    
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
                
                //選択済みの画像が空じゃなかったら
                if !self.selected.isEmpty {

                    ScrollView(.horizontal, showsIndicators: false) {

                        HStack {
                            
                            ForEach(self.selected) {music in
                                
                                VStack {
                                    
                                    WebImage(url: URL(string: music.imageUrl))
                                        .resizable()
                                        .frame(width: 320, height: 320)
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
                    .padding(.horizontal, 25)
                }
                
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
                
                //画像が選択されていたら次へボタンを表示
                if !self.selected.isEmpty {
                    
                    Button(action: {
                        
                        self.showCommentView = true
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
            //投稿文追加画面を表示
            .fullScreenCover(isPresented: self.$showCommentView) {
                
                CommentView(showCommentView: self.$showCommentView, selectedMusic: self.$selected)
            }
            
            //お気に入り音楽選択画面を表示
            if self.show {

                CustomPicker(selected: self.$selected, show: self.$show)
            }
        }
    }
}

//お気に入り音楽選択画面
struct CustomPicker: View {
    
    //選択された画像を受け果たすための配列
    @Binding var selected: [favMusics]
    
    //お気に入り選択画面を表示、非表示するための変数
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
                                        }
                                        
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
                        .disabled(self.selectedMusic.count == 0 ? true : false)
                        .opacity(self.selectedMusic.count == 0 ? 0.5 : 1)
                        
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

//投稿文追加画像
struct CommentView: View {
    
    //投稿文保存用変数
    @State var text = ""
    
    //コメントビューの表示非表示の切り替え用変数
    @Binding var showCommentView: Bool
    
    //投稿用お気に入り音楽保存用変数
    @Binding var selectedMusic: [favMusics]
    
    //アラート表示用変数
    @State var showAlert = false
    
    //投稿ボタン押下後HOME画面に戻す用の変数
    @State var showHomeView = false
    
    //ユーザーIDとユーザーネームをUserdefaultから取得
    var userID = UserDefaults.standard.object(forKey: "userID")
    var userName = UserDefaults.standard.object(forKey: "userName")
    
    var body: some View {
        
        VStack(spacing: 15) {
            
            MultiLineTF(text: $text)
                .border(Color.gray.opacity(0.5), width: 1)
            
            HStack {
                
                //戻るボタン
                Button(action: {
                    
                    self.showCommentView.toggle()
                }) {
                    
                    Text("戻る")
                        .padding()
                        .padding(.horizontal)
                }
                .background(Color("Color1"))
                .foregroundColor(.white)
                .clipShape(Capsule())
                
                //投稿ボタン
                Button(action: {
                    
                    print("投稿ボタン押下")
                    
                    // 現在日時を取得
                    let now = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMdkHms", options: 0, locale: Locale(identifier: "ja_JP"))
                    print(dateFormatter.string(from: now))
                    
                    //ユーザーの投稿内容ごとに分けるためのユニークな文字列
                    //ChildByAutoIDはStringにキャストできなかった
                    let autoID = UUID().uuidString
                    
                    //配列に存在するだけ投稿内容として保存
                    for i in self.selectedMusic {

                        let savePostData = SaveMusicData(trackID: i.trackID, artistName: i.artistName,
                                                         musicName: i.musicName, imageUrl: i.imageUrl,
                                                         userID: userID as! String, userName: userName as! String,
                                                         post: text,date: dateFormatter.string(from: now),
                                                         autoID: autoID)

                        savePostData.savePost()
                    }
                    
                    //アラートを表示
                    self.showAlert.toggle()
                    
                }) {
                    
                    Text("投稿")
                        .padding()
                        .padding(.horizontal)
                }
                .background(Color("Color3"))
                .foregroundColor(.white)
                .clipShape(Capsule())
                //空白(スペース含む)でないか判定
                //投稿文が入力されていたら投稿ボタンを押せるようにする
                .disabled(self.text.trimmingCharacters(in: .whitespaces).isEmpty == true ? true : false)
                .opacity(self.text.trimmingCharacters(in: .whitespaces).isEmpty == true ? 0.5 : 1)
            }
            //alertView
            .alert(isPresented: self.$showAlert) {
                Alert(title: Text("投稿が完了しました"), message: Text(""),
                      dismissButton: .default(Text("OK"), action: {
                        self.showHomeView.toggle()
                      }))
            }
            //HOMW画面を表示
            .fullScreenCover(isPresented: self.$showHomeView) {
                
                HomescreenView()
            }
        }
        .padding()
    }
}

//投稿画面のMultiLineTextField用
struct MultiLineTF: UIViewRepresentable {
    
    @Binding var text: String
    
    func makeCoordinator() -> Coordinator {
        
        return MultiLineTF.Coordinator(parent1: self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        
        let txview = UITextView()
        
        //編集、タップ、スクロールを有効にする
        txview.isEditable = true
        txview.isUserInteractionEnabled = true
        txview.isScrollEnabled = true
        txview.text = "投稿文を入力"
        txview.textColor = .gray
        txview.font = .systemFont(ofSize: 20)
        txview.delegate = context.coordinator
        
        return txview
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        
        var parent: MultiLineTF
        
        init(parent1: MultiLineTF) {
            
            parent = parent1
        }
        
        func textViewDidChange(_ textView: UITextView) {
            
            self.parent.text = textView.text
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            
            textView.text = ""
            textView.textColor = .label
        }
    }
    
}


//選択された画像用構造体
struct favMusics: Identifiable {
    var id = UUID()
    var trackID: String
    var musicName: String
    var artistName: String
    var imageUrl: String
}

