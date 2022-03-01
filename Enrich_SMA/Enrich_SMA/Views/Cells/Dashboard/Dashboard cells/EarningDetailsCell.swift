//
//  EarningDetailsCell.swift
//  Enrich_SMA
//
//  Created by Prarthana on 25/01/22.
//  Copyright © 2022 e-zest. All rights reserved.
//

import UIKit
import Charts

class EarningDetailsCell: UITableViewCell, ChartViewDelegate {
    
    @IBOutlet weak private var lblTitle: UILabel!
    @IBOutlet weak private var lblSubTitle: UILabel!
    @IBOutlet weak private var btnTreandline: UIButton!
    @IBOutlet weak private var trendlineView: UIStackView!
    @IBOutlet weak private var chartParentView: UIView!
    @IBOutlet weak private var parentView: UIView!
    @IBOutlet weak private var parentViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak private var imageDropDown: UIImageView!
    
    @IBOutlet weak private var chartView: CombinedChartView!
    
    @IBOutlet var lblLeftAxis: UILabel!
    @IBOutlet var lblRightAxis: UILabel!
    
    @IBOutlet weak var graphDtFilter: UIButton!

    // First View
    @IBOutlet weak private var firstValueView: UIView!
    @IBOutlet weak private var firstValueTitleView: UIView!
    @IBOutlet weak private var firstValueSubTitleView: UIView!
    @IBOutlet weak private var lblFirstValueViewRupee: UILabel!
    @IBOutlet weak private var lblFirstValueViewTitle: UILabel!
    @IBOutlet weak private var lblFirstValueViewSubTitle: UILabel!

    // Second View
    @IBOutlet weak private var secondValueView: UIView!
    @IBOutlet weak private var secondValueTitleView: UIView!
    @IBOutlet weak private var secondValueSubTitleView: UIView!
    @IBOutlet weak private var lblSecondValueViewRupee: UILabel!
    @IBOutlet weak private var lblSecondValueViewTitle: UILabel!
    @IBOutlet weak private var lblSecondValueViewSubTitle: UILabel!
    
    @IBOutlet weak private var dataViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var firstValueTitleStackViewVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak private var secondValueTitleStackViewVerticalConstraint: NSLayoutConstraint!

    
    // New IBOutlets
    @IBOutlet weak private var titleContainerView: UIView!
    @IBOutlet weak private var allPackageStackView: UIStackView!

    
    var model: EarningsCellDataModel!
        
    var dataModel: [GraphDataEntry]?
    
    weak var delegate: EarningDetailsDelegate?
    
    weak var parentVC: UIViewController?

    override func awakeFromNib() {
        super.awakeFromNib()
        parentViewWidthConstraint.constant = UIScreen.main.bounds.width - 30
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        parentView.clipsToBounds = true
        parentView.layer.cornerRadius = 8
        parentView.layer.masksToBounds = false
        parentView.layer.shadowRadius = 8
        parentView.layer.shadowOpacity = 0.20
        parentView.layer.shadowOffset = CGSize(width: 0, height: 10)
        parentView.layer.shadowColor = UIColor.gray.cgColor
        
        chartParentView.clipsToBounds = true
        chartParentView.layer.cornerRadius = 8
        chartParentView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    @IBAction func actionViewTrendline(_ sender: UIButton) {
        model.isExpanded = !model.isExpanded
        chartParentView.isHidden = !model.isExpanded
        imageDropDown.transform =  model.isExpanded ? CGAffineTransform(rotationAngle: .pi) : CGAffineTransform.identity
        btnTreandline.setTitle(model.isExpanded ? "Hide Trendline" : "View Trendline", for: .normal)
        delegate?.reloadData()
    }
    
    @IBAction func actionAllPackages(_ sender: UIButton) {
        print("All Package Button Clicked...")
    }
    
    private func shouldAllPackageButtonVisible() -> Bool {
        switch self.model.title {
        case "Value Package", "Service Package", "Product Package": return true
        default: return false
        }
    }
    
    private func resetDataView() {
        dataViewHeightConstraint.constant = 60
        firstValueTitleStackViewVerticalConstraint.constant = 0
        firstValueSubTitleView.isHidden = true
        secondValueView.isHidden = true
    }
    
    private func setDataForMembership() {
        guard model.title == "Membership" else { return }
        dataViewHeightConstraint.constant = 77
        firstValueTitleStackViewVerticalConstraint.constant = 10
        firstValueSubTitleView.isHidden = false
        //TODO:: Please set data here from API
        lblFirstValueViewTitle.text = model.value[0] 
        lblSecondValueViewTitle.text = model.value[1] 
        
        secondValueView.isHidden = false
        firstValueView.backgroundColor = UIColor(red: 82/255.0, green: 223/255.0, blue: 157/255.0, alpha: 0.6)
        secondValueView.backgroundColor = UIColor(red: 96/255.0, green: 201/255.0, blue: 255/255.0, alpha: 0.59)
    }
    
    func configureCell(model: EarningsCellDataModel, data: [GraphDataEntry], isFromRevenueScreen: Bool = false) {
        resetDataView()
        self.model = model
        self.lblTitle.text = model.title
        allPackageStackView.isHidden = !shouldAllPackageButtonVisible()
        titleContainerView.isHidden = model.title.isEmpty && !shouldAllPackageButtonVisible()
        
        self.lblSubTitle.text = model.subTitle[0]
        trendlineView.isHidden = !model.showGraph
        chartParentView.isHidden = !model.isExpanded
        if(model.earningsType == .CustomerEngagement)
        {
            lblLeftAxis.isHidden = false
            lblRightAxis.isHidden = false
        }
        else {
            lblLeftAxis.isHidden = true
            lblRightAxis.isHidden = true
        }
        graphDtFilter.setTitle(model.dateRangeType.rawValue, for: .normal)

//        drawGraph(graphData: data, showRightAxix: (model.earningsType == .CustomerEngagement || model.earningsType == .ResourceUtilisation), isFromRevenueScreen: isFromRevenueScreen)

        drawGraph(graphData: data, showRightAxix: false, isFromRevenueScreen: isFromRevenueScreen)
        
        
        firstValueView.isHidden = model.cellType != .SingleValue
        
        switch model.cellType {
        case .SingleValue:
            firstValueView.backgroundColor = model.earningsType.singleValueTileColor
            lblFirstValueViewTitle.text = model.value[0]
            lblFirstValueViewRupee.isHidden = shouldHideRupeeSymbol()
        case .DoubleValue:
           break
        case .PackageType:
           break
        case .TripleValue: break
    
        }
        setDataForMembership()
    }
    
    private func shouldHideRupeeSymbol() -> Bool {
        if model.earningsType == .Productivity {
            let arr = ["Revenue Per Team Member", "Revenue Per Workstation", "Revenue Per Square Feet"]
            return !arr.contains(self.model.title)
        } else if(model.earningsType == .FreeServices || model.earningsType == .Footfall || model.earningsType == .CustomerEngagement || model.earningsType == .PenetrationRatios || model.earningsType == .ResourceUtilisation){
            return true
        } else {
            return false
        }
    }
    
    @IBAction func actionDurationFilter(_ sender: UIButton) {
        self.delegate?.actionDurationFilter(forCell: self)
    }
    
    
    @IBAction func actionPackageFilter(_ sender: UIButton) {
        self.delegate?.actionPackageFilter?(forCell: self)
    }
    
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let dataSet = chartView.data?.dataSets[highlight.dataSetIndex] else {
            return
        }
        var entryIndex = dataSet.entryIndex(entry: entry)
        if entryIndex == -1 { // Temp code to fix click issue
            entryIndex = Int(entry.x) - 1
            if entryIndex < 0 {
                entryIndex = 0
            }
        }//--- Temp code end
        if let data = dataModel, entryIndex >= 0  {
            var text = ""
            data.forEach {
                text.append(!text.isEmpty ? "\n" : "")
                text.append("\($0.dataTitle) \($0.values[entryIndex])")
            }
            self.parentVC?.showToast(alertTitle: alertTitle, message: text, seconds: toastMessageDuration)
        }
        chartView.highlightValue(nil) // Temp code to fix click issue
    }
}

extension EarningDetailsCell {
    
    func drawGraph(graphData: [GraphDataEntry], showRightAxix: Bool, isFromRevenueScreen: Bool) {
        dataModel = graphData
    
        chartView.noDataText = "You need to provide data for the chart."
        
        let data = CombinedChartData()
        
        let barData = graphData.filter { $0.graphType == .barGraph }
        if !barData.isEmpty {
            data.barData = generateBarData(graphData: barData, isFromRevenueScreen: isFromRevenueScreen)
        }

        if let lineData = graphData.first(where: { $0.graphType == .linedGraph }) {
            data.lineData = generateLineData(graphData: lineData)
        }
        
        chartView.data = data
        chartView.notifyDataSetChanged()
        chartView.delegate = self
        
        // xAxis
        let xAxis = chartView.xAxis
        xAxis.enabled = true
        xAxis.labelPosition = .bottom
        xAxis.labelCount = graphData.first?.units.count ?? 0
        xAxis.wordWrapEnabled = true
        xAxis.valueFormatter = CustomValueFormatter(values: graphData.first?.units ?? [])//IndexAxisValueFormatter(values: graphData.first?.units ?? [])//
        xAxis.labelTextColor = UIColor(red: 0.17, green: 0.16, blue: 0.16, alpha: 1.00)
        if let font = UIFont(name: FontName.FuturaPTMedium.rawValue, size: 8.0) {
            xAxis.labelFont = font
        }
        xAxis.gridColor = UIColor(red: 0.61, green: 0.62, blue: 0.70, alpha: 1.00)
        xAxis.axisLineColor = UIColor(red: 0.61, green: 0.62, blue: 0.70, alpha: 1.00)
        xAxis.drawGridLinesEnabled = false
        xAxis.axisLineWidth = 0.5
        xAxis.gridLineDashLengths = [(5.0)]
        if graphData.count == 1 || isFromRevenueScreen {
            xAxis.axisMinimum = 0.5
            xAxis.axisMaximum = Double(graphData.first?.units.count ?? 0) + 1
            xAxis.spaceMin = 0.3
            xAxis.spaceMax = 0.3
        } else if graphData.count == 2 {
            let groupSpace = 0.4
            let barSpace = 0.0
            xAxis.centerAxisLabelsEnabled = true
            xAxis.granularityEnabled = true
                    
            xAxis.axisMinimum = 0.0
            xAxis.axisMaximum = 0.0 + data.barData.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(graphData.first?.units.count ?? 0)
                    
            chartView.xAxis.granularity = chartView.xAxis.axisMaximum / Double(graphData.first?.units.count ?? 0)
        }
        
        
        // Left Axis
        let leftAxis = chartView.leftAxis
        leftAxis.setLabelCount(6, force: true)
        leftAxis.labelTextColor = UIColor(red: 0.61, green: 0.62, blue: 0.70, alpha: 1.00)
        if let font = UIFont(name: FontName.FuturaPTMedium.rawValue, size: 8.0) {
            leftAxis.labelFont = font
        }
        leftAxis.labelPosition = .outsideChart
        leftAxis.axisMinimum = 0
        //leftAxis.valueFormatter = LargeValueFormatter()
        leftAxis.gridColor = UIColor(red: 0.61, green: 0.62, blue: 0.70, alpha: 1.00)
        leftAxis.axisLineColor = UIColor(red: 0.61, green: 0.62, blue: 0.70, alpha: 1.00)
        leftAxis.drawGridLinesEnabled = true
        leftAxis.axisLineWidth = 0.5
        leftAxis.gridLineDashLengths = [(5.0)]
        
        
        // Right Axis
        let rightAxis = chartView.rightAxis
        rightAxis.enabled = showRightAxix
        rightAxis.setLabelCount(6, force: true)
        rightAxis.labelTextColor = UIColor(red: 0.61, green: 0.62, blue: 0.70, alpha: 1.00)
        if let font = UIFont(name: FontName.FuturaPTMedium.rawValue, size: 8.0) {
            rightAxis.labelFont = font
        }
        rightAxis.labelPosition = .outsideChart
        rightAxis.axisMinimum = 0
        //leftAxis.valueFormatter = LargeValueFormatter()
        rightAxis.gridColor = UIColor(red: 0.61, green: 0.62, blue: 0.70, alpha: 1.00)
        rightAxis.axisLineColor = UIColor(red: 0.61, green: 0.62, blue: 0.70, alpha: 1.00)
        rightAxis.drawGridLinesEnabled = false
        rightAxis.axisLineWidth = 0.5
        rightAxis.gridLineDashLengths = [(5.0)]
        
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.drawInside = true
        l.form = .circle
        l.formSize = 9
        l.textColor = UIColor(red: 0.17, green: 0.16, blue: 0.16, alpha: 1.00)
        if let font = UIFont(name: FontName.FuturaPTMedium.rawValue, size: 10) {
            l.font = font
        }
        l.yOffset = -48

        chartView.extraBottomOffset = 10
        chartView.extraTopOffset = 50
        chartView.doubleTapToZoomEnabled = false
        chartView.pinchZoomEnabled = false
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        chartView.fitScreen()
    }
    
    func generateBarData(graphData: [GraphDataEntry], isFromRevenueScreen: Bool) -> BarChartData{
        
        let barChartData = BarChartData()
        
        if graphData.count == 1 || isFromRevenueScreen {
            graphData.forEach { data in
                var dataEntries: [BarChartDataEntry] = []
                
                for i in 0..<data.values.count {
                    let dataEntry = BarChartDataEntry(x: Double(i+1), y: data.values[i])
                    dataEntries.append(dataEntry)
                }
                let chartDataSet = BarChartDataSet(entries: dataEntries, label: data.dataTitle)
                chartDataSet.drawValuesEnabled = false
                chartDataSet.colors = [data.barColor]
                chartDataSet.highlightColor = UIColor.clear
                barChartData.addDataSet(chartDataSet)
            }
            var barWidth = 0.3
            let barSpace = 0.0
            let groupSpace = (1 - (barWidth * Double(graphData.count)))
            
            if let barCount = barChartData.dataSets.first?.entryCount, barCount <= 5 { barWidth = 0.05 * Double(barCount) }
            barChartData.barWidth = barWidth
        } else if graphData.count == 2 {// Sales : Membership
            
            var dataEntries: [BarChartDataEntry] = []
            var dataEntries1: [BarChartDataEntry] = []
            for i in 0..<graphData[0].values.count {
                let dataEntry = BarChartDataEntry(x: Double(i+1), y: graphData[0].values[i])
                dataEntries.append(dataEntry)
                
                let dataEntry1 = BarChartDataEntry(x: Double(i+1), y: graphData[1].values[i])
                dataEntries1.append(dataEntry1)
            }
            
            let chartDataSet = BarChartDataSet(entries: dataEntries, label: graphData[0].dataTitle)
            chartDataSet.drawValuesEnabled = false
            chartDataSet.colors = [graphData[0].barColor]
            chartDataSet.highlightColor = UIColor.clear
            barChartData.addDataSet(chartDataSet)
            
            let chartDataSet1 = BarChartDataSet(entries: dataEntries1, label: graphData[1].dataTitle)
            chartDataSet1.drawValuesEnabled = false
            chartDataSet1.colors = [graphData[1].barColor]
            chartDataSet1.highlightColor = UIColor.clear
            barChartData.addDataSet(chartDataSet1)
            
            let groupSpace = 0.4
            let barSpace = 0.0
            let barWidth = 0.2
            barChartData.barWidth = barWidth
            barChartData.groupBars(fromX: 0, groupSpace: groupSpace, barSpace: barSpace)
        }
        return barChartData
    }
    
    func generateLineData(graphData: GraphDataEntry) -> LineChartData {
        // MARK: ChartDataEntry
        
        var entries = [ChartDataEntry]()
        
        for i in 0..<graphData.values.count {
            let dataEntry = BarChartDataEntry(x: Double(i+1), y: graphData.values[i])
            entries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(entries: entries, label: graphData.dataTitle)
        chartDataSet.drawValuesEnabled = false
        chartDataSet.colors = [graphData.barColor]
        
        // MARK: LineChartDataSet
        let set = LineChartDataSet(entries: entries, label: graphData.dataTitle)
        set.colors = [graphData.barColor]
        set.lineWidth = 1.5
        set.circleColors = [graphData.barColor]
        set.circleRadius = 6
        set.circleHoleRadius = 4.5
        //set.fillColor = graphData.barColor
        set.circleColors = [UIColor.white]
        set.circleHoleColor = graphData.barColor
        set.mode = .linear
        set.drawValuesEnabled = false
        
        if let font = UIFont(name: FontName.FuturaPTMedium.rawValue, size: 10) {
            set.valueFont = font
        }
        set.valueTextColor = graphData.barColor
        set.axisDependency = .right
        
        // MARK: LineChartData
        let data = LineChartData()
        data.addDataSet(set)
        return data
    }
    
}
