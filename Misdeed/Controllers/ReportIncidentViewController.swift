//
//  ReportIncidentViewController.swift
//  Misdeed
//
//  Created by Katie YK So on 8/1/18.
//  Copyright © 2018 Katie YK So. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class ReportIncidentViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var ReportSubmitButton: UIButton!
    @IBAction func reportSubmitButtonTapped(_ sender: UIButton) {
        addReports()
        ReportSubmitButton.setTitle("Report Submitted", for: .normal)
        ReportSubmitButton.isEnabled = false
        ReportSubmitButton.backgroundColor = UIColor.gray
    }
    
    var refReports: DatabaseReference!
    let cate = ["Vehicle Theft", "Robbery","Burglary", "Drug/Narcotic", "Prostitution", "Assault", "Vandalism", "Stolen Property", "Drunkenness", "Other"]
    var selectedCategory: String?
    var datePicker: UIDatePicker?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        refReports = Database.database().reference().child("userReports");
        getDate()
        createCategoryPicker()
        catePickerToolBar()
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(ReportIncidentViewController.dateChanged), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ReportIncidentViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        dateTextField.inputView = datePicker
    }
    
    func addReports(){
        let key = refReports.childByAutoId().key
        let reports = ["id": key,
                       "category": categoryTextField.text! as String,
                       "address": addressTextField.text! as String,
                       "description": descriptionTextField.text! as String,
                       "date": dateTextField.text! as String]
        refReports.child(key).setValue(reports)
    }
    
    
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        print("tap tap tap")
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    func getDate(){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let str = formatter.string(from: Date())
        dateTextField.text = str
    }
    
    func createCategoryPicker(){
        let catePicker = UIPickerView()
        catePicker.delegate = self
        categoryTextField.inputView = catePicker
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cate.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cate[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = cate[row]
        categoryTextField.text = selectedCategory
    }
    func catePickerToolBar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(ReportIncidentViewController.dismissKeyboard))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        categoryTextField.inputAccessoryView = toolbar
        dateTextField.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
}


