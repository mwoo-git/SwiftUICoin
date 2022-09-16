//
//  SearchBarView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/14.
//  TextField First Responder

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    @Binding var showSearchView: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            IconView(iconName: "magnifyingglass")
                .padding(.vertical, -10)
                .padding(.horizontal, -5)
            
            if !showSearchView {
                normalTextField
            } else {
                firstResponderTextField
            }
        }
        .background(Color.theme.searchBar)
        .cornerRadius(25)
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchBarView(searchText: .constant(""), showSearchView: .constant(true))
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
            SearchBarView(searchText: .constant(""), showSearchView: .constant(true))
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
        }
    }
}

extension SearchBarView {
    private var normalTextField: some View {
        TextField("Search", text: $searchText)
            .foregroundColor(Color.white)
            .accentColor(Color.theme.binanceColor)
            .frame(height: 30)
    }
    
    private var firstResponderTextField: some View {
        FirstResponderTextField(searchText: $searchText, placeHolder: "Search")
            .foregroundColor(Color.white)
            .accentColor(Color.theme.binanceColor)
            .frame(height: 30)
            .overlay(
                Image(systemName: "xmark.circle.fill")
                    .padding()
                    .foregroundColor(Color.theme.iconColor)
                    .offset(x: 10)
                    .opacity(searchText.isEmpty ? 0.0 : 0.5)
                    .onTapGesture {
                        searchText = ""
                    }
                , alignment: .trailing
            )
    }
}

struct FirstResponderTextField: UIViewRepresentable {
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        @Binding var searchText: String
        var becameFirstResponder = false
        
        init(searchText: Binding<String>) {
            self._searchText = searchText
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            searchText = textField.text ?? ""
        }
        
        // 리턴키를 누르면 포커스 해제됩니다.
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }
    
    @Binding var searchText: String
    let placeHolder: String
    
    func makeUIView(context: Context) -> some UIView {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.placeholder = placeHolder
        return textField
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(searchText: $searchText)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        if !context.coordinator.becameFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.becameFirstResponder = true
        }
    }
}
