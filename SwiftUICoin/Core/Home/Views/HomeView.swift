//
//  HomeView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/12.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showSidebar: Bool = false
    
    var body: some View {
        ZStack {
            // Background layer
            Color.theme.background
                .ignoresSafeArea()
            
            // content layer
            VStack {
                homeHeader
                
                Spacer(minLength: 0)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .navigationBarHidden(true)
        }
        .preferredColorScheme(.dark)
    }
}

extension HomeView {
    private var homeHeader: some View {
        HStack {
            IconView(iconName: showSidebar ? "arrow.left" : "person.fill")
                .onTapGesture {
                    showSidebar.toggle()
                }
            
            Spacer()
            
            if showSidebar == false {
                HStack {
                    IconView(iconName: "magnifyingglass")
                        .padding(.trailing, -20)
                    
                    IconView(iconName: "qrcode.viewfinder")
                }
            } else {
                IconView(iconName: "sun.min.fill")
                    .padding(.trailing, 18)
            }
        }
    }
}
