//
//  Created by Vijith on 21/10/2022.
//

import UIKit

public extension Movies {
    
    struct UIDataMapper {
        
        public init () { }
        
        /// Section Header Title Provider
        /// - parameters: Header title string
        /// - returns: Attributed string with custom fonts
        public var headerTitleProvider: (String) -> NSMutableAttributedString? = {
            let words = $0.components(separatedBy: .whitespacesAndNewlines)
            guard let firstWord = words.first else { return nil }
            var attributedText = NSMutableAttributedString(string: $0)
            if let range = $0.nsRange(of: firstWord) {
                attributedText.addAttribute(.font,
                                            value: DesignSystem.shared.font.preferredFont(.caption1, .light),
                                            range: range)
            }
            let remainingWords = words.filter { $0 != firstWord }.joined(separator: " ")
            if let range = $0.nsRange(of: remainingWords) {
                attributedText.addAttribute(.font,
                                            value: DesignSystem.shared.font.preferredFont(.caption1, .heavy),
                                            range:
                                            range)
            }
            return attributedText
        }
        
        public var movieDetailsHeaderTitleProvider: (String, String) -> NSMutableAttributedString = { title, year in
            
            let title = "\(title) \(year)"
            let attributedTitle = NSMutableAttributedString(string: title)
            
            if let range = title.nsRange(of: title) {
                attributedTitle.addAttribute(.font, value: DesignSystem.shared.font.preferredFont(.title3, .heavy), range: range)
                attributedTitle.addAttribute(.foregroundColor, value: DesignSystem.shared.colors.backgroundColor, range: range)
            }
            if let range = title.nsRange(of: year) {
                attributedTitle.addAttribute(.font, value: DesignSystem.shared.font.preferredFont(.title3, .light), range: range)
                attributedTitle.addAttribute(.foregroundColor, value: DesignSystem.shared.colors.backgroundColor.withAlphaComponent(0.7), range: range)
            }
            return attributedTitle
        }
        
        /// Date from string
        /// - parameters: String value of date
        /// - returns: formatted date
        public var date: (String?, DateFormats) -> Date? = { dateString, format in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format.rawValue
            return dateFormatter.date(from: dateString ?? "")
        }
        
        /// Year from date object
        /// - parameters: date value
        /// - returns: year in string
        public var yearFromDate: (Date?) -> String = {
            guard let date = $0 else { return "" }
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
            return "\(components.year ?? 0)"
        }
        
        /// String from data
        /// - parameters: Date object
        /// - parameters: Date format
        /// - returns: formated date
        public var stringFromDate: (Date?, DateFormats) -> String = { date, format in
            guard let date = date else { return "" }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format.rawValue
            return dateFormatter.string(from: date)
        }
        
        /// Duration from Int
        /// - parameters: Duration of movie
        /// - returns: formated value
        /// example: 130 t0 2h:10m
        public var durationProvier: (Int?) -> String? = { timeInterval in
            guard let interval = timeInterval else { return "" }
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
            formatter.unitsStyle = .abbreviated
            let value = TimeInterval(interval * 60)
            let formattedString = formatter.string(from: value)
            return formattedString
        }
    }
}

@objc
protocol ViewSetupProvidable: AnyObject {
    
    @objc optional func setup()
    @objc optional func applyStyles()
    @objc optional func applyConstraints()
    @objc optional func updateConstraints()
    @objc optional func addSubviews()
}

public enum DateFormats: String {
    case `default` = "yyyy-MM-dd"
    case dot = "dd.MM.yyy"
}
