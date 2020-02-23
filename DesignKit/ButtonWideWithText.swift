//
//  ButtonWideWithText.swift
//  DesignKit
//
//  Created by Alexander Krupichko on 26.01.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import SwiftUI

public struct NOWideTextButton: View {
    let title: String
    let action: () -> Void
    
    public var body: some View {
        Button(action: action) {
            Text(title)
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(.horizontal, .gridSteps(4))
                .padding(.vertical, .gridSteps(4))
                .background(Color(.secondarySystemBackground))
                .cornerRadius(.gridSteps(2))
        }
    }
    
    public init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
}

struct NOWideTextButton_Previews: PreviewProvider {
    static var previews: some View {
        NOWideTextButton("Button", action: {})
    }
}
