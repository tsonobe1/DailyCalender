//
//  DateExtention.swift
//  dailyCalender
//
//  Created by 薗部拓人 on 2023/01/19.
//

import Foundation

/// Converts a given Date object to a CGFloat representing the number of minutes since midnight.
/// - Parameters:
///   - date: The Date object to be converted.
/// - Returns: A CGFloat representing the number of minutes since midnight on the same day as date.
func dateToMinute(date: Date) -> CGFloat {
    let calendar = Calendar.current
    let hour = calendar.component(.hour, from: date)
    let minute = calendar.component(.minute, from: date)
    return CGFloat((hour * 60) + minute)
}

func dateTimeFormatter(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    let dateTimeString = dateFormatter.string(from: date)
    return dateTimeString
}

func dateFormatter(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.setLocalizedDateFormatFromTemplate("yMMMMdEEEE")
    let dateString = dateFormatter.string(from: date)
//    print("😊 DateString : \(dateString)")
    return dateString
}

/// Calculates the time interval in minutes between two given `Date` objects.
/// - Parameters:
///   - startDate: The start date of the time interval.
///   - endDate: The end date of the time interval.
/// - Returns: A CGFloat representing the time interval in minutes between startDate and endDate.
func caluculateTimeInterval(startDate: Date, endDate: Date) -> CGFloat {
    let timeInterval = endDate.timeIntervalSince(startDate)
    return CGFloat(timeInterval / 60)
}

/// Round the given moved position according to the minute period
/// - Parameters:
///   - movedPosition: The moved position before rounding
///   - scrollViewHeight: The height of the scroll view
///   - minutePeriod: The minute period to round to
/// - Returns: The rounded moved position and the moved minutes after rounding
func roundToMultipleMinutes(_ movedPosition: CGFloat, _ scrollViewHeight: CGFloat, _ minutePeriod: Double) -> (movedPosition: CGFloat, movedMinute: Int) {
    let perOneMinutePosition = floor(movedPosition / (scrollViewHeight / 1_440 * minutePeriod))
    let roundedMovedPosition = perOneMinutePosition * (scrollViewHeight / 1_440 * minutePeriod)
    return (roundedMovedPosition, Int(perOneMinutePosition * minutePeriod))
}
