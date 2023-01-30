//
//  WebkitView.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/23.
//

import SwiftUI
import WebKit

// TODO: 현상소, 수리점 마커 클릭시 넘어올 뷰

struct WebkitView: UIViewRepresentable {
    
    @Binding var bindingWebURL : String
    //ui view 만들기
    func makeUIView(context: Context) -> WKWebView {
        print("urlToLoad :\(bindingWebURL)")
        //unwrapping
        guard let url = URL(string: bindingWebURL) else {
            print("error")
            return WKWebView()
        }
        //웹뷰 인스턴스 생성
        let webView = WKWebView()
        
        //웹뷰를 로드한다
        webView.load(URLRequest(url: url))
        return webView
    }
    
    //업데이트 ui view
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebkitView>) {
        
    }
}
