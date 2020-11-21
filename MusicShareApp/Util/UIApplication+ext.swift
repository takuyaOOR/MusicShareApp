//
//  UIApplication+ext.swift
//  MusicShareApp
//
//  Created by yanasetakuya on 2020/11/20.
//

import Foundation
import UIKit

//キーボードを閉じる拡張機能
extension UIApplication {
    func closeKeyboard() {
        sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
