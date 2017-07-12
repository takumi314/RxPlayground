//: Playground - noun: a place where people can play

import UIKit
import RxCocoa
import RxSwift
import PlaygroundSupport

var str = "Hello, playground"

/*
 
 # Int型の排出するシーケンス

 */

let firstObservaable = Observable<Int>
    .create { observer in
        observer.on(.next(1))
        observer.onNext(2)
        observer.onCompleted()

        return Disposables.create()
    }

