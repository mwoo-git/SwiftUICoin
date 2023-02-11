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
    @State private var isEditing = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            topHeader
            description
            Text("뉴스 순서")
                .bold()
                .padding(.leading)
                .padding(.vertical, 5)
                .font(.footnote)
            categoryList
        }
        .background(Color.theme.background.ignoresSafeArea())
        .navigationBarHidden(true)
        .onDisappear {
            self.didChange.toggle()
            print(didChange)
        }
        .onAppear {
            UITableView.appearance().separatorColor = UIColor(Color.theme.background)
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
                Text("뉴스 키워드")
                    .bold()
                Spacer()
            }
            Spacer()
        }
        .overlay(
            BackButtonView()
            , alignment: .leading
        )
        .overlay(
            Button(action: {
                withAnimation { self.isEditing.toggle() }
            }) { Text(isEditing ? "저장" : "편집") }
                .padding(.trailing)
                .foregroundColor(Color.theme.textColor)
            , alignment: .trailing
        )
        .background(Color.theme.background.ignoresSafeArea())
        .frame(width: UIScreen.main.bounds.width)
        .padding(.vertical)
    }
    
    var description: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("아래의 순서로 뉴스 화면에 표시됩니다.")
            Text("순서를 원하는대로 바꿔보세요! 🎨☺️")
                .bold()
        }
        .font(.title3)
        .foregroundColor(Color.theme.textColor)
        .padding()
    }
    
    var categoryList: some View {
        List {
            ForEach(categories, id: \.self) { item in
                HStack {
                    Text(item)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.theme.textColor)
                        .padding()
                    Spacer()
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                )
            }
            .onMove(perform: move)
            .onDelete(perform: delete)
            .listRowBackground(Color.theme.background)
        }
        .listStyle(.plain)
        .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive))

    }
}
