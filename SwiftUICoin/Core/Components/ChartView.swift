////
////  ChartView.swift
////  SwiftUICoin
////
////  Created by Woo Min on 2022/09/22.
////  라인 차트를 보여주는 뷰입니다. 사용 하지 않는 뷰
//
//import SwiftUI
//
//struct ChartView: View {
//
//    let data: [Double]
//    let maxY: Double
//    let minY: Double
//    let lineColor: Color
//
//    init(coin: CoinModel) {
//        data = coin.sparklineIn7D?.price ?? []
//        maxY = data.max() ?? 0
//        minY = data.min() ?? 0
//
//        let priceChange = (data.last ?? 0) - (data.first ?? 0)
//        lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
//    }
//
//    var body: some View {
//        GeometryReader { geometry in
//            Path { path in
//                for index in data.indices {
//                    let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
//
//                    let yAxis = maxY - minY
//
//                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
//
//                    if index == 0 {
//                        path.move(to: CGPoint(x: xPosition, y: yPosition))
//                    }
//                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
//                }
//            }
//            .trim(from: 0, to: 1)
//            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
//        }
//    }
//}
//
//struct ChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChartView(coin: dev.coin)
//    }
//}
