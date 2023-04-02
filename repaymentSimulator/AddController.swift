//
//  AddController.swift
//  repaymentSimulator
//
//  Created by 永田光一 on 2023/04/01.
//

import UIKit
import Eureka
//支払いに関するデータを格納する
var paymentData = [String]()

class AddController: UIViewController {
    
    //名称
    @IBOutlet weak var paymentName: UITextField!
    //支払い総額
    //支払い方式
    //年利
    //遅延損害金の利率
    //月毎の返済日
    //月毎の返済額
    //月毎の返済日
    //ボーナス月の返済額
    //ボーナス月の返済日
    
    @IBAction func addPayment(_ sender: Any) {
        //配列に入力内容を格納
        paymentData.append(paymentName.text!)
        //追加後にフィールドを空にする
        paymentName.text = ""
        //UDに保存
        UserDefaults.standard.set(paymentData, forKey: "paymentData")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
