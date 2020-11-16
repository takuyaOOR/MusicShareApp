//
//  SignupView.swift
//  MusicShareApp
//
//  Created by yanasetakuya on 2020/11/15.
//

import SwiftUI
import Firebase

struct SignupView : View {
    
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var pass = ""
    @State var repass = ""
    @State var visible = false
    @State var revisible = false
    @Binding var show : Bool
    @State var alert = false
    @State var error = ""
    
    //キーボードの監視
    @ObservedObject var keyboard = KeyboardObserver()
    
    var body: some View{
        
        ZStack{
            
            ZStack(alignment: .topLeading) {
                
                GeometryReader{_ in
                    
                    VStack{
                        
                        Image("logo")
                            .resizable()
                            .frame(width: 250, height: 250, alignment: .center)
                        
                        Text("アカウントを新規登録")
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
                        
                        HStack(spacing: 15){
                            
                            VStack{
                                
                                if self.revisible{
                                    
                                    TextField("パスワードを再入力", text: self.$repass)
                                    .autocapitalization(.none)
                                }
                                else{
                                    SecureField("パスワードを再入力", text: self.$repass)
                                    .autocapitalization(.none)
                                }
                                
                            }
                            
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
                
                Button(action: {
                    self.show.toggle()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(Color("Color3"))
                }
                .padding()
                
            }
            
            if self.alert{
                ErrorView(alert: self.$alert, error: self.$error)
            }
            
        }
        .navigationBarHidden(true)
    }
    
    //新規登録
    func register(){
        //メールの空白確認
        if self.email != ""{
            //パスワードが一致するかの確認
            if self.pass == self.repass{
                //Firebaseにクリエイトユーザーのリクエストを送る
                Auth.auth().createUser(withEmail: self.email, password: self.pass) { (res, err) in
                    //エラーが存在する場合
                    if err != nil{
                        //アラートをtrueにして返す
                        self.error = err!.localizedDescription
                        self.alert.toggle()
                        return
                    }
                    
                    //成功した場合
                    //UserDefaultに新規登録が完了したことをstatusとして保存
                    //新規登録が完了したことを通知
                    print("success")
                    UserDefaults.standard.set(true, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                }
            }
            else{
                //パスワードが一致しない場合
                self.error = "パスワードが一致しません"
                self.alert.toggle()
            }
        }
        else{
            //項目に空白がある場合
            self.error = "すべての項目を入力してください"
            self.alert.toggle()
        }
        
    }
}
