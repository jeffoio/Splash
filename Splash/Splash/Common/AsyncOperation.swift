//
//  AsyncOperation.swift
//  Splash
//
//  Created by TakHyun Jung on 2022/01/07.
//

import Foundation

class AsyncOperation: Operation {
    enum State: String {
        case ready
        case executing
        case finished
        
        fileprivate var keyPath: String {
            return "is\(self.rawValue.capitalized)"
        }
    }
    
    var state = State.ready {
        willSet {
            self.willChangeValue(forKey: newValue.keyPath) // change to excuting
            self.willChangeValue(forKey: state.keyPath) // 현재 상태가 변경될 것임
        }
        didSet {
            self.didChangeValue(forKey: oldValue.keyPath) // ready상태가 변경되었음
            self.didChangeValue(forKey: state.keyPath) //excuting으로 변경완료
        }
    }

    override var isReady: Bool {
        return super.isReady && self.state == .ready
    }
    
    override var isExecuting: Bool {
        return self.state == .executing
    }
    
    override var isFinished: Bool {
        return self.state == .finished
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override func start() {
        if self.isCancelled {
            self.state = .finished
            return
        }
        self.main()
        self.state = .executing
    }
    
    override func cancel() {
        super.cancel()
        self.state = .finished
    }
}
