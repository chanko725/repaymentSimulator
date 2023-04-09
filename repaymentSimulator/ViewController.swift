//
//  ViewController.swift
//  repaymentSimulator
//
//  Created by 永田光一 on 2023/03/30.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var paymentDataList:[PaymentData] = []
    
    //リストの表示数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getPaymentDataList().count
    }
    
    //リストの表示内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let paymentCell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "paymentCell", for: indexPath)
        let paymentData = paymentDataList[indexPath.row]
        paymentCell.textLabel?.numberOfLines = 2
        paymentCell.textLabel!.text = "支払い名称：" + paymentData.paymentName + "\n" + "支払額：¥" +  String(paymentData.totalPayment)
        return paymentCell
     
     }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        paymentDataList = getPaymentDataList()
       /*
        //追加画面で入力した内容を取得
        if UserDefaults.standard.object(forKey: "paymentData") != nil {
            paymentData = UserDefaults.standard.object(forKey: "paymentData") as! [String]
        }
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    //画面再表示
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func getPaymentDataList() -> [PaymentData] {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: "paymentData"), let paymentDataArray = try? JSONDecoder().decode([PaymentData].self, from: data) {
            return paymentDataArray
        } else {
            return []
        }
    }
}

