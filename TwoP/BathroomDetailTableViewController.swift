//
//  BathroomDetailTableViewController.swift
//  TwoP
//
//  Created by HSummy on 2/1/17.
//  Copyright © 2017 HSummy. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation


class BathroomDetailTableViewController: UITableViewController
{
    

    @IBOutlet weak var bathroomDescriptionDetailLabel: UILabel!
    @IBOutlet weak var flushRatingDetailLabel: UILabel!
    @IBOutlet weak var safeDetailLabel: UILabel!
    @IBOutlet weak var dateAddedDetailLabel: UILabel!
    @IBOutlet weak var genderDetailLabel: UILabel!
    @IBOutlet weak var bathroomTypeDetailLabel: UILabel!
    @IBOutlet weak var handicapDetailLabel: UILabel!
    @IBOutlet weak var stallDetailLabel: UILabel!
    @IBOutlet weak var urinalDetailLabel: UILabel!
    @IBOutlet weak var openingTimeDetailLabel: UILabel!
    @IBOutlet weak var closingTimeDetailLabel: UILabel!
    @IBOutlet weak var extraNotesDetailLabel: UILabel!
    @IBOutlet weak var bathroomAddressDetailLabel: UILabel!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        
        return 7
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {

        return 0
    }
    //HNS - not allowing the user to Edit (false) the Read Only items at this time.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    
        return false
    }
 



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

}// end of class BathroomDetailTableViewController
