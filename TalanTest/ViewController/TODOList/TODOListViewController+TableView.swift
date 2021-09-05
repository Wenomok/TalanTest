//
//  TODOListViewController+TableView.swift
//  TalanTest
//
//  Created by Vladislav Ivshin on 03.09.2021.
//

import UIKit

extension TODOListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if !newTasks.isEmpty {
            return doneTasks.isEmpty ? 1 : 2
        }
        return doneTasks.isEmpty ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !newTasks.isEmpty, section == 0 {
            return newTasks.count
        }
        if !doneTasks.isEmpty, section == 0 {
            return doneTasks.count
        }
        return doneTasks.count
    }
    
    // MARK: Cells
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let todoItemCell = tableView.dequeueReusableCell(withIdentifier: TODOItemTableViewCell.reuseIdentifier,
                                                            for: indexPath) as? TODOItemTableViewCell {
            var item: TODOItem?
            
            if indexPath.section == 0 {
                if !newTasks.isEmpty {
                    item = newTasks[safeIndex: indexPath.row]
                } else {
                    item = doneTasks[safeIndex: indexPath.row]
                }
                
            } else if indexPath.section == 1 {
                item = doneTasks[safeIndex: indexPath.row]
            }
            
            if let todoItem = item {
                todoItemCell.configure(item: todoItem, delegate: self)
            }
            
            todoItemCell.configureImage(fromURL: item?.getImageURL())
            
            return todoItemCell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if newTasks.isEmpty {
                if let todoItem = doneTasks[safeIndex: indexPath.row] {
                    mainPageCoordinator.pushDetails(type: .show(item: todoItem))
                }
            } else {
                if let todoItem = newTasks[safeIndex: indexPath.row] {
                    mainPageCoordinator.pushDetails(type: .show(item: todoItem))
                }
            }
        } else if indexPath.section == 1, let todoItem = doneTasks[safeIndex: indexPath.row] {
            mainPageCoordinator.pushDetails(type: .show(item: todoItem))
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction.init(style: .destructive, title: nil) { [unowned self] action, indexPath in
            if indexPath.section == 0 {
                if !newTasks.isEmpty {
                    if let todoItem = newTasks[safeIndex: indexPath.row] {
                        DBManager.shared.remove(item: todoItem)
                    }
                } else {
                    if let todoItem = doneTasks[safeIndex: indexPath.row] {
                        DBManager.shared.remove(item: todoItem)
                    }
                }
            } else if indexPath.section == 1, let todoItem = doneTasks[safeIndex: indexPath.row] {
                DBManager.shared.remove(item: todoItem)
            }
        }
        return [deleteAction]
    }
    
    // MARK: Header
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let newTasksHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: TODOHeaderView.reuseIdentifier) as? TODOHeaderView {
            
            if section == 0 {
                newTasksHeaderView.configure(title: !newTasks.isEmpty ? "New tasks" : "Done tasks")
            } else if section == 1 {
                newTasksHeaderView.configure(title: "Done tasks")
            }
            
            return newTasksHeaderView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48.0
    }
}

extension TODOListViewController: TODOItemTableViewCellDelegate {
    func didUpdateCheck(isChecked: Bool, forItem item: TODOItem) {
        item.update(isDone: isChecked, doneDate: isChecked ? Date.init() : nil)
        DBManager.shared.updateCheck(forItem: item, isChecked: isChecked)
    }
}
