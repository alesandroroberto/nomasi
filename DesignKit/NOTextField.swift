//
//  NOTextField.swift
//  DesignKit
//
//  Created by Alexander Krupichko on 26.01.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import SwiftUI

public struct NOTextField: View {
    let title: String
    let text: Binding<String>
    
    public var body: some View {
        TextField(title, text: text)
            .padding(.horizontal, .gridSteps(4))
            .padding(.vertical, .gridSteps(2))
            .background(Color(.secondarySystemBackground))
    }
    
    public init(_ title: String, text: Binding<String>) {
        self.title = title
        self.text = text
    }
}

struct NOTextField_Previews: PreviewProvider {
    static var previews: some View {
        NOTextField("Placeholder",
                    text: .init(get: { "" }, set: { _ in }))
    }
}
