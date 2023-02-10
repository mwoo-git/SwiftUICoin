//
//  HeadlineEditView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2023/02/05.
//

import SwiftUI

struct HeadlineEditView: View {
    
    @AppStorage("categories") private var categories = ["비트코인", "이더리움", "증시", "연준", "금리", "환율", "NFT", "메타버스"]
    @Binding var didChange: Bool
    @State private var newItem = ""
    @State private var isEditing = false
    
    var body: some View {
        VStack(spacing: 0) {
            topHeader
            List {
                HStack {
                    TextField("새 항목 추가", text: $newItem)
                        .font(.title3)
                        .foregroundColor(Color.theme.textColor)
                    Button(action: {
                        self.categories.append(self.newItem)
                        self.newItem = ""
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundColor(.theme.background)
                    })
                }
                .padding(.horizontal)
                
                ForEach(categories, id: \.self) { item in
                    Text(item)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color.theme.textColor)
                }
                .onMove(perform: move)
                .onDelete(perform: delete)
            }
            .environment(\.editMode, .constant(isEditing ? .active : .inactive))
        }
        .background(Color.theme.background.ignoresSafeArea())
        .navigationBarHidden(true)
        .onAppear {
            self.isEditing = true
        }
        .onDisappear {
            self.isEditing = false
            self.didChange.toggle()
            print(didChange)
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        categories.move(fromOffsets: source, toOffset: destination)
    }
    
    func delete(at offsets: IndexSet) {
        categories.remove(atOffsets: offsets)
    }
}

struct HeadlineEditView_Previews: PreviewProvider {
    static var previews: some View {
        HeadlineEditView(didChange: .constant(false))
    }
}

private extension HeadlineEditView {
    
    var topHeader: some View {
        HStack(spacing: 0) {
            HStack {
                Spacer()
                Text("키워드 편집")
                    .bold()
                Spacer()
            }
            Spacer()
        }
        .overlay(
            BackButtonView()
            , alignment: .leading
        )
        .background(Color.theme.background.ignoresSafeArea())
        .frame(width: UIScreen.main.bounds.width)
        .padding(.vertical)
    }
}
