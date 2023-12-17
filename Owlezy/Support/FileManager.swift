//
//  FileManager.swift
//  Owlezy
//
//  Created by man on 16/12/23.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}

