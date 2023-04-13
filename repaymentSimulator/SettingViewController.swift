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
        let paymentCell = tableView.dequeueReusableCell(withIdentifier: "paymentCell", for: indexPath)
        let paymentData = paymentDataList[indexPath.row]
        paymentCell.accessoryType = .disclosureIndicator
        paymentCell.textLabel!.text = paymentData.paymentName
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formattedNum = formatter.string(from: NSNumber(value: paymentData.totalPayment)) ?? ""
        paymentCell.detailTextLabel?.text = "利用残高：¥" +  formattedNum
        return paymentCell
     
     }
    
    //詳細画面への遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedStruct = paymentDataList[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let settingDetailViewController = storyboard.instantiateViewController(withIdentifier: "SettingDetailViewController") as! SettingDetailViewController
        settingDetailViewController.selectedStruct = selectedStruct
        navigationController?.pushViewController(settingDetailViewController, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        paymentDataList = getPaymentDataList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    //画面再表示
    override func viewWillAppear(_ animated: Bool) {
        paymentDataList = getPaymentDataList()
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

