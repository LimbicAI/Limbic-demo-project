//
//  ViewController.swift
//  Limbic-Demo-Project
//
//  Created by Bas de Vries on 6/19/18.
//  Copyright © 2018 Limbic. All rights reserved.
//

import UIKit
import Limbic
import Charts

class ViewController: UIViewController,
    IValueFormatter, IAxisValueFormatter, ChartViewDelegate,
    UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,
    UIScrollViewDelegate
{
    
    // MARK: Constant variables
    
    let CELL_WIDTH = CGFloat(UIScreen.main.bounds.width * 0.744)
    let CELL_SPACING = CGFloat(10.0)
    
    // MARK: Global variables
    
    let lineColor = hexStringToUIColor(hex: "#FE71AD")
    let gridColor = hexStringToUIColor(hex: "#EBEBF2")
    var stressDict = Dictionary<Date, Dictionary<String, Double>>()
    
    // MARK: CollectionView delegate methods
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CELL_WIDTH, height: 90.0)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth:CGFloat = CGFloat(CELL_WIDTH + CELL_SPACING);
        
        let currentOffset:CGFloat = scrollView.contentOffset.x
        let targetOffset:CGFloat = targetContentOffset.pointee.x
        var newTargetOffset:CGFloat = 0
        
        if targetOffset > currentOffset {
            newTargetOffset = ceil(currentOffset / pageWidth) * pageWidth;
        } else {
            newTargetOffset = floor(currentOffset / pageWidth) * pageWidth;
        }
        
        if newTargetOffset < 0 {
            newTargetOffset = 0
        } else if newTargetOffset > scrollView.contentSize.width {
            newTargetOffset = scrollView.contentSize.width;
        }
        
        targetContentOffset.pointee.x = currentOffset
        
        scrollView.setContentOffset(CGPoint(x: newTargetOffset, y: 0), animated: true)
        
        // Determine new position and reload graph data
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: newTargetOffset, y: visibleRect.midY)
        let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint)
        if let visibleRow = visibleIndexPath?.row {
            let actualRow = visibleRow - 1 // :-/
            let startDate = Date() - actualRow.weeks - 6.days
            let endDate = Date() - actualRow.weeks
            loadGraphData(startDate: startDate, endDate: endDate)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 52
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BDVCollectionViewCell
        let startDate = Date() - indexPath.row.weeks
        let endDate = startDate + 1.week
        
        /* populate right text in card*/
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var todayString = formatter.string(from: endDate)
        let todayDate = formatter.date(from: todayString)
        formatter.dateFormat = "dd MMM"
        todayString = formatter.string(from: todayDate!)
        
        var lastWeekString = formatter.string(from: startDate)
        let lastWeekDate = formatter.date(from: lastWeekString)
        formatter.dateFormat = "dd MMM"
        lastWeekString = formatter.string(from: lastWeekDate!)
        
        cell.dateLabel.text = "\(lastWeekString) - \(todayString)"
        
        switch indexPath.row {
        case 0:
            cell.weekLabel.text = "This week"
        case 1:
            cell.weekLabel.text = "Last week"
        default:
            cell.weekLabel.text = "Week \(startDate.weekOfYear)"
        }
        
        return cell
    }
    
    // MARK: Charts iOS delegate methods
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if axis == self.chartView.xAxis {
            let daysAgo = Int(value)
            let date = Date() + daysAgo.day
            let day = date.dayOfWeek()!
            let index = day.index(day.startIndex, offsetBy: 0)
            let firstLetterOfDay = String(describing: day[index]).capitalized

            return firstLetterOfDay
        }
        
        return ""
    }
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return ""
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        for (_, stressValues) in self.stressDict {
            if entry.y == stressValues["stressIndex"] {
                var confidenceLevel = "High"
                let confidenceIndex = stressValues["confidence"]
                let stressLevel = stressValues["stressLevel"]
                let stressIndex = stressValues["stressIndex"]
                var explanation = ""
                if stressValues["confidenceLevel"] == 2 {
                    confidenceLevel = "Low"
                    explanation = "\n\n This is an inconfident measurement. Maybe you weren't wearing your Apple Watch on this day?"
                }
                self.showAlert(
                    title: "Stress datapoint",
                    message: "Stress level: \(stressLevel!) \n Stress Index: \(stressIndex!) \n Confidence: \(confidenceLevel) \n Confidence Index: \(confidenceIndex!) \(explanation)")
                break
            }
        }
    }
    
    // MARK: Interface builder methods
    
    @IBOutlet var chartView: LineChartView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var collectionView: UICollectionView!
    @IBAction func findOutMoreButtonPush(_ sender: Any) {
        UIApplication.shared.open(URL(string : "http://limbic.ai")!, options: [:], completionHandler: { (status) in })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.activityIndicator.hidesWhenStopped = true
        
        /* collectionView setup */
        collectionView.semanticContentAttribute = UISemanticContentAttribute.forceRightToLeft

        /* limbic setup*/
        let startDate = Date() - 6.days
        let endDate = Date()
        chartSetup()
        loadGraphData(startDate: startDate, endDate: endDate)
    }
    
    func chartSetup() {
        self.chartView.delegate = self
        self.chartView.dragEnabled = false
        self.chartView.xAxis.granularity = 1
        self.chartView.xAxis.valueFormatter = nil
        self.chartView.xAxis.labelPosition = .bottom
        self.chartView.pinchZoomEnabled = false
        self.chartView.doubleTapToZoomEnabled = false
        
        let leftAxis = self.chartView.leftAxis
        leftAxis.axisMinimum = -5
        leftAxis.axisMaximum = 5
        leftAxis.granularityEnabled = true
        leftAxis.granularity = 1
        leftAxis.enabled = false
        leftAxis.drawGridLinesEnabled = false
        
        let rightAxis = self.chartView.rightAxis
        rightAxis.axisMinimum = -5
        rightAxis.axisMaximum = 5
        rightAxis.granularity = 1
        rightAxis.enabled = true
        rightAxis.valueFormatter = self
        rightAxis.axisLineColor = .clear
        rightAxis.gridColor = .clear
        
        let xAxis = self.chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.enabled = true
        xAxis.axisLineColor = .clear
        xAxis.valueFormatter = self
        xAxis.gridColor = gridColor
        
        self.chartView.legend.enabled = false
        self.chartView.setViewPortOffsets(left: 10, top: 0, right: 10, bottom: 30)
        self.chartView.chartDescription?.enabled = false
        
        chartView.noDataText = "Loading stress data"
    }
    
    func loadGraphData(startDate: Date, endDate: Date) {
        /* limbic setup*/
        self.activityIndicator.startAnimating()
        let limbic = Limbic()
        limbic.getStressForCurrentUser(startDate: startDate, endDate: endDate) { stress, error in
            if error == nil {
                DispatchQueue.main.async {
                    self.stressDict = stress!
                    
                    var dataEntries: [ChartDataEntry] = []
                    let sortedKeys = Array(stress!.keys).sorted(by: {
                        return $1 > $0
                    })
                    
                    var sortedStressArray = Array<Dictionary<Date, Dictionary<String, Double>>>()
                    
                    for sortedDate in sortedKeys {
                        for (dictDate, stressValues) in stress! {
                            if sortedDate == dictDate {
                                sortedStressArray.append([dictDate: stressValues])
                                break
                            }
                        }
                    }
                    
                    var circleColors = [NSUIColor]()
                    
                    for stressDict in sortedStressArray {
                        for (date, values) in stressDict {
                            let daysAgo = date.interval(ofComponent: .day, fromDate: Date().startOfDay)
                            let dataEntry = ChartDataEntry(x: Double(daysAgo), y: Double(values["stressIndex"]!))
                            dataEntries.append(dataEntry)
                            circleColors.append(colorPicker(value: values["confidenceLevel"]!))
                        }
                    }
                    
                    let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Stress Values")
                    let lineChartData = LineChartData(dataSet: lineChartDataSet)
                    
                    lineChartDataSet.mode = .cubicBezier
                    lineChartDataSet.lineWidth = 3
                    lineChartDataSet.circleRadius = 10
                    lineChartDataSet.setCircleColor(.white)
                    lineChartDataSet.circleHoleRadius = 5
                    lineChartDataSet.fillAlpha = 1
                    lineChartDataSet.drawHorizontalHighlightIndicatorEnabled = false
                    lineChartDataSet.setColor(self.lineColor)
                    
                    lineChartData.dataSets[0].valueFormatter = self
                    lineChartDataSet.circleColors = circleColors
                    
                    self.activityIndicator.stopAnimating()
                    self.chartView.data = lineChartData
                }
            } else if let err = error {
                var message = err.localizedDescription
                if case Limbic.Err.notEnoughData = err {
                    message = "Limbic didn't have enough data to calculate your stress levels! Have you worn your wearable recently?"
                }
                
                if case Limbic.Err.OSNotSupported = err {
                    message = "Limbic only works from iOS 11 and up. It seems like your device is running an older iOS version. Sorry!"
                }
                
                if case Limbic.Err.noInternetConnection = err {
                    message = "Seems like you're not connected to the internet!"
                }
                
                if case Limbic.Err.noDataAccess = err {
                    message = "Seems like you haven't given Limbic enough permission to access HealthKit. Please go to ..."
                }
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.showAlert(title: "Oops", message: message)
                }
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: helper functions
func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

func colorPicker(value : Double) -> NSUIColor {
    if value == 2 {
        return NSUIColor.white
    }
    else {
        return hexStringToUIColor(hex: "#FE71AD")
    }
}

extension Date {
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
    
    func weekNumber() -> Int? {
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfYear, from: self)
        
        return weekOfYear
    }
}
