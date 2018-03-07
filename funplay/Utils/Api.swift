//
//  Api.swift
//  funplay
//
//  Created by Adriano Paladini on 14/02/2018.
//  Copyright © 2018 IBM. All rights reserved.
//

import Foundation


open class API {

    // MARK: - Variables

    static var showDebugLog = false
    static private let baseUrl = "http://localhost:3000"
    static private var token = ""
    static private var task: URLRequest?


    // MARK: - Application API's

    static func login(user: String, pwd: String, completion: @escaping (LoggedUser?) -> Void) {
        let type = "POST"
        let params = ["username": user,
                      "password": pwd]
        let action = "authenticate"
        send(type, action, params) { result in
            guard result != nil,
                let tmp = try? JSONDecoder().decode(LoggedUser.self, from: result!)
                else { return completion(nil) }

            completion(tmp)
        }
    }

    static func findRide(from: geolocation, to: geolocation, date: String, completion: @escaping (Data?) -> Void) {
        let type = "GET"
        let params = ["lat_from": from.lat,
                      "long_from": from.lng,
                      "lat_to": to.lat,
                      "long_to": to.lng,
                      "date": date]
        let action = "ride/find"
        send(type, action, params) { data in
            completion(data)
        }
    }

    static func createRide(completion: @escaping (Data?) -> Void) {
        let type = "POST"
        let params = ["ride_type": "ride_type",
                      "date_start": "date_start",
                      "date_finish": "date_finish",
                      "quantity_slot": "quantity_slot",
                      "destination_primary": "destination_primary",
                      "destination_secondary": "destination_secondary",
                      "departure_primary": "departure_primary",
                      "departure_secondary": "departure_secondary",
                      "destination_long": "destination_long",
                      "departure_long": "departure_long",
                      "destination_lat": "destination_lat",
                      "departure_lat": "departure_lat"]
        let action = "ride/find"
        send(type, action, params) { data in
            completion(data)
        }
    }

    static func joinRide(rideId: String, completion: @escaping (Data?) -> Void) {
        let type = "POST"
        let action = "ride/join/\(rideId)"
        send(type, action, nil) { data in
            completion(data)
        }
    }

    static func leaveRide(rideId: String, completion: @escaping (Data?) -> Void) {
        let type = "POST"
        let action = "ride/leave/\(rideId)"
        send(type, action, nil) { data in
            completion(data)
        }
    }

    static func rideDetails(rideId: String, completion: @escaping (Rider?) -> Void) {
        let type = "GET"
        let action = "ride/\(rideId)"
        send(type, action, nil) { result in
            guard result != nil,
                let tmp = try? JSONDecoder().decode(Rider.self, from: result!)
                else { return completion(nil) }

            completion(tmp)
        }
    }

    static func notifications(completion: @escaping ([Notification]?) -> Void) {
        let type = "GET"
        let action = "notification"
        send(type, action, nil) { result in
            guard result != nil,
                let tmp = try? JSONDecoder().decode([Notification].self, from: result!)
                else { return completion(nil) }

            completion(tmp)
        }
    }

    static func approveRequest(rideId: String, userId: String, completion: @escaping (Data?) -> Void) {
        let type = "PUT"
        let action = "ride/approve/\(rideId)/\(userId)"
        send(type, action, nil) { data in
            completion(data)
        }
    }

    static func rejectRequest(rideId: String, userId: String, completion: @escaping (Data?) -> Void) {
        let type = "PUT"
        let action = "ride/reject/\(rideId)/\(userId)"
        send(type, action, nil) { data in
            completion(data)
        }
    }

    static func listMyRides(completion: @escaping ([Rider]?) -> Void) {
        let type = "GET"
        let action = "ride/list"
        send(type, action, nil) { result in
            guard result != nil,
                let tmp = try? JSONDecoder().decode([Rider].self, from: result!)
                else { return completion(nil) }

            completion(tmp)
        }
    }

    static func deleteMyRide(rideId: String, completion: @escaping (Data?) -> Void) {
        let type = "DELETE"
        let action = "ride/delete/\(rideId)"
        send(type, action, nil) { data in
            completion(data)
        }
    }

    static func profile(userId: String, completion: @escaping (Profile?) -> Void) {
        let type = "GET"
        let action = "ranking/\(userId)"
        send(type, action, nil) { result in
            guard result != nil,
                let tmp = try? JSONDecoder().decode(Profile.self, from: result!)
                else { return completion(nil) }

            completion(tmp)
        }
    }

    static func checkinRide(rideId: String, completion: @escaping (Data?) -> Void) {
        let type = "POST"
        let action = "ride/checkin/\(rideId)"
        send(type, action, nil) { data in
            completion(data)
        }
    }

    // MARK: - Internal functions

    static func saveUserToken(_ token: String) {
        self.token = token
    }

    static private func urlWithParams(_ action: String, _ params: [String: String]?) -> URL? {
        var urlObj = URLComponents(string: "\(self.baseUrl)/api/\(action)")
        guard let allParams = params else { return urlObj?.url }

        urlObj?.queryItems = []
        for (key, value) in allParams {
            urlObj?.queryItems?.append(URLQueryItem(name: key, value: value))
        }
        return urlObj?.url!
    }

    static private func send(_ type: String, _ action: String, _ params: [String: String]?, completion: @escaping (Data?) -> Void) {
        guard let apiUrl = urlWithParams(action, params) else { return }
        task = URLRequest(url: apiUrl)
        task?.httpMethod = type
        if self.token != "" {
            task?.setValue(self.token, forHTTPHeaderField: "X-Authtoken")
        }
        task?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        task?.timeoutInterval = 20
        let session = URLSession.shared
        session.dataTask(with: task!) { data, response, err in
            if self.showDebugLog {
                var debugString = ""
                if err == nil {
                    let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: [])
                    debugString = responseJSON.debugDescription
                } else {
                    debugString = err?.localizedDescription ?? ""
                }
                print("###### START ######\n\(apiUrl)\n##### RESPONSE #####\n\(debugString)\n####### END #######")
            }
            if err == nil,
                let response = response as? HTTPURLResponse,
                200..<300 ~= response.statusCode {
                DispatchQueue.main.async { completion(data) }
            } else {
                DispatchQueue.main.async { completion(nil) }
            }
        }.resume()
    }

}
