//
//  SettingDetailViewController.swift
//  repaymentSimulator
//
//  Created by 永田光一 on 2023/04/10.
//

import UIKit
import Eureka

//FIXME:　登録後セルが赤くなっちゃうのを修正
class SettingDetailViewController: FormViewController{
    var selectedStruct: PaymentData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form
        +++ Section()
        //支払い先名
        <<< LabelRow {
            $0.title = "支払い先名"
            $0.value = selectedStruct!.paymentName
        }
        //支払い残高
        <<< LabelRow {
            $0.title = "支払い残高"
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            let formattedNum = formatter.string(from: NSNumber(value: selectedStruct!.totalPayment)) ?? ""
            $0.value = "¥" + String(formattedNum)
        }
        //支払い方式
        <<< LabelRow {
            $0.title = "支払い方式"
            $0.value = selectedStruct!.paymentMethod
        }
        //年利
        <<< LabelRow {
            $0.title = "年利"
            $0.value = String(selectedStruct!.annualInterestLate) + "%"
        }
        //遅延損害金の金利
        <<< LabelRow {
            $0.title = "遅延損害金の金利"
            $0.value = String(selectedStruct!.penaltyLate) + "%"
        }
        //FIXME: 返済額は0番指定でなく最新の額を出力する
        //または、変更月がきたら先頭の要素を削除する
        //月毎の返済額
        <<< LabelRow {
            $0.title = "月毎の返済額"
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            let formattedNum = formatter.string(from: NSNumber(value: selectedStruct!.monthlyRepaymentAmount[0])) ?? ""
            $0.value = "¥" + String(formattedNum)
        }
        //FIXME: 返済額と同じ
        //月毎の返済日
        <<< LabelRow {
            $0.title = "月毎の返済日"
            $0.value = String(selectedStruct!.monthlyRepaymentDate[0]) + "日"
            //FIXME: 999日は表示の時には月末と表示
        }
        if (selectedStruct?.bonusMonth.count != 0) {
            form
            +++ Section("ボーナス月の返済")
            //ボーナス月
            <<< LabelRow {
                var months = ""
                $0.title = "ボーナス月"
                if (selectedStruct?.bonusMonth.count != 1) {
                    for month in selectedStruct!.bonusMonth {
                        months = months + String(month) + "月, "
                    }
                    months = String(months.prefix(months.count - 2))
                } else {
                    months = String(selectedStruct!.bonusMonth[0]) + "月"
                }
                $0.value = months
            }
            //ボーナスの返済額
            <<< LabelRow {
                $0.title = "ボーナスの返済日"
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                let formattedNum = formatter.string(from: NSNumber(value: selectedStruct!.bonusRepaymentAmount)) ?? ""
                $0.value = "¥" + String(formattedNum)
            }
            //ボーナスの返済日
            <<< LabelRow {
                $0.title = "ボーナスの返済日"
                $0.value = String(selectedStruct!.bonusRepaymentDate) + "日"
            }
        }
    }
}
