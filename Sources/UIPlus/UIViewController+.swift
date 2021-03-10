//
//  UIViewController+.swift
//  
//
//  Created by Li-Heng Hsu on 2021/3/10.
//

import UIKit
import Combine

public enum UIPlusError: Error {
    case viewControllerReleased
}

public extension UIViewController {

    @available(iOS 13.0, *)
    func alertPublisher<Output>(
        title: String?,
        message: String?,
        preferredStyle: UIAlertController.Style,
        actions: [AlertAction<Output>]
    ) -> Future<Output, Error> {
    
        return Future { [weak self] completion in
            guard let self = self else {
                completion(.failure(UIPlusError.viewControllerReleased))
                  return
            }
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: preferredStyle
            )
            
            actions.lazy
                .map { builder in
                    UIAlertAction(title: builder.title, style: builder.style) { _ in
                        do {
                            completion(.success(try builder.handler()))
                        } catch {
                            completion(.failure(error))
                        }
                    }
                }
                .forEach { action in
                    
                    alert.addAction(action)
                }
            self.present(alert, animated: true)
        }
    }
}

public struct AlertAction<Output> {
    public init(title: String?, style: UIAlertAction.Style, handler: @escaping () throws -> Output) {
        self.title = title
        self.style = style
        self.handler = handler
    }
    

    var title: String?
    var style: UIAlertAction.Style
    var handler: () throws -> Output
}


