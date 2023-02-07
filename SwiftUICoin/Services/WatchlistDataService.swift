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
    private let entityName = "WatchlistEntity"
    
    @Published var savedEntities = [WatchlistEntity]()
    
    init() {
        container = NSPersistentContainer(name: "WatchlistContainer")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading Core Data! \(error)")
            }
            self.getWatchlist()
        }
    }
    
    // MARK: PUBLIC
    
    func isWatchlistEmpty() -> Bool {
        return savedEntities.isEmpty
    }
    
    func isWatchlistExists(coin: CoinModel?, backup: BackupCoinEntity?) -> Bool {
        return savedEntities.first(where: {$0.coinID == coin?.id ?? backup?.id }) != nil
    }
    
    func updateWatchlist(coin: CoinModel?, backup: BackupCoinEntity?) {
        // saveEntities 어레이에 저장된 객체 중에 coinID와 coin.id가 같은 객체가 있다면 그 중 첫번째를 가져와서 저장하고 진행하라. (first(where:)는 조건에 부합하는 첫번재 원소를 가져옵니다.)
        if let id = coin?.id ?? backup?.id {
            if let index = savedEntities.firstIndex(where: { $0.coinID == id }) {
                delete(at: index)
            } else {
                add(coin: coin, backup: backup)
            }
        }
    }
    
    // MARK: PRIVATE
    
    // Read and Update
    private func getWatchlist() {
        // request에 WatchlistEntity 설정
        let request = NSFetchRequest<WatchlistEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Watchlist Entities. \(error)")
        }
    }
    
    // Create
    private func add(coin: CoinModel?, backup: BackupCoinEntity?) {
        // context는 조건, 환경을 의미합니다. 상수로 지정했던 container의 모델을 가져오게 됩니다.
        let entity = WatchlistEntity(context: container.viewContext)
        
        // entity.coinID에 coin.id를 저장하라.
        entity.coinID = coin?.id ?? backup?.id
        
        savedEntities.append(entity)
        
        // Core data에 저장하고 savedEtities 어레이에 업데이트
        saveChanges()
    }
    
    private func delete(at index: Int) {
        let entity = savedEntities[index]
        savedEntities.remove(at: index)
        container.viewContext.delete(entity)
        saveChanges()
    }
    
    private func saveChanges() {
        do {
            try container.viewContext.save() // 지금 상태를 저장하라
        } catch let error {
            print("Error saving Core Data. \(error)")
        }
    }
}
