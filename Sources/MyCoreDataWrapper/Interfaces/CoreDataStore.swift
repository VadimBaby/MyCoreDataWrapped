//
//  File.swift
//  MyCoreDataWrapper
//
//  Created by Вадим Мартыненко on 11.06.2025.
//

import CoreData

public protocol CoreDataStore: AnyObject {
    // swiftlint:disable:next generic_constraint_naming
    func delete<Entity: NSManagedObject>(entity: Entity) throws
    
    // swiftlint:disable:next generic_constraint_naming
    func create<Entity: NSManagedObject>(type: Entity.Type, configure: (_ entity: Entity) -> Void) throws
    
    // swiftlint:disable:next generic_constraint_naming
    func update<Entity: NSManagedObject>(entity: Entity, configure: (_ entity: Entity) -> Void) throws
}
