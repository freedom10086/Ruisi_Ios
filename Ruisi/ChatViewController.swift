//
//  ChatViewController.swift
//  Ruisi
//
//  Created by yang on 2017/11/30.
//  Copyright © 2017年 yang. All rights reserved.
//

import UIKit
import Kanna

class ChatViewController: BaseTableViewController<ChatData> {
    
    var uid: Int?
    var username: String?
    var isPresented = false
    
    override func viewDidLoad() {
        if uid == nil {
            showBackAlert(message: "没有传入uid参数")
            return
        }
        super.viewDidLoad()
        if ((presentingViewController as? UserDetailViewController) != nil) {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(closeClick))
        }
        
        self.title = username
        self.tableView.tableFooterView?.isHidden = true
    }
    
    
    // MARK: - Table view data source
    
    override func getUrl(page: Int) -> String {
        return Urls.getChatDetailUrl(tuid:uid!)
    }
    
    override func parseData(pos: Int, doc: HTMLDocument) -> [ChatData] {
        let msgs = doc.css(".msgbox .cl")
        print("msg count:\(msgs.count)")
        var subDatas = [ChatData]()
        for m in msgs {
            let uid:Int
            let username:String
            if m["class"]!.contains("friend_msg") {//左边 对方
                uid = self.uid!
                username = self.username ?? "对方"
            } else {//右边
                uid = App.uid!
                username = App.username ?? "我"
            }
            
            let content = m.css(".dialog_t").first?.text ?? "" //TODO innerHtml
            let time = m.css(".date").first?.text ?? ""
            
            subDatas.append(ChatData(uid: uid, uname: username, message: content, time: time))
        }
        
        print("data count:\(subDatas.count)")
        if subDatas.count == 0 {
            pageSume = currentPage
        }
        
        if subDatas.count == 0 && currentPage == 1 { //无消息
            subDatas.append(ChatData(uid: self.uid!, uname: self.username ?? "", message: "给我发消息吧...", time: "刚刚"))
        }
        
        return subDatas
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Configure the cell...
        
        return cell
    }
    
    
    private func showBackAlert(message: String) {
        let alert = UIAlertController(title: "错误", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "关闭", style: .cancel, handler: { action in
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    @objc func closeClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}