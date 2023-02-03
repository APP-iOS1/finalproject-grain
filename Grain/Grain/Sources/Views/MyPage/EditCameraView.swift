//
//  EditCameraView.swift
//  Grain
//
//  Created by 한승수 on 2023/01/31.
//

import SwiftUI

struct EditCameraView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var cameras: [String] = ["코닥", "캐논", "소니", "니콘"]
    @State private var lenses: [String] = ["렌즈1", "렌즈2", "렌즈3", "렌즈4"]
    @State private var films: [String] = ["코닥", "캐논", "소니", "니콘"]
    
    @State private var isShowingModal: Bool = false
  
    @State private var cameraModal: Bool = true
    @State private var lensModal: Bool = true
    @State private var filmModal: Bool = true


    var body: some View {
        NavigationStack{
            ZStack(alignment: .bottomTrailing){
                VStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("설정")
                            Spacer()
                            
                            
                            EditButton()
                            
                        }
                        .padding(.horizontal)
                    })
                    .accentColor(.black)
                    
                    List{
                        Section(header: Text("카메라")){
                            
                            ForEach(cameras, id: \.self) { camera in
                                Text(camera)
                            }
                            .onDelete(perform: removeCameraList(at:))
                            
                        }
                        
                        Section(header: Text("렌즈")){
                            ForEach(lenses, id: \.self) { lens in
                                Text(lens)
                            }
                            .onDelete(perform: removeLensList(at:))
                            
                        }
                        
                        Section(header: Text("필름")){
                            ForEach(films, id: \.self) { film in
                                Text(film)
                            }
                            .onDelete(perform: removeFilmList(at:))
                            
                        }
                    }
                    .listStyle(.sidebar)
                    .scrollContentBackground(.hidden)
                    
                }
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(true)
                
                FloatingMenu(isShowingModal: $isShowingModal, cameraModal: $cameraModal, lensModal: $lensModal, filmModal: $filmModal)
                    .padding()
            }
            .sheet(isPresented: $isShowingModal) {
                
                    if cameraModal{
                        CameraModalView()
//                        ListTestView()
                        .presentationDetents([.height(250)])
                    } else if lensModal{
                        VStack{
                            Text("렌즈")
                        }
                    } else if filmModal{
                        VStack{
                            Text("film")
                        }
                    }
                
            }
            
        }
    }
    // MARK: 카메라 삭제 함수
    func removeCameraList(at offsets: IndexSet) {
        cameras.remove(atOffsets: offsets)
    }
    
    // MARK: 렌즈 삭제 함수
    func removeLensList(at offsets: IndexSet) {
        lenses.remove(atOffsets: offsets)
        
    } // MARK: 필름 삭제 함수
    func removeFilmList(at offsets: IndexSet) {
        films.remove(atOffsets: offsets)
    }
}

struct EditCameraView_Previews: PreviewProvider {
    static var previews: some View {
        EditCameraView()
    }
}


