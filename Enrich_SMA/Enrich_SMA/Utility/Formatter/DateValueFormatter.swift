//
//  DateValueFormatter.swift
//  Enrich_SMA
//
//  Created by Harshal on 25/01/22.
//  Copyright © 2022 e-zest. All rights reserved.
//

import Foundation
import Charts

public class DateValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "dd MMM HH:mm"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}


public class CustomValueFormatter: NSObject, IAxisValueFormatter {
    
    var values = [String]()
    
    override init() {
        super.init()
    }
    
    public init(values: [String]) {
        self.values = values
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        var stringToReturn = ""
        
        for i in 0..<(values.count) {
            if Double(i+1) == value {
                stringToReturn = values[i]
                break
            }
        }
        return stringToReturn
    }
}

class BarChartFormatter: NSObject,IAxisValueFormatter,IValueFormatter {


    var values : [String]
    required init (values : [String]) {
        self.values = values
        super.init()
    }


    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return values[Int(value)]

    }

    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return values[Int(entry.x)]

    }
}

class CustomLabelsXAxisValueFormatter : NSObject, IAxisValueFormatter {
    
    var labels: [String] = []
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        let count = self.labels.count
        
        guard let axis = axis, count > 0 else {
            
            return ""
        }
        
        let factor = axis.axisMaximum / Double(count)
        
        let index = Int((value / factor).rounded())
        
        if index >= 0 && index < count {
            
            return self.labels[index]
        }
        
        return ""
    }
}
