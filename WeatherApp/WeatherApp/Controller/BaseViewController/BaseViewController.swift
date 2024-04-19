//
//  BaseViewController.swift
//  WeatherApp
//
//  Created by Sanat S Salian on 18/04/24.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {

    var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }

    func startActivityIndicator() {
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
    }

    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    
    func showAlertWithTitle(_ title: String, message: String, leftButtonTitle: String,rightButtonTitle: String, completionHandler:((_ isLeftButtonTapped: Bool) ->Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
        let messageFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        
        let titleAttrString = NSMutableAttributedString(string: title, attributes: titleFont)
        let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
        
        alert.setValue(titleAttrString, forKey: "attributedTitle")
        alert.setValue(messageAttrString, forKey: "attributedMessage")
        
        let leftAction = UIAlertAction(title: leftButtonTitle, style: .default) { action in
            if let handler = completionHandler{
                handler(true)
            }
        }
        
        let rightAction = UIAlertAction(title: rightButtonTitle, style: .default) { action in
            if let handler = completionHandler{
                handler(false)
            }
        }
        alert.addAction(leftAction)
        alert.addAction(rightAction)
        self.present(alert, animated: true, completion: nil)
    }

  
}
