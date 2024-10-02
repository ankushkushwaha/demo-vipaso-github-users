//
//  ToggleCheckmarkView.swift
//  GithubMobile
//
//  Created by Ankush Kushwaha on 02/10/24.
//

import SwiftUI

struct ToggleCheckmarkView: View {
    @Binding var isChecked: Bool
    let title: String
    
    var body: some View {
        
        HStack() {
            Text(title)
            Toggle(isOn: $isChecked) {
                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isChecked ? .red : .gray)
                    .font(.system(size: 20)) 
            }
            .toggleStyle(.button)
            .frame(height: 30) // Set fixed height here
        }
    }
}

struct ToggleCheckmarkView_Previews: PreviewProvider {
    static var previews: some View {
        ToggleCheckmarkView(isChecked: .constant(true), title: "Title")
    }
}
