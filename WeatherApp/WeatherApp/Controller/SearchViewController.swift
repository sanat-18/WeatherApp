//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Sanat S Salian on 17/04/24.
//

import Foundation
import UIKit

protocol SearchViewControllerDelegate: AnyObject {
    func fetchWeatherForCity(_ name: String)
}

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var navbar: UINavigationBar!
    
    weak var delegate: SearchViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.layer.cornerRadius = 10
        searchTextfield.placeholder = String(localized: "SEARCH")
        setNavigationBar()
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        if searchTextfield.text != kEmptyString {
            delegate?.fetchWeatherForCity(searchTextfield.text ?? kEmptyString)
            dismiss(animated: true, completion: nil)
        } else {
            searchTextfield.placeholder = String(localized: "PLEASE_ENTER_CITY_NAME")
        }
    }
    
    private func setNavigationBar(){
        navbar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
        let navItem = UINavigationItem(title: String(localized: "SEARCH_CITY"))
        let backButton = UIButton(type: .system)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white

        navbar.standardAppearance = appearance
        navbar.scrollEdgeAppearance = appearance
        
        let buttonAttributedString = NSMutableAttributedString(string: String(localized: "CANCEL"), attributes: [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)] as [NSAttributedString.Key: Any])
        backButton.setAttributedTitle(buttonAttributedString, for: [])
        
        backButton.addTarget(self, action: #selector (backTapped), for: .allTouchEvents)
        
        let navBarButton = UIBarButtonItem(customView: backButton)
        navItem.leftBarButtonItem = navBarButton
        navbar.items = [navItem]
    }
    
    @objc func backTapped(){
        dismiss(animated: true, completion: nil)
    }
    
}
