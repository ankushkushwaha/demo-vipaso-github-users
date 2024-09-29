//
//  ErrorAlert.swift
//  GithubMobile
//
//  Created by Ankush Kushwaha on 29/09/24.
//

import Foundation
import SwiftUI

struct AlertViewModifier: ViewModifier {
    @Binding var showAlert: Bool
        var title: String
        var message: String?
        
        func body(content: Content) -> some View {
            content
                .alert(title, isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(message ?? "")
                }
        }
}

extension View {
    func customAlert(showAlert: Binding<Bool>, title: String, message: String?) -> some View {
            self.modifier(AlertViewModifier(showAlert: showAlert, title: title, message: message))
        }
}
