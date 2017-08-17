//
//  DatabaseController.swift
//  coreDataTest
//
//  Created by 0x384c0 on 8/17/17.
//  Copyright © 2017 Spalmalo. All rights reserved.
//

import Foundation
import CoreData

class DatabaseController {
    private static let modelName = "coreDataTest"
    private init() { }
    static private func getCoordinator() -> NSPersistentStoreCoordinator{
        let
        modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd")!,
        model = NSManagedObjectModel(contentsOf: modelURL)!
        return NSPersistentStoreCoordinator(managedObjectModel: model )
    }
    static private func getDBFileURL() -> URL{
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1].appendingPathComponent("\(modelName).sqlite")
    }
    static private func addStorage(in coordinator:NSPersistentStoreCoordinator) -> Bool{
        let url = getDBFileURL()
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
            return true
        } catch {
            return false
        }
    }
    private static func destroyStorage(in coordinator:NSPersistentStoreCoordinator){
        let url = getDBFileURL()
        do {
            try coordinator.destroyPersistentStore(at: url, ofType: NSSQLiteStoreType, options: nil)
        } catch {
            print("!!!!! FATAL DB ERROR: CANT DESTROY STORAGE")
        }
    }
    fileprivate static var managedObjectContext: NSManagedObjectContext = {
        let coordinator = getCoordinator()
        let isFailed = !addStorage(in: coordinator)
        if isFailed{
            destroyStorage(in: coordinator)
            if !addStorage(in: coordinator){
                print("!!!!! FATAL DB ERROR: CANT ADD STORAGE")
            }
        }
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    
    //public
    class func saveContext() {
        if managedObjectContext.hasChanges {
            do { try managedObjectContext.save() }
            catch { print(error as NSError) }
        }
    }
}
extension DatabaseController{
    //Languages
    class func getLanguages() -> [Language]{
        let entityDescription = NSEntityDescription.entity(forEntityName: String(describing: Language.self), in: managedObjectContext)
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        do {
            let results = try managedObjectContext.fetch(request) as? [Language]
            return results ?? []
        } catch let error as NSError {
            print(error)
            return []
        }
    }
    class func removeLanguages(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Language.self))
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do { try managedObjectContext.execute(deleteRequest)}
        catch { print(error as NSError) }
    }
    
    class func newLanguage() -> Language{
        let entityDescription = NSEntityDescription.entity(forEntityName: String(describing: Language.self), in: managedObjectContext)
        return Language(entity: entityDescription!, insertInto: managedObjectContext)
    }
    class func newLocalizedString() -> LocalizedString{
        let entityDescription = NSEntityDescription.entity(forEntityName: String(describing: LocalizedString.self), in: managedObjectContext)
        return LocalizedString(entity: entityDescription!, insertInto: managedObjectContext)
    }
}
