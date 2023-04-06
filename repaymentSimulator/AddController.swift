//
//  AddController.swift
//  repaymentSimulator
//
//  Created by 永田光一 on 2023/04/01.
//

import UIKit
import Eureka
//FIXME:validateの記述を共通化
//支払いに関するデータを格納する
//var paymentData = [String]()
struct paymentData {
    //支払い先名
    var paymentName:String
    //支払い総額
    var totalPayment:Int
    //支払い方式
    var paymentMethod:String
    //年利
    var annualInterestLate:Double
    //遅延損害金の利率
    var penaltyLate:Double
    //返済額変更月
    var changeRepaymentMonth:[Int] = []
    //月毎の返済額
    var monthlyRepaymentAmount:[Int] = []
    //月毎の返済日
    var monthlyRepaymentDate:[Int] = []
    //ボーナス月
    var bonusMonth:[Int] = []
    //ボーナスの返済額
    var bonusRepaymentAmount:Int
    //ボーナスの返済日
    var bonusRepaymentDate:Int
}

class AddController: FormViewController {
    
    var paymentName:String = ""
    var totalPayment:Int?
    var paymentMethod:String?
    var annualInterestLate:Double?
    var penaltyLate:Double?
    var monthlyRepaymentAmount:Int?
    var monthlyRepaymentDate:Int?
    var bonusMonth:[Int] = []
    var bonusRepaymentAmount:Int?
    var bonusRepaymentDate:Int?
     

    override func viewDidLoad() {
        super.viewDidLoad()
        
        LabelRow.defaultCellUpdate = { cell, row in
            cell.contentView.backgroundColor = .red
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            cell.textLabel?.textAlignment = .right

        }
        
        form
        +++ Section()
        //支払い先名
        <<< TextRow {
            $0.title = "支払い先名"
            $0.placeholder = "支払い先名"
            $0.add(rule: RuleRequired(msg:"支払先名は必須です"))
        }.onChange{ row in
            self.paymentName = row.value ?? "paymentName"
        }
        .onRowValidationChanged { cell, row in
            let rowIndex = row.indexPath!.row
            while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                row.section?.remove(at: rowIndex + 1)
            }
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    let labelRow = LabelRow() {
                        $0.title = validationMsg
                        $0.cell.height = { 30 }
                    }
                    let indexPath = row.indexPath!.row + index + 1
                    row.section?.insert(labelRow, at: indexPath)
                }
            }
        }
        //支払い総額
        <<< IntRow() {
            $0.title = "支払い総額"
            $0.value = 0
            $0.add(rule: RuleGreaterThan(min: 0, msg:"支払い総額は1円以上です"))
        }.onChange({[unowned self] row in
            self.totalPayment = row.value ?? 0
        })
        .onRowValidationChanged { cell, row in
            let rowIndex = row.indexPath!.row
            while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                row.section?.remove(at: rowIndex + 1)
            }
            if !row.isValid {
                for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                    let labelRow = LabelRow() {
                        $0.title = validationMsg
                        $0.cell.height = { 30 }
                    }
                    let indexPath = row.indexPath!.row + index + 1
                    row.section?.insert(labelRow, at: indexPath)
                }
            }
        }
        //支払い方式
        <<< SegmentedRow<String>("paymentMethod"){
            $0.options = ["元利定額方式", "元金定額方式"]
            $0.title = "支払い方式"
            $0.value = "元利定額方式"
        }.onChange{ row in
            self.paymentMethod = row.value ?? "paymentMethod"
        }
        //年利
        <<< DecimalRow() {
            $0.title = "年利"
            $0.value = 0.0
        }.onChange({[unowned self] row in
            self.annualInterestLate = row.value ?? 0
        })
        //遅延損害金の利率
        <<< DecimalRow() {
            $0.title = "遅延損害金の金利"
            $0.value = 0.0
        }.onChange({[unowned self] row in
            self.penaltyLate = row.value ?? 0
        })
        //月毎の返済額
        <<< IntRow() {
            $0.title = "月毎の返済額"
            $0.value = 0
        }.onChange({[unowned self] row in
            self.monthlyRepaymentAmount = row.value ?? 0
        })
        //月毎の返済日
        <<< PickerInlineRow<String>() {
            $0.title = "月毎の返済日"
            $0.options = ["1日","2日","3日","4日","5日","6日","7日","8日","9日","10日","11日","12日","13日","14日","15日","16日","17日","18日","19日","20日","21日","22日","23日","24日","25日","26日","27日","28日","29日","30日","31日","月末"]
            $0.value = $0.options.first
        }.onChange {[unowned self] row in
            if row.value == "月末" {
                self.monthlyRepaymentDate = 999
            } else {
                self.monthlyRepaymentDate = Int(row.value?.replacingOccurrences(of: "日", with: "") ?? "0") ?? 0
            }
        }
        //ボーナス月の返済
        +++ Section()
        <<< SwitchRow("ボーナス月の返済"){
            $0.title = $0.tag
        }
        <<< MultipleSelectorRow<String>() {
            $0.title = "ボーナス月"
            $0.options = ["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月"]
            $0.hidden = .function(["ボーナス月の返済"], { form -> Bool in
                let row: RowOf<Bool>! = form.rowBy(tag: "ボーナス月の返済")
                return row.value ?? false == false
            })
        }
        <<< IntRow() {
            $0.title = "返済額"
            $0.value = 0
            $0.hidden = .function(["ボーナス月の返済"], { form -> Bool in
                let row: RowOf<Bool>! = form.rowBy(tag: "ボーナス月の返済")
                return row.value ?? false == false
            })
        }.onChange({[unowned self] row in
            self.monthlyRepaymentAmount = row.value ?? 0
        })
        <<< PickerInlineRow<String>() {
            $0.title = "返済日"
            $0.options = ["1日","2日","3日","4日","5日","6日","7日","8日","9日","10日","11日","12日","13日","14日","15日","16日","17日","18日","19日","20日","21日","22日","23日","24日","25日","26日","27日","28日","29日","30日","31日","月末"]
            $0.value = $0.options.first
            $0.hidden = .function(["ボーナス月の返済"], { form -> Bool in
                let row: RowOf<Bool>! = form.rowBy(tag: "ボーナス月の返済")
                return row.value ?? false == false
            })
        }.onChange {[unowned self] row in
            if row.value == "月末" {
                self.monthlyRepaymentDate = 999
            } else {
                self.monthlyRepaymentDate = Int(row.value?.replacingOccurrences(of: "日", with: "") ?? "0") ?? 0
            }
        }
        +++ Section()
        <<< ButtonRow("登録") {row in
            row.title = "登録"
            row.onCellSelection{[unowned self] ButtonCellOf, row in
                if (row.section?.form?.validate().count != 0) {
                    return
                }
                
                //データ登録
//                paymentData.append(self.paymentName)
//                paymentData.append(String(self.totalPayment))
//                UserDefaults.standard.set(paymentData, forKey: "paymentData")
                //前の画面に戻る
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
