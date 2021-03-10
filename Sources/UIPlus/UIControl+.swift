//
//  UIControl+.swift
//  
//
//  Created by Li-Heng Hsu on 2021/3/10.
//

import Foundation
import Combine

public protocol EventHandling {
    
}

#if !os(macOS)
import UIKit


extension UIControl: EventHandling {
    
    
    
    class ActionTarget<T>: NSObject {
        init(action: @escaping (T) -> Void) {
            self.action = action
        }
        let action: (T) -> Void
        @objc func handleEvent(_ sender: Any) {
            action(sender as! T)
        }
    }
    static var targets = [Any]()
}
public extension EventHandling where Self: UIControl {
    
    @available(iOS 13.0, *)
    func publisher(for controlEvents: Event) -> AnyPublisher<Self, Never> {
        let subject = PassthroughSubject<Self, Never>()
        addAction(for: controlEvents, handler: subject.send)
        return subject.eraseToAnyPublisher()
    }
    
    func addAction(for controlEvents: Event, handler: @escaping (Self) -> Void) {
        let target = ActionTarget(action: handler)
        addTarget(target, action: #selector(target.handleEvent(_:)), for: controlEvents)
        Self.targets.append(target)
    }
    
    func removeAction(for controlEvents: Event) {
        removeTarget(nil, action: #selector(ActionTarget<Self>.handleEvent(_:)), for: controlEvents)
    }
}

#endif
