//
//  HomescreenView.swift
//  MusicShareApp
//
//  Created by yanasetakuya on 2020/11/15.
//

import SwiftUI
import Firebase

struct HomescreenView : View {
    
    @State var index = 0
    
    var body: some View{
        
        VStack(spacing: 0){
            
            ZStack {
                //タブ切り替え
                if self.index == 0 {
                    Text("Home")
                    Color("Color1").opacity(0.35)
                } else if self.index == 1 {
                    Text("Search")
                    Color("Color1").opacity(0.35)
                } else if self.index == 2 {
                    Text("Favorite")
                    Color("Color1").opacity(0.35)
                } else{
                    Color("Color1").opacity(0.35)
                    AccountView()
                }
                
            }
            .padding(.bottom, -35)
            
            CustomTabsView(index: self.$index)
            
        }
        
    }
}
