//
//  Extentions+Time.swift
//  Cinema
//
//  Created by Helen on 19.10.2023.
//

import Foundation

func minutesToHoursAndMinutes(_ minutes: Int) -> (hours: Int , leftMinutes: Int) {
    return (minutes / 60, (minutes % 60))
}
