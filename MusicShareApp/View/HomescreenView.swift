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
                    Color.red
                } else if self.index == 1 {
                    Color.blue
                } else if self.index == 2 {
                    Color.green
                } else{
                    Color.yellow
                    AccountView()
                }
                
            }
            .padding(.bottom, -35)
            
            CustomTabsView(index: self.$index)
            
        }
        
    }
}
