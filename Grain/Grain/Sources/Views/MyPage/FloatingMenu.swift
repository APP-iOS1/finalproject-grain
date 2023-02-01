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
    
    @State var showCameraSheet: Bool = false
    @State var showLensSheet: Bool = false
    @State var showFilmSheet: Bool = false

    
    var body: some View {
        VStack {
            Spacer()
            if showCameraMenu {
                MenuItem(showCameraMenu: $showCameraMenu, showLensMenu: $showLensMenu, showFilmMenu: $showFilmMenu, icon:"camera.fill")
            }
            if showLensMenu {
                MenuItem(showCameraMenu: $showCameraMenu, showLensMenu: $showLensMenu, showFilmMenu: $showFilmMenu,icon:"camera.aperture")
            }
            if showFilmMenu {
                MenuItem(showCameraMenu: $showCameraMenu, showLensMenu: $showLensMenu, showFilmMenu: $showFilmMenu,icon:"film.fill")
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
        FloatingMenu()
    }
}

struct MenuItem: View {
    
    @Binding var showCameraMenu: Bool
    @Binding var showLensMenu: Bool
    @Binding var showFilmMenu: Bool
    
    var icon: String // icon을 받아서 처리하도록 변경
    var body: some View {
        Button{
            
            if showCameraMenu {
                print("showCameraMenu")
            }
            
            if showLensMenu {
                print("showLensMenu")
            }
            if showFilmMenu {
                print("showFilmMenu")
            }
            
        } label: {
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
}
