import CoreData

public class CoreDataStorage {
    public init() {}
    
    private var isSetup = false
    
    private var store: PersistenceStore!
    
    public func setup(model: String, bundle: AnyClass) {
        guard !isSetup else { return }
        
        store = PersistenceStore(model: model, for: bundle)
        isSetup = true
    }
    
    public func delete<Entity: NSManagedObject>(entity: Entity) throws {
        store.viewContext.delete(entity)
        try saveContext()
    }
    
    public func create<Entity: NSManagedObject>(type: Entity.Type, configure: (Entity) -> Void) throws {
        let entity = Entity(context: viewContext)
        configure(entity)
        try saveContext()
    }
    
    public func update<Entity: NSManagedObject>(entity: Entity, configure: (Entity) -> Void) throws {
        configure(entity)
        try saveContext()
    }
}

// MARK: - Fetchers

public extension CoreDataStorage {
    func fetch<Entity: NSManagedObject>(type: Entity.Type) throws -> [Entity] {
        let request = createFetchRequest(for: type)
        return try store.viewContext.fetch(request)
    }
    
    func fetch<Entity: NSManagedObject>(
        type: Entity.Type,
        configureRequest: (NSFetchRequest<Entity>) -> Void
    ) throws -> [Entity] {
        let request = createFetchRequest(for: type)
        configureRequest(request)
        return try store.viewContext.fetch(request)
    }
    
    func fetch<Entity: NSManagedObject, T: CVarArg>(by id: T, type: Entity.Type) throws -> Entity? {
        try fetch(type: type) { request in
            request.predicate = NSPredicate(format: "id == %@", id)
            request.fetchLimit = 1
        }.first
    }
    
    func fetch<Entity: NSManagedObject>(by date: Date, type: Entity.Type) throws -> Entity? {
        try fetch(type: type) { request in
            request.predicate = NSPredicate(format: "date == %@", date as NSDate)
            request.fetchLimit = 1
        }.first
    }
    
    func fetch<Entity: NSManagedObject, T: CVarArg>(by ids: [T], type: Entity.Type) throws -> [Entity] {
        try fetch(type: type) { request in
            request.predicate = NSPredicate(format: "id IN %@", ids)
        }
    }
}

// MARK: - Private Methods

private extension CoreDataStorage {
    // swiftlint:disable:next generic_constraint_naming
    func createFetchRequest<Entity: NSManagedObject>(for type: Entity.Type) -> NSFetchRequest<Entity> {
        return NSFetchRequest(entityName: "\(Entity.self)")
    }
    
    var viewContext: NSManagedObjectContext {
        store.viewContext
    }
    
    func saveContext() throws {
        try store.viewContext.save()
    }
}

