//
//  BaseViewController.swift
//  WeatherApp
//
//  Created by Sanat S Salian on 18/04/24.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {

    var activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func handleError(_ error: DemoError) -> Void{
       stopActivityIndicator()
        switch error {
        case .BadURL:
            showAlertWithTitle(String(localized: "ERROR"), message: String(localized: "BAD_URL"), buttonTitle: String(localized: "OK"), completionHandler: nil)
        case .DecodingError:
            showAlertWithTitle(String(localized: "ERROR"), message: String(localized: "DECODING_ERROR"), buttonTitle: String(localized: "OK"), completionHandler: nil)
        case .NoData:
            showAlertWithTitle(String(localized: "ERROR"), message: String(localized: "NO_DATA"), buttonTitle: String(localized: "OK"), completionHandler: nil)
            
        }
    }
    
    func showAlertWithTitle(_ title: String, message: String, buttonTitle: String, completionHandler: (() -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
        let messageFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        
        let titleAttrString = NSMutableAttributedString(string: title, attributes: titleFont)
        let messageAttrString = NSMutableAttributedString(string: message, attributes: messageFont)
        
        alert.setValue(titleAttrString, forKey: "attributedTitle")
        alert.setValue(messageAttrString, forKey: "attributedMessage")
        
        let action = UIAlertAction(title: buttonTitle, style: .default) { action in
            if let handler = completionHandler{
                handler()
            }
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
