//
//  CheckBox.swift
//  RecruitSheets
//
//  Created by Zhihao Cui on 19/10/2015.
//  Copyright © 2015 Delcam. All rights reserved.
//

import Foundation
import UIKit

protocol CheckboxDelegate {
    func didSelectCheckbox(state: Bool, identifier: Int, title: String);
}

class Checkbox : UIButton {
    var mDelegate: CheckboxDelegate?;
    
    required init?(coder: NSCoder) {
        super.init(coder: coder);
    }
    
    init(frame: CGRect, title: String, selected: Bool) {
        super.init(frame: frame);
        
        self.adjustEdgeInsets();
        self.applyStyle();
        
        self.setTitle(title, forState: UIControlState.Normal);
        self.addTarget(self, action: "onTouchUpInside:", forControlEvents: UIControlEvents.TouchUpInside);
    }
    
    func set(title: String, selected: Bool) {
        self.adjustEdgeInsets();
        self.applyStyle();
        
        self.setTitle(title, forState: UIControlState.Normal);
        self.addTarget(self, action: "onTouchUpInside:", forControlEvents: UIControlEvents.TouchUpInside);
    }
    
    func adjustEdgeInsets() {
        let lLeftInset: CGFloat = 8.0;
        
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left;
        self.imageEdgeInsets = UIEdgeInsetsMake(0.0 as CGFloat, lLeftInset, 0.0 as CGFloat, 0.0 as CGFloat);
        self.titleEdgeInsets = UIEdgeInsetsMake(0.0 as CGFloat, (lLeftInset * 2), 0.0 as CGFloat, 0.0 as CGFloat);
    }
    
    func applyStyle() {
        self.setImage(UIImage(named: "checked_checkbox"), forState: UIControlState.Selected);
        self.setImage(UIImage(named: "unchecked_checkbox"), forState: UIControlState.Normal);
        self.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
    }
    
    func onTouchUpInside(sender: UIButton) {
        self.selected = !self.selected;
        mDelegate?.didSelectCheckbox(self.selected, identifier: self.tag, title: self.titleLabel!.text!);
    }
}