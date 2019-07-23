//
//  ViewController.swift
//  NorthLoopAssignment
//
//  Created by Abhishek Vasudev on 22/07/19.
//  Copyright © 2019 Abhishek Vasudev. All rights reserved.
//

/*
 MUST READ:
 
 Requirements:
 
 Build An iOS app in swift that:
 
 Pulls data of all launches - filter out all launches before 2014
 
 The list of launches should show in a list as per the attached design, so instead of dominos or starbucks, it'll be the name of the capsule and instead of the price it'll be the date of launch
 
 In the element that says "Current Balance" replace it with "Total Launches" and display the total number of launches instead of "$234,ooo"
 
 Instead of "Good Evening, Philip", put in your name
 
 No menu bar is required
 
 Leverage this api to build out the following feature: If I tap on a launch from the list of launches, I should be able to see a simple popup (no major styling required) with the following details: flight_number, mission_name, mission_id
 
 
 
 
 DOUBTS:
 From the response we are not getting anything for capsule name, hence assuming rocketName to be capsule Name.
 Date of launch is present as both local and global, hence assuming the date of launch to be used is local, though I have parsed both values and global can be used as well
 Total number of launch can be understood as the total number of launch of filtered launches which is before 2014 or total number of launches till date, hence assuming it is total number of launches till date.

*/

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(rootView)
        getData()
        configure()
    }
    
    struct Launches: Codable {
        let flight_number: Int?
        let rocket: Rocket
        let launch_year: String?
        let launch_date_utc: String?
        let launch_date_local: String?
        let mission_name: String?
        let mission_id: [String?]
        let links: Links
    }
    
    struct Rocket: Codable {
        let rocket_id: String?
        let rocket_name: String?
    }
    
    struct Links: Codable {
        let mission_patch: String?
        let mission_patch_small: String?
    }
    
    var totalLaunchesData: String = ""
    
    var dataLoaded: Bool = false {
        didSet {
            totalLaunchesValue.text = totalLaunchesData
            self.tableView.reloadData()
        }
    }
    
    var check:[Launches] = []
    
    let rootView:UIView = {
        let view = UIView()
        view.accessibilityIdentifier = "rootView"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.9568068385, green: 0.957210958, blue: 0.9404107332, alpha: 1)
        return view
    }()
    
    let welcomeSectionView:UIView = {
        let view = UIView();
        view.accessibilityIdentifier = "welcomeSectionView"
        view.translatesAutoresizingMaskIntoConstraints = false;
        view.backgroundColor = #colorLiteral(red: 0.9502845407, green: 0.907390058, blue: 0.8068680763, alpha: 1)
        return view
    }()
    
    let nameLabel: UILabel = {
       let label = UILabel()
        label.accessibilityIdentifier = "nameLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Abhishek Vasudev"
        return label
    }()
    
    let masterDataView:UIView = {
        let view = UIView();
        view.accessibilityIdentifier = "masterDataView"
        view.translatesAutoresizingMaskIntoConstraints = false;
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        view.layer.cornerRadius = 40.0
        return view
    }()
    
    let totalLaunchesTitle: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = "totalLaunchesTitle"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Total Launches"
        return label
    }()
    
    let totalLaunchesValue: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = "totalLaunchesValue"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tableSectionView:UIView = {
        let view = UIView();
        view.accessibilityIdentifier = "tableSectionView"
        view.translatesAutoresizingMaskIntoConstraints = false;
        view.backgroundColor = #colorLiteral(red: 0.9528618455, green: 0.953145802, blue: 0.9446603656, alpha: 1)
        return view
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.accessibilityIdentifier = "tableView"
        table.translatesAutoresizingMaskIntoConstraints = false;
        table.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        table.estimatedRowHeight = 50
        table.rowHeight = UITableView.automaticDimension
        table.backgroundColor = #colorLiteral(red: 0.9568068385, green: 0.957210958, blue: 0.9404107332, alpha: 1)
        return table
    }()
    
    func configure() {

        rootView.addSubview(welcomeSectionView)
        rootView.addSubview(tableSectionView)
        
        welcomeSectionView.addSubview(nameLabel)
        welcomeSectionView.addSubview(masterDataView)
        
        masterDataView.addSubview(totalLaunchesTitle)
        masterDataView.addSubview(totalLaunchesValue)
        
        tableSectionView.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        activateConstraints()
  
    }
    
    
    func activateConstraints() {
        var constraints: [NSLayoutConstraint] = []        
        
        //rootView constraints
        constraints.append(rootView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor))
        constraints.append(rootView.topAnchor.constraint(equalTo: self.view.topAnchor))
        constraints.append(rootView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor))
        constraints.append(rootView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor))
        
        //welcomeSectionView constraints
        let welcomeSectionHeight = self.view.frame.height*(1/3)
        constraints.append(welcomeSectionView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor))
        //        The below commented constraint to handle if the top has to be as per readableCOntentGuide
        //        constraints.append(welcomeSectionView.topAnchor.constraint(equalTo: rootView.readableContentGuide.topAnchor))
        constraints.append(welcomeSectionView.topAnchor.constraint(equalTo: rootView.topAnchor))
        constraints.append(welcomeSectionView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor))
        constraints.append(welcomeSectionView.bottomAnchor.constraint(equalTo: tableSectionView.topAnchor))
        constraints.append(welcomeSectionView.heightAnchor.constraint(equalToConstant: welcomeSectionHeight))
        
        //nameLabel constraints
        constraints.append(nameLabel.leadingAnchor.constraint(equalTo: welcomeSectionView.leadingAnchor, constant: 20))
        constraints.append(nameLabel.topAnchor.constraint(greaterThanOrEqualTo: welcomeSectionView.readableContentGuide.topAnchor, constant: 20))
        constraints.append(nameLabel.trailingAnchor.constraint(equalTo: welcomeSectionView.trailingAnchor, constant: -20))
        constraints.append(nameLabel.bottomAnchor.constraint(equalTo: masterDataView.topAnchor, constant: -40))
        
        //masterDataView constraints
        constraints.append(masterDataView.leadingAnchor.constraint(equalTo: welcomeSectionView.leadingAnchor, constant: 20))
        constraints.append(masterDataView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 40))
        constraints.append(masterDataView.trailingAnchor.constraint(equalTo: welcomeSectionView.trailingAnchor, constant: -20))
        constraints.append(masterDataView.bottomAnchor.constraint(equalTo: welcomeSectionView.bottomAnchor, constant: -20))
        
        //totalLaunchesTitle constraints
        constraints.append(totalLaunchesTitle.leadingAnchor.constraint(equalTo: masterDataView.leadingAnchor, constant: 40))
        constraints.append(totalLaunchesTitle.topAnchor.constraint(equalTo: masterDataView.topAnchor, constant: 10))
        constraints.append(totalLaunchesTitle.trailingAnchor.constraint(equalTo: totalLaunchesValue.leadingAnchor, constant: -10))
        constraints.append(totalLaunchesTitle.bottomAnchor.constraint(equalTo: masterDataView.bottomAnchor, constant: -10))
        
        //totalLaunchesValue constraints
        constraints.append(totalLaunchesValue.leadingAnchor.constraint(equalTo: totalLaunchesTitle.trailingAnchor, constant: 10))
        constraints.append(totalLaunchesValue.topAnchor.constraint(equalTo: masterDataView.topAnchor, constant: 10))
        constraints.append(totalLaunchesValue.trailingAnchor.constraint(equalTo: masterDataView.trailingAnchor, constant: -40))
        constraints.append(totalLaunchesValue.bottomAnchor.constraint(equalTo: masterDataView.bottomAnchor, constant: -10))
        
        //tableSectionView constraints
        constraints.append(tableSectionView.leadingAnchor.constraint(equalTo: rootView.leadingAnchor))
        constraints.append(tableSectionView.topAnchor.constraint(equalTo: welcomeSectionView.bottomAnchor))
        constraints.append(tableSectionView.trailingAnchor.constraint(equalTo: rootView.trailingAnchor))
        constraints.append(tableSectionView.bottomAnchor.constraint(equalTo: rootView.readableContentGuide.bottomAnchor))
        
        //tableView constraints
        constraints.append(tableView.leadingAnchor.constraint(equalTo: tableSectionView.leadingAnchor))
        constraints.append(tableView.topAnchor.constraint(equalTo: tableSectionView.topAnchor))
        constraints.append(tableView.trailingAnchor.constraint(equalTo: tableSectionView.trailingAnchor))
        constraints.append(tableView.bottomAnchor.constraint(equalTo: tableSectionView.bottomAnchor))
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    


}


// TableView DataSource and Delegate
extension ViewController: UITableViewDelegate, UITableViewDataSource {


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return check.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath as IndexPath) as! CustomTableViewCell
        let array = check as NSArray
        cell.data = array[indexPath.item] as? Launches
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }


}


// Getting data from url
extension ViewController {
    
    func getData() {

    
        let url = "https://api.spacexdata.com/v3/launches"
        let urlObj = URL(string: url)
        
        URLSession.shared.dataTask(with: urlObj!){(data,response,error) in
            
            do {
                let launches = try JSONDecoder().decode([Launches].self , from: data!)
                DispatchQueue.main.async {
                    
                    //Getting total launches count
                    self.totalLaunchesData = String(launches.count)
                    
                    //Getting launches before 2014
                    for launch in launches {
                        // Double check if the launch_year comes null
                        let valueString:String = launch.launch_year ?? "No Launch Date"
                        let valueInt:Int = Int(valueString)!
                        if(valueInt<2014) {
                            self.check.append(launch)
                        }
                        
                    }
                    self.dataLoaded = true
                }
                
            } catch {
                print("JSON DECODING FAILIURE")
                print(error)
            }
            
            }.resume()
        
        
    }
}
