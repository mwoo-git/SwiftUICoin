//
//  NftDetailView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/25.
//

import SwiftUI
import Kingfisher

struct NftDetailView: View {
    
    let nft: NftModel
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    IconView(iconName: "chevron.backward")
                    Text(nft.name)
                        .font(.headline)
                    Spacer()
                    IconView(iconName: "square.and.arrow.up")
                }
                KFImage(URL(string: nft.image))
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                HStack {
                    VStack(alignment: .leading) {
                        Text(nft.name)
                            .font(.headline)
                        Text("Floor price: \(nft.floorPrice)")
                            .font(.headline)
                    }
                    Spacer()
                    IconView(iconName: "bookmark")
                }
                .padding(.leading)
                Link(destination: URL(string: nft.url)!) {
                    Text("웹사이트에서 보기")
                        .frame(width: UIScreen.main.bounds.width / 1.1, height: 40)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
            }
        }
    }
}

struct NftDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NftDetailView(nft: dev.nft)
            .preferredColorScheme(.dark)
    }
}
