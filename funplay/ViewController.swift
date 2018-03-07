//
//  ViewController.swift
//  funplay
//
//  Created by Adriano Paladini on 14/02/2018.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var loggedUser: LoggedUser?
    var myRiders: [Rider] = []
    var myNotifications: [Notification] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        API.showDebugLog = true

        loginUser()
    }

    func loginUser() {
        API.login(user: "adpalad@br.ibm.com", pwd: "7752Senha70") { res in
            guard let user = res else { return self.loginError() }
            API.saveUserToken(user.token)
            self.loggedUser = user
            self.getMyRiders()
            self.getNotifications()
        }
    }

    func loginError() {
        print("LOGIN ERROR 😭")
    }

    func getMyRiders() {
        API.listMyRides() { res in
            guard let riders = res else { return self.myRiders = [] }
            self.myRiders = riders
            self.rideDetails(rideId: self.myRiders.first?.ride_id ?? "")
        }
    }

    func getNotifications() {
        API.notifications { res in
            guard let notifications = res else { return self.myNotifications = [] }
            self.myNotifications = notifications

            self.profile(userId: notifications.first?.user_id ?? "")
        }
    }

    func rideDetails(rideId: String) {
        API.rideDetails(rideId: rideId) { res in
            guard let ride = res else { return }
            print(ride)
        }
    }

    func profile(userId: String) {
        API.profile(userId: userId) { res in
            guard let user = res else { return }
            print(user)
        }
    }


}

