//
//  HeadlineView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/05.
//

import SwiftUI

struct HeadlineView: View {
    
    @StateObject private var viewModel = HeadlineViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            
            header
            category
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.articles) { article in
                        HeadlineRowView(headline: article)
                    }
                }
                .padding(.top)
            }
            Spacer()
        }
        .background(Color.theme.background.ignoresSafeArea())
    }
}

struct HeadlineView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HeadlineView()
                .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
        .environmentObject(dev.homeVM)
    }
}

extension HeadlineView {
    private var header: some View {
        HStack {
            Text("헤드라인")
                .font(.title2)
                .bold()
                .padding(.leading)
            Spacer()
            HStack(spacing: 0) {
                NavigationLink(
                    destination: SearchView()) {
                        IconView(iconName: "magnifyingglass")
                    }
                IconView(iconName:"person.circle")
            }
        }
    }
    
    private var category: some View {
        HStack {
            VStack {
                Text("비트코인")
                    .foregroundColor(Color.theme.textColor)
                Capsule()
                    .fill(Color.theme.textColor)
                    .frame(width: 30, height: 2)
            }
            Spacer()
        }
        .font(.headline)
        .padding(.horizontal)
        .padding(.top)
    }
}
