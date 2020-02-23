//
//  NOSecureField.swift
//  DesignKit
//
//  Created by Alexander Krupichko on 26.01.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import SwiftUI

public struct NOSecureField: View {
    let title: String
    let text: Binding<String>
    
    public var body: some View {
        SecureField(title, text: text)
            .padding(.horizontal, .gridSteps(4))
            .padding(.vertical, .gridSteps(2))
            .background(Color(.secondarySystemBackground))
    }
    
    public init(_ title: String, text: Binding<String>) {
        self.title = title
        self.text = text
    }
}

struct NOSecureField_Previews: PreviewProvider {
    static var previews: some View {
        NOSecureField("Placeholder",
                      text: .init(get: { "" }, set: { _ in }))
    }
}
