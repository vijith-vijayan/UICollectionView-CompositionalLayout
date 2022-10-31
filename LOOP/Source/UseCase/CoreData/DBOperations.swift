//
//  Created by Vijith TV on 27/10/22.
//

import Foundation
import Combine

class DBOperations {
    
    static let shared = DBOperations()
    
    private init () {}
    
    private var bag: [AnyCancellable] = []
    private var dbManager: DBManager = DBManager<MoviesEntity>()
    
    func fecthBookmarkFromDB(with predicate: NSPredicate?, completion: @escaping (Bool) -> ()) {
        dbManager.fetch(predicate: predicate)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    debugPrint("an error occurred \(error.localizedDescription)")
                case .finished:
                    debugPrint("PRINT VALUE \(completion)")
                }
            } receiveValue: { moviesEntities in
                moviesEntities.forEach { entity in
                    completion(entity.bookmark)
                }
            }.store(in: &bag)
    }
    
    func updateBookmark(with predicate: NSPredicate?, status: Bool) {
        dbManager.fetch(predicate: predicate)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    debugPrint("an error occurred \(error.localizedDescription)")
                case .finished:
                    debugPrint("PRINT VALUE \(completion)")
                }
            } receiveValue: { entities in
                entities.forEach { [weak self] entity in
                    entity.bookmark = status
                    self?.dbManager.save()
                }
            }
            .store(in: &bag)
    }
}
