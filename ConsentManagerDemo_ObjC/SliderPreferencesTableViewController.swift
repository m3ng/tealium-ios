//
//  SliderPreferencesTableViewController.swift
//  ConsentManagerDemo_ObjC
//
//  Created by Jonathan Wong on 5/29/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import UIKit

struct ConsentGroup {
    let name: String
    let categories: [String]
}

class SliderPreferencesTableViewController: UITableViewController {

    @IBOutlet weak var consentStatusLabel: UILabel!
    @IBOutlet weak var consentedCategoriesLabel: UILabel!
    @IBOutlet weak var consentStatusSlider: UISlider!
    @IBOutlet weak var consentLevelLabel: UILabel!
    
    var consentSliderValue: Int = 0
    var consentGroups = [ConsentGroup]()
    
    let consentManager = TealiumHelper.shared.tealium.consentManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Slider Preferences"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        setupConsentGroups()
        updateConsentStatusSlider()
        updateConsentStatusLabel()
        updateConsentLevelLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupConsentGroups() {
        consentGroups.append(ConsentGroup(name: "Off", categories: []))
        consentGroups.append(ConsentGroup(name: "Performance", categories: ["analytics", "monitoring", "big_data", "mobile", "crm"]))
        consentGroups.append(ConsentGroup(name: "Marketing", categories: ["analytics", "monitoring", "big_data", "mobile", "crm", "affiliates", "email", "search", "engagement", "cdp"]))
        consentGroups.append(ConsentGroup(name: "Personalized Advertising", categories: ["analytics", "monitoring", "big_data", "mobile", "crm", "affiliates", "email", "search", "engagement", "cdp", "display_ads", "personalization", "social", "cookiematch", "misc"]))
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return 2
        } else {
            return 0
        }
    }

    func updateConsentStatusLabel() {
        let consentStatusString = TEALConsentManager.consentStatusString(consentManager.consentStatus)
        consentStatusLabel.text = "Consent Status: \(consentStatusString)"
    }
    
    func updateConsentedCategoriesLabel(index: Int) {
        consentedCategoriesLabel.text = "Consent Status: \(consentGroups[index].categories.joined(separator: ", "))"
    }
    
    func updateConsentLevelLabel() {
        if consentSliderValue == 0 {
            consentLevelLabel.text = "Consent Level: \(consentGroups[0].name)"
        } else if consentSliderValue == 1 {
            consentLevelLabel.text = "Consent Level: \(consentGroups[1].name)"
        } else if consentSliderValue == 2 {
            consentLevelLabel.text = "Consent Level: \(consentGroups[2].name)"
        } else if consentSliderValue == 3 {
            consentLevelLabel.text = "Consent Level: \(consentGroups[3].name)"
        } else {
            consentLevelLabel.text = "Consent Level"
        }
    }
    
    @IBAction func onConsentSliderChange(_ sender: UISlider) {
        let index = Int(sender.value + 0.5)
        sender.setValue(Float(index), animated: false)
        consentSliderValue = index
        
        updateConsent(consentIndex: index)
    }
    
    func updateConsent(consentIndex: Int) {
        switch consentIndex {
        case 0:
            consentManager.updateConsentStatus(TEALConsentStatus.NotConsented)
        case 1:
            consentManager.updateConsentStatus(TEALConsentStatus.Consented)
        case 2:
            consentManager.updateConsentStatus(TEALConsentStatus.Consented)
        case 3:
            consentManager.updateConsentStatus(TEALConsentStatus.Consented)
        default:
            consentManager.updateConsentStatus(TEALConsentStatus.Unknown)
        }
        consentManager.updateConsentedCategoryNames(consentGroups[consentIndex].categories)
        updateConsentStatusLabel()
        updateConsentLevelLabel()
        updateConsentedCategoriesLabel(index: consentIndex)
    }
    
    func updateConsentStatusSlider() {
        switch consentManager.consentStatus {
        case .NotConsented, .Unknown, .Disabled:
            let index = 0
            consentStatusSlider.setValue(Float(index), animated: false)
            consentManager.updateConsentedCategoryNames(consentGroups[index].categories)
                    updateConsentedCategoriesLabel(index: index)
            consentSliderValue = 0
        case .Consented:
            let index = 3
            consentStatusSlider.setValue(Float(index), animated: false)
            consentManager.updateConsentedCategoryNames(consentGroups[index].categories)
                    updateConsentedCategoriesLabel(index: index)
            consentSliderValue = index
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
