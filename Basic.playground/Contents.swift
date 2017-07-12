//: Playground - noun: a place where people can play

import UIKit
import RxCocoa
import RxSwift
import PlaygroundSupport

var str = "Hello, playground"


/*
 
 # 目標: Int型の排出するシーケンス Observable を排出する

 */

let firstObservaable = Observable<Int>
    .create { observer in
        observer.on(.next(1))
        observer.onNext(2)
        observer.on(.next(3))
        observer.on(.next(4))
        observer.onCompleted()

        return Disposables.create()
    }



/*
 
    Observable: ObservableType
 
    create() : Creates an observable sequence from a specified subscribe method implementation.
 

    クロージャ内では, 戻り値 (Disposable) を返さなくてはならない.
    
      >  create { (AnyObserver<E>) -> Disposable in  .... }


 */

let secondObservable = Observable<Int>
    .create { obsever in
        obsever.onNext(1)
        obsever.onNext(2)
        obsever.onNext(3)
        obsever.onCompleted()

        return Disposables.create()
    }


/*

 追記: 外部リソースを利用しているときは, 購読終了時にリソース解放が必要
 cf. 通信処理, データベースへのアクセス
 購読終了時に実行すべき処理を定義できる.

 */

let thirdObservable = Observable<Int>
    .create { obsever in
        obsever.onNext(1)
        obsever.onNext(2)
        obsever.onNext(3)
        obsever.onCompleted()

        let dispose = Disposables.create {
            // 終了時に実行される処理
            print("Done!")                  // 購読終了後に処理される
        }

        return dispose
}




/*

 # 目標: Observable を購読する

 */

let output: Disposable = firstObservaable
    .subscribe { event in
        print(event.element ?? "" )
}

print(output)


let output2: Disposable = secondObservable
    .subscribe { event in
        print(event.element ?? "" )
}



/*

    subscribe() : Subscribes an event handler to an observable sequence
 
    シーケンス Observable から排出された event を引数に,
    新しいイベントが発生するたびにクロージャが呼び出される.

        > subscribe { (RxSwift.Event<Self.E>) -> Swift.Void in  ...  }
 
 */


let _ = thirdObservable
    .subscribe { event in
        switch event {
        case .next(let element):
            print(element)
        case .completed:
            print("complted")
        case .error:
            print("error")
        }
    }
    .dispose()  // リソース解放

/*
 
    リソースを処分する. 
    - 戻り値:　なし

    /// Dispose resource

    func dispose() -> Void
 
 */





/*
    # 基本フロー

 
    Observable

        1.生成 create() -----> 2.排出 on() 

    Observable => Disposable
 
        3.購読 subscript()  -----> .next or .completed or .error

    Disposable
 
        4.処分 dispose
 
 */

