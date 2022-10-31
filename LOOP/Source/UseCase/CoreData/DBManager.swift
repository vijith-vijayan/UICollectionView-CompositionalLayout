//
//  Created by Vijith TV on 26/10/22.
//

import CoreData
import Combine

enum DBError: Error {
    case objectNotFound
}

class DBManager<Entity: NSManagedObject> {
    
    
    //MARK: - MAINCONTEXT
    private lazy var moc: NSManagedObjectContext = {
        return coreData.viewContext
    }()
    
    //MARK: - CONTEXT
    private lazy var context: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = moc
        return context
    }()
    
    private lazy var coreData: CoreDataStoring = CoreDataStore.default
    private var bag: [AnyCancellable] = []
    
    //MARK: - OBJECT FROM ID

    func object(_ id: NSManagedObjectID) -> AnyPublisher<Entity, Error> {
        Deferred { [context] in
            Future { promise in
                context.perform {
                    guard let entity = try? context.existingObject(with: id) as? Entity else {
                        promise(.failure(DBError.objectNotFound))
                        return
                    }
                    promise(.success(entity))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    //MARK: - STORE DATA INTO CORE DATA
    func store(_ body: @escaping (inout Entity) -> Void) -> AnyPublisher<Entity, Error> {
        Deferred { [context] in
            Future  { promise in
                context.perform {
                    var entity = Entity(context: context)
                    body(&entity)
                    do {
                        try context.save()
                        promise(.success(entity))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    //MARK: - FETCH DATA FROM COREDATA
    func fetch(sortDescriptors: [NSSortDescriptor] = [],
               predicate: NSPredicate? = nil) -> AnyPublisher<[Entity], Error> {
        Deferred { [context] in
            Future { promise in
                context.perform {
                    let request = Entity.fetchRequest()
                    request.sortDescriptors = sortDescriptors
                    request.predicate = predicate
                    do {
                        let results = try context.fetch(request) as! [Entity]
                        promise(.success(results))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    // MARK: - CHECK IF OBJECT IS ALREADY EXIST IN DB
    func findRecord(for id: String, completion: @escaping (Bool) -> ()) {
        let predicate = NSPredicate(format: "movieId == %@", "\(id)")
        fetch(predicate: predicate)
            .sink {completion in
                switch completion {
                case .failure(let error):
                    debugPrint("an error occurred \(error.localizedDescription)")
                case .finished:
                    debugPrint("IS RECORD FOUND \(completion)")
                }
            } receiveValue: { entity in
                completion(entity.isEmpty)
            }
            .store(in: &bag)
    }
    
    func save() {
        do {
            try? context.save()
        }
    }
}

