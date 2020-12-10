//
//  CustomTabsView.swift
//  MusicShareApp
//
//  Created by yanasetakuya on 2020/11/17.
//

import SwiftUI

struct CustomTabsView: View {
    
    @Binding var index: Int
    
    var body: some View {
        HStack {
            
            //ホームタブ
            Button(action: {
                self.index = 0
            }) {
                Image(systemName: "house.circle")
                    .resizable()
                    .frame(width: 30, height: 30, alignment: .center)
            }
            .foregroundColor(Color("Color1").opacity(self.index == 0 ? 1 : 0.3))
            
            
            Spacer(minLength: 0)
            //検索タブ
            Button(action: {
                self.index = 1
            }) {
                Image(systemName: "magnifyingglass.circle")
                    .resizable()
                    .frame(width: 30, height: 30, alignment: .center)
            }
            .foregroundColor(Color("Color1").opacity(self.index == 1 ? 1 : 0.3))
            
            Spacer(minLength: 0)
            
            //追加ボタン
            Button(action: {
                self.index = 2
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30, alignment: .center)
            }
            .foregroundColor(Color("Color3").opacity(self.index == 2 ? 1 : 0.3))
            
            Spacer(minLength: 0)
            
            //お気に入りタブ
            Button(action: {
                self.index = 3
            }) {
                Image(systemName: "heart.circle")
                    .resizable()
                    .frame(width: 30, height: 30, alignment: .center)
            }
            .foregroundColor(Color("Color1").opacity(self.index == 3 ? 1 : 0.3))
            
            Spacer(minLength: 0)
            
            //個人設定タブ
            Button(action: {
                self.index = 4
            }) {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 30, height: 30, alignment: .center)
            }
            .foregroundColor(Color("Color1").opacity(self.index == 4 ? 1 : 0.3))
            
        }
        .padding(.horizontal, 35)
        .padding(.top, 10)
        .background(Color.white)
    }
}


