//
//  mainView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/02/26.
//

import SwiftUI
import UIKit
import MessageUI

public typealias MailViewCallback = ((Result<MFMailComposeResult, Error>) -> Void)?

// MFMailComposeViewController를 SwiftUI 뷰로 표현하기 위한 UIViewControllerRepresentable
public struct MailView: UIViewControllerRepresentable {
    // presentationMode를 사용하기 위한 environment
    @Environment(\.presentationMode) var presentation
    // 메일 내용을 담는 Binding 변수
    @Binding var data: ComposeMailData
    // 메일 전송 후 결과를 전달받기 위한 콜백
    let callback: MailViewCallback
    
    public init(data: Binding<ComposeMailData>,
                callback: MailViewCallback) {
        _data = data
        self.callback = callback
    }
    
    // UIViewControllerRepresentable에 필요한 Coordinator 구현
    public class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        // presentationMode를 사용하기 위한 Binding 변수
        @Binding var presentation: PresentationMode
        // 메일 내용을 담는 Binding 변수
        @Binding var data: ComposeMailData
        // 메일 전송 후 결과를 전달받기 위한 콜백
        let callback: MailViewCallback
        
        public init(presentation: Binding<PresentationMode>,
                    data: Binding<ComposeMailData>,
                    callback: MailViewCallback) {
            _presentation = presentation
            _data = data
            self.callback = callback
        }
        
        public func mailComposeController(_ controller: MFMailComposeViewController,
                                          didFinishWith result: MFMailComposeResult,
                                          error: Error?) {
            if let error = error {
                callback?(.failure(error))
            } else {
                callback?(.success(result))
            }
            $presentation.wrappedValue.dismiss()
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(presentation: presentation, data: $data, callback: callback)
    }
    
    // UIViewControllerRepresentable 프로토콜을 구현하기 위한 메서드
    public func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        // 메일의 제목, 수신자, 본문 등을 설정
        vc.setSubject(data.subject)
        vc.setToRecipients(data.recipients)
        vc.setMessageBody(data.message, isHTML: false)
        vc.accessibilityElementDidLoseFocus()
        return vc
    }
    
    // UIViewControllerRepresentable 프로토콜을 구현하기 위한 메서드
    public func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                       context: UIViewControllerRepresentableContext<MailView>) {
    }
    
    // 메일을 보낼 수 있는 기기인지 확인하는 변수
    public static var canSendMail: Bool {
        MFMailComposeViewController.canSendMail()
    }
}

// 메일 내용을 담는 구조체
public struct ComposeMailData {
    public let subject: String // 제목
    public let recipients: [String]? // 수신자 이메일 주소
    public let message: String // 본문
    
    public init(subject: String,
                recipients: [String]?,
                message: String) {
        self.subject = subject
        self.recipients = recipients
        self.message = message
    }
    
    // 빈 ComposeMailData를 반환하는 변수
    public static let empty = ComposeMailData(subject: "", recipients: nil, message: "")
}


// 메일을 보내는 데모를 위한 테스트용 뷰
struct MailViewTest: View {
    // 메일 내용을 담는 Binding 변수
    @State private var mailData = ComposeMailData(subject: "A subject",
                                                  recipients: ["i.love@swiftuirecipes.com"],
                                                  message: "Here's a message")
    // MailView 표시 여부를 결정하는 변수
    @State private var showMailView = false
    
    var body: some View {
        Button(action: {
            showMailView.toggle()
        }) {
            Text("Send mail")
        }
        // 메일 전송 기능을 지원하는 기기인지 확인 후 버튼 비활성화
        .disabled(!MailView.canSendMail)
        // MailView 표시
        .sheet(isPresented: $showMailView) {
            MailView(data: $mailData) { result in
                print(result)
            }
        }
    }
}

