//
//  SignupView.swift
//  MusicShareApp
//
//  Created by yanasetakuya on 2020/11/15.
//

import SwiftUI
import Firebase
import PKHUD
import UIKit

struct SignupView : View {
    
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var userName = ""
    @State var pass = ""
    @State var repass = ""
    @State var visible = false
    @State var revisible = false
    @Binding var show : Bool
    @State var alert = false
    @State var error = ""
    
    //キーボードオブザーブ用変数
    @State var value: CGFloat = 0
    
    var body: some View{
        
        ZStack{
            
            ZStack(alignment: .topLeading) {
                
                GeometryReader{_ in
                    
                    VStack{
                        
                        Image("logo")
                            .resizable()
                            .frame(width: 150, height: 150, alignment: .center)
                        
                        Text("アカウントを新規登録")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(self.color)
                            .padding(.top, 35)
                        
                        //メールアドレステキストフィールド
                        TextField("メールアドレス", text: self.$email)
                            .autocapitalization(.none)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Color3") : self.color,lineWidth: 2))
                            .padding(.top, 25)
                            .font(Font.system(size: 13, design: .default))
                        
                        //ユーザーネームテキストフィールド
                        TextField("ユーザーネーム", text: self.$userName)
                            .autocapitalization(.none)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.userName != "" ? Color("Color3") : self.color,lineWidth: 2))
                            .padding(.top, 25)
                            .font(Font.system(size: 13, design: .default))
                        
                        
                        //パスワードテキストフィールド
                        HStack(spacing: 15){
                            
                            VStack{
                                
                                if self.visible{
                                    TextField("パスワード", text: self.$pass)
                                        .autocapitalization(.none)
                                        .font(Font.system(size: 13, design: .default))
                                }
                                else{
                                    
                                    SecureField("パスワード", text: self.$pass)
                                        .autocapitalization(.none)
                                    .   font(Font.system(size: 13, design: .default))
                                }
                            }
                            
                            //パスワード可視化ボタン
                            Button(action: {
                                self.visible.toggle()
                            }) {
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                            }
                            
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color("Color3") : self.color,lineWidth: 2))
                        .padding(.top, 25)
                        
                        //パスワード再入力テキストフィールド
                        HStack(spacing: 15){
                            
                            VStack{
                                
                                if self.revisible{
                                    
                                    TextField("パスワードを再入力", text: self.$repass)
                                        .autocapitalization(.none)
                                        .font(Font.system(size: 13, design: .default))
                                }
                                else{
                                    SecureField("パスワードを再入力", text: self.$repass)
                                        .autocapitalization(.none)
                                        .font(Font.system(size: 13, design: .default))
                                }
                                
                            }
                            
                            //パスワード可視化ボタン
                            Button(action: {
                                self.revisible.toggle()
                                
                            }) {
                                Image(systemName: self.revisible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                            }
                            
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.repass != "" ? Color("Color3") : self.color,lineWidth: 2))
                        .padding(.top, 25)
                        
                        //新規登録ボタン
                        Button(action: {
                            self.register()
                        }) {
                            Text("新規登録")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        }
                        .background(Color("Color3"))
                        .cornerRadius(10)
                        .padding(.top, 25)
                        
                    }
                    .padding(.horizontal, 25)
                    
                }
                
                //バックボタン
                Button(action: {
                    self.show.toggle()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(Color("Color3"))
                }
                .padding()
                
            }
            
            //もしエラーが存在するならErrorVoewを表示
            if self.alert{
                ErrorView(alert: self.$alert, error: self.$error)
            }
            
        }
        .navigationBarHidden(true)
        //キーボードオブザーブ（テキストフィールドがキーボードに隠れてしまうことの対策）
        .offset(y: -self.value)
        .animation(.spring())
        .onAppear {
            NotificationCenter.default.addObserver(
                forName: UIResponder.keyboardWillShowNotification,
                object: nil, queue: .main) { (noti) in
                let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                let height = value.height
                
                self.value = height * 0.75
            }
            
            NotificationCenter.default.addObserver(
                forName: UIResponder.keyboardWillHideNotification,
                object: nil, queue: .main) { (noti) in
                
                self.value = 0
            }
        }
    }
    
    //新規登録
    func register(){
        
        //インディケーターを回す
        HUD.show(.progress)
        
        //メールとユーザーネームの空白確認
        if self.email != "" && self.userName != ""{
            //パスワードが一致するかの確認
            if self.pass == self.repass{
                //Firebaseにクリエイトユーザーのリクエストを送る
                Auth.auth().createUser(withEmail: self.email, password: self.pass) { (res, err) in
                    
                    //エラーが存在する場合
                    if err != nil{
                        //アラートをtrueにして返す
                        self.error = err!.localizedDescription
                        self.alert.toggle()
                        
                        //インディケーターを隠す
                        HUD.hide()
                        
                        //キーボードの高さ分ずらしたviewを戻す
                        self.value = 0
                        UIApplication.shared.closeKeyboard()
                        
                        return
                    }
                    
                    //成功した場合
                    //UserDefaultに新規登録が完了したことをstatusとして保存
                    //新規登録が完了したことを通知
                    print("success")
                    UserDefaults.standard.set(true, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                    
                    //Firebase(Realtime Database)にIDとユーザーネームを保存
                    guard let user = res?.user else { return }
                    let saveProfile = SaveProfile(userID: user.uid, userName: self.userName, email: self.email)
                    saveProfile.saveProfile()
                    
                    //UserDefaultsにユーザーIDを保存
                    UserDefaults.standard.setValue(user.uid, forKey: "userID")
                    
                    //UserDefaultにメールアドレスを保存する
                    UserDefaults.standard.setValue(user.email, forKey: "email")
                    
                    //Userdefaultにユーザーネームを保存
                    UserDefaults.standard.setValue(self.userName, forKey: "userName")
                    
                    //インディケーターを隠す
                    HUD.hide()
                    
                }
            }
            else{
                //パスワードが一致しない場合
                self.error = "パスワードが一致しません"
                self.alert.toggle()
                
                //キーボードの高さ分ずらしたviewを戻す
                self.value = 0
                UIApplication.shared.closeKeyboard()
                
                //インディケーターを隠す
                HUD.hide()
            }
        }
        else{
            //項目に空白がある場合
            self.error = "すべての項目を入力してください"
            self.alert.toggle()
            
            //キーボードの高さ分ずらしたviewを戻す
            self.value = 0
            UIApplication.shared.closeKeyboard()
            
            //インディケーターを隠す
            HUD.hide()
        }
        
    }
}


