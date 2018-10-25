//
//  BaseViewController.swift
//  CoordinateSystem
//
//  Created by 周飞 on 2018/10/25.
//  Copyright © 2018年 zhoufei. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    @IBOutlet weak var coordinateView: CoordinateView!
    @IBOutlet weak var onTimeFlag: UILabel!
    @IBOutlet weak var logTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        coordinateView.coordinateType = .UIGraphics
        coordinateView.addObserver(self, forKeyPath: "log", options: NSKeyValueObservingOptions.new, context: nil)
        logTextView.layoutManager.allowsNonContiguousLayout = false
    }
    
    deinit {
        coordinateView.removeObserver(self, forKeyPath: "log")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        var text = logTextView.text
        text?.append(contentsOf: "\n")
        text?.append(contentsOf: change?[NSKeyValueChangeKey.newKey] as! String)
        logTextView.text = text
        logTextView.scrollRangeToVisible(NSRange(location: (text?.count)!, length: 50))
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
        onTimeFlag.text = sender.isOn ? "顺时针" : "逆时针"
        coordinateView.direction = sender.isOn ? .onTime : .unTime
    }
    
    @IBAction func sliderAction(_ sender: UISlider) {
        coordinateView.progressValue = CGFloat(sender.value)
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
