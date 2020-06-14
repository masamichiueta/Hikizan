//
//  ContentView.swift
//  Hikizan
//
//  Created by masamichi on 2020/06/14.
//  Copyright © 2020 Masamichi Ueta. All rights reserved.
//

import SwiftUI
import Combine

class Setting: ObservableObject {
    @Published var maxMinuend: UInt = 20
}

struct ContentView: View {
    struct AlertItem: Identifiable {
        var id = UUID()
        var title: Text
        var message: Text?
        var dismissButton: Alert.Button?
    }

    @ObservedObject var setting: Setting = Setting()
    @State private var minuend: UInt = 0
    @State private var subtrahend: UInt = 0
    @State private var difference: String = ""

    @State private var alertItem: AlertItem?

    @State private var numberOfQuiz: UInt = 0
    @State private var numberOfAns: UInt = 0
    @State private var numberOfOk: UInt = 0

    @State private var isSettingPresented: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 12) {
                Text("だい\(numberOfQuiz)もん")
                    .font(.system(size: 24))
                HStack {
                    Text("\(minuend)")
                    Text("-")
                    Text("\(subtrahend)")
                    Text("=")
                }.font(.system(size: 60))
                TextField("こたえ", text: $difference)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.system(size: 60))
                    .keyboardType(.numberPad)
                VStack(spacing: 12) {
                    Button("ファイナルアンサー", action: {
                        guard let dif = UInt(self.difference) else {
                            self.alertItem = AlertItem(title: Text("数字を入れてね"))
                            return
                        }
                        self.numberOfAns += 1
                        if dif == (self.minuend - self.subtrahend) {
                            self.alertItem = AlertItem(
                                title: Text("せいかい！"),
                                dismissButton: Alert.Button.default(
                                    Text("つぎのもんだい"), action: {
                                        self.makeFormula(isUpdateNumOfQuiz: true)
                                        self.alertItem = nil
                                        self.difference = ""
                                }))
                            self.numberOfOk += 1
                        } else {
                            // Show NG
                            self.alertItem = AlertItem(
                                title: Text("ざんねん..."),
                                dismissButton: Alert.Button.default(
                                    Text("もういっかい！"), action: {
                                        self.difference = ""
                                        self.alertItem = nil
                                }))
                        }

                    }).frame(maxWidth: .infinity)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color.blue, lineWidth: 1)
                    )
                    Button("つぎのもんだい", action: {
                        self.makeFormula(isUpdateNumOfQuiz: false)
                        self.difference = ""
                    }).frame(maxWidth: .infinity)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color.blue, lineWidth: 1)
                    )
                }
                Spacer()
            }
            .padding()
            .navigationBarTitle(Text("ひきざん"), displayMode: .inline)
            .navigationBarItems(
                leading: Button("せってい", action: {
                    self.isSettingPresented = true
                }),
                trailing:
                Button("せいせき") {
                    let rate = Double(self.numberOfOk) / Double(self.numberOfAns)

                    let message: String

                    if rate > 0.8 {
                        message = "よくがんばりました！"
                    } else if rate > 0.5 {
                        message = "あとすこし！"
                    } else {
                        message = "つぎはがんばろう！"
                    }

                    let text = "もんだいのかず \(self.numberOfQuiz)\nこたえのかず \(self.numberOfAns)\nせいかいのかず\n\(self.numberOfOk)\n\(message)"
                    self.alertItem = AlertItem(title: Text(text))
                }
            )
        }
        .onAppear {
            self.makeFormula(isUpdateNumOfQuiz: true)
        }.alert(item: self.$alertItem) { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }.sheet(isPresented: $isSettingPresented) {
            SettingView(setting: self.setting)
        }
    }

    func makeFormula(isUpdateNumOfQuiz: Bool) {
        minuend = UInt.random(in: 1...setting.maxMinuend)
        subtrahend = UInt.random(in: 1...minuend)

        if isUpdateNumOfQuiz {
            numberOfQuiz += 1
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

