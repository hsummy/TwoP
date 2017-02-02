//
//  AppState.swift
//  TwoP
//
//  Created by HSummy on 1/25/17.
//  Copyright © 2017 HSummy. All rights reserved.
//

import Foundation
import CoreData


class AppState
{
    //creating a 'Singleton' code to store data for login info on user.
    static let sharedInstance = AppState()
    
    
    var signedIn = false
    var coreEmail: String!
    var corePassword: String!
    
    
}
