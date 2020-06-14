//
//  SettingView.swift
//  Hikizan
//
//  Created by masamichi on 2020/06/14.
//  Copyright © 2020 Masamichi Ueta. All rights reserved.
//

import SwiftUI

struct SettingView: View {

    @ObservedObject var setting: Setting

    var body: some View {
        let maxMinuendProxy = Binding<String>(
            get: { "\(self.setting.maxMinuend)" },
            set: {
                if let value = NumberFormatter().number(from: $0) {
                    self.setting.maxMinuend = value.uintValue
                }
        }
        )

        return VStack(alignment: .leading, spacing: 12) {
            Text("せってい")
                .font(.system(size: 32))
            Text("なにひくまでできる？")
                .font(.system(size: 24))
            TextField("", text: maxMinuendProxy)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.system(size: 60))
                .keyboardType(.numberPad)
            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(setting: Setting())
    }
}
