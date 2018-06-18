//
//  MainTabViewController.swift
//  MediCue
//
//  Created by Mads Østergaard on 14/06/2018.
//  Copyright © 2018 Mads Østergaard. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController{
    
    @IBOutlet weak var theTabBar: MainTabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setController()
        changeToHome()
    }
    
    func setController(){
        theTabBar?.tabBarController = self
    }
    
    func changeToHome()->Void{
        self.selectedIndex = 2
    }
}

class MainTabBar: UITabBar{
    private var middleButton = UIButton()
    var tabBarController: MainTabViewController? = MainTabViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupMiddleButton()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.isHidden {
            return super.hitTest(point, with: event)
        }
        
        let from = point
        let to = middleButton.center
        
        return sqrt((from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)) <= 39 ? middleButton : super.hitTest(point, with: event)
    }
    
    func setupMiddleButton() {
        middleButton.frame.size = CGSize(width: 70, height: 70)
        middleButton.backgroundColor = UIColor(named: "ThirdColor")
        middleButton.layer.cornerRadius = 35
        middleButton.layer.masksToBounds = true
        if let image = UIImage(named: "homeicon.png")?.withRenderingMode(.alwaysTemplate){
            middleButton.imageView?.tintColor = UIColor.white
            middleButton.setImage(image, for: .normal)
        }
        middleButton.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: 0)
        middleButton.addTarget(self, action: #selector(changeView), for: .touchUpInside)
        addSubview(middleButton)
    }
    
    @objc func changeView() {
        if let controller = tabBarController {
            controller.changeToHome()
        }
    }
}
