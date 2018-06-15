//
//  MedicineDetailsViewController.swift
//  MediCue
//
//  Created by Mads Østergaard on 14/06/2018.
//  Copyright © 2018 Mads Østergaard. All rights reserved.
//

import UIKit

class MedicineDetailsViewController: UITableViewController{
    
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    // Date labels
    @IBOutlet weak var datoStartLabel: UILabel!
    @IBOutlet weak var datoSlutLabel: UILabel!
    // Day Labels
    @IBOutlet weak var manLabel: UIButton!
    @IBOutlet weak var tirsLabel: UIButton!
    @IBOutlet weak var onsLabel: UIButton!
    @IBOutlet weak var torLabel: UIButton!
    @IBOutlet weak var freLabel: UIButton!
    @IBOutlet weak var lørLabel: UIButton!
    @IBOutlet weak var sønLabel: UIButton!
    
    // Day times Labels
    @IBOutlet weak var morgenLabel: UILabel!
    @IBOutlet weak var formiddagLabel: UILabel!
    @IBOutlet weak var middagLabel: UILabel!
    @IBOutlet weak var eftermiddagLabel: UILabel!
    @IBOutlet weak var aftenLAbel: UILabel!
    @IBOutlet weak var natLabel: UILabel!
    
    
    var thisMedicine: Medicine?{
        didSet{
            configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("thismedicine name: ", thisMedicine?.name)
        
        
        configureView()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView(){
        if let medicine = thisMedicine, let label = self.nameLabel, let image = typeImageView, let type = medicine.medType{
            
            label.text = medicine.name
            
            switch type{
            case Medicine.MedicineType.injektion:
                image.image = UIImage(named: "injectionIcon.pdf")
            case Medicine.MedicineType.pill:
                image.image = UIImage(named: "pillIcon.pdf")
            case Medicine.MedicineType.tablet:
                image.image = UIImage(named: "capsuleIcon.pdf")
                
                //set first section
                nameLabel.text = medicine.name
                print("name sat to:", medicine.name)
                
                // set second section
                datoStartLabel.text = medicine.dateToString(from: medicine.date!)
                datoSlutLabel.text = medicine.dateToString(from: medicine.endDate!)
                // set third section
                if medicine.weekdays["Man"]! == true{
                    manLabel.tintColor = .green
                } else {
                    manLabel.tintColor = .red
                }
                
                
                
                
            }
        }
    }
}
