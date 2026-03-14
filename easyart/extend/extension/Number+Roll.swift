//
//  Number+Roll.swift
//  Menses
//
//  Created by Damon on 2020/9/11.
//  Copyright © 2020 Damon. All rights reserved.
//

import Foundation
import RxSwift

protocol RollAble {
    func roll(to: Self, timeInterval: TimeInterval, rollCount: Int, callback: @escaping ((Self, Bool)->Void)) -> Void
}

extension Int: RollAble {
    func roll(to: Int, timeInterval: TimeInterval = 2.0, rollCount: Int = 100, callback: @escaping ((Int, Bool)->Void)) {
        if to > self {
            var from = self
            //转一百次
            let time = timeInterval/Double(rollCount) * 1000
            let addCount = Int(ceil(Double(to - from) / Double(rollCount)))

            var disposeBag = DisposeBag()

            _ = Observable<Int>.timer(DispatchTimeInterval.milliseconds(0), period: DispatchTimeInterval.milliseconds(Int(time)), scheduler: MainScheduler.instance).subscribe(onNext: { (_) in
                from = from + addCount
                if from >= to {
                    from = to
                    disposeBag = DisposeBag()
                     callback(from, true)
                } else {
                     callback(from, false)
                }
            }).disposed(by: disposeBag)
        } else {
            callback(to, true)
        }
    }
}

extension Double: RollAble {
    func roll(to: Double, timeInterval: TimeInterval = 2.0, rollCount: Int = 100,  callback: @escaping ((Double, Bool)->Void)) {
        if to > self {
            var from = self
            let time = timeInterval/Double(rollCount) * 1000
            let addCount = max((to - from) / Double(rollCount), 0.1)
            var disposeBag = DisposeBag()

            _ = Observable<Int>.timer(DispatchTimeInterval.milliseconds(0), period: DispatchTimeInterval.milliseconds(Int(time)), scheduler: MainScheduler.instance).subscribe(onNext: { (_) in
                from = from + addCount
                if from >= to {
                    from = to
                    disposeBag = DisposeBag()
                    callback(from, true)
                } else {
                    callback(from, false)
                }
            }).disposed(by: disposeBag)
        } else {
            callback(to, true)
        }
    }
}


