//
//  CameraModalView.swift
//  Grain
//
//  Created by 홍수만 on 2023/02/01.
//

import SwiftUI

struct CameraModalView: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var camera1: String = ""
    @State private var camera2: String = ""
    @State private var camera3: String = ""
    
    var trimCamera1: String {
        camera1.trimmingCharacters(in: .whitespaces)
    }
    var trimCamera2: String {
        camera2.trimmingCharacters(in: .whitespaces)
    }
    var trimCamera3: String {
        camera3.trimmingCharacters(in: .whitespaces)
    }
    
    var body: some View {
        VStack{
            VStack{
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    HStack {
                        Image(systemName: "xmark")
                            .bold()
                        Spacer()
                        
                        if trimCamera1.count + trimCamera2.count + trimCamera3.count > 0 {
                            Button{
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Text("추가")
                                    .bold()
                            }
                            
                        } else {
                            Button{
                                
                            } label: {
                                Text("추가")
                            }
                        }
                        
                    }
                    .padding(.horizontal)
                    .padding(.top)
                })
                .accentColor(.black)
                .padding(.horizontal)
                .padding(.bottom)
            }
            .background(Color(UIColor.systemGray6))
            List{

                TextField("추가할 카메라를 입력하세요", text: $camera1)
                TextField("추가할 카메라를 입력하세요", text: $camera2)
                TextField("추가할 카메라를 입력하세요", text: $camera3)
            }
//            .background(.white)
//            .scrollContentBackground(.hidden)
            .listStyle(.plain)
            .padding()
        
        }
    }
}

struct CameraModalView_Previews: PreviewProvider {
    static var previews: some View {
        CameraModalView()
    }
}
