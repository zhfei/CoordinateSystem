//
//  BezierVC.swift
//  CoordinateSystem
//
//  Created by 周飞 on 2018/10/25.
//  Copyright © 2018年 zhoufei. All rights reserved.
//

import UIKit

class BezierVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        coordinateView.coordinateType = .UIBezierPath
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
