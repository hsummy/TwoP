//
//  BathroomAddedTableViewController.swift
//  TwoP
//
//  Created by HSummy on 2/1/17.
//  Copyright © 2017 HSummy. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation



class BathroomAddedTableViewController: UITableViewController, UITextFieldDelegate {

    
    @IBOutlet weak var dateAddedTextField: DatePickerTextField!
    @IBOutlet weak var bathroomDescriptionText: UITableViewCell!
    
    
    @IBOutlet weak var openingHourTextField: DatePickerTextField!
    
    @IBOutlet weak var closingHourTextField: DatePickerTextField!
    
    
    @IBOutlet weak var stallCountAmtLabel: UILabel!
    @IBOutlet weak var stallStepper: UIStepper!

    @IBOutlet weak var urinalCountAmt: UILabel!
    @IBOutlet weak var urinalStepper: UIStepper!

    
    @IBOutlet weak var extraNotesText: UITableViewCell!
    

    @IBOutlet weak var bathroomAddress: UILabel!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UIView!
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        dateAddedTextField.style = .date
        
        let textFields = [
            dateAddedTextField,
            openingHourTextField,
            closingHourTextField
        ]
        
        for textField in textFields {
            textField?.delegate = self
        }
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source



    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Private
    func getContext() -> NSManagedObjectContext
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //HNS - referring the value of persistentContainer in AppDelegate, then accessing viewContext
        return appDelegate.persistentContainer.viewContext
    }
    
    func saveBathroomToCoreData()
    {
        let context = getContext()
        //HNS - my Entity is Bathroom (class).
        //let entity = NSEntityDescription.entity(forEntityName: "Bathroom", in: context)
        //let entity = NSEntityDescription.insertNewObject(forEntityName: "Bathroom", into: context)
        //HNS - my managed objects are the attributes associated with Bathroom
        let aBathroom = Bathroom(context: context)
        
        
        
        //HNS - below hardcoded items wil be replaced with managedBathroomObject.setValue(gender, forKeyPath "gender") etc....
        aBathroom.bathroomDescription = "The Iron Yard"
        aBathroom.gender = "Male"
        aBathroom.bathroomType = "Public"
        aBathroom.handicapAccess = true
        // aBathroom.openingTime = picker.date
        
        // aBathroom.closingTime = picker
        //managedBathroomObject.setValue("Employees Only", forKey: "bathroomType")
        aBathroom.flushRating = 4
        // aBathroom.dateRated = picker
        aBathroom.safe = true
        // aBathroom.placemark = ?
        aBathroom.extraNotes = "Clean most of the time. Some mishapes from time to time."
        aBathroom.stallCount = 0
        aBathroom.urinalCount = 0
        aBathroom.changingTable = true
        aBathroom.latitude = -81.00
        aBathroom.longitude = 23.00
        aBathroom.bathroomAddress = "jdajf;d"
        
        do{
            try context.save()
            print("Data saved!")
        } catch {
            print(error.localizedDescription)
        }
        
    }

//MARK: IBActions
    

    @IBAction func stallStepperValueChanged(_ sender: UIStepper)
    {
        stallCountAmtLabel.text = String(sender.value)


    }
    

}
