//
//  AddController.swift
//  repaymentSimulator
//
//  Created by 永田光一 on 2023/04/01.
//

import UIKit
import Eureka
//FIXME:Data型にする？サイズは大したことにならないから配列もありだが不具合の温床になりそう
//https://capibara1969.com/2531/#toc16
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
    //ボーナス月
    var bonusMonth : [Int] = []
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
        <<< IntRow() { row in
            row.title = "支払い総額"
            row.value = 0
        }.onChange({[unowned self] row in
            self.totalPayment = row.value ?? 0
        })
        +++ Section()
        <<< ButtonRow("登録") {row in
            row.title = "登録"
            row.onCellSelection{[unowned self] ButtonCellOf, row in
                //データ登録
                paymentData.append(self.paymentName)
                paymentData.append(String(self.totalPayment))
                UserDefaults.standard.set(paymentData, forKey: "paymentData")
                //前の画面に戻る
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
