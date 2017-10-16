//
//  HealthKitStepCountManager.swift
//  SampleStepCounts
//
//  Created by 贾小燕 on 2017/10/16.
//  Copyright © 2017年 xiaoyanJia. All rights reserved.
//

import UIKit
import HealthKit

class HealthKitStepCountManager: NSObject {
    var healthStore = HKHealthStore()

    func isHealthDataAvilabel() -> Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    func requestAuthrationStepCount(completion: @escaping (Bool, Error?) -> Swift.Void) {
        let hkObjectType = HKObjectType.quantityType(forIdentifier:.stepCount)
        let healthSet = Set.init(arrayLiteral: hkObjectType!)
        //从健康中获取步数权限
        healthStore.requestAuthorization(toShare: nil, read: healthSet, completion: { (success, error) in
            completion(success,error)
        })
    }
    func readStepCountsFromDevice(completion: @escaping (Int64, Error?) -> Swift.Void) {
        //初始化步数类型
        let hkObjectType = HKObjectType.quantityType(forIdentifier:.stepCount)
        let now = Date()
        let calendar = NSCalendar.current
        //获取今天的凌晨零点，获取到的值是UTC时间
        let startDate = calendar.startOfDay(for: now)
        let endDate = startDate.addingTimeInterval(86400)
        //条件查询，设置起始和终止时间点
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        //查询结果排序
        let sortStart = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)
        let sortEnd = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: true)
        //查询的时候HKSampleQuery会自动将UTC时间转化为本地时间，进行查询
        let sampleStepCountQuery = HKSampleQuery(sampleType: hkObjectType!, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortStart,sortEnd]) { (query,results,error) in
            var totalSteps = Int64(0)
            for quantitySample in results! {
                if let quantitySample = quantitySample as? HKQuantitySample
                {
                    print(quantitySample)
                    let quantity = quantitySample.quantity
                    let step = quantity.doubleValue(for: HKUnit.count())
                    totalSteps += Int64(step)
                }
            }
            completion(totalSteps , error)
        }
        //执行查询，每个HKQuery实例只执行一次，避免抛异常
        healthStore.execute(sampleStepCountQuery)
    }
}
