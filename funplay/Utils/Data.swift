//
//  Data.swift
//  funplay
//
//  Created by Adriano Paladini on 14/02/2018.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation

struct LoggedUser: Codable {
    let uid: String
    let email: String
    let token: String
    let user_id: String
    let name: String?
    let ranking_points: Int?
    let ranking_position: Int?
    let ranking_rides: Int?
}

struct Profile: Codable {
    let email: String
    let km: String
    let name: String
    let rank_pos: Int
    let rides: Int
    let total_points: String
    let uid: String
    let user_id: String
}

struct Rider: Codable {
    let approvals: [Approval]
    let date_finish: String
    let date_start: String
    let departure_lat: String
    let departure_long: String
    let departure_primary: String
    let departure_secondary: String
    let destination_lat: String
    let destination_long: String
    let destination_primary: String
    let destination_secondary: String
    let is_owner: Int
    let quantity_slot: Int
    let ride_id: String
    let ride_status: Int
    let ride_type_id: Int
    let unix: Double
}

struct Approval: Codable {
    let checkin: Bool
    let email: String
    let name: String
    let permission_type: Int
    let ranking_points: Int
    let ranking_position: Int
    let ranking_rides: Int
    let ride_id: String
    let telephone: Int
    let telephone_2: Int
    let uid: String
    let user_id: String
    let user_type: Int
}

struct Notification: Codable {
    let action: String
    let created: String
    let departure_primary: String
    let departure_secondary: String
    let destination_primary: String
    let destination_secondary: String
    let email: String
    let id: String
    let name: String
    let ride_id: String
    let ride_type_id: Int
    let uid: String
    let unix: Int
    let user_id: String
}
