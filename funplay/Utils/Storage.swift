//
//  Storage.swift
//  funplay
//
//  Created by Adriano Paladini on 14/02/2018.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation

open class Storage {
    public class func save(key: String, value: String) {
        let defaults = UserDefaults.standard
        defaults.setValue(value, forKey: key)
        defaults.synchronize()
    }
    public class func get(key: String) -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: key)
    }
    public class func delete(key: String) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
        defaults.synchronize()
    }
    public class func clear() {
        let defaults = UserDefaults.standard
        let appDomain = Bundle.main.bundleIdentifier!
        defaults.removePersistentDomain(forName: appDomain)
    }
}
