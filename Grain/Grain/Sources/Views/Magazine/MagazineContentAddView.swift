//
//  MagazineContentAddView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/20.
//

import SwiftUI

struct MagazineContentAddView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var titleText: String = ""
    @State private var contentText: String = ""
    @State private var inputTitle: String = ""
    @State private var inputPlace: String = ""
    @State private var inputContent: String = ""
    @State private var selectedCamera: Int = 0
    @State private var selectedLens: Int = 0
    @State private var selectedFilm: Int = 0
    let camera:[Int] = [1, 2, 3]
    let lens:[Int] = [1, 2, 3]
    let film:[Int] = [1, 2, 3]
    
    @Binding var isAddViewShown: Bool
    var body: some View {
        VStack {
            Button {
                
            } label: {
                HStack{
                    Image(systemName: "location.fill")
                    Text("위치 받아오기")
                }
            }
            Divider()
            HStack {
                VStack{
                    Text("카메라")
                        .padding(.bottom,-10)
                    //카메라 피커
                    Picker(selection: $selectedCamera, label: Text("Picker")) {
                        ForEach(0 ..< camera.count, id: \.self){index in
                            Text("\(camera[index])").tag(index)
                        }
                    }
                    
                }
                VStack{
                    Text("렌즈")
                        .padding(.bottom,-10)
                    //렌즈 피커
                    Picker(selection: $selectedLens, label: Text("Picker")) {
                        ForEach(0 ..< lens.count, id: \.self){index in
                            Text("\(lens[index])").tag(index)
                        }
                    }
                }
                VStack{
                    Text("필름")
                        .padding(.bottom,-10)
                    //필름 피커
                    Picker(selection: $selectedFilm, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                        ForEach(0 ..< film.count, id: \.self){index in
                            Text("\(film[index])").tag(index)
                        }
                    }
                }
            }
            

            HStack {
                Text("제목")
                    .padding(.horizontal)
                    .padding(.bottom, -15)
                Spacer()
            }
            TextField(
                "Title",
                text: $inputTitle
            )
            .padding()
            .border(.black)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .padding()
            
            TextEditor(
                text: $inputContent
            )
            .border(.black)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .padding()
            .overlay{
                if inputContent.isEmpty {
                    Text("내용을 입력해주세요.")
                        .foregroundColor(.gray)
                }
            }
            
            Button {
                isAddViewShown.toggle()
            } label: {
                Text("등록하기")
            }
            
        }
    }
}

struct MagazineContentAddView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            MagazineContentAddView(isAddViewShown: .constant(false))
        }
    }
}
