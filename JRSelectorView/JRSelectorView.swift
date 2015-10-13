//
//  JRSelectorView.swift
//  JingJianLogistics-iOS
//
//  Created by SilversRayleigh on 23/9/15.
//  Copyright (c) 2015 qi-cloud.com. All rights reserved.
//
//MARK: - Header
//MARK: Header - Files
import UIKit
//MARK: Header - Enums
//MARK: Header - Protocols
@objc protocol JRSelectorViewDataSource: NSObjectProtocol {
    func numberOfComponentsInSelectorView(seletorView: JRSelectorView) -> Int
    func selectorView(selectorView: JRSelectorView, numberOfRowsInComponent component: Int) -> Int
}
@objc protocol JRSelectorViewDelegate: NSObjectProtocol {
    optional func selectorView(selectorView: JRSelectorView, heightForRowsInComponent component: Int) -> Float
    optional func selectorView(selectorView: JRSelectorView, widthForComponents component: Int) -> Float
    
    optional func selectorView(selectorView: JRSelectorView, titleForRow row: Int, forComponent component: Int) -> String!
    
    optional func selectorView(selectorView: JRSelectorView, didSelectRows rows: [Int])
}
//MARK: - Class
//MARK: - Classes - Body
class JRSelectorView: UIView {
    //MARK: - Parameter
    //MARK: - Parameters - Constant
    //MARK: - Parameters - Basic
    var numberOfComponent: Int = Int(0)
    
    var selectedContent: [String]?
    //MARK: - Parameters - Foundation
    var selectedIndex: [Int]?
    //MARK: - Parameters - UIKit
    var selectorCoverView: UIView = UIView()
    var selectorContentView: UIView = UIView()
    var selectorHeaderView: UIView = UIView()
    
    var selectorPickerView: UIPickerView = UIPickerView()
    
    var selectorHeaderCancelButton: UIButton = UIButton()
    var selectorHeaderConfirmButton: UIButton = UIButton()
    
    var selectorHeaderDisplayLabel: UILabel = UILabel()
    //MARK: - Parameters - Array
    var numberOfRowsInComponent: [Int] = Array()
    
    var widthForComponents: [Float] = Array()
    var heightForRowInComponent: [[Float]] = Array()
    
    var arrayOfDatas: [[AnyObject]]?

    //MARK: - Parameters - Dictionary
    //MARK: - Parameters - Tuple
    //MARK: - Parameters - Customed
    //MARK: Customed - Normal
    //MARK: Customed - Delegate
    weak var delegate: JRSelectorViewDelegate?
    //MARK: Customed - Datasource
    weak var dataSource: JRSelectorViewDataSource? {
        didSet {
            self.reloadData()
        }
    }
    //MARK: Customed - Enum
    
    //MARK: - Method
    //MARK: - Methods - Life Circle
    //MARK: - Methods - Implementation
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    //MARK: - Methods - Initation
    convenience init(frame: CGRect, dataSource: JRSelectorViewDataSource?, delegate: JRSelectorViewDelegate?) {
        self.init(frame: frame)
        if dataSource != nil {
            self.dataSource = dataSource
        }
        if delegate != nil {
            self.delegate = delegate
        }
        self.arrayOfDatas = Array()
        self.selectedIndex = Array()
        self.selectedContent = Array()
        self.setupSelectorView()
    }
    //MARK: - Methods - Class(Static Methods)
    //MARK: - Methods - Selector
    //MARK: Selectors - Gesture Recognizer
    func didSelectorCoverViewTouched(sender: UITapGestureRecognizer) {
        self.dismiss()
    }
    //MARK: Selectors - Action
    func didSelectorCancelButtonClicked(sender: UIButton) {
        self.dismiss()
    }
    func didSelectorConfirmButtonClicked(sender: UIButton) {
        if self.delegate != nil {
            if self.delegate!.respondsToSelector("selectorView:didSelectRows:") {
                self.delegate!.selectorView!(self, didSelectRows: self.selectedIndex!)
            }
        }
        self.dismiss()
    }
    //MARK: - Methods - Operation
    //MARK: Operations - Go Operation
    //MARK: Operations - Do Operation
    //MARK: Operations - Show or Dismiss Operation
    func show() {
        self.selectorCoverView.frame = self.bounds
        self.selectorContentView.frame = CGRect(
            x: 0,
            y: self.bounds.height - 256,
            width: self.bounds.width,
            height: 256)
        self.selectorHeaderView.frame = CGRect(
            x: 0,
            y: 0,
            width: self.selectorContentView.bounds.width,
            height: 40)
        self.selectorHeaderCancelButton.frame = CGRect(
            x: 10,
            y: 0,
            width: 80,
            height: self.selectorHeaderView.bounds.height)
        self.selectorHeaderConfirmButton.frame = CGRect(
            x: self.selectorHeaderView.bounds.width - self.selectorHeaderCancelButton.bounds.width - 10,
            y: 0,
            width: self.selectorHeaderCancelButton.bounds.width,
            height: self.selectorHeaderView.bounds.height)
        self.selectorHeaderDisplayLabel.frame = CGRect(
            x: CGRectGetMaxX(self.selectorHeaderCancelButton.frame),
            y: 0,
            width: CGRectGetMinX(self.selectorHeaderConfirmButton.frame) - CGRectGetMaxX(self.selectorHeaderCancelButton.frame),
            height: self.selectorHeaderView.bounds.height)
        self.selectorPickerView.frame = CGRect(
            x: 0,
            y: CGRectGetMaxY(self.selectorHeaderView.frame),
            width: self.selectorContentView.bounds.width,
            height: 216)
        self.selectorContentView.transform = CGAffineTransformTranslate(self.selectorContentView.transform, 0, 256)
        UIView.animateWithDuration(0.35, animations: {() in
            self.alpha = 1
            self.selectorContentView.transform = CGAffineTransformTranslate(self.selectorContentView.transform, 0, -256)
        }, completion: {(finished: Bool) in
            for index in 0..<self.numberOfComponent {
                self.selectedIndex![index] = 0
                self.selectedContent![index] += (self.arrayOfDatas![index][0] as? String)!
            }
        })
    }
    func dismiss() {
        UIView.animateWithDuration(0.25, animations: {() in
            self.alpha = 0
        }, completion: {(finished: Bool) in
            self.removeFromSuperview()
        })
    }
    func showOnView(superView: UIView) {
        self.frame = superView.bounds
        self.alpha = 0
        superView.addSubview(self)
        self.show()
    }
    func showOnWindow() {
        self.frame = UIScreen.mainScreen().bounds
        self.alpha = 0
        (UIApplication.sharedApplication().delegate as! AppDelegate).window!.addSubview(self)
        self.show()
    }
    //MARK: Operations - Setup Operation
    func setupSelectorView() {
        self.selectorCoverView.backgroundColor = UIColor.blackColor()
        self.selectorCoverView.alpha = 0.3
        self.selectorCoverView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "didSelectorCoverViewTouched:"))
        
        self.addSubview(self.selectorCoverView)
        
        self.selectorContentView.backgroundColor = UIColor.clearColor()
        self.selectorContentView.alpha = 1
        
        self.addSubview(self.selectorContentView)
        
        self.selectorHeaderView.backgroundColor = UIColor.blackColor()
        self.selectorHeaderView.alpha = 1
        self.selectorContentView.addSubview(self.selectorHeaderView)
        
        self.selectorHeaderCancelButton.backgroundColor = UIColor.clearColor()
        self.selectorHeaderCancelButton.setTitle("取消", forState: UIControlState.Normal)
        self.selectorHeaderCancelButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.selectorHeaderCancelButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Highlighted)
        self.selectorHeaderCancelButton.addTarget(self, action: "didSelectorCancelButtonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.selectorHeaderView.addSubview(self.selectorHeaderCancelButton)
        
        self.selectorHeaderConfirmButton.backgroundColor = UIColor.clearColor()
        self.selectorHeaderConfirmButton.setTitle("确认", forState: UIControlState.Normal)
        self.selectorHeaderConfirmButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.selectorHeaderConfirmButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Highlighted)
        self.selectorHeaderConfirmButton.addTarget(self, action: "didSelectorConfirmButtonClicked", forControlEvents: UIControlEvents.TouchUpInside)
        self.selectorHeaderView.addSubview(self.selectorHeaderConfirmButton)
        
        self.selectorHeaderDisplayLabel.backgroundColor = UIColor.clearColor()
        self.selectorHeaderDisplayLabel.textAlignment = NSTextAlignment.Center
        self.selectorHeaderDisplayLabel.textColor = UIColor.whiteColor()
        self.selectorHeaderDisplayLabel.font = UIFont.systemFontOfSize(15.0)
        self.selectorHeaderDisplayLabel.text = "请选择"
        self.selectorHeaderView.addSubview(self.selectorHeaderDisplayLabel)
        
        self.selectorPickerView.backgroundColor = UIColor.whiteColor()
        if self.dataSource != nil {
            self.selectorPickerView.dataSource = self
            self.selectorPickerView.delegate = self
            self.selectorPickerView.reloadAllComponents()
            self.selectorContentView.addSubview(self.selectorPickerView)
        }
    }
    //MARK: Operations - Customed Operation
    func reloadData() {
        
    }
    //MARK: - Methods - Getter
    //MARK: - Methods - Setter
}
//MARK: - Classes - Extension
//MARK: - Extensions - DataSource
extension JRSelectorView: UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        self.arrayOfDatas!.append([AnyObject]())
        self.selectedIndex!.append(0)
        self.selectedContent!.append("")
        return self.dataSource!.numberOfComponentsInSelectorView(self)
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.arrayOfDatas![component].append("")
        return self.dataSource!.selectorView(self, numberOfRowsInComponent: component)
    }
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        if self.delegate != nil {
            if self.delegate!.respondsToSelector("selectorView:heightForRowsInComponent:") {
                return CGFloat(self.delegate!.selectorView!(self, heightForRowsInComponent: component))
            }
        }
        return 35.0
    }
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if self.delegate != nil {
            if self.delegate!.respondsToSelector("selectorView:widthForComponents:") {
                return CGFloat(self.delegate!.selectorView!(self, widthForComponents: component))
            }
        }
        return self.selectorPickerView.frame.width / CGFloat(self.numberOfComponent)
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.delegate != nil {
            if self.delegate!.respondsToSelector("selectorView:titleForRow:forComponent:") {
                let stringInReturn = self.delegate!.selectorView!(self, titleForRow: row, forComponent: component)
                self.arrayOfDatas![component][row] = stringInReturn
                return stringInReturn
            }
        }
        return ""
    }
}
//MARK: - Extensions - Delegate
extension JRSelectorView: UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedIndex![component] = row
        self.selectedContent![component] = (self.arrayOfDatas![component][row] as? String)!
        var theString = ""
        for index in 0..<self.numberOfComponent {
            theString += (self.arrayOfDatas![index][self.selectedIndex![index]] as? String)!
        }
        self.selectorHeaderDisplayLabel.text = self.selectedContent![component]
    }
}
//MARK: - Classes - Custom