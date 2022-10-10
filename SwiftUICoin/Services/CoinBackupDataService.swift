//
//  CoinBackupDataService.swift
//  SwiftUICoin
//
//  Created by Woo Min on 2022/10/10.
//

import Foundation
import CoreData

class CoinBackupDataService {
    
    @Published var backupCoins: [BackupCoinEntity] = []
    
    private let container: NSPersistentContainer
    private let containerName: String = "BackupCoinContainer"
    private let entityName: String = "BackupCoinEntity"
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading Core Data! \(error)")
            }
            self.getBackup()
        }
    }
    
    func updateBackup(coins: [CoinModel]) {
        if backupCoins.isEmpty {
            add(coins: coins)
        } else {
            delete()
            add(coins: coins)
        }
    }
    
    private func add(coins: [CoinModel]) {
        coins.forEach { (data) in
            let entity = BackupCoinEntity(context: container.viewContext)
            entity.id = data.id
            entity.symbol = data.symbol
            entity.name = data.name
            entity.image = data.image
            entity.rank = data.marketCapRank ?? 0
        }
        applyChanges()
    }
    
    // coinBackup 배열에 저장
    private func getBackup() {
        let request = NSFetchRequest<BackupCoinEntity>(entityName: entityName)
        do {
            backupCoins = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Watchlist Entities. \(error)")
        }
    }
    
    // Save
    private func save() {
        do {
            try container.viewContext.save()
            print("Success saving to Cora Data.")
        } catch let error {
            print("Error saving to Core Data. \(error)")
        }
    }
    
    // 변경 적용
    private func applyChanges() {
        save() // CoreData Entity에 저장하고
        getBackup() // 저장된(변경된) 모든 객체를 가져와서 savedEtities 어레이에 업데이트하라
    }
    
    // Delete
    private func delete() {
        backupCoins.forEach { (coin) in
            container.viewContext.delete(coin)
        }
        applyChanges()
    }
}
