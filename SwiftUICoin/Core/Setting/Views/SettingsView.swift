//
//  SettingView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/23.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var isDark: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            settingHeader
            HStack {
                HStack(spacing: 10) {
                    Image(systemName: "mail")
                    Text("개발자에게 연락하기")
                        .foregroundColor(Color.theme.textColor)
                }
                
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color.theme.accent)
            }
            .padding()
            Spacer()
        }
        .background(Color.theme.background.ignoresSafeArea())
        .navigationBarHidden(true)
        .environment(\.colorScheme, isDark ? .dark : .light)
        .onAppear {
            if isDarkMode {
                isDark = true
            } else {
                isDark = false
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

extension SettingsView {
    private var settingHeader: some View {
        HStack {
            IconView(iconName: "chevron.left")
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                    if isDark {
                        isDarkMode = true
                    } else {
                        isDarkMode = false
                    }
                }
            Spacer()
            Text("더보기")
                .font(.headline)
            Spacer()
            Button {
                isDark.toggle()
            } label: {
                IconView(iconName: isDark ? "moon.fill" : "sun.min.fill")
            }

            
        }
    }
}
