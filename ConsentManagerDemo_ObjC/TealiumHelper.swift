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
        self.tealium = Tealium.newInstance(forKey: "1", configuration: configuration)
        self.tealium.setConsentManagerDelegate(self)
        print("\(TEALConsentManager.consentStatusString(self.tealium.consentManager.consentStatus))")
    }
    
    static func start() {
        _ = TealiumHelper.shared
    }
    
    func trackView(title: String, dataSources: [AnyHashable: Any]?) {
        tealium.trackView(withTitle: title, dataSources: dataSources)
    }
}

extension TealiumHelper: TEALConsentManagerDelegate {
    func consentManagerWillChange(withState consentStatus: TEALConsentStatus) {
        print(#function)
        print("\(TEALConsentManager.consentStatusString(consentStatus))")
    }
    
    func consentManagerDidChange(withState consentStatus: TEALConsentStatus) {
        print(#function)
        print("\(consentStatus)")
    }
    
    func consentManagerDidUpdateConsentedCategoryNames(_ categoryNames: [Any]?) {
        print(#function)
        print("\(String(describing: categoryNames))")
    }
}
