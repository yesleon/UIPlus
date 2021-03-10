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
        handler: @escaping (UIAlertController, @escaping (Result<Output, Error>) -> Void) -> Void
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
            handler(alert, completion)
            self.present(alert, animated: true)
        }
    }
    
}

