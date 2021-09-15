//
//  TaskViewController.swift
//  14.7_HomeWork
//
//  Created by Саша on 09.09.2021.
//

import UIKit
import CoreData

class TaskViewController: UIViewController {

    @IBOutlet weak var greenView: UIView!
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var taskTableView: UITableView!
    
    let taskEntity = TaskEntity()
    
    var tasks: [Task] = [] // источник данных для таблицы
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTableView.tableFooterView = UIView() // так убираются пустые строчки
        greenView.layer.cornerRadius = 20
        taskTableView.layer.cornerRadius = 10
        taskTableView.dataSource = self       // подписка таблицы на источник данных таблицы
        taskTableView.delegate = self         // подписка таблицы на делегат таблицы
        taskTextField.delegate = self         // подписка поля ввода на делегат поля ввода
        tasks = taskEntity.loadTask()            // заполнение источника данных таблицы данными из базы данных
    }
}

//MARK: - UITableViewDataSource - Источник данных таблицы -

extension TaskViewController: UITableViewDataSource {
    
//    этот метод возвращает количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
//    этот метод возвращает сконфигурированную ячейку
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellIdetifier", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].task
        return cell
    }
}

//MARK: - UITableViewDelegate - Методы делегата таблицы -

extension TaskViewController: UITableViewDelegate {
    
//    этот метод удаляет ячейку
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let id = tasks[indexPath.row].id
            taskEntity.deleteTasks(id)
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

//MARK: - UITextFieldDelegate - Методы делегата поля ввода -

extension TaskViewController: UITextFieldDelegate {
    
//    этот метод реагирует на нажатие кнопки "Ввод" на клавиатуре поля ввода
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

//        скрывание клавиатуры
        taskTextField.resignFirstResponder()
//        генерирование уникального id
        let id = UUID().uuidString
//        копирование текста из поля ввода
        let task = Task(taskTextField.text ?? "", id)
//        добавление текста в источник данных
        tasks.append(task)
//        перезагрузка таблицы
        taskTableView.reloadData()
//        очистка поля ввода
        taskTextField.text = ""
//        сохранение в базу данных
        taskEntity.saveTask(task)

        return true
    }
}
