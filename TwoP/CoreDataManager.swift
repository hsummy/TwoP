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
        
    //HNS - storing object in our core data. then Calling it into BathroomDetailViewController in viewDidLoad.
    //https://www.youtube.com/watch?v=zZJpsszfTHM
    //https://www.raywenderlich.com/145809/getting-started-core-data-tutorial
    func StoreObject()
{
    let context = getContext()
    //HNS - my Entity is Bathroom (class).
    //let entity = NSEntityDescription.entity(forEntityName: "Bathroom", in: context)
    //let entity = NSEntityDescription.insertNewObject(forEntityName: "Bathroom", into: context)
    //HNS - my managed objects are the attributes associated with Bathroom. Replaced managedUserObject with user.
    let aUser = User(context: context)
    let aBathroom = Bathroom(context: context)
    //HNS - replaced managedUserObject.setValue with user.
    aUser.email = "email"
    aUser.password = "password"

    
    //HNS - below hardcoded items wil be replaced with managedBathroomObject.setValue(gender, forKeyPath "gender") etc....
    aBathroom.bathroomDescription = "The Iron Yard"
    //above replaced below.
   //managedBathroomObject.setValue("The Iron Yard", forKey: "bathroomDescription")
    aBathroom.bathroomDescription = "The Iron Yard"
    aBathroom.gender = "All"
    aBathroom.bathroomType = "Employees Only"
    aBathroom.handicapAccess = true
    //aBathroom.openingTime = Date
    //aBathroom.closingTime = Date
    aBathroom.flushRating = 4
    //aBathroom.dateRated = Date
    aBathroom.safe = true
    aBathroom.extraNotes = "Clean most of the time. Some mishapes from time to time."
    
    do{
        try context.save()
        //HNS - add later managedBathroomObjects.append(bathroom) after you add var managedBathroomObjects: [NSManagedObject] = []?
        print("Data saved!")
    } catch {
        print(error.localizedDescription)        
    }
    
}//end of StoreObject class
    
    func FetchObject()
    {
    let context = getContext()
        
    let requestBathroomObject = NSFetchRequest<NSFetchRequestResult>(entityName: "Bathroom")
     //HNS - see the object back as how i stored it above.
    requestBathroomObject.returnsObjectsAsFaults = false
        
        do{
            let results = try context.fetch(requestBathroomObject)
            
            if results.count > 0
            {
                for result in results as! [NSManagedObject]
                {
                    if let bathroomDescription = result.value(forKey: "bathroomDescription") as? String
                    {
                       print(bathroomDescription)
                    }
                    if let gender = result.value(forKey: "gender") as? String
                    {
                        print(gender)
                    }
                    if let bathroomType = result.value(forKey: "bathroomType") as? String
                    {
                        print(bathroomType)
                    }
                    if let extraNotes = result.value(forKey: "extraNotes") as? String
                    {
                        print(extraNotes)
                    }
                    if let flushRating = result.value(forKey: "flushRating") as? String
                    {
                        print(flushRating)
                    }

                }
            }
        }catch{
        print(error.localizedDescription) 
        }
        
    }//end of FetchObject class
    
    
}//end of CoreDataManager class
