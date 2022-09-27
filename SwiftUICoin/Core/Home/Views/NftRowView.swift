//
//  NftRowView.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/25.
//

import SwiftUI
import Kingfisher

struct NftRowView: View {
    
    let nft: NftModel
    
    var body: some View {
        HStack {
            KFImage(URL(string: nft.image))
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .cornerRadius(10)
            VStack(alignment: .leading) {
                Text(nft.name)
                Text("Floor price: \(nft.floorPrice)")
                    .foregroundColor(Color.theme.accent)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(nft.volume)
                Text(nft.volumeChangePercentage)
                    .foregroundColor(Color.theme.green)
            }
        }
        .font(.headline)
        .padding()
    }
}

struct NftRowView_Previews: PreviewProvider {
    static var previews: some View {
        NftRowView(nft: dev.nft)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
