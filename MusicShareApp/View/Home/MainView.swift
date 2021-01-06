//
//  MainView.swift
//  MusicShareApp
//
//  Created by yanasetakuya on 2020/12/28.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        
        VStack() {
            
            Image("appName")
                .resizable()
                .frame(width: 250, height: 55)
                .scaledToFit()
                .padding(.top)
            
            Spacer()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
