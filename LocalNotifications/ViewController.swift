//
//  ViewController.swift
//  LocalNotifications
//
//  Created by admin on 15/12/2021.
//

import UIKit

class ViewController: UIViewController {

    //MARK: Connect IBOutlet
    @IBOutlet weak var timePickerView: UIPickerView!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var setedTimeLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var finishTimeLabel: UILabel!
    @IBOutlet weak var stackViewCollection: UIStackView!
    
    //Picker View Elements
    var times = [
        ListOfTime(timeName: "5 Minutes", settedTime: 5),
        ListOfTime(timeName: "10 Minutes", settedTime: 10),
        ListOfTime(timeName: "20 Minutes", settedTime: 20),
        ListOfTime(timeName: "30 Minutes", settedTime: 30)
    ]
    
    //Needed Variables
    var timerIsRunning = false
    var selectedTime = 0
    var currentTimer = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set the picker view delegate and data source
        timePickerView.delegate = self
        timePickerView.dataSource = self
        
    }
    
    
    //MARK: Start Time Action Button
    @IBAction func startTimerButton(_ sender: UIButton) {
        showAlert(message: "Start \(times[selectedTime].timeName) Timer?", alertType: .startNewTimer)
    }
    
    //MARK: Tool Bar Buttons
    //Cancel current seted timer action button
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        showAlert(message: "Cancel Current Timer?", alertType: .cancelCurrentTimer)
    }
    //Start new day action button
    @IBAction func startNewDayButton(_ sender: UIBarButtonItem) {
        showAlert(message: "Start New Day?", alertType: .startNewDay)
    }
    //Switch between views action button
    @IBAction func showDetailsButton(_ sender: Any) {
    }
    
    //MARK: Function to Display Alert
    func showAlert(message: String, alertType: AlertTypes){
        //Set alert Message
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        //Styling my aalert
//        alert.view.backgroundColor = .brown
        alert.view.layer.cornerRadius = 10
        alert.view.layer.borderWidth = 2
        alert.view.layer.borderColor = UIColor.cyan.cgColor
        //Add Action Buttons to My Alert
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
            return
        }))
        alert.addAction(UIAlertAction(title: "Sure", style: .destructive, handler: { action in
            switch alertType {
            case .startNewTimer:
                self.startNewTimer()
            case .cancelCurrentTimer:
                self.cancelTimer()
            case .startNewDay:
                self.startNewDay()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Cancel Current Timer Function
    func cancelTimer() {
        if timerIsRunning {
            //Setting Labels and Variables
            informationLabel.text = "\(times[currentTimer].timeName) Timer Canceled"
            setedTimeLabel.text = "0 hours, 0 min"
            totalTimeLabel.text = "Total Time: 0"
            finishTimeLabel.isHidden = true
            timerIsRunning = false
        }else {
            informationLabel.text = "No Running Timer"
        }
    }
    //MARK: Start New Day Function
    func startNewDay() {
        //Hiding Labels
        setedTimeLabel.isHidden = true
        finishTimeLabel.isHidden = true
        informationLabel.isHidden = true
        timerIsRunning = false
    }
    //MARK: Start New Timer Function
    func startNewTimer() {
        //Set Finish Time
        let seconds = Double(times[selectedTime].settedTime * 60)
        let finishTime = Date().addingTimeInterval(seconds)
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        //Setting The Labels
        finishTimeLabel.text = "Working Until: \(timeFormatter.string(from: finishTime))"
        informationLabel.text = "\(times[selectedTime].timeName) Timer Set"
        setedTimeLabel.text = "0 hours, \(times[selectedTime].settedTime) min"
        totalTimeLabel.text = "Total Time: \(times[selectedTime].settedTime)"
        //Setting Needed Variables
        timerIsRunning = true
        currentTimer = selectedTime
        //Display Labels
        setedTimeLabel.isHidden = false
        informationLabel.isHidden = false
        finishTimeLabel.isHidden = false
    }
}

//MARK: Picker View Codes
extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    //Number of rows in the Picker View
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //Number of elements in the row
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return times.count
    }
    //Elements that will be displayed
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        //Styling string element before display
        let time = NSAttributedString(string: times[row].timeName, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle), size: 28),
        ])
        return time
    }
    //Save selected timer
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTime = row
    }
}

enum AlertTypes {
    case startNewTimer
    case cancelCurrentTimer
    case startNewDay
}

struct ListOfTime {
    let timeName: String
    let settedTime: Int
}
