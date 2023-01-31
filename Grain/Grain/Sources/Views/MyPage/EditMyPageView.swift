//
//  EditMyPageView.swift
//  Grain
//
//  Created by 한승수 on 2023/01/31.
//

import SwiftUI
import Combine

struct EditMyPageView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var editedNickname = ""
    @State private var editedIntroduce = ""
    let nickNameLimit = 8
    let introduceLimit = 20
    var body: some View {
        VStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("설정")
                    Spacer()
                }
                .padding(.horizontal)
            })
            .accentColor(.black)
            
            Button {
                //이미지 선택 동작
            } label: {
                Image("2")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(64)
                    .overlay {
                        Circle()
                            .stroke(lineWidth: 1.5)
                            .foregroundColor(.black)
                    }
                    .overlay {
                        Circle()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                            .offset(x: Screen.maxWidth * 0.1, y: Screen.maxHeight * 0.04)
                            .overlay {
                                Image(systemName: "camera.circle.fill")
                                    .resizable()
                                    .frame(width: 26, height: 26)
                                    .foregroundColor(.black)
                                    .offset(x: Screen.maxWidth * 0.1, y: Screen.maxHeight * 0.04)
                            }
                    }
            }

            HStack {
                Text("닉네임")
                    .padding(.horizontal, 3)
                Spacer()
                Text("\(editedNickname.count)/8")
            }
            .padding(.horizontal)
            TextField("변경할 닉네임을 입력해주세요", text: $editedNickname)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .underlineTextField()
                .padding(.bottom, 30)
                .onReceive(Just(editedNickname)) { _ in
                    limitNickname(nickNameLimit)
                }
            
            HStack {
                Text("소개")
                    .padding(.horizontal, 3)
                Spacer()
                Text("\(editedIntroduce.count)/20")
            }
            .padding(.horizontal)
            TextField("소개글을 입력해주세요", text: $editedIntroduce)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .underlineTextField()
                .padding(.bottom, 30)
                .onReceive(Just(editedIntroduce)) { _ in
                    limitIntroduce(introduceLimit)
                }
            Spacer()

        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
    
    func limitNickname(_ upper: Int) {
        if editedNickname.count > upper {
            editedNickname = String(editedNickname.prefix(upper))
        }
    }
    func limitIntroduce(_ upper: Int) {
        if editedIntroduce.count > upper {
            editedIntroduce = String(editedIntroduce.prefix(upper))
        }
    }
}

struct EditMyPageView_Previews: PreviewProvider {
    static var previews: some View {
        EditMyPageView()
    }
}


extension View {
    func underlineTextField() -> some View {
        self
            .padding(.horizontal, 10)
            .overlay(Rectangle().frame(width: Screen.maxWidth * 0.9, height: 2).padding(.top, 35).padding(.horizontal))
            .foregroundColor(Color(UIColor.black))
            .padding(.horizontal,10)
    }
}
