//
//  Units.swift
//  DesignKit
//
//  Created by Alexander Krupichko on 26.01.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import SwiftUI

extension CGFloat {
    public static let gridStep: CGFloat = 4
    public static func gridSteps(_ steps: Int) -> CGFloat { CGFloat(steps) * gridStep }
}
