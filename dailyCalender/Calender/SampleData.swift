//
//  SampleData.swift
//  dailyCalender
//
//  Created by 薗部拓人 on 2022/12/27.
//

import SwiftUI


// MARK: Model
// CoreDataのEntityの再現
struct Task1: Hashable, Identifiable{
    var name: String
    var startDate: Date
    var endDate: Date
    var id: UUID
    var color: Color
}

// MARK: データセットを作る
func makeDataSet() -> [Task1]{
    var tasks = [Task1]()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let dateString = "2022-12-06"
    let date = dateFormatter.date(from: dateString)!
    
    // Data Set
    let startDate1 = date
    let endDate1 = Calendar.current.date(byAdding: .minute, value: 60, to: startDate1)!
    let startDate2 = Calendar.current.date(byAdding: .minute, value: 0, to: startDate1)!
    let endDate2 = Calendar.current.date(byAdding: .minute, value: 100, to: startDate1)!
    let startDate3 = Calendar.current.date(byAdding: .minute, value: 30, to: startDate1)!
    let endDate3 = Calendar.current.date(byAdding: .minute, value: 150, to: startDate1)!
    let startDate4 = Calendar.current.date(byAdding: .minute, value: 300, to: startDate1)!
    let endDate4 = Calendar.current.date(byAdding: .minute, value: 480, to: startDate1)!
    let startDate5 = Calendar.current.date(byAdding: .minute, value: 200, to: startDate1)!
    let endDate5 = Calendar.current.date(byAdding: .minute, value: 300, to: startDate1)!
    let startDate6 = Calendar.current.date(byAdding: .minute, value: 600, to: startDate1)!
    let endDate6 = Calendar.current.date(byAdding: .minute, value: 700, to: startDate1)!
    let startDate7 = Calendar.current.date(byAdding: .minute, value: 800, to: startDate1)!
    let endDate7 = Calendar.current.date(byAdding: .minute, value: 900, to: startDate1)!
    let startDate8 = Calendar.current.date(byAdding: .minute, value: 1000, to: startDate1)!
    let endDate8 = Calendar.current.date(byAdding: .minute, value: 1300, to: startDate1)!
    let startDate9 = Calendar.current.date(byAdding: .minute, value: 1000, to: startDate1)!
    let endDate9 = Calendar.current.date(byAdding: .minute, value: 1300, to: startDate1)!
    let startDate10 = Calendar.current.date(byAdding: .minute, value: 50, to: startDate1)!
    let endDate10 = Calendar.current.date(byAdding: .minute, value: 150, to: startDate1)!
    let startDate11 = Calendar.current.date(byAdding: .minute, value: 1380, to: startDate1)!
    let endDate11 = Calendar.current.date(byAdding: .minute, value: 1435, to: startDate1)!
    let startDate12 = Calendar.current.date(byAdding: .minute, value: 1320, to: startDate1)!
    let endDate12 = Calendar.current.date(byAdding: .minute, value: 1435, to: startDate1)!
    let startDate13 = Calendar.current.date(byAdding: .minute, value: 540, to: startDate1)!
    let endDate13 = Calendar.current.date(byAdding: .minute, value: 660, to: startDate1)!
    let startDate14 = Calendar.current.date(byAdding: .minute, value: 600, to: startDate1)!
    let endDate14 = Calendar.current.date(byAdding: .minute, value: 720, to: startDate1)!
    
    tasks.append(Task1(name: "Lorem ipsum dolor sit amet consectetur", startDate: startDate1, endDate: endDate1, id: UUID(), color: Color.orange ))
    tasks.append(Task1(name: "Lorem ipsum dolor sit amet consectetur", startDate: startDate2, endDate: endDate2, id: UUID(), color: Color.orange))
    tasks.append(Task1(name: "Lorem ipsum dolor sit amet consectetur", startDate: startDate3, endDate: endDate3, id: UUID(), color: Color.red))
    tasks.append(Task1(name: "Lorem ipsum dolor sit amet consectetur", startDate: startDate4, endDate: endDate4, id: UUID(), color: Color.pink))
    tasks.append(Task1(name: "Lorem ipsum dolor sit amet consectetur", startDate: startDate5, endDate: endDate5, id: UUID(), color: Color.blue))
    tasks.append(Task1(name: "Read the Shushoku Teachings", startDate: startDate6, endDate: endDate6, id: UUID(), color: Color.white))
    tasks.append(Task1(name: "Lorem ipsum dolor sit amet consectetur", startDate: startDate7, endDate: endDate7, id: UUID(), color: Color.cyan))
    tasks.append(Task1(name: "Lorem ipsum dolor sit amet consectetur", startDate: startDate8, endDate: endDate8, id: UUID(), color: Color.cyan))
    tasks.append(Task1(name: "Lorem ipsum dolor sit amet consectetur", startDate: startDate9, endDate: endDate9, id: UUID(), color: Color.orange))
    tasks.append(Task1(name: "Lorem ipsum dolor sit amet consectetur", startDate: startDate10, endDate: endDate10, id: UUID(), color: Color.brown))
    tasks.append(Task1(name: "Lorem ipsum dolor sit amet consectetur", startDate: startDate11, endDate: endDate11, id: UUID(), color: Color.green))
    tasks.append(Task1(name: "Lorem ipsum dolor sit amet consectetur", startDate: startDate12, endDate: endDate12, id: UUID(), color: Color.yellow))
    tasks.append(Task1(name: "Lorem ipsum dolor sit amet consectetur", startDate: startDate13, endDate: endDate13, id: UUID(), color: Color.mint))
    tasks.append(Task1(name: "Lorem ipsum dolor sit amet consectetur", startDate: startDate14, endDate: endDate14, id: UUID(), color: Color.purple))
    return tasks
}





// MARK: 開始時刻、終了時刻の順に並べ替える。
let comparator = { (e1: Task1, e2: Task1) -> Bool in
    if e1.startDate < e2.startDate { return true }
    if e1.startDate > e2.startDate { return false }
    if e1.endDate < e2.endDate { return true }
    if e1.endDate > e2.endDate { return false }
    return false
}

/// Computes the x-axis properties of the task boxes for all regions in a given list of tasks.
/// The x-axis properties include the x-position ratio and width ratio of each task box, relative to the total width of the region.
/// These properties are used to determine the position and size of the task boxes when rendering them on a timeline view.
/// - Parameters:
///     - tasks: A list of Task objects representing the tasks to be rendered on the timeline.
/// - Returns:  A dictionary mapping the UUID of each task to a tuple containing its x-position ratio and width ratio.
func computeTaskBoxXAxisPropertiesOfAllRegion(tasks: [Task1]) -> [UUID: (CGFloat, CGFloat)] {
    var taskBoxXAxisPropertiesOfAllRegion: [UUID: (xPositionRatio: CGFloat, widthRatio: CGFloat)] = [:]
    var columnsInRegion: [[Task1]] = []
    var lastTaskEnding: Date?
    
    tasks.enumerated().forEach { (index, task) in
        // A: 今回のtaskが、前のtaskと時間が被っていない場合、これまでにpackしたtaskの、x軸上のpropertiesを算出して、辞書にマージする
        if lastTaskEnding != nil && task.startDate >= lastTaskEnding! {
            // 辞書型のtaskBoxXAxisPropertiesOfAllRegionに、taskBoxXAxisPropertiesOfOneRegionをマージする
            taskBoxXAxisPropertiesOfAllRegion.merge( packTasks(columnsInRegion: columnsInRegion) ){ (current, _) in current }
            columnsInRegion = [] //初期化して次のRegionに備える
            lastTaskEnding = nil //初期化して次のRegionに備える
        }
        
        // B: columnsを順に見て、前のtaskと今のtaskが重ならない場合、colmuns[i]に今のtaskを追加
        // e.g. [ [task1, task10, task11], [task2], [task3]... ] <- このcolumn[task1, task10 ... ]に、taskを追加していく
        var placed = false
        for i in 0..<columnsInRegion.count {
            
            let col = columnsInRegion[i]
            // 前のtaskと今のtaskが重なっていない場合は...
            if !collidesWith( a: col[col.count - 1], b: task ){
                columnsInRegion[i].append(task)
                placed = true
                break
            }
        }
        
        // C taskがどのカラムにも追加されなかった場合、新しいカラムを作成し、そこに今のtaskを追加
        // e.g. [ [task1], [task2], [task3]... ] <- このcolumnsに、column:[taskx]を追加していく
        if !placed {
            columnsInRegion.append([task])
            //            print(columnsInRegion)
        }
        
        // D 今のtaskのendDateが前回のtaskのendDateより大きい場合、lastTaskEndingを今のtaskのendDateに更新
        if lastTaskEnding == nil || task.endDate > lastTaskEnding! {
            lastTaskEnding = task.endDate
        }
    }
    if !columnsInRegion.isEmpty {
        taskBoxXAxisPropertiesOfAllRegion.merge( packTasks(columnsInRegion: columnsInRegion) ){ (current, _) in current }
    }
    return taskBoxXAxisPropertiesOfAllRegion
}


/// Determines whether two given Task objects overlap in time.
/// - Parameters:
///   - a: The first Task object.
///   - b: The second Task object.
/// - Returns: `true` if the tasks overlap, `false` otherwise.
func collidesWith(a: Task1, b: Task1) -> Bool {
    a.endDate > b.startDate && a.startDate < b.endDate
}


/// Packs a list of tasks into columns and calculates the x-axis properties of the task boxes for each task.
/// The x-axis properties include the x-position ratio and width ratio of each task box, relative to the total width of the region.
/// These properties are used to determine the position and size of the task boxes when rendering them on a timeline view.
/// - Parameters:
///   - columnsInRegion: A list of lists of `Task` objects, where each inner list represents a column and the tasks in the column do not overlap in time.
/// - Returns: A dictionary mapping the UUID of each task to a tuple containing its x-position ratio and width ratio.
func packTasks(columnsInRegion: [[Task1]]) -> [UUID: (CGFloat, CGFloat)]{
    var taskBoxXAxisPropertiesOfOneRegion: [UUID: (xPositionRatio: CGFloat, widthRatio: CGFloat)] = [:]
    let columnsCount = columnsInRegion.count
    
    for (index, column) in columnsInRegion.enumerated() {
        for task in column {
            let leftRate = CGFloat(index) / CGFloat(columnsCount)
            let widthRate = 100.0 / CGFloat(columnsCount) / 100.0
            taskBoxXAxisPropertiesOfOneRegion[task.id] = (xPositionRatio: leftRate, widthRatio: widthRate)
        }
    }
    return taskBoxXAxisPropertiesOfOneRegion
}


/// Gets the x-axis properties of the task boxes for a given list of tasks.
/// The x-axis properties include the x-position ratio and width ratio of each task box, relative to the total width of the region.
/// These properties are used to determine the position and size of the task boxes when rendering them on a timeline view.
/// The tasks are first sorted by start date and end date, and then the x-axis properties are calculated for all regions.
/// - Parameters:
///   - tasks: A list of `Task` objects representing the tasks to be rendered on the timeline.
/// - Returns: A dictionary mapping the UUID of each task to a tuple containing its x-position ratio and width ratio.
func getTaskBoxXAxisProperties(tasks: [Task1]) -> [UUID: (CGFloat, CGFloat)]{
    let sortedTasks = tasks.sorted(by: comparator)
    print("axisをgetしました")
    return computeTaskBoxXAxisPropertiesOfAllRegion(tasks: sortedTasks)
}


extension Date {
    func isSameDay(otherDay: Date) -> Bool{
        Calendar.current.isDate(self, equalTo: otherDay, toGranularity: .day)
    }
}
//
//extension View {
//    /// Applies the given transform if the given condition evaluates to `true`.
//    /// - Parameters:
//    ///   - condition: The condition to evaluate.
//    ///   - transform: The transform to apply to the source `View`.
//    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
//    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
//        if condition {
//            transform(self)
//        } else {
//            self
//        }
//    }
//}
