//
//  SettingView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/23.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @EnvironmentObject var viewModel: HomeViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showMailView = false
    @State private var mailData = ComposeMailData(subject: "문의하기", recipients: ["blockwide.ios@gmail.com"], message: "의견을 보내주시면 더 나은 서비스 개발에 활용됩니다.")
    
    var body: some View {
        VStack(spacing: 0) {
            settingHeader
            settingList
            Spacer()
        }
        .background(Color.theme.background.ignoresSafeArea())
        .navigationBarHidden(true)
        .environment(\.colorScheme, .dark)
//        .onAppear {
//            if isDarkMode {
//                viewModel.isDark = true
//            } else {
//                viewModel.isDark = false
//            }
//        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

private extension SettingsView {
    var settingHeader: some View {
        HStack {
            Spacer()
            Text("더보기")
                .font(.subheadline)
                .bold()
            Spacer()
        }
        .overlay(
            BackButtonView()
                .contentShape(Rectangle())
            , alignment: .leading
        )
        .padding(.vertical)
    }
    
    var chevron_right: some View {
        Image(systemName: "chevron.right")
            .foregroundColor(Color.theme.accent)
            .font(.subheadline)
    }
    
    var settingList: some View {
        Group {
            Button {
                showMailView.toggle()
            } label: {
                HStack {
                    HStack(spacing: 10) {
                        Image(systemName: "mail")
                            .frame(width: 30, height: 30)
                        Text("문의하기")
                            .foregroundColor(Color.theme.textColor)
                    }
                    Spacer()
                    chevron_right
                }
                .contentShape(Rectangle())
                .padding()
                
            }
            .buttonStyle(ListSelectionStyle())
            .sheet(isPresented: $showMailView) {
                MailView(data: $mailData) { result in
                    print(result)
                }
            }
            .disabled(!MailView.canSendMail)
        }
    }
}
