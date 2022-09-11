//
//  HomeView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/12.
//

import SwiftUI

struct HomeView: View {
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
            IconView(iconName: "person.fill")
            
            Spacer()
            
            HStack {
                IconView(iconName: "magnifyingglass")
                    .padding(.trailing, -20)
                
                IconView(iconName: "qrcode.viewfinder")
            }
        }
    }
}
