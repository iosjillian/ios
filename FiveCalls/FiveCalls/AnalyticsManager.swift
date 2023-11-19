//
//  AnalyticsManager.swift
//  FiveCalls
//
//  Created by Nick O'Neill on 5/29/19.
//  Copyright © 2019 5calls. All rights reserved.
//

import Foundation
import PlausibleSwift

class AnalyticsManager {
    static let shared = AnalyticsManager()
    private var plausible: PlausibleSwift?
    
    private init() {
        plausible = try? PlausibleSwift(domain: "5calls.org")
    }
        
    var callerID: String {
        if let cid = UserDefaults.standard.string(forKey: UserDefaultsKey.callerID.rawValue) {
            return cid
        }
        
        let cid = UUID()
        UserDefaults.standard.setValue(cid.uuidString, forKey: UserDefaultsKey.callerID.rawValue)
        return cid.uuidString
    }
    
    func trackPageview(path: String, properties: [String: String] = .init()) {
        #if !DEBUG
        let alwaysUseProperties: [String: String] = ["isIOSApp": "true"]
        try? plausible?.trackPageview(path: path, properties: properties.merging(alwaysUseProperties) { _, new in new })
        #endif
    }
    
    func trackEvent(name: String, path: String, properties: [String: String] = .init()) {
        #if !DEBUG
        let alwaysUseProperties: [String: String] = ["isIOSApp": "true"]
        try? plausible?.trackEvent(event: name, path: path, properties: properties.merging(alwaysUseProperties) { _, new in new })
        #endif
    }
        
    func trackError(error: Error) {
        // no remote error tracking right now
    }
}
