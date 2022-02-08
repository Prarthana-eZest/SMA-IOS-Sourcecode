//
//  ExtensionEncodable.swift
//  Enrich_SMA
//
//  Created by Harshal on 08/02/22.
//  Copyright © 2022 e-zest. All rights reserved.
//

import Foundation
extension Encodable {

  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
  }

}
