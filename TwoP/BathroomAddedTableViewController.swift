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
    
    @IBOutlet weak var safeLabel: UILabel!
    @IBOutlet weak var safeSwitchButton: UISwitch!
    

    @IBOutlet weak var genderSegmentButton: UISegmentedControl!
    @IBOutlet weak var bathroomTypeSegmentButton: UISegmentedControl!
    @IBOutlet weak var handicapAccessSegmentButton: UISegmentedControl!
    
    @IBOutlet weak var mondayButton: UIButton!
    @IBOutlet weak var tuesdayButton: UIButton!
    @IBOutlet weak var wednesdayButton: UIButton!
    @IBOutlet weak var thursdayButton: UIButton!
    @IBOutlet weak var fridayButton: UIButton!
    @IBOutlet weak var saturdayButton: UIButton!
    @IBOutlet weak var sundayButton: UIButton!
    
    
    @IBOutlet weak var openingHourTextField: UILabel!
    @IBOutlet weak var openingHourTimePicker: UIDatePicker!
    @IBOutlet weak var closingHourTextField: UILabel!
    @IBOutlet weak var closingHourTimePicker: UIDatePicker!
   
    @IBOutlet weak var stallCountAmtLabel: UILabel!
    @IBOutlet weak var stallStepper: UIStepper!
    @IBOutlet weak var urinalCountAmtLabel: UILabel!
    @IBOutlet weak var urinalStepper: UIStepper!

    @IBOutlet weak var changingTableLabel: UILabel!
    @IBOutlet weak var changingTableSwitchButton: UISwitch!
    
    @IBOutlet weak var extraNotesText: UITextField!

    @IBOutlet weak var bathroomAddressDetail: UILabel!
    @IBOutlet weak var latitudeDetail: UILabel!
    @IBOutlet weak var longitudeDetail: UILabel!
    
    var datePickerHidden = false
    var openTimePickerHidden = false
    var closeTimePickerHidden = false
    
    var bathroomLocationInfo = [String: AnyObject]()
    //var bathrooms = [Bathroom]()
    
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
        bathroomDescriptionText.delegate = self
        extraNotesText.delegate = self
        mondayButton.layer.cornerRadius = 4
        tuesdayButton.layer.cornerRadius = 4
        wednesdayButton.layer.cornerRadius = 4
        thursdayButton.layer.cornerRadius = 4
        fridayButton.layer.cornerRadius = 4
        saturdayButton.layer.cornerRadius = 4
        sundayButton.layer.cornerRadius = 4
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        bathroomAddressDetail.text = bathroomLocationInfo["address"] as? String
        let latitude = bathroomLocationInfo["latitude"] as! Double
        let longitude = bathroomLocationInfo["longitude"] as! Double
        latitudeDetail.text = String(format: "%.4f", latitude)
        longitudeDetail.text = String(format: "%.4f", longitude)
        dateAddedLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
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
        aBathroom.dateAdded = dateAddedPicker.date as NSDate?
        aBathroom.bathroomDescription = bathroomDescriptionText?.text
        aBathroom.flushRating = Int16(flushRatingSegment.selectedSegmentIndex)
        aBathroom.safe = safeSwitchButton.isOn
        //HNS - storying gender/bathroomtype/handicap as an INT since i used a segment button, instead of String
        aBathroom.gender = Int16(genderSegmentButton.selectedSegmentIndex)
        aBathroom.bathroomType = Int16(bathroomTypeSegmentButton.selectedSegmentIndex)
        aBathroom.handicapAccess = Int16(handicapAccessSegmentButton.selectedSegmentIndex)
        aBathroom.monday = mondayButton.isSelected
        aBathroom.tuesday = tuesdayButton.isSelected
        aBathroom.wednesday = wednesdayButton.isSelected
        aBathroom.thursday = thursdayButton.isSelected
        aBathroom.friday = fridayButton.isSelected
        aBathroom.saturday = saturdayButton.isSelected
        aBathroom.sunday = sundayButton.isSelected
        aBathroom.openingTime = openingHourTimePicker.date as NSDate?
        aBathroom.closingTime = closingHourTimePicker.date as NSDate?
        aBathroom.stallCount = Int16(stallStepper.stepValue)
        aBathroom.urinalCount = Int16(urinalStepper.stepValue)
        aBathroom.changingTable = changingTableSwitchButton.isOn
        aBathroom.extraNotes = extraNotesText?.text
        aBathroom.bathroomAddress = bathroomLocationInfo["address"] as! String?
        aBathroom.latitude = bathroomLocationInfo["latitude"] as! Double
        aBathroom.longitude = bathroomLocationInfo["longitude"] as! Double
        //aBathroom.placemark = do not need since using lat and long.
        
        do{
            try context.save()
            print("Data saved!")
        } catch {
            //print(error.localizedDescription)
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
    }//end of saveBathroomtoCoreData function


    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let row = Row(indexPath: indexPath)
        
        if row == .dateAddedRow
        {
            toggleDatePicker()
        }
        if row == .openingTimeRow
        {
            toggleOpenTimePicker()
        }
        if row == .closingTimeRow
        {
            toggleCloseTimePicker()
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
        case .openingTimePickerRow:
            if openTimePickerHidden
            {
                return 0
            }
            else
            {
                return super.tableView(tableView, heightForRowAt: indexPath)
            }
        case .closingTimePickerRow:
            if closeTimePickerHidden
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
        
        //HNS - Forces tableview to update itself
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func toggleOpenTimePicker()
    {
        openTimePickerHidden = !openTimePickerHidden
        
        //HNS - Forces tableview to update itself
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func toggleCloseTimePicker()
    {
        closeTimePickerHidden = !closeTimePickerHidden
        
        //HNS - Forces tableview to update itself
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
        dateAddedLabel.text = DateFormatter.localizedString(from: dateAddedPicker.date, dateStyle: .short, timeStyle: .none)
        
    }

//MARK: IBActions - How was it...
    
    @IBAction func flushRatingSegmentButton(_ sender: UISegmentedControl)
    {
        
    }

    @IBAction func safeSwitch(_ sender: UISwitch)
    {
        if safeSwitchButton.isOn == true
        {
        safeLabel.text = "Safe!"
        }else{
        safeLabel.text = "NOT Safe!"
        }
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
//MARK: IBActions - When can...
    @IBAction func daysOfWeekButtons(_ sender: UIButton)
    {
        
        sender.isSelected = !sender.isSelected
        if sender.isSelected
        {
            sender.backgroundColor = UIColor(hue: 29/360, saturation: 58/100, brightness: 44/100, alpha: 1.0)
        }
        else
        {
            sender.backgroundColor = UIColor(hue: 49/360, saturation: 54/100, brightness: 96/100, alpha: 1.0)
        }
    }
    
 //MARK: IBActions - BONUS
    @IBAction func stallStepperValueChanged(_ sender: UIStepper)
    {
        _ = sender.superview
        let countAsInt = Int16(sender.value)
        stallCountAmtLabel.text = "\(countAsInt)"
    }
    
    @IBAction func urinalStepperValueChanged(_ sender: UIStepper)
    {
        _ = sender.superview
        let countAsInt = Int16(sender.value)
        urinalCountAmtLabel.text = "\(countAsInt)"
    }
    
    @IBAction func changingTableSwitch(_ sender: UISwitch)
    {
        if changingTableSwitchButton.isOn == true
        {
            changingTableLabel.text = "Changing Table!"
        }else{
            changingTableLabel.text = "NO Changing Table!"
        }
    }
    

//MARK: IBActions - Notes
    @IBAction func extraNotes(_ sender: UITextField)
    {
        dismiss(animated: true, completion: nil)
    }

}//end of class BathroomAddedTableViewController
