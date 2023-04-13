//
//  AddController.swift
//  repaymentSimulator
//
//  Created by 永田光一 on 2023/04/01.
//


//FIXME: 設定内容を削除できるように修正したい
import UIKit
import Eureka
//支払いに関するデータを格納する
struct PaymentData : Codable{
    //支払い先名
    var paymentName:String
    //支払い残高
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
    var totalPayment:Int = 0
    var paymentMethod:String = "元利定額方式"
    var annualInterestLate:Double = 0.0
    var penaltyLate:Double = 0.0
    var monthlyRepaymentAmount:Int = 0
    var monthlyRepaymentDate:Int = 0
    var bonusRepaymentFlag:Bool = false
    var bonusMonth:[Int] = []
    var bonusRepaymentAmount:Int = 0
    var bonusRepaymentDate:Int = 0
     

    override func viewDidLoad() {
        super.viewDidLoad()
        LabelRow.defaultCellUpdate = { cell, row in
            cell.contentView.backgroundColor = .red
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            cell.textLabel?.textAlignment = .right
            
        }
        
        func validateFormText(cell:TextCell,row:TextRow) {
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
        
        func validateFormInt(cell:IntCell,row:IntRow) {
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
        
        func validateFormDecimal(cell:DecimalCell,row:DecimalRow) {
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
        
        form
        +++ Section()
        //支払い先名
        <<< TextRow {
            $0.title = "支払い先名"
            $0.placeholder = "支払い先名"
            $0.add(rule: RuleRequired(msg:"支払先名は必須です"))
        }.onChange{ row in
            self.paymentName = row.value ?? "paymentName"
        }.onRowValidationChanged { cell, row in
            validateFormText(cell: cell,row: row)
        }
        //支払い残高
        <<< IntRow() {
            $0.title = "支払い残高"
            $0.value = 0
            $0.add(rule: RuleGreaterThan(min: 0, msg:"支払い総額は1円以上です"))
        }.onChange({[unowned self] row in
            self.totalPayment = row.value ?? 0
        }).onRowValidationChanged { cell, row in
            validateFormInt(cell: cell,row: row)
        }
        //支払い方式
        <<< SegmentedRow<String>("paymentMethod"){
            $0.options = ["元利定額方式", "元金定額方式"]
            $0.title = "支払い方式"
            $0.value = "元利定額方式"
        }.onChange{ row in
            self.paymentMethod = row.value ?? "test"
        }
        //年利
        <<< DecimalRow() {
            $0.title = "年利"
            $0.value = 0.0
            let formatter = DecimalFormatter()
            formatter.locale = .current
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 1
            $0.formatter = formatter
            $0.add(rule: RuleGreaterThan(min: 0, msg:"年利は0.1％以上を指定してください"))
            $0.add(rule: RuleSmallerThan(max: 100, msg:"年利は100.0％未満を指定してください"))
        }.onChange({[unowned self] row in
            self.annualInterestLate = row.value ?? 0
        }).onRowValidationChanged { cell, row in
            validateFormDecimal(cell: cell,row: row)
        }
        //遅延損害金の利率
        <<< DecimalRow() {
            $0.title = "遅延損害金の金利"
            $0.value = 0.0
            let formatter = DecimalFormatter()
            formatter.locale = .current
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 1
            $0.formatter = formatter
            $0.add(rule: RuleGreaterThan(min: 0, msg:"遅延損害金の金利は0.1％以上を指定してください"))
            $0.add(rule: RuleSmallerThan(max: 100, msg:"遅延損害金の年利は100.0％未満を指定してください"))
        }.onChange({[unowned self] row in
            self.penaltyLate = row.value ?? 0
        }).onRowValidationChanged { cell, row in
            validateFormDecimal(cell: cell,row: row)
        }
        //月毎の返済額
        <<< IntRow() {
            $0.title = "月毎の返済額"
            $0.value = 0
            $0.add(rule: RuleGreaterThan(min: 0, msg:"月毎の返済額は1円以上です"))
        }.onChange({[unowned self] row in
            self.monthlyRepaymentAmount = row.value ?? 0
        }).onRowValidationChanged { cell, row in
            validateFormInt(cell: cell,row: row)
        }
        //月毎の返済日
        <<< PickerInlineRow<String>() {
            $0.title = "月毎の返済日"
            //FIXME: onChangeで変更しないと1日で登録されない
            $0.options = ["1日","2日","3日","4日","5日","6日","7日","8日","9日","10日","11日","12日","13日","14日","15日","16日","17日","18日","19日","20日","21日","22日","23日","24日","25日","26日","27日","28日","29日","30日","31日","月末"]
            $0.value = $0.options.first
        }.onChange {[unowned self] row in
            if row.value == "月末" {
                self.monthlyRepaymentDate = 999
            } else {
                self.monthlyRepaymentDate = Int(row.value?.replacingOccurrences(of: "日", with: "") ?? "0") ?? 0
            }
        }
        //FIXME: ボーナス月が無効の時には入れた値をリセットする
        //ボーナス月の返済
        +++ Section()
        <<< SwitchRow("ボーナス月の返済"){
            $0.title = $0.tag
        }.onChange{ row in
            self.bonusRepaymentFlag = row.value!
        }
        <<< MultipleSelectorRow<String>() {
            $0.title = "ボーナス月"
            $0.options = ["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"]
            $0.add(rule: RuleRequired(msg:"ボーナス月は1つ以上選択してください"))
            $0.hidden = .function(["ボーナス月の返済"], { form -> Bool in
                let row: RowOf<Bool>! = form.rowBy(tag: "ボーナス月の返済")
                return row.value ?? false == false
            })
        }.onChange{[unowned self] row in
            //FIXME: 月の並び順を月の並び順通りに(数字の並びにすると10月台が前に出てくる)
            var months : [Int] = []
            if let rowValue = row.value {
                for month in rowValue {
                    if let intMonth = Int(month.replacingOccurrences(of: "月", with: "")) {
                        months.append(intMonth)
                    }
                }
            }
            self.bonusMonth = months
        }.onRowValidationChanged { cell, row in
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
        <<< IntRow() {
            $0.title = "返済額"
            $0.value = 0
            $0.add(rule: RuleGreaterThan(min: 0, msg:"月毎の返済額は1円以上です"))
            $0.hidden = .function(["ボーナス月の返済"], { form -> Bool in
                let row: RowOf<Bool>! = form.rowBy(tag: "ボーナス月の返済")
                return row.value ?? false == false
            })
        }.onChange({[unowned self] row in
            self.bonusRepaymentAmount = row.value ?? 0
        }).onRowValidationChanged { cell, row in
            validateFormInt(cell: cell,row: row)
        }
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
                self.bonusRepaymentDate = 999
            } else {
                self.bonusRepaymentDate = Int(row.value?.replacingOccurrences(of: "日", with: "") ?? "0") ?? 0
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
                let paymentData = PaymentData(paymentName: paymentName,
                                             totalPayment: totalPayment,
                                             paymentMethod: paymentMethod,
                                             annualInterestLate: annualInterestLate,
                                             penaltyLate: penaltyLate,
                                             changeRepaymentMonth: [0],
                                             monthlyRepaymentAmount: [monthlyRepaymentAmount],
                                             monthlyRepaymentDate: [monthlyRepaymentDate],
                                             bonusMonth: bonusMonth,
                                             bonusRepaymentAmount: bonusRepaymentAmount,
                                             bonusRepaymentDate: bonusRepaymentDate)
                var paymentDataList = getPaymentDataList()
                paymentDataList.append(paymentData)
                if let jsonData = try? JSONEncoder().encode(paymentDataList) {
                    UserDefaults.standard.set(jsonData, forKey: "paymentData")
                }
                //前の画面に戻る
                self.navigationController?.popViewController(animated: true)
            }
        }
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
