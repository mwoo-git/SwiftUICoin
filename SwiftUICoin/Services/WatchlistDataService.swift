//
//  WatchlistDataService.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/09/27.
//

import Foundation
import CoreData

class WatchlistDataService {
    private let container: NSPersistentContainer
    private let containerName: String = "WatchlistContainer"
    private let entityName: String = "WatchlistEntity"
    
    @Published var savedEntities: [WatchlistEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName) // 컨테이너 초기화, 생성
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading Core Data! \(error)")
            }
            self.getWatchlist()
        }
    }
    
    // MARK: PUBLIC
    
    func isWatchlistEmpty() -> Bool {
        if savedEntities.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func isWatchlistExists(coin: CoinModel?, backup: BackupCoinEntity?) -> Bool {
        if savedEntities.first(where: {$0.coinID == coin?.id ?? backup?.id }) != nil {
            return true
        } else {
            return false
        }
    }
    
    func updateWatchlist(coin: CoinModel?, backup: BackupCoinEntity?) {
        // saveEntities 어레이에 저장된 객체 중에 coinID와 coin.id가 같은 객체가 있다면 그 중 첫번째를 가져와서 저장하고 진행하라. (first(where:)는 조건에 부합하는 첫번재 원소를 가져옵니다.)
        if coin == nil {
            if let entity = savedEntities.first(where: {$0.coinID == backup?.id }) {
                delete(entity: entity)
            } else {
                add(coin: nil, backup: backup)
            }
        } else {
            if let entity = savedEntities.first(where: {$0.coinID == coin?.id }) {
                delete(entity: entity)
            } else {
                add(coin: coin, backup: nil)
            }
        }
        
    }
    
    // MARK: PRIVATE
    
    // Read and Update
    private func getWatchlist() {
        let request = NSFetchRequest<WatchlistEntity>(entityName: entityName) // request에 WatchlistEntity 설정
        do {
            savedEntities = try container.viewContext.fetch(request) // WatchlistEntity 안의 객체를 모두 가져와서 savedEtities 어레이에 저장하라
            // viewContext는 컨테이너 안의 내용을 관리해주는 프로퍼티입니다. fetch는 모든 객체를 가져오게 됩니다.
        } catch let error {
            print("Error fetching Watchlist Entities. \(error)")
        }
    }
    
    // Create
    private func add(coin: CoinModel?, backup: BackupCoinEntity?) {
        if coin == nil {
            let entity = WatchlistEntity(context: container.viewContext) // context는 조건, 환경을 의미합니다. 상수로 지정했던 container의 모델을 가져오게 됩니다.
            entity.coinID = backup?.id
        } else {
            let entity = WatchlistEntity(context: container.viewContext) // context는 조건, 환경을 의미합니다. 상수로 지정했던 container의 모델을 가져오게 됩니다.
            entity.coinID = coin?.id
        }
        // entity.coinID에 coin.id를 저장하라.
        applyChanges() // Core data에 저장하고 savedEtities 어레이에 업데이트
    }
    
    // Save
    private func save() {
        do {
            try container.viewContext.save() // 지금 상태를 저장하라
        } catch let error {
            print("Error saving to Core Data. \(error)")
        }
    }
    
    // 변경 적용
    private func applyChanges() {
        save() // CoreData Entity에 저장하고
        getWatchlist() // 저장된(변경된) 모든 객체를 가져와서 savedEtities 어레이에 업데이트하라
    }
    
    // Delete
    private func delete(entity: WatchlistEntity) {
        container.viewContext.delete(entity) // 전달된 entity를 삭제하라
        applyChanges()
    }
}
