//
//  ExtentionUserDefaults.swift
//  EnrichSalon
//
//  Created by Apple on 23/03/19.
//  Copyright © 2019 Aman Gupta. All rights reserved.
//

// How To use
/*struct Dummy: Codable {
    let value1 = "V1"
    let value2 = "V2"
}

// Save
UserDefaults.standard.set(encodable: Dummy(), forKey: "K1")

// Load
let dummy = UserDefaults.standard.value(Dummy.self, forKey: "K1")*/

import Foundation

extension UserDefaults {
func set<T: Encodable>(encodable: T, forKey key: String) {
    if let data = try? JSONEncoder().encode(encodable) {
        set(data, forKey: key)
    }
}

func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
    if let data = object(forKey: key) as? Data,
        let value = try? JSONDecoder().decode(type, from: data) {
        return value
    }
    return nil
}
}
