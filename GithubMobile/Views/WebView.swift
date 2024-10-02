//
//  WebView.swift
//  GithubMobile
//
//  Created by Ankush Kushwaha on 02/10/24.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

struct WebViewContainer: View {
    let url: URL

    var body: some View {
        WebView(url: url)
            .navigationBarTitle("Web Page", displayMode: .inline)
            .navigationBarBackButtonHidden(false)
    }
}
