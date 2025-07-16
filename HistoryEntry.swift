//
//  HistoryEntry.swift
//  ScanEmotion
//
//  Created by Nursel Kırca on 21.06.2025.
//

import Foundation

struct HistoryEntry: Codable, Identifiable {
    let id: UUID
    let date: Date
    let level: Int
}

