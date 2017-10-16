//
//  ViewController.swift
//  SampleStepCounts
//
//  Created by 贾小燕 on 2017/10/16.
//  Copyright © 2017年 xiaoyanJia. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {

    @IBOutlet weak var stepCountsLabel: UILabel!
    var healthStepCountManager = HealthKitStepCountManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func getTodayStepCounts(_ sender: Any) {
        //查看当前设备是否支持健康
        if healthStepCountManager.isHealthDataAvilabel() {
            weak var weakSelf = self
            healthStepCountManager.requestAuthrationStepCount(completion: { (success, error) in
                if(success){
                    //读取当天的步数
                    weakSelf?.healthStepCountManager.readStepCountsFromDevice(completion: { (totalStepCounts, error) in
                        if let _ = error  {
                            return
                        }
                        DispatchQueue.main.async {
                            var totalString = "今天的步数是："
                            totalString += String(describing: totalStepCounts)
                            weakSelf?.stepCountsLabel.text = totalString
                        }
                    })
                }else{
                    weakSelf?.showAlertWithMessage(message: "获取步数失败")
                }
            })
        }else{
            showAlertWithMessage(message: "当前设备不支持healkit")
        }
    }

    func showAlertWithMessage(message:String) {
        let alertController = UIAlertController(title: "温馨提示", message: message, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

