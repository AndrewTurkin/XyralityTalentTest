//
//  ViewController.swift
//  XyralityTalentTest
//
//  Created by Andrew Turkin on 2/18/16.
//  Copyright © 2016 andrew.turkin. All rights reserved.
//

import UIKit

class Worlds: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let WorldCellId = "WorldCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let nib = UINib(nibName: WorldCellId, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: WorldCellId)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
    }
    
    var worlds:[World]?

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(WorldCellId, forIndexPath: indexPath) as! WorldCell
        
        guard let worlds = self.worlds else {
            assertionFailure("Attempt to create cell while worlds not initialized")
            abort()
        }
        
        let world = worlds[indexPath.row]
        
        cell.nameLabel.text = world.name
        cell.countryLabel.text = world.country
        cell.statusLabel.text = world.status
        
        return cell
        
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let worlds = self.worlds {
            return worlds.count
        }
        return 0
    }

}

