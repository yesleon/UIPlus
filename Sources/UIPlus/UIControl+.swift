//
//  UIControl+.swift
//  
//
//  Created by Li-Heng Hsu on 2021/3/10.
//

import Foundation
import Combine

public protocol EventHandling { }

#if !os(macOS)
import UIKit

extension UIControl.Event: Hashable { }

extension UIControl: EventHandling {
    
    fileprivate class ActionTarget<T: EventHandling>: NSObject {
        var actions: [(T) -> Void] = []
        @objc func handleEvent(_ sender: Any) {
            actions.forEach { $0(sender as! T) }
        }
    }
    
    fileprivate static var targets = [ObjectIdentifier: [Event: Any]]()
}

public extension EventHandling where Self: UIControl {
    
    @available(iOS 13.0, *)
    func publisher(for controlEvents: Event) -> AnyPublisher<Self, Never> {
        let subject = PassthroughSubject<Self, Never>()
        addAction(for: controlEvents, handler: subject.send)
        return subject.eraseToAnyPublisher()
    }
    
    func addAction(for controlEvents: Event, handler: @escaping (Self) -> Void) {
        let target = Self.targets[ObjectIdentifier(self), default: [:]][controlEvents, default: ActionTarget<Self>()] as! ActionTarget<Self>
        addTarget(target, action: #selector(target.handleEvent(_:)), for: controlEvents)
        target.actions.append(handler)
    }
    
    func removeAction(for controlEvents: Event) {
        let target = Self.targets[ObjectIdentifier(self), default: [:]][controlEvents, default: ActionTarget<Self>()] as! ActionTarget<Self>
        removeTarget(target, action: #selector(ActionTarget<Self>.handleEvent(_:)), for: controlEvents)
        Self.targets[ObjectIdentifier(self), default: [:]][controlEvents] = nil
    }
}

extension UIBarButtonItem: EventHandling {
    fileprivate class ActionTarget<T: EventHandling>: NSObject {
        var actions: [(T) -> Void] = []
        @objc func handleEvent(_ sender: Any) {
            actions.forEach { $0(sender as! T) }
        }
    }
    fileprivate static var targets = [ObjectIdentifier: Any]()
}

public extension EventHandling where Self: UIBarButtonItem {
    
    @available(iOS 13.0, *)
    func publisher() -> AnyPublisher<Self, Never> {
        let subject = PassthroughSubject<Self, Never>()
        addAction(handler: subject.send)
        return subject.eraseToAnyPublisher()
    }
    
    func addAction(handler: @escaping (Self) -> Void) {
        let target = Self.targets[.init(self), default: ActionTarget<Self>()] as! ActionTarget<Self>
        target.actions.append(handler)
        self.target = target
        self.action = #selector(target.handleEvent(_:))
    }
    
    func removeActions() {
        Self.targets[.init(self)] = nil
        self.target = nil
        self.action = nil
    }
}

#endif
