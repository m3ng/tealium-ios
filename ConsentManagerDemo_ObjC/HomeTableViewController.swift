//
//  HomeTableViewController.swift
//  ConsentManagerDemo_ObjC
//
//  Created by Jonathan Wong on 5/25/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    let consentManager = TealiumHelper.shared.tealium.consentManager
    var consentStatusText = ""
    var consentedCategoriesText = ""
    let consentedCategoriesFont = UIFont.systemFont(ofSize: 17.0)
    let padding = 16.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let consentStatusString = TEALConsentManager.consentStatusString(consentManager.consentStatus)
        consentStatusText = "Consent Status: \(consentStatusString)"
        
        if let categories = consentManager.consentedCategoryNames() as? [String] {
            consentedCategoriesText = "Consented Categories: \(categories.joined(separator: ", "))"
        } else {
            consentedCategoriesText = "Consented Categories:"
        }
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 3
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            TealiumHelper.shared.trackView(title: "HomeTableViewController", dataSources: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        } else if indexPath.section == 1 {
//            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PreferencesListViewController")
//            navigationController?.pushViewController(controller, animated: true)
            if indexPath.row == 2 {

            }
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let footerView = UIView(frame: tableView.frame)
            footerView.backgroundColor = UIColor.orange
            
            let categoriesLabel = UILabel(frame: footerView.frame)
            categoriesLabel.numberOfLines = 0
            categoriesLabel.lineBreakMode = .byWordWrapping
            categoriesLabel.font = consentedCategoriesFont
            categoriesLabel.text = consentedCategoriesText
            
            let height = labelHeight(text: consentedCategoriesText, font: consentedCategoriesFont)
            footerView.frame.size.height = height
            categoriesLabel.frame.size.height = height
            
//            categoriesLabel.translatesAutoresizingMaskIntoConstraints = false
            footerView.addSubview(categoriesLabel)

//            let constraint1 = NSLayoutConstraint(item: categoriesLabel, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
//            let constraint2 = NSLayoutConstraint(item: categoriesLabel, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
//
//            categoriesLabel.addConstraints([constraint1, constraint2])
            
            return footerView
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return labelHeight(text: consentedCategoriesText, font: consentedCategoriesFont)
        } else {
            return 0
        }
    }
    
    func labelHeight(text: String, font: UIFont) -> CGFloat {
        let label = UILabel(frame: view.frame)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.size.height
    }
}
