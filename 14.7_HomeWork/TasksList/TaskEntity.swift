//
//  TaskEntity.swift
//  14.7_HomeWork
//
//  Created by Саша on 09.09.2021.
//

import Foundation
import CoreData

class TaskEntity: NSManagedObject {
    let container = AppDelegate.container // контейнер базы данных
    
//MARK: - saveTask (task:) -
        
    //    этот метод сохраняет данные в базу данных
    func saveTask (_ task: Task) {
        let taskContext = container.viewContext
        taskContext.perform {
            let taskEntity = TaskEntity(context: taskContext)
            taskEntity.task = task.task
            taskEntity.id = task.id
        }
        try? taskContext.save()
    }
    
//MARK: - loadTask () -> [Task] -
        
    //    этот метод выгружает данные из базы данных
    func loadTask () -> [Task] {
        var tasks: [Task] = []
        var counterLoadTask = 0
        let taskContext = container.viewContext
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        if let taskEntity = try? taskContext.fetch(request) {
            for _ in taskEntity {
                if let task = taskEntity[counterLoadTask].task {
                    if let id = taskEntity[counterLoadTask].id {
                        let idAndTask = Task(task, id)
                        tasks.append(idAndTask)
                        counterLoadTask += 1
                    }
                }
            }
        }
        counterLoadTask = 0
        return tasks
    }
        
//MARK: - deleteTasks() -
        
    //    этот метод удаляет данные из базы данных, но не все, а только с определённым id
    func deleteTasks(_ id: String) {
        let taskContext = container.viewContext
        let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        if let taskEntity = try? taskContext.fetch(request)  {
            for task in taskEntity {
                taskContext.delete(task)
            }
        }
        try? taskContext.save()
    }    
}
