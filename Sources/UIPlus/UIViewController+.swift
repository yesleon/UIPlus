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
        textFieldHandlers: [(UITextField, UIAlertController) -> Void],
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
            textFieldHandlers.forEach { handler in
                alert.addTextField { textField in
                    handler(textField, alert)
                }
            }
            actions.lazy
                .map { builder in
                    UIAlertAction(title: builder.title, style: builder.style) { action in
                        do {
                            completion(.success(try builder.handler(alert.textFields ?? [])))
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
    public init(title: String?, style: UIAlertAction.Style, handler: @escaping ([UITextField]) throws -> Output) {
        self.title = title
        self.style = style
        self.handler = handler
    }
    

    var title: String?
    var style: UIAlertAction.Style
    var handler: ([UITextField]) throws -> Output
}


