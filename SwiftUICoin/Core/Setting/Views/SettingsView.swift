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
    @Environment(\.openURL) var openURL
    var email = SupportEmailModel(toAddress: "hanulbom@gmail.com", subject: "문의하기", body: "의견을 보내주시면 더 나은 서비스 개발에 활용됩니다.")
    
    var body: some View {
        VStack(spacing: 0) {
            settingHeader
            settingList
            Spacer()
        }
        .background(Color.theme.background.ignoresSafeArea())
        .navigationBarHidden(true)
        .environment(\.colorScheme, viewModel.isDark ? .dark : .light)
        .onAppear {
            if isDarkMode {
                viewModel.isDark = true
            } else {
                viewModel.isDark = false
            }
        }
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
            IconView(iconName: "chevron.left")
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                    if viewModel.isDark {
                        isDarkMode = true
                    } else {
                        isDarkMode = false
                    }
                }
                .contentShape(Rectangle())
            Spacer()
            Text("더보기")
                .font(.headline)
            Spacer()
            Button {
                viewModel.isDark.toggle()
            } label: {
                IconView(iconName: viewModel.isDark ? "moon.fill" : "sun.min.fill")
            }
        }
    }
    
    var chevron_right: some View {
        Image(systemName: "chevron.right")
            .foregroundColor(Color.theme.accent)
            .font(.subheadline)
    }
    
    var settingList: some View {
        Group {
            HStack {
                HStack(spacing: 10) {
                    Image(systemName: "speaker.wave.1")
                        .frame(width: 30, height: 30)
                        .font(.title3)
                    Text("공지사항")
                        .foregroundColor(Color.theme.textColor)
                }
                Spacer()
                chevron_right
            }
            .padding()
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
            .onTapGesture {
                email.send(openURL: openURL)
            }
            .padding()
            HStack {
                HStack(spacing: 10) {
                    Image(systemName: "v.circle")
                        .frame(width: 30, height: 30)
                    Text("버전 정보")
                        .foregroundColor(Color.theme.textColor)
                }
                Spacer()
                chevron_right
            }
            .padding()
        }
    }
}
