//
//  TestPickerView.swift
//  Grain
//
//  Created by 박희경 on 2023/04/06.
//


import SwiftUI


struct ItemListView: View {
    @ObservedObject var userVM: UserViewModel
    @Binding var selectedCamera: String
    @Binding var selectedLense: String
    @Binding var selectedFilm: String
    @Binding var showModal: Bool
    
    var body: some View {
        NavigationView {
            VStack{
                List {
                    Section("이 필름에 사용된 카메라 바디를 선택해 주세요") {
                        Text("\(userVM.myCamera[0])")
                        ForEach(1..<userVM.myCamera.count) { i in
                            ListCell(selectedCamera: $selectedCamera, selectedLense: $selectedLense, selectedFilm: $selectedFilm, type: "카메라", text: userVM.myCamera[i])
                        }
                    }
                    
                    Section("이 필름에 사용된 렌즈를 선택해 주세요") {
                        Text("\(userVM.myLens[0])")
                        ForEach(1..<userVM.myLens.count) { i in
                            ListCell(selectedCamera: $selectedCamera, selectedLense: $selectedLense, selectedFilm: $selectedFilm, type: "렌즈", text: userVM.myLens[i])
                        }
                        ListCell(selectedCamera: $selectedCamera, selectedLense: $selectedLense, selectedFilm: $selectedFilm, type: "렌즈", text: "선택 안함")
                    }
                    Section("이 필름에 사용된 필름을 선택해 주세요") {
                        Text("\(userVM.myFilm[0])")
                        ForEach(1..<userVM.myFilm.count) { i in
                            ListCell(selectedCamera: $selectedCamera, selectedLense: $selectedLense, selectedFilm: $selectedFilm, type: "필름", text: userVM.myFilm[i])
                        }
                        ListCell(selectedCamera: $selectedCamera, selectedLense: $selectedLense, selectedFilm: $selectedFilm, type: "필름", text: "없음")
                    }
                }.listStyle(.insetGrouped)
                
            } .toolbar {
                ToolbarItem {
                    Button {
                        showModal.toggle()
                    } label: {
                        Text("완료")
                            .foregroundColor(.black)
                            .font(.body)
//                            .bold()
                    }.padding(.horizontal, 8)
                }
            }
        }
    }
}

struct ListCell: View {
    @Binding var selectedCamera: String
    @Binding var selectedLense: String
    @Binding var selectedFilm: String
    var type: String
    var text: String
    
    var body: some View {
        HStack {
            CheckBoxView(selectedCamera: $selectedCamera, selectedLense: $selectedLense, selectedFilm: $selectedFilm, type: type, text: text)
            
            Text(text).padding(.horizontal)
        }
    }
    
}



struct CheckBoxView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var selectedCamera: String
    @Binding var selectedLense: String
    @Binding var selectedFilm: String
    
    var type: String
    var text: String
    
    var body: some View
    {
        
        switch type {
        case "카메라" :
            Image(systemName: selectedCamera == text ? "checkmark.circle.fill" : "circle")
                .foregroundColor( selectedCamera == text ? .black : .secondary)
                .onTapGesture {
                    selectedCamera = text
                }
        case "렌즈" :
            Image(systemName: selectedLense == text ? "checkmark.circle.fill" : "circle")
                .foregroundColor(selectedLense == text ? .black : .secondary)
                .onTapGesture {
                    if text == "없음" {
                        selectedLense = " "
                    }
                    selectedLense = text

                }
        default :
            Image(systemName: selectedFilm == text ? "checkmark.circle.fill" : "circle")
                .foregroundColor(selectedFilm == text ? .black : .secondary)
                .onTapGesture {
                    if text == "없음" {
                        selectedFilm = " "
                    }
                    selectedFilm = text
                }
        }
    }
    
}
