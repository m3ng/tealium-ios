//
//  PreferencesListViewController.swift
//  ConsentManagerDemo_ObjC
//
//  Created by Jonathan Wong on 5/25/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import UIKit

class Preference {
    let name: String
    var enabled: Bool
    let helpText: String
    let categoryName: String
    
    init(name: String, enabled: Bool, helpText: String, categoryName: String) {
        self.name = name
        self.enabled = enabled
        self.helpText = helpText
        self.categoryName = categoryName
    }
}

class PreferencesListViewController: UITableViewController {

    let consentManager = TealiumHelper.shared.tealium.consentManager
    var titles = [String]()
    var preferences = [Preference]()
    var filteredCategoryNames = [String]()
    var categoryIndexPaths = [IndexPath]()
    
    enum Section: Int {
        case consent
        case settings
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPreferences()
        setupTitles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTitles() {
        let consentStatusString = TEALConsentManager.consentStatusString(consentManager.consentStatus)
        titles.append("Consent Status: \(consentStatusString)")
        categoryNames()
        titles.append("Current categories: \(filteredCategoryNames.joined(separator: ", "))")
    }
    
    func categoryNames() {
        filteredCategoryNames = preferences.filter { preference in
            preference.enabled == true && !preference.categoryName.isEmpty
            }.map { p in
                return p.categoryName
        }
        consentManager.updateConsentedCategoryNames(filteredCategoryNames)
    }
    
    func setupPreferences() {
        let consentedCategoryNames = consentManager.consentedCategoryNames() as? [String]
        
        preferences.append(Preference(name: "Consent Status", enabled: consentManager.isConsented(), helpText: "We would like to collect data about your app experience to help us improve our products. Please choose your preferences.", categoryName: ""))
        
        preferences.append(Preference(name: "Analytics", enabled: consentedCategoryNames?.contains("analytics") ?? false, helpText: "Help us improve your experience.", categoryName: "analytics"))
        preferences.append(Preference(name: "Affiliates", enabled: consentedCategoryNames?.contains("affiliates") ?? false, helpText: "Earn credit for shopping with us.", categoryName: "affiliates"))
        preferences.append(Preference(name: "Display Ads", enabled: consentedCategoryNames?.contains("display_ads") ?? false, helpText: "Help us improve the ads you see.", categoryName: "display_ads"))
        preferences.append(Preference(name: "Email", enabled: consentedCategoryNames?.contains("email") ?? false, helpText: "Allows email marketing tools.", categoryName: "email"))
        preferences.append(Preference(name: "Personalization", enabled: consentedCategoryNames?.contains("personalization") ?? false, helpText: "Let us tailor your app experience.", categoryName: "personalization"))
        preferences.append(Preference(name: "Search", enabled: consentedCategoryNames?.contains("search") ?? false, helpText: "Helps optimize search results.", categoryName: "search"))
        preferences.append(Preference(name: "Social", enabled: consentedCategoryNames?.contains("social") ?? false, helpText: "Social media advertising.", categoryName: "social"))
        preferences.append(Preference(name: "Big Data", enabled: consentedCategoryNames?.contains("big_data") ?? false, helpText: "Helps us better understand our customers.", categoryName: "big_data"))
        preferences.append(Preference(name: "Mobile", enabled: consentedCategoryNames?.contains("mobile") ?? false, helpText: "Optimizes your mobile experience.", categoryName: "mobile"))
        preferences.append(Preference(name: "Engagement", enabled: consentedCategoryNames?.contains("engagement") ?? false, helpText: "Keep in touch with us.", categoryName: "engagement"))
        preferences.append(Preference(name: "Monitoring", enabled: consentedCategoryNames?.contains("monitoring") ?? false, helpText: "Lets us know when things are broken.", categoryName: "monitoring"))
        preferences.append(Preference(name: "CDP", enabled: consentedCategoryNames?.contains("cdp") ?? false, helpText: "Helps us understand your individual needs.", categoryName: "cdp"))
        preferences.append(Preference(name: "CRM", enabled: consentedCategoryNames?.contains("crm") ?? false, helpText: "Helps us keep track of your purchase history.", categoryName: "crm"))
        preferences.append(Preference(name: "Cookie Match", enabled: consentedCategoryNames?.contains("cookiematch") ?? false, helpText: "Required for personalized ads.", categoryName: "cookiematch"))
        preferences.append(Preference(name: "Misc", enabled: consentedCategoryNames?.contains("misc") ?? false, helpText: "Misc items that help us build a better app experience.", categoryName: "misc"))
        
        for row in 1...preferences.count - 1 {
            categoryIndexPaths.append(IndexPath(row: row, section: Section.settings.rawValue))
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == Section.consent.rawValue {
            return 2
        } else if section == Section.settings.rawValue {
            return preferences.count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == Section.consent.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell") as! TitleTableViewCell
            let title = titles[indexPath.row]
            cell.title = title
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchTableViewCell") as! SwitchTableViewCell
            let preference = preferences[indexPath.row]
            cell.preference = preference
            cell.enabled.addTarget(self, action: #selector(onSwitchChanged(_:)), for: .valueChanged)
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
//        let cell = tableView.cellForRow(at: indexPath) as! SwitchTableViewCell
//            cell.enabled
        }
        print(indexPath)
    }

    @objc func onSwitchChanged(_ sender: UISwitch) {
        guard let cell = sender.superview?.superview as? SwitchTableViewCell, let indexPath = tableView.indexPath(for: cell) else {
            return
        }

        let preference = preferences[indexPath.row]
        preference.enabled = sender.isOn
        
        if preference.name == "Consent Status" {
            if preference.enabled {
                consentManager.updateConsentStatus(TEALConsentStatus.Consented)
            } else {
                consentManager.updateConsentStatus(TEALConsentStatus.NotConsented)
            }
            
            preferences.forEach { p in
                p.enabled = sender.isOn
            }
            
            updateConsentStatusLabel()
            updateConsentCategoriesLabel()
            tableView.reloadRows(at: categoryIndexPaths, with: .automatic)
        } else {
            if preference.enabled {
                // Update to Consented if needed
                if !consentManager.isConsented() {
                    consentManager.updateConsentStatus(TEALConsentStatus.Consented)
                    updateConsentStatusLabel()
                    preferences[0].enabled = true
                    tableView.reloadRows(at: [IndexPath(row: 0, section: Section.settings.rawValue)], with: .automatic)
                }
            }
            updateConsentCategoriesLabel()
        }
    }
    
    func updateConsentStatusLabel() {
        let consentStatusString = TEALConsentManager.consentStatusString(consentManager.consentStatus)
        titles[0] = "Consent Status: \(consentStatusString)"
        tableView.reloadRows(at: [IndexPath(row: 0, section: Section.consent.rawValue)], with: .automatic)
    }
    
    func updateConsentCategoriesLabel() {
        categoryNames()
        titles[1] = "Current categories: \(filteredCategoryNames.joined(separator: ", "))"
        tableView.reloadRows(at: [IndexPath(row: 1, section: Section.consent.rawValue)], with: .automatic)
    }
}
