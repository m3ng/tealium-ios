//
//  SimplePreferencesTableViewController.swift
//  ConsentManagerDemo_ObjC
//
//  Created by Jonathan Wong on 5/25/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import UIKit

class SimplePreferencesTableViewController: UITableViewController {

    @IBOutlet weak var consentStatusLabel: UILabel!
    @IBOutlet weak var consentedCategoriesLabel: UILabel!
    @IBOutlet weak var consentStatusSwitch: UISwitch!
    
    let consentManager = TealiumHelper.shared.tealium.consentManager
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Simple Preferences"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        updateConsentStatusLabel()
        updateConsentStatus()
        updateConsentedCategoriesLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return 1
        } else {
            return 0
        }
    }
    
    func updateConsentStatusLabel() {
        let consentStatusString = TEALConsentManager.consentStatusString(consentManager.consentStatus)
        consentStatusLabel.text = "Consent Status: \(consentStatusString)"
    }

    func updateConsentStatus() {
        if consentManager.consentStatus == TEALConsentStatus.Consented {
            consentStatusSwitch.isOn = true
        } else {
            consentStatusSwitch.isOn = false
        }
    }
    
    func updateConsentedCategoriesLabel() {
        if consentManager.consentStatus == TEALConsentStatus.Consented {
            guard let consentedCategoryNames = consentManager.consentedCategoryNames() as? [String] else {
                return
            }
            
            consentedCategoriesLabel.text = "Current Categories: \(consentedCategoryNames.joined(separator: ", "))"
        } else {
            consentedCategoriesLabel.text = "Current Categories: "
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func onConsentStatusSwitchChange(_ sender: UISwitch) {
        let enabled = sender.isOn
        
        if enabled {
            consentManager.updateConsentStatus(TEALConsentStatus.Consented)
            consentManager.updateConsentedCategoryNames(consentManager.acceptableCategoryNames())
        } else {
            consentManager.updateConsentStatus(TEALConsentStatus.NotConsented)
            consentManager.removeConsentedCategories()
        }
        
        updateConsentStatusLabel()
        updateConsentedCategoriesLabel()
    }
}
