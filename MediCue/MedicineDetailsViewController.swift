//
//  MedicineDetailsViewController.swift
//  MediCue
//
//  Created by Mads Østergaard on 14/06/2018.
//  Copyright © 2018 Mads Østergaard. All rights reserved.
//

import UIKit

class MedicineDetailsViewController: UIViewController {
    
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var thisMedicine: Medicine?{
        didSet{
            configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            }
            
            
        }
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
