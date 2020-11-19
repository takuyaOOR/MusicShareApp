//
//  LoginView.swift
//  MusicShareApp
//
//  Created by yanasetakuya on 2020/11/15.
//

import SwiftUI
import Firebase

struct LoginView : View {
    
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var pass = ""
    @State var visible = false
    @Binding var show : Bool
    @State var alert = false
    @State var error = ""
    
    //RealtimeDatabase(pfofile情報)
    var ref = Database.database().reference()
    //キーボードオブザーブ用変数
    @State var value: CGFloat = 0
    
    var body: some View{
        
        ZStack{
            
            VStack {
                ZStack(alignment: .topTrailing) {
                    
                    GeometryReader{_ in
                        VStack{
                            
                            Image("logo")
                                .resizable()
                                .frame(width: 250, height: 250, alignment: .center)
                            
                            Text("アカウントにログイン")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(self.color)
                                .padding(.top, 35)
                            
                            TextField("Email", text: self.$email)
                            .autocapitalization(.none)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Color3") : self.color,lineWidth: 2))
                            .padding(.top, 25)
                            
                            HStack(spacing: 15){
                                
                                VStack{
                                    
                                    if self.visible{
                                        TextField("Password", text: self.$pass)
                                        .autocapitalization(.none)
                                    }
                                    else{
                                        SecureField("Password", text: self.$pass)
                                        .autocapitalization(.none)
                                    }
                                }
                                
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
                            
                            HStack{
                                
                                Spacer()
                                
                                Button(action: {
                                    self.reset()
                                }) {
                                    Text("パスワードを忘れた場合")
                                        .fontWeight(.bold)
                                        .foregroundColor(Color("Color3"))
                                }
                            }
                            .padding(.top, 20)
                            
                            Button(action: {
                                self.verify()
                            }) {
                                Text("ログイン")
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
                    
                    
                    Button(action: {
                        self.show.toggle()
                    }) {
                        Text("新規登録")
                            .fontWeight(.bold)
                            .foregroundColor(Color("Color3"))
                    }
                    .padding()
                    
                }
            }
            
            
            if self.alert{
                
                ErrorView(alert: self.$alert, error: self.$error)
            }
        }
        //キーボードオブザーブ（テキストフィールドがキーボードん隠れてしまうことの対策）
        .offset(y: -self.value)
        .animation(.spring())
        .onAppear {
            NotificationCenter.default.addObserver(
                forName: UIResponder.keyboardWillShowNotification,
                object: nil, queue: .main) { (noti) in
                let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                let height = value.height
                
                self.value = height
            }
            
            NotificationCenter.default.addObserver(
                forName: UIResponder.keyboardWillHideNotification,
                object: nil, queue: .main) { (noti) in
                
                
                self.value = 0
            }
        }
        
    }
    
    //認証
    func verify(){
        
        //メールとパスワードの空白確認
        if self.email != "" && self.pass != ""{
            
            //Firebaseに認証のリスエストを送る
            Auth.auth().signIn(withEmail: self.email, password: self.pass) { (res, err) in
                
                if err != nil{
                    //エラーの場合アラートをtrueにして返す
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                //成功した場合
                //UserDefaultsにstatasとして認証成功したことを保存
                //認証成功したことを通知
                print("success")
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                
                //ユーザーIDをFirebaseから取得しUserDefaultに保存
                guard let user = res?.user else { return }
                let userID = user.uid
                UserDefaults.standard.setValue(userID, forKey: "userID")
                
                //uidと紐づくユーザーネームをFirebaseから取得しUserDefaultに保存
                ref.child("profile").observe(.childAdded) { (snapShot) in
                    if let user = snapShot.value as? [String:Any] {
                        let userName = user["userName"]
                        UserDefaults.standard.setValue(userName, forKey: "userName")
                    }
                }
                
            }
        }
        else{
            //項目に空白がある場合
            self.error = "すべての項目を入力してください"
            self.alert.toggle()
        }
    }
    
    //パスワード忘れ
    func reset(){
        
        //メールに空白確認
        if self.email != ""{
            //Firebaseにパスワードリセットのリクエストを送る
            Auth.auth().sendPasswordReset(withEmail: self.email) { (err) in
                
                if err != nil{
                    //エラーが存在する場合アラートをtrueにして返す
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                //リセットが成功した場合
                self.error = "RESET"
                self.alert.toggle()
            }
        }
        else{
            //メールがからの場合
            self.error = "メールが入力されていません"
            self.alert.toggle()
        }
    }
    
}



