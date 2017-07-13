//: Playground - noun: a place where people can play

import UIKit
import RxSwift
import RxCocoa
import PlaygroundSupport


/*
 
 # Intro to Schedulers
 
 - This chapter will cover the beauty behind schedulers, 
 where you’ll learn why the Rx abstraction is so powerful and 
 why working with 'asynchronous' programming is far less less 
 painful than using locks or queues.


 */


/// 
PlaygroundPage.current.needsIndefiniteExecution = true



struct Session {
    static func send<T: Request>(_ request: T) -> Observable<T.Response> {
        let observable = Observable<T.Response>.create { observer in
            let task = Session.send(request, callbackQueue: .main, handler: { result in
                switch result {
                case .success(let value):
                    observer.on(.next(value))
                    observer.onCompleted()

                case .failure(let error):
                    if (error as NSError).code == URLError.cancelled.rawValue {
                        observer.onCompleted()
                        break
                    }
                    observer.onError(error)
                }
            })
            return Disposables.create(with: {
                task?.cancel()
            })
        }
        return observable.take(1)
    }

    static func cancelRequest<T: Request>(with type: T.Type) {
        Session.cancelRequests(with: type)
    }
}
