//
//  ViewController.swift
//  TalanTest
//
//  Created by Vladislav Ivshin on 03.09.2021.
//

import UIKit

class TODOListViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var addTODOBarButtonItem: UIBarButtonItem!
    
    var newTasks: [TODOItem] = []
    var doneTasks: [TODOItem] = []
    
    var photoGallery: PhotoGallery = PhotoGallery.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoGallery.observer = self
        DBManager.shared.observer = self
        
        setupNavBar()
        setupTableView()
    }
    
    // MARK: Private

    private func setupNavBar() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "TODO List"
        
        addTODOBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .add,
                                                    target: self, action: #selector(addTODOItem))
        navigationItem.rightBarButtonItem = addTODOBarButtonItem
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib.init(nibName: "TODOItemTableViewCell", bundle: nil),
                           forCellReuseIdentifier: TODOItemTableViewCell.reuseIdentifier)
        tableView.register(TODOHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: TODOHeaderView.reuseIdentifier)
        
        let todoItems = DBManager.shared.getTODOList()
        
        todoItems.forEach { item in
            if item.isDone {
                doneTasks.append(item)
            } else {
                newTasks.append(item)
            }
        }
        doneTasks.sort(by: { $0.doneDate ?? Date() > $1.doneDate ?? Date() })
        newTasks.sort(by: { $0.createDate < $1.createDate })
        
        tableView.reloadData()
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func reloadTableView(section: Int) {
        DispatchQueue.main.async { [unowned self] in
            tableView.reloadSections([section], with: .automatic)
        }
    }
    
    private func removeCell(indexPath: IndexPath) {
        DispatchQueue.main.async { [unowned self] in
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: Actions
    
    @objc func addTODOItem() {
        mainPageCoordinator.pushDetails(type: .add)
    }
}

extension TODOListViewController: DBManagerObserver {
    func added(item: TODOItem) {
        newTasks.append(item)
        
        reloadTableView()
    }
    
    func removed(item: TODOItem) {
        if item.isDone {
            if let index = doneTasks.firstIndex(of: item) {
                doneTasks.remove(at: index)
            }
        } else {
            if let index = newTasks.firstIndex(of: item) {
                newTasks.remove(at: index)
            }
        }
        
        reloadTableView()
    }
    
    func checkUpdated(item: TODOItem, isChecked: Bool) {
        if isChecked {
            doneTasks.append(item)
            doneTasks.sort(by: { $0.doneDate ?? Date() > $1.doneDate ?? Date() })
            newTasks.removeAll(where: { $0.createDate == item.createDate })
        } else {
            doneTasks.removeAll(where: { $0.createDate == item.createDate })
            newTasks.append(item)
            newTasks.sort(by: { $0.createDate < $1.createDate })
        }
        
        reloadTableView()
    }
    
    func updated(item: TODOItem) {
        if item.isDone {
            if let index = doneTasks.firstIndex(of: item) {
                doneTasks[index] = item
                reloadTableView()
            }
        } else {
            if let index = newTasks.firstIndex(of: item) {
                newTasks[index] = item
                reloadTableView()
            }
        }
    }
    
    func failedAdd(item: TODOItem, error: Error) {
        showMessage(message: "Failed add new todo item: \(error.localizedDescription)")
    }
    
    func failedRemove(item: TODOItem, error: Error) {
        showMessage(message: "Failed remove todo item: \(error.localizedDescription)")
    }
    
    func failedUpdateCheck(item: TODOItem, error: Error) {
        showMessage(message: "Failed update done status for item: \(error.localizedDescription)")
    }
    
    func failedUpdate(item: TODOItem, error: Error) {
        showMessage(message: "Failed update todo item: \(error.localizedDescription)")
    }
}

extension TODOListViewController: PhotoGalleryObserver {
    func failedWrite(imageData: ImageData, error: Error) {
        
    }
    
    func failedRead(imageData: ImageData, error: Error) {
        self.showMessage(message: "Failed read image data \(imageData.imageName) \(error.localizedDescription)")
    }
}
