//
//  UIViewcontroller+Utility.swift
//  WeatherApp
//
//  Created by Sanat S Salian on 17/04/24.
//

import Foundation
import UIKit

extension UIViewController{
    
    class func searchViewController() -> UIViewController {
        return UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: "SearchViewController")
    }
    
}
