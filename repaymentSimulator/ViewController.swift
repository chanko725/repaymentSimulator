//
//  ViewController.swift
//  repaymentSimulator
//
//  Created by 永田光一 on 2023/03/30.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //リストの表示数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentData.count
    }
    
    //リストの表示内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let paymentCell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "paymentCell", for: indexPath)
        paymentCell.textLabel!.text = paymentData[indexPath.row]
        return paymentCell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //追加画面で入力した内容を取得
        if UserDefaults.standard.object(forKey: "paymentData") != nil {
            paymentData = UserDefaults.standard.object(forKey: "paymentData") as! [String]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

