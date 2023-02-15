////
////  txtediton.swift
////  Grain
////
////  Created by 윤소희 on 2023/02/15.
////
//
//import SwiftUI
//import Introspect
//
//struct txtediton: View {
//    
//    @State private var text = ""
//    let placeholder = "Placeholder"
//    
//    var body: some View {
//        VStack {
//          
//            TextEditor(text: $text)
//                .background(alignment: .topLeading) {
//                    TextEditor(text: .constant(text.isEmpty ? placeholder : "그레인 최고"))
//                        .foregroundColor(.gray)
//                }
//                .introspectTextView { uiTextView in
//                    uiTextView.backgroundColor = .clear
//                }
//        }
//        .border(.black)
//    }
//}
//
//struct txtediton_Previews: PreviewProvider {
//    static var previews: some View {
//        txtediton()
//    }
//}
