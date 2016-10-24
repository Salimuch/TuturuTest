//
//  ViewController.swift
//  TuturuTest
//
//  Created by Артем on 05/10/2016.
//  Copyright © 2016 Artem Salimyanov. All rights reserved.
//

import UIKit

struct Storyboard {
    static var ToSearchStationsSegue = "ToSearchStations"
}

class ViewController: UIViewController {
    
    // Методы установки модели контроллера из другого контроллера
    
    private func hanldeStationTo() -> (Station) -> Void {
        return { [weak self] station in
          self?.stationTo = station
        }
    }
    
    private func handlerStationFrom() -> (Station) -> Void {
        return { [weak self] station in
            self?.stationFrom = station
        }
    }
    
    // MARK: Model
    var stationFrom: Station? {
        didSet {
            stationFromTextField.text = stationFrom?.stationName
        }
    }
    var stationTo: Station? {
        didSet {
            stationToTextField.text = stationTo?.stationName
        }
    }
    var date: Date?
    
    // MARK: Outlets
    
    @IBOutlet weak var stationFromTextField: UITextField! {
        didSet {
            stationFromTextField.delegate = self
        }
    }
    @IBOutlet weak var stationToTextField: UITextField! {
        didSet {
            stationToTextField.delegate = self
        }
    }
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBAction func setDateText(_ sender: UITextField) {
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 240))
        let datePickerView: UIDatePicker = UIDatePicker(frame: CGRect(x: 0, y: 40, width: 0, height: 0))
        datePickerView.datePickerMode = UIDatePickerMode.date
        inputView.addSubview(datePickerView)
        let doneButton = configDoneButton()
        inputView.addSubview(doneButton)
        sender.inputView = inputView
        datePickerView.addTarget(self, action: #selector(ViewController.datePickerValueChanged(_:)), for: UIControlEvents.valueChanged)
        // set button click event
        doneButton.addTarget(self, action: #selector(ViewController.doneButton(_:)), for: UIControlEvents.touchUpInside)
        // Set the date on start.
        datePickerValueChanged(datePickerView)

    }
    
    @IBAction func unwindSegueFromSearchStation(segue: UIStoryboardSegue) {
    
    }
    
    // helper methods to set dateTextField
    
    private func configDoneButton() -> UIButton {
        let doneButton = UIButton(frame: CGRect(x: (self.view.frame.size.width/2) - (100/2), y: 0, width: 100, height: 50))
        doneButton.setTitle("Done", for: UIControlState())
        doneButton.setTitle("Done", for: UIControlState.highlighted)
        doneButton.setTitleColor(UIColor.black, for: UIControlState())
        doneButton.setTitleColor(UIColor.gray, for: UIControlState.highlighted)
        return doneButton
    }
    
    @objc private func datePickerValueChanged(_ sender:UIDatePicker) {
        dateTextField.text = setDateText(date: sender.date)
        date = sender.date
    }
    
    @objc private func doneButton(_ sender:UIButton)
    {
        dateTextField.resignFirstResponder()
    }
    
    private func setDateText(date: Date?) -> String {
        if let date = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            return "  " + dateFormatter.string(from: date)
        } else { return "" }
    }

    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.ToSearchStationsSegue {
            if let textField = sender as? UITextField {
                textField.resignFirstResponder()
                if let destinationVC = segue.destination as? SearchTableViewController {
                    destinationVC.filter = textField.text
                    if textField == stationFromTextField {
                        destinationVC.handlerStation = handlerStationFrom()
                    }
                    if textField == stationToTextField {
                        destinationVC.handlerStation = hanldeStationTo()
                    }
                }
            }
        }
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        performSegue(withIdentifier: Storyboard.ToSearchStationsSegue, sender: textField)
    }
}

