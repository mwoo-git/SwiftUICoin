//
//  FirstResponderTextField.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/02/26.
//

import SwiftUI

struct FirstResponderTextField: UIViewRepresentable {
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        @Binding var searchText: String
        @Binding var didReturn: Bool
        @Binding var isFocus: Bool
        var becameFirstResponder = false
        
        init(searchText: Binding<String>, didReturn: Binding<Bool>, isFocus: Binding<Bool>) {
            self._searchText = searchText
            self._didReturn = didReturn
            self._isFocus = isFocus
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            searchText = textField.text ?? ""
            textField.text = String(searchText.prefix(15)) // 글자 수 제한
        }
        
        // 리턴키를 누르면 포커스 해제됩니다.
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            didReturn.toggle()
            textField.resignFirstResponder()
            return true
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            isFocus = true
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            isFocus = false
        }
    }
    
    @Binding var searchText: String
    @Binding var didReturn: Bool
    @Binding var isFocus: Bool
    let placeHolder: String
    
    func makeUIView(context: Context) -> some UIView {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.placeholder = placeHolder
        textField.autocorrectionType = .no // 자동완성 기능 비활성화
        return textField
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(searchText: $searchText, didReturn: $didReturn, isFocus: $isFocus)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if !context.coordinator.becameFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.becameFirstResponder = true
        }
    }
}
