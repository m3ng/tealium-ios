//
//  TealiumHelper.swift
//  ConsentManagerDemo_ObjC
//
//  Created by Jonathan Wong on 5/25/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import Foundation

class TealiumHelper: NSObject {
    
    static let shared = TealiumHelper()
    
    let configuration = TEALConfiguration(account: "services-jonwong", profile: "mobile", environment: "dev")
    var tealium: Tealium!
    
    override private init() {
        super.init()
        configuration.logLevel = TEALLogLevel.dev
        // optionally set consent manager properties on initialization of Tealium instance
        configuration.enableConsentManager = true
        configuration.userConsentStatus = .Consented
        configuration.userConsentCategories = ["analytics", "big_data"]
        
        self.tealium = Tealium.newInstance(forKey: "1", configuration: configuration)
        self.tealium.setConsentManagerDelegate(self)
        self.tealium.consentManager.setConsentLoggingEnabled(true)
        print("\(TEALConsentManager.consentStatusString(self.tealium.consentManager.userConsentStatus))")
    }
    
    static func start() {
        _ = TealiumHelper.shared
    }
    
    func trackView(title: String, dataSources: [AnyHashable: Any]?) {
        tealium.trackView(withTitle: title, dataSources: dataSources)
    }
}

extension TealiumHelper: TEALConsentManagerDelegate {
    func consentManagerDidChange(withState consentStatus: TEALConsentStatus) {
        print(#function)
        print("🕵🏻‍♂️\(consentStatus)")
    }
    
    func consentManagerDidUpdateConsentCategories(_ categories: [Any]?) {
        print(#function)
        print("🕵🏻‍♂️\(String(describing: categories))")
    }
    
    func consentManagerWillDrop(_ dispatch: TEALDispatch?) {
        print(#function)
        guard let dispatch = dispatch else {
            return
        }
        print("🕵🏻‍♂️\(dispatch)")
    }
    
    func consentManagerWillQueue(_ dispatch: TEALDispatch?) {
        print(#function)
        guard let dispatch = dispatch else {
            return
        }
        print("🕵🏻‍♂️\(dispatch)")
    }
}
