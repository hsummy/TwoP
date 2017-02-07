//
//  CoreDataManager.swift
//  TwoP
//
//  Created by HSummy on 1/30/17.
//  Copyright © 2017 HSummy. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject
{
    //?????ask if i should make this 'private'
    
    static let sharedInstance = CoreDataManager()
  
    func getContext() -> NSManagedObjectContext
    {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
    //HNS - referring the value of persistentContainer in AppDelegate, then accessing viewContext
    return appDelegate.persistentContainer.viewContext
    }
    
    func fetchObject()
    {
    let context = getContext()
        
    let requestBathroomObject = NSFetchRequest<NSFetchRequestResult>(entityName: "Bathroom")
     //HNS - see the object back as how i stored it above.
    requestBathroomObject.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(requestBathroomObject)
            
            if results.count > 0
            {
                for result in results as! [Bathroom]
                {
                    if let bathroomAddress = result.bathroomAddress
                    {
                       print(bathroomAddress)
                    }
                    if let bathroomDescription = result.bathroomDescription
                    {
                        print(bathroomDescription)

                    }
                    if let bathroomType = result.value(forKey: "bathroomType") as? String
                    {
                        print(bathroomType)
                    }
                    if let changingTable = result.value(forKey: "changingTable") as? Bool
                    {
                        print(changingTable)
                    }
                    
                    if let closingTime = result.value(forKey: "closingTime") as? Date
                    {
                        print(closingTime)
                    }
                    if let dateRated = result.value(forKey: "dateRated") as? Date
                    {
                        print(dateRated)
                    }
                    if let extraNotes = result.value(forKey: "extraNotes") as? String
                    {
                        print(extraNotes)
                    }
                    if let flushRating = result.value(forKey: "flushRating") as? Int16
                    {
                        print(flushRating)
                    }

                    if let gender = result.value(forKey: "gender") as? String
                    {
                        print(gender)
                    }
                    if let handicapAccess = result.value(forKey: "handicapAccess") as? Bool
                    {
                        print(handicapAccess)
                    }
                    if let latitude = result.value(forKey: "latitude") as? Double
                    {
                        print(latitude)
                    }
                    if let longitude = result.value(forKey: "longitude") as? Double
                    {
                        print(longitude)
                    }
                    if let openingTime = result.value(forKey: "openingTime") as? Date
                    {
                        print(openingTime)
                    }
                   // if let placemark = result.value(forKey: "placemark") as? CATransformLayer
                   // {
                   //     print(placemark)
                    //}
                    if let safe = result.value(forKey: "safe") as? Bool
                    {
                        print(safe)
                    }
                    if let stallCount = result.value(forKey: "stallCount") as? Int16
                    {
                        print(stallCount)
                    }
                    if let urinalCount = result.value(forKey: "urinalCount") as? Int16
                    {
                        print(urinalCount)
                    }
                    if let monday = result.value(forKey: "monday") as? String
                    {
                        print(monday)
                    }
                    if let tuesday = result.value(forKey: "tuesday") as? String
                    {
                        print(tuesday)
                    }
                    if let wednesday = result.value(forKey: "wednesday") as? String
                    {
                        print(wednesday)
                    }
                    if let thursday = result.value(forKey: "thursday") as? String
                    {
                        print(thursday)
                    }
                    if let friday = result.value(forKey: "friday") as? String
                    {
                        print(friday)
                    }
                    if let saturday = result.value(forKey: "saturday") as? String
                    {
                        print(saturday)
                    }
                    if let sunday = result.value(forKey: "sunday") as? String
                    {
                        print(sunday)
                    }
                }
            }
        }catch{
        print(error.localizedDescription) 
        }
        
    }//end of FetchObject class
    
    
}//end of CoreDataManager class
