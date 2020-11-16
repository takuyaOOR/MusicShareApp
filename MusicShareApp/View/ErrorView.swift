//
//  ErrorView.swift
//  MusicShareApp
//
//  Created by yanasetakuya on 2020/11/15.
//

import SwiftUI

struct ErrorView : View {
    
    @State var color = Color.black.opacity(0.7)
    @Binding var alert : Bool
    @Binding var error : String
    
    var body: some View{
        
        GeometryReader{_ in
            
            Spacer()
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    VStack{
                                
                        HStack{
                            
                            Text(self.error == "RESET" ? "Message" : "Error")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(self.color)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 25)
                        
                        Text(self.error == "RESET" ? "パスワード再設定用のリンクを送信しました" : self.error)
                        .foregroundColor(self.color)
                        .padding(.top)
                        .padding(.horizontal, 25)
                        
                        Button(action: {
                            
                            self.alert.toggle()
                            
                        }) {
                            
                            Text(self.error == "RESET" ? "Ok" : "Cancel")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 120)
                        }
                        .background(Color("Color3"))
                        .cornerRadius(10)
                        .padding(.top, 25)
                        
                        
                    }
                    .padding(.vertical, 25)
                    .frame(width: UIScreen.main.bounds.width - 70)
                    .background(Color.white)
                    .cornerRadius(15)
                    
                    Spacer()
                }
                
                Spacer()
            }
            
            Spacer()
            
        }
        .background(Color.black.opacity(0.35).edgesIgnoringSafeArea(.all))
        
    }
}


