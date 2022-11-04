//
//  PreviewProvider.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/12.
//  재사용 가능한 프리뷰 익스텐션

import SwiftUI
import Foundation

extension PreviewProvider {
    
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
    
}

class DeveloperPreview {
    static let instance = DeveloperPreview()
    
    private init() { }
    
    let global = GlobalModel(name: "나스닥 100", price: "11,191.63", priceChange: "▾214.27", priceChangePercentage: "-1.88%")
    
    let headline = HeadlineModel(url: "http://www.wowtv.co.kr/NewsCenter/News/Read?articleId=A202210040046&amp;t=NN", title: "'부자아빠' 기요사키, 달러 폭락 예언...비트코인·금·은 매수할 때", date: "17시간 전", author: "한국경제TV", authorImageUrl: "https://search.pstatic.net/common/?src=https%3A%2F%2Fmimgnews.pstatic.net%2Fimage%2Fupload%2Foffice_logo%2F215%2F2018%2F09%2F18%2Flogo_215_18_20180918133718.png&type=f54_54&expire=24&refresh=true")
    
    let nft = NftModel(rank: "1", url: "https://opensea.io/collection/bvdcats", image: "https://i.seadn.io/gae/SdpY8dCNgOWZJI3InTapwx_Day4CgRw1xJK_v1emooqmVAkgzF2rUc-dP9E37oeC9j_diRaa3ZA5yx7urMfO0KnCRNmwAvRtgO5k?w=500&auto=format", name: "BVDCATs", floorPrice: "10 SOL", volume: "7,483 SOL", volumeChangePercentage: "+163%")
    
    let stat = StatisticModel(title: "Rank", value: "No. 1")
    
    let article = ArticleModel(url: "https://www.blockmedia.co.kr/archives/258270", title: "거래소 BTC 입금 수, 2년래 최저", date: "2022년 9월 22일 오후 12:25", author: "Coinness", imageUrl: "https://www.blockmedia.co.kr/wp-content/uploads/2022/10/1-bitcoin-image-2-3.jpg")
    
    let homeVM = HomeViewModel()
    
    let coin = CoinModel(
        id: "bitcoin",
        symbol: "btc",
        name: "Bitcoin",
        image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
        currentPrice: 61408,
        priceChangePercentage24H: 6.87944, marketCap: 1141731099010,
        marketCapRank: 1,
        fullyDilutedValuation: 1285385611303,
        totalVolume: 67190952980,
        high24H: 61712,
        low24H: 56220,
        priceChange24H: 3952.64,
        marketCapChange24H: 72110681879,
        marketCapChangePercentage24H: 6.74171,
        circulatingSupply: 18653043,
        totalSupply: 21000000,
        maxSupply: 21000000,
        ath: 61712,
        athChangePercentage: -0.97589,
        athDate: "2021-03-13T20:49:26.606Z",
        atl: 67.81,
        atlChangePercentage: 90020.24075,
        atlDate: "2013-07-06T00:00:00.000Z",
        lastUpdated: "2021-03-13T23:18:10.268Z",
        priceChangePercentage24HInCurrency: 3952.64)
}
