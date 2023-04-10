//
//  SettingDetailViewController.swift
//  repaymentSimulator
//
//  Created by 永田光一 on 2023/04/10.
//

import Foundation
import UIKit

class SettingDetailViewController: UIViewController{
    var selectedStruct: PaymentData?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedStruct = selectedStruct {
            nameLabel.text = "名称: \(selectedStruct.paymentName)"
            totalLabel.text = "支払い総額: \(selectedStruct.totalPayment)"
        }
    }
}
