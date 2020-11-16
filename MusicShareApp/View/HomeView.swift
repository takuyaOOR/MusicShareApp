//
//  HomeView.swift
//  MusicShareApp
//
//  Created by yanasetakuya on 2020/11/15.
//

import SwiftUI

struct HomeView : View {
    
    @State var show = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    var body: some View{
        
        NavigationView{
            
            VStack{
                
                //すでにログインしているかの判定
                //ログインしている場合
                if self.status{
                    HomescreenView()
                }
                else{
                    //ログインしていない場合
                    ZStack{
                        
                        NavigationLink(destination: SignupView(show: self.$show), isActive: self.$show) {
                            Text("")
                        }
                        .hidden()
                        
                        LoginView(show: self.$show)
                    }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                NotificationCenter.default.addObserver(forName: NSNotification.Name("status"),
                                                       object: nil, queue: .main) { (_) in
                    self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
