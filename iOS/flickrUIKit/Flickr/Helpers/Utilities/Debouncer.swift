//
//  Debouncer.swift
//  Flickr
//
//  Created by David Castro Cisneros on 30/09/22.
//  Copyright © 2022 Michael Harville. All rights reserved.
//

import Foundation

public final class Debouncer {
    typealias Handler = () -> Void
    
    private let timeInterval: TimeInterval
    private var timer: Timer?
    var handler: Handler?
    
    public init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    public func renewInterval() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false, block: { [weak self] timer in
            self?.handleTimer(timer)
        })
    }
    
    private func handleTimer(_ timer: Timer) {
        guard timer.isValid else {
            return
        }
        handler?()
    }
}
