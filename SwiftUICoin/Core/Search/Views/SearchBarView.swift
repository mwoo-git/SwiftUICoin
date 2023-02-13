//
//  SearchBarView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/14.
//  TextField First Responder

import SwiftUI
import Combine

struct SearchBarView: View {
    
    @Binding var searchText: String
    @Binding var didReturn: Bool
    @State private var clearTextField = false
    
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: "magnifyingglass")
                .padding(.vertical, -5)
                .padding(.horizontal, 7)
                .foregroundColor(Color.theme.iconColor)
                .font(.subheadline)
            if !clearTextField {
                firstResponderTextField
            } else {
                firstResponderTextField
            }
        }
        .background(Color.theme.searchBar)
        .cornerRadius(8)
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchBarView(searchText: .constant(""), didReturn: .constant(false))
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
            SearchBarView(searchText: .constant(""), didReturn: .constant(false))
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
        }
    }
}

extension SearchBarView {
    private var normalTextField: some View {
        TextField("검색", text: $searchText)
            .foregroundColor(Color.white)
            .accentColor(Color.theme.binanceColor)
            .frame(height: 30)
            .overlay(
                Image(systemName: "xmark.circle.fill")
                    .padding()
                    .foregroundColor(Color.theme.iconColor)
            )
    }
    
    private var firstResponderTextField: some View {
        FirstResponderTextField(searchText: $searchText, didReturn: $didReturn, placeHolder: "검색")
            .foregroundColor(Color.white)
            .accentColor(Color.theme.iconColor)
            .frame(height: 30)
            .overlay(
                Image(systemName: "xmark.circle.fill")
                    .padding()
                    .foregroundColor(Color.theme.iconColor)
                    .offset(x: 10)
                    .opacity(searchText.isEmpty ? 0.0 : 0.5)
                    .onTapGesture {
                        searchText = ""
                        clearTextField.toggle()
                    }
                , alignment: .trailing
            )
    }
}

struct FirstResponderTextField: UIViewRepresentable {
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        @Binding var searchText: String
        @Binding var didReturn: Bool
        var becameFirstResponder = false
        
        init(searchText: Binding<String>, didReturn: Binding<Bool>) {
            self._searchText = searchText
            self._didReturn = didReturn
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
    }
    
    @Binding var searchText: String
    @Binding var didReturn: Bool
    let placeHolder: String
    
    func makeUIView(context: Context) -> some UIView {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.placeholder = placeHolder
        return textField
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(searchText: $searchText, didReturn: $didReturn)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if !context.coordinator.becameFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.becameFirstResponder = true
        }
    }
}
