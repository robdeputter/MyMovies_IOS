//
//  Extension.swift
//  MyMovies
//
//  Created by Rob De Putter on 17/12/2019.
//  Copyright © 2019 Rob De Putter. All rights reserved.
//

import Foundation
import UIKit

var vSpinner : UIView?
//SOURCE: http://brainwashinc.com/2017/07/21/loading-activity-indicator-ios-swift/

extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}

//SOURCE: https://medium.com/@mtssonmez/handle-empty-tableview-in-swift-4-ios-11-23635d108409
extension UITableView{
    func setEmptyView(message : String){
        
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let messageLabel = UILabel()
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        
        
        emptyView.addSubview(messageLabel)
        
        messageLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
