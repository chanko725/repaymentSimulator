//
//  SettingDetailViewController.swift
//  repaymentSimulator
//
//  Created by 永田光一 on 2023/04/10.
//

import UIKit
import Eureka

class SettingDetailViewController: FormViewController{
    var selectedStruct: PaymentData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        form
        +++ Section()
        //支払い先名
        <<< LabelRow {
            $0.title = "支払い先名"
            $0.value = selectedStruct?.paymentName
        }
    }
}
