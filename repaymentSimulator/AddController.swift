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
     */
     
    //名称
    var paymentName : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        form
        +++ Section("")
        <<< TextRow { row in
            row.title = "支払い先名"//フォームのタイトル
            row.placeholder = "支払い先名"//初期状態でフォームに表示されている文字
        }.onChange{ row in
            self.paymentName = row.value ?? "paymentName"//変数に格納
        }
        +++ Section("送信")
        <<< ButtonRow("フォームを送信") {row in
            row.title = "送信する"
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
