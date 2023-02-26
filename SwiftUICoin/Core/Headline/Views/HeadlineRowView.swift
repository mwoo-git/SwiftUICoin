//
//  HeadlineRowView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/05.
//

import SwiftUI
import Kingfisher

struct HeadlineRowView: View {
    
    let headline: HeadlineModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(headline.title)
                .font(.title3)
                .lineLimit(2)
                .foregroundColor(Color.theme.textColor)
                .multilineTextAlignment(.leading)
            Spacer()
            HStack(spacing: 5) {
                Text(headline.cleanAuthor)
                    .font(.footnote)
                Text("·")
                Text(headline.cleanDate)
                    .font(.footnote)
                Spacer()
            }
            .overlay(
                MenuButtonView(url: headline.url, author: headline.cleanAuthor, title: headline.title)
                    .offset(x: 13)
                , alignment: .trailing
            )
        }
        .contentShape(Rectangle())
        .padding()
        .frame(height: 110)
        .foregroundColor(Color.theme.accent)
    }
}

struct HeadlineRowView_Previews: PreviewProvider {
    static var previews: some View {
        HeadlineRowView(headline: dev.headline)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}

struct MenuButtonView: View {
    
    @State private var isShareSheetShowing = false
    @Environment(\.presentationMode) var presentationMode
    
    let url: String
    let author: String
    let title: String
    
    @State private var showMailView = false
    @State private var mailData = ComposeMailData(subject: "", recipients: nil, message: "")
    
    var body: some View {
        Menu {
            Button(action: share) {
                HStack {
                    Text("공유")
                    Image(systemName: "square.and.arrow.up")
                }
            }
            
            Button(action: {
                mailData = ComposeMailData(subject: "뉴스 문제 신고", recipients: ["blockwide.ios@gmail.com"], message: """
                [\(author)] \(title)
                """)
                showMailView.toggle()
            }) {
                HStack {
                    Text("문제 신고")
                    Image(systemName: "exclamationmark.bubble")
                }
            }
            
        } label:{
            Image(systemName: "ellipsis")
                .padding()
                .contentShape(Rectangle())
                .foregroundColor(Color.theme.accent)
        }
        .buttonStyle(ListSelectionStyle())
        .sheet(isPresented: $showMailView) {
            MailView(data: $mailData) { result in
                print(result)
            }
        }
        .disabled(!MailView.canSendMail)
    }
    
    func share() {
        isShareSheetShowing.toggle()
        
        let url = URL(string: url)
        let av = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
        
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
}
