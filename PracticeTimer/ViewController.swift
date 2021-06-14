//
//  ViewController.swift
//  PracticeTimer
//
//  Created by Heather Martin on 6/4/21.
//

import UIKit

class ViewController: UIViewController {
    
struct Practice: Codable {
     let desc: String
     let time: Int
}
    
var practices: [Practice] = [
    Practice(desc: "4 count", time: 5),
    Practice(desc: "8 count", time: 5),
    Practice(desc: "16 count", time: 3),
    Practice(desc: "paradiddle", time: 3),
    Practice(desc: "double paradiddle", time: 3),
    Practice(desc: "bass+timpani+highhat", time: 3)
]

    @IBOutlet weak var PercentLabel: UILabel!
    @IBOutlet weak var MinutesLabel: UILabel!
    @IBOutlet weak var ProgressBar: UIProgressView!
    @IBOutlet weak var CompletedTextView: UITextView!
    @IBOutlet weak var AddButton: UIButton!
    
    var progressTimer: Timer!
    var timerIsRunning = false
    var totalTimeInSeconds = 0
    let progress = Progress()
    var selectedPracticeIndex = 0
    
    @objc func updateProgressView() {

        DispatchQueue.global().async {
              DispatchQueue.main.async { () -> Void in
                print("+++++++++++++++++++++++++++")
                self.progress.completedUnitCount += 1
                self.timerIsRunning  = true
                self.ProgressBar.progress += 0.1
                self.ProgressBar.setProgress(Float(self.progress.fractionCompleted), animated: true)
                let secondsLeft = self.totalTimeInSeconds - (Int(self.progress.fractionCompleted*Double(self.totalTimeInSeconds)))
                self.MinutesLabel.text = "\(secondsLeft/60) mins \(secondsLeft%60) secs left to go"
                print("percent completed \(Int(self.progress.fractionCompleted*Double(self.totalTimeInSeconds))/2)")
                self.PercentLabel.text = "percent completed \(Int(self.progress.fractionCompleted*100)) %"
                print("+++++++++++++++++++++++++++")
                if (self.progress.fractionCompleted == Double(1.0)) {
                    self.progressTimer.invalidate()
                    print("finished \(self.practices[self.selectedPracticeIndex].desc) \n")
                    self.CompletedTextView.text! += "finished \(self.practices[self.selectedPracticeIndex].desc) \n"
                }
              }
        }
    }
    
    @objc func startTimer(sender: UIButton){
        // pause or reset timer when button clicked
        if (timerIsRunning) {
            progressTimer.invalidate()
        }
        // reset progressbar
        print("called startTimer")
        ProgressBar.progress = 0.0
        timerIsRunning = true
        selectedPracticeIndex = sender.tag
        totalTimeInSeconds = practices[selectedPracticeIndex].time * 60
        progress.totalUnitCount = Int64(totalTimeInSeconds)
        progress.completedUnitCount = 0
        MinutesLabel.text = "\(String(totalTimeInSeconds/60)) minutes to go"
        
        let customLightGreenColor = UIColor(red: CGFloat(144/255.0), green: CGFloat(219/255.0), blue: CGFloat(4/255.0), alpha: 1.0)
        sender.backgroundColor = customLightGreenColor
        
        self.progressTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateProgressView), userInfo: nil, repeats: true)
        

    }
        
    @IBAction func ViewRecords(_ sender: Any) {
        performSegue(withIdentifier: "recordsSegue", sender: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressBar.layer.cornerRadius = 10
        ProgressBar.clipsToBounds = true
        ProgressBar.layer.sublayers![1].cornerRadius = 10
        ProgressBar.subviews[1].clipsToBounds = true
        ProgressBar.progress = 0.0

        let xCoordinate = 40
        var yCoordinate = 120
        let yCoordinateIncrement = 10
        let height = 35
        let width = 200
        
        selectedPracticeIndex = 0

        overrideUserInterfaceStyle = .dark
        
        for practice in practices {
            
            // create label for the practice action
            let label = UILabel() as UILabel
            label.textColor = UIColor.black
            label.frame = CGRect(x: xCoordinate, y: yCoordinate, width: width, height: height)
            label.text = practice.desc
            label.textColor = .white
            self.view.addSubview(label)
            
            // create button for the practice timer
            let labelWidth = label.intrinsicContentSize.width
            let button = UIButton(type: UIButton.ButtonType.custom) as UIButton
            button.frame = CGRect(x: xCoordinate + Int(labelWidth) + 5, y: yCoordinate, width: 35, height: height)
            yCoordinate += height + yCoordinateIncrement
            button.addTarget(self, action: #selector(startTimer), for:.touchUpInside)
            button.backgroundColor = UIColor.lightGray
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.setTitle("Go", for: .normal)
            button.tag = selectedPracticeIndex
            self.view.addSubview(button)

            self.CompletedTextView.text! += "TEST \(practices[selectedPracticeIndex].desc) \n"

            selectedPracticeIndex += 1
            
        }
        
        // Do any additional setup after loading the view.
    }

}

