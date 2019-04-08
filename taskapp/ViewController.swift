//
//  ViewController.swift
//  taskapp
//
//  Created by ouyou on 2019/04/06.
//  Copyright © 2019 ouyou. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "category", ascending: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        searchBar.delegate = self
        searchBar?.placeholder = "カテゴリで検索する"
    }
    
    //1个section的row数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return taskArray.count

    }
    
    //注册cell      dequeue：出列  indexpath：获取section上的row值
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableview.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = taskArray[indexPath.row]
        cell.textLabel?.text = "\(task.title)"
        cell.detailTextLabel?.text = "カテゴリ:\(task.category)"
        
        return cell
    }
    
    // 入力画面から戻ってきた時に TableView を更新させる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableview.reloadData()
    }
    
    //对点击的row进行编辑
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue",sender: nil) // ←追加する
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // 削除するタスクを取得する
            let task = self.taskArray[indexPath.row]
            print(task)
            
            // ローカル通知をキャンセルする
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [String(task.id)])
            
            // データベースから削除する
            try! realm.write {
                self.realm.delete(task)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            // 未通知のローカル通知一覧をログ出力
            center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
                for request in requests {
                }
            }
        } // --- ここまで変更 ---
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let inputViewController : InputViewController = segue.destination as! InputViewController
        
        if segue.identifier == "cellSegue"{
            let indexPath = self.tableview.indexPathForSelectedRow
            inputViewController.task = taskArray[indexPath!.row]
        }else {
            let task = Task()
            task.date = Date()
            
            let allTasks = realm.objects(Task.self)
            if allTasks.count != 0 {
                task.id = allTasks.max(ofProperty: "id")! + 1
            }
        
            inputViewController.task = task
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        if (searchBar.text?.count)! > 0 {
            let predicate = NSPredicate(format: "SELF.category CONTAINS[x] %@", searchBar.text!)
            taskArray = taskArray.filter(predicate)
        } else {
            taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "category", ascending: false)
        }
        tableview.reloadData()
    }
    //在搜索框中输入的文字只要有变化就执行一次这个方法
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }

}




