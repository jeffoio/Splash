//
//  Observable.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/04.
//
import Foundation

final class Observable<T> {
    struct Observer<T> {
        weak var observer: AnyObject?
        let block: (T) -> Void
    }

    private var observers = [Observer<T>]()
    var value: T {
        didSet {
            self.notifyObservers()
        }
    }

    init(_ value: T) {
        self.value = value
    }

    func observe(on observer: AnyObject, observerBlock: @escaping (T) -> Void) {
        self.observers.append(Observer(observer: observer, block: observerBlock))
    }
}

private extension Observable {
    func notifyObservers() {
        for observer in observers {
            DispatchQueue.main.async {
                observer.block(self.value)
            }
        }
    }
}

