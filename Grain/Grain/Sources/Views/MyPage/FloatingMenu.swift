//
//  FloatingMenu.swift
//  Grain
//
//  Created by 홍수만 on 2023/02/01.
//

import SwiftUI

struct FloatingMenu: View {
    
    @State var showCameraMenu = false
    @State var showLensMenu = false
    @State var showFilmMenu = false
    
    @Binding var isShowingModal: Bool
    
    @Binding var cameraModal: Bool
    @Binding var lensModal: Bool
    @Binding var filmModal: Bool
    
    var body: some View {
        VStack {
            Spacer()
            if showCameraMenu {
                MenuItem(icon:"camera.fill")
                    .onTapGesture {
                        self.showMenu()
                        isShowingModal.toggle()
                        cameraModal = true
                        lensModal = false
                        filmModal = false
                    }
            }
            
            if showLensMenu {
                MenuItem(icon:"camera.aperture")
                    .onTapGesture {
                        self.showMenu()
                        isShowingModal.toggle()
                        cameraModal = false
                        lensModal = true
                        filmModal = false
                    }
            }
            if showFilmMenu {
                MenuItem(icon:"film.fill")
                    .onTapGesture {
                        self.showMenu()
                        isShowingModal.toggle()
                        cameraModal = false
                        lensModal = false
                        filmModal = true
                    }
            }
            
            
            Button(action: {
                self.showMenu()
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width:70,height:70)
                    .foregroundColor(.black)
                    .shadow(color: .gray, radius: 0.3, x: 1, y: 1)
            }
        }
    }
    
    func showMenu(){
        withAnimation{
            showFilmMenu.toggle()
        }
        
        withAnimation{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                self.showLensMenu.toggle()
            }
        }
        
        withAnimation{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                self.showCameraMenu.toggle()
            }
        }
        
    }
}

struct FloatingMenu_Previews: PreviewProvider {
    static var previews: some View {
        FloatingMenu(isShowingModal: .constant(false), cameraModal: .constant(false), lensModal: .constant(false), filmModal: .constant(false))
    }
}

struct MenuItem: View {
    
    var icon: String // icon을 받아서 처리하도록 변경
    var body: some View {
        
        ZStack{
            Circle()
                .foregroundColor(.black)
                .frame(width:50,height:50)
            Image(systemName: icon)
                .imageScale(.large)
                .foregroundColor(.white)
        }
        .shadow(color: .gray, radius: 0.3, x: 1, y: 1)
        .transition(.move(edge: .trailing))
        
    }
}
