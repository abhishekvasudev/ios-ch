//
//  popupViewController.swift
//  NorthLoopAssignment
//
//  Created by Abhishek Vasudev on 23/07/19.
//  Copyright © 2019 Abhishek Vasudev. All rights reserved.
// following details: flight_number, mission_name, mission_id

import UIKit

class popupViewController: UIViewController {
    
    var data : ViewController.LaunchDetails? {
        didSet {
            flightNumberValue.text = "\(data?.flight_number ?? 0)"
            missionNameValue.text = data?.mission_name
            
            var missionIdStr:String = ""
            for missionID in (data?.mission_id) ?? [] {
                missionIdStr += missionID ?? ""+", "
            }
            if (missionIdStr == ""){
                missionIdStr = "-"
            }
            missionIdValue.text = missionIdStr
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configure()
    }
    
    let rootView:UIView = {
        let view = UIView()
        view.accessibilityIdentifier = "popupRootView"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.9502845407, green: 0.907390058, blue: 0.8068680763, alpha: 0.9)
//        view.alpha = 0.9
        return view
    }()
    
    let launchDetailsTitle: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = "launchDetailsTitle"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "LAUNCH DETAILS"
        label.textAlignment = .center
        return label
    }()
    
    let flightNumberTitle: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = "flightNumberTitle"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Flight Number:"
        return label
    }()
    
    let flightNumberValue: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = "flightNumberValue"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let missionNameTitle: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = "missionNameTitle"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Mission Name:"
        return label
    }()
    
    let missionNameValue: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = "missionNameValue"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let missionIdTitle: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = "missionIdTitle"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Mission id:"
        return label
    }()
    
    let missionIdValue: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = "missionIdValue"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("CLOSE", for: .normal)
        button.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.backgroundColor = #colorLiteral(red: 0.4391649365, green: 0.4392448664, blue: 0.4391598701, alpha: 1)
        return button
    }()
    
    
    func configure() {
        self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.view.addSubview(rootView)
        
        rootView.addSubview(launchDetailsTitle)
        rootView.addSubview(flightNumberTitle)
        rootView.addSubview(flightNumberValue)
        rootView.addSubview(missionNameTitle)
        rootView.addSubview(missionNameValue)
        rootView.addSubview(missionIdTitle)
        rootView.addSubview(missionIdValue)
        rootView.addSubview(closeButton)
        
        closeButton.addTarget(self, action: #selector(self.closeAction(_:)), for: .touchUpInside)
        
        activateConstraints()
    }
    
    func activateConstraints() {
        var constraints: [NSLayoutConstraint] = []

        //rootView constraints
        constraints.append(rootView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor))
        constraints.append(rootView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor))
        
        //POP-UP title constraints(launchDetailsTitle)
        constraints.append(launchDetailsTitle.leadingAnchor.constraint(equalTo: rootView.leadingAnchor,constant: 20))
        constraints.append(launchDetailsTitle.topAnchor.constraint(equalTo: rootView.topAnchor,constant: 20))
        constraints.append(launchDetailsTitle.trailingAnchor.constraint(equalTo: rootView.trailingAnchor, constant: -20))
        constraints.append(launchDetailsTitle.bottomAnchor.constraint(equalTo: flightNumberTitle.topAnchor, constant: -20))
        
        //flight number title constraints
        constraints.append(flightNumberTitle.leadingAnchor.constraint(equalTo: rootView.leadingAnchor,constant: 20))
        constraints.append(flightNumberTitle.topAnchor.constraint(equalTo: launchDetailsTitle.bottomAnchor,constant: 20))
        constraints.append(flightNumberTitle.trailingAnchor.constraint(equalTo: flightNumberValue.leadingAnchor, constant: -20))
        constraints.append(flightNumberTitle.bottomAnchor.constraint(equalTo: missionNameTitle.topAnchor, constant: -20))
        
        //flight number value constraints
        constraints.append(flightNumberValue.leadingAnchor.constraint(equalTo: flightNumberTitle.trailingAnchor,constant: 20))
        constraints.append(flightNumberValue.topAnchor.constraint(equalTo: launchDetailsTitle.bottomAnchor,constant: 20))
        constraints.append(flightNumberValue.trailingAnchor.constraint(equalTo: rootView.trailingAnchor, constant: -20))
        constraints.append(flightNumberValue.bottomAnchor.constraint(equalTo: missionNameValue.topAnchor, constant: -20))
        
        //mission name title constraints
        constraints.append(missionNameTitle.leadingAnchor.constraint(equalTo: rootView.leadingAnchor,constant: 20))
        constraints.append(missionNameTitle.topAnchor.constraint(equalTo: flightNumberTitle.bottomAnchor,constant: 20))
        constraints.append(missionNameTitle.trailingAnchor.constraint(equalTo: missionNameValue.leadingAnchor, constant: -20))
        constraints.append(missionNameTitle.bottomAnchor.constraint(equalTo: missionIdTitle.topAnchor,constant: -20))
        
        //mission name value constraints
        constraints.append(missionNameValue.leadingAnchor.constraint(equalTo: flightNumberTitle.trailingAnchor,constant: 20))
        constraints.append(missionNameValue.topAnchor.constraint(equalTo: flightNumberValue.bottomAnchor,constant: 20))
        constraints.append(missionNameValue.trailingAnchor.constraint(equalTo: rootView.trailingAnchor, constant: -20))
        constraints.append(missionNameValue.bottomAnchor.constraint(equalTo: missionIdValue.topAnchor,constant: -20))
        
        //mission id title constraints
        constraints.append(missionIdTitle.leadingAnchor.constraint(equalTo: rootView.leadingAnchor,constant: 20))
        constraints.append(missionIdTitle.topAnchor.constraint(equalTo: missionNameTitle.bottomAnchor,constant: 20))
        constraints.append(missionIdTitle.trailingAnchor.constraint(equalTo: missionIdValue.leadingAnchor, constant: -20))
        constraints.append(missionIdTitle.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -20))
        
        //mission id value constraints
        constraints.append(missionIdValue.leadingAnchor.constraint(equalTo: flightNumberTitle.trailingAnchor,constant: 20))
        constraints.append(missionIdValue.topAnchor.constraint(equalTo: missionNameValue.bottomAnchor,constant: 20))
        constraints.append(missionIdValue.trailingAnchor.constraint(equalTo: rootView.trailingAnchor, constant: -20))
        constraints.append(missionIdValue.bottomAnchor.constraint(equalTo: closeButton.topAnchor, constant: -20))
        
        //closeButtn constraints
        constraints.append(closeButton.leadingAnchor.constraint(equalTo: rootView.leadingAnchor,constant: 20))
        constraints.append(closeButton.topAnchor.constraint(equalTo: missionIdTitle.bottomAnchor,constant: 20))
        constraints.append(closeButton.trailingAnchor.constraint(equalTo: rootView.trailingAnchor, constant: -20))
        constraints.append(closeButton.bottomAnchor.constraint(equalTo: rootView.bottomAnchor, constant: -20))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func closeAction(_ sender:UIButton!) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
