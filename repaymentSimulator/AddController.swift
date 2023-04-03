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

class AddController: FormViewController {
    
    /*

     //ボーナス月の返済額
     //ボーナス月の返済日
     */
     
    //支払い先名
    var paymentName : String = ""
    //支払い総額
    var totalPayment = Int()
    //支払い方式
    var paymentMethod : String = ""
    //年利
    var annualInterestLate = Int()
    //遅延損害金の利率
    var penaltyLate = Int()
    //月毎の返済額
    var monthlyRepaymentAmount = Int()
    //月毎の返済日
    var monthlyRepaymentDate = Int()
    //ボーナスの返済額
    var bonusRepaymentAmount = Int()
    //ボーナスの返済日
    var bonusRepaymentDate = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        form
        +++ Section()
        //支払い先名
        <<< TextRow { row in
            row.title = "支払い先名"
            row.placeholder = "支払い先名"
            }.onChange{ row in
                self.paymentName = row.value ?? "paymentName"//変数に格納
                
            }
        //支払い総額
        //<<< IntRow() {
        +++ Section()
        <<< ButtonRow("登録") {row in
            row.title = "登録"
            row.onCellSelection{[unowned self] ButtonCellOf, row in
                //データ登録＆戻る処理を書く
                paymentData.append(self.paymentName)
                UserDefaults.standard.set(paymentData, forKey: "paymentData")
                //FIXME:画面を戻る操作でなく、読み込み直すように実装する
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
