//
//  TestView.swift
//  Grain
//
//  Created by 지정훈 on 2023/01/20.
//

import SwiftUI

struct TestView: View {
    @ObservedObject var testVM = TestViewModel()
    
    var body: some View {
        VStack{
            ForEach(testVM.test, id: \.self){ item in
                Text(item.title)
            }
        }
    }
}
struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
