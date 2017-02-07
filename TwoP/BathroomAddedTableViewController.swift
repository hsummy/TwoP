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

enum Row: Int
{
    case dateAddedRow
    case dateAddedPickerRow
    case bathroomDescriptionRow
    case flushRatingRow
    case safeRow
    case genderRow
    case bathroomTypeRow
    case handicapRow
    case daysRow
    case openingTimeRow
    case openingTimePickerRow
    case closingTimeRow
    case closingTimePickerRow
    case stallRow
    case urinalRow
    case changingTableRow
    case extraNotesRow
    case bathroomAddressRow
    case latitudeRow
    case longitudeRow
    
    
    case unknown
    
    init(indexPath: IndexPath)
    {
        var row = Row.unknown
        
        switch (indexPath.section, indexPath.row)
        {
        case (0,0):
            row = Row.dateAddedRow
        case (0,1):
            row = Row.dateAddedPickerRow
        case (5,1):
            row = Row.openingTimeRow
        case (5,2):
            row = Row.openingTimePickerRow
        case (5,3):
            row = Row.closingTimeRow
        case (5,4):
            row = Row.closingTimePickerRow
        default: break
        }

        
        self = row
    }
}


class BathroomAddedTableViewController: UITableViewController, UITextFieldDelegate, CLLocationManagerDelegate {

    
    
    @IBOutlet weak var dateAddedLabel: UILabel!
    @IBOutlet weak var dateAddedPicker: UIDatePicker!
    
    @IBOutlet weak var bathroomDescriptionText: UITextField!
    
    @IBOutlet weak var flushRatingSegment: UISegmentedControl!
    
    
    
    
    
    

    @IBOutlet weak var MSUN: UIButton!
    
    @IBOutlet weak var openingHourTextField: UILabel!
    @IBOutlet weak var openingHourTimePicker: UIDatePicker!
    @IBOutlet weak var closingHourTextField: UILabel!
    @IBOutlet weak var closingHourTimePicker: UIDatePicker!
   
    @IBOutlet weak var stallCountAmtLabel: UILabel!
    @IBOutlet weak var stallStepper: UIStepper!
    @IBOutlet weak var urinalCountAmtLabel: UILabel!
    @IBOutlet weak var urinalStepper: UIStepper!
    
    @IBOutlet weak var extraNotesText: UITableViewCell!
    

    @IBOutlet weak var bathroomAddressDetail: UILabel!
    @IBOutlet weak var latitudeDetail: UILabel!
    @IBOutlet weak var longitudeDetail: UILabel!
    
    var datePickerHidden = false
    
    
    var bathroomLocationInfo = [String: String]()
    
    /* - ?????for days of the week buttons?
 let calendar = NSCalendar.currentCalendar()
 let date = NSDate()
 let dateComponent =  calendar.components(NSCalendarUnit.CalendarUnitWeekday, fromDate: date)
 let weekday = dateComponent.weekday
 */
 
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        toggleDatePicker()
        

        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        bathroomAddressDetail.text = bathroomLocationInfo["address"]
        latitudeDetail.text = bathroomLocationInfo["latitude"]
        longitudeDetail.text = bathroomLocationInfo["longitude"]
        
    }
    


    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
       
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return false
    }
    
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
        // aBathroom.dateRated = picker
        aBathroom.bathroomDescription = ""
        aBathroom.flushRating = 4
        aBathroom.safe = true
        aBathroom.gender = ""
        aBathroom.bathroomType = ""
        aBathroom.handicapAccess = true
        // aBathroom.openingTime = picker.date
        // aBathroom.closingTime = picker
        //managedBathroomObject.setValue("Employees Only", forKey: "bathroomType")
        aBathroom.stallCount = 0
        aBathroom.urinalCount = 0
        aBathroom.changingTable = true
        aBathroom.extraNotes = "Clean most of the time. Some mishapes from time to time."
        aBathroom.bathroomAddress = bathroomLocationInfo["address"]
        aBathroom.latitude = Double(bathroomLocationInfo["latitude"]!)!
        aBathroom.longitude = Double(bathroomLocationInfo["longitude"]!)!
        // aBathroom.placemark = ?
        
        do{
            try context.save()
            print("Data saved!")
        } catch {
            print(error.localizedDescription)
        }
        
    }


    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let row = Row(indexPath: indexPath)
        
        if row == .dateAddedRow
        {
            toggleDatePicker()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let row = Row(indexPath: indexPath)
        
        switch row
        {
        case .dateAddedPickerRow:
            if datePickerHidden
            {
                return 0
            }
            else
            {
                return super.tableView(tableView, heightForRowAt: indexPath)
            }
        default: return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    func toggleDatePicker()
    {
        datePickerHidden = !datePickerHidden
        
        // Forces tableview to update itself
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
   
//MARK: IBActions - Bar Buttons
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem)
    {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem)
    {
        //HNS !!!!!Need to add 'place pin X' when saved.
        saveBathroomToCoreData()
        dismiss(animated: true, completion: nil)
        
    }
    
//MARK: IBActions - Date and Time Pickers - Date and When can...
    
    @IBAction func didChangeDateAdded(_ sender: UIDatePicker)
    {//convert this dateinto a string.
        dateAddedLabel.text = DateFormatter.localizedString(from: dateAddedPicker.date, dateStyle: .short, timeStyle: .short)
        
    }

//MARK: IBActions - How was it...
    
    @IBAction func flushRatingSegmentButton(_ sender: UISegmentedControl)
    {
        
    }

    
    @IBAction func safeSwitch(_ sender: UISwitch)
    {
        
    }
    
   //MARK: IBActions - Who can...
    @IBAction func genderSegmentButton(_ sender: UISegmentedControl)
    {
        
    }
    
    @IBAction func bathroomTypeSegmentButton(_ sender: UISegmentedControl)
    {
        
    }
    

    @IBAction func handicapSegmentChanged(_ sender: UISegmentedControl)
    {
        
    }
    
 //MARK: IBActions - BONUS
    @IBAction func stallStepperValueChanged(_ sender: UIStepper)
    {
        _ = sender.superview
        _ = Int16(sender.value)
        stallCountAmtLabel.text = String(sender.value)
    }
    

    @IBAction func urinalStepperValueChanged(_ sender: UIStepper)
    {
        _ = sender.superview
        _ = Int16(sender.value)
        urinalCountAmtLabel.text = String(sender.value)
    }
    
    @IBAction func changingTableSwitch(_ sender: UISwitch)
    {
        
    }

//MARK: IBActions - Notes
    
    
    @IBAction func extraNotes(_ sender: UITextField)
    {
        dismiss(animated: true, completion: nil)
    }

}
