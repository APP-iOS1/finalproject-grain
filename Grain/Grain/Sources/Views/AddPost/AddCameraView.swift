//
//  AddCameraView.swift
//  Grain
//
//  Created by 홍수만 on 2023/04/04.
//

import SwiftUI

struct AddCameraView: View {
    @ObservedObject var userVM: UserViewModel
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("아직 장비를 등록하지 않으셨군요")
                    .font(.title)
                    .bold()
                    .padding()
                VStack{
                    Text("장비 등록 화면으로 이동하여")
                    Text("촬영하신 카메라, 렌즈, 필름을 등록해주세요!")
                }
                .font(.headline)
                .padding()
                
                NavigationLink{
                    EditCameraView(userVM: userVM)
                        .padding(.top)
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                    //                    .stroke()
                        .foregroundColor(.black)
                        .frame(width: Screen.maxWidth * 0.5, height: 45 )
                        .overlay{
                            Text("장비등록하기")
                                .bold()
                                .foregroundColor(.white)
                            
                            
                        }
                }
                .padding()
            }
        }
    }
}

struct AddCameraView_Previews: PreviewProvider {
    static var previews: some View {
        AddCameraView(userVM: UserViewModel())
    }
}
