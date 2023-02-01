//
//  FloatingMenu.swift
//  Grain
//
//  Created by 홍수만 on 2023/02/01.
//

import SwiftUI

struct FloatingMenu: View {
    
     @State var showMenuItem1 = false
     @State var showMenuItem2 = false
     @State var showMenuItem3 = false
    
    var body: some View {
        VStack {
            Spacer()
            if showMenuItem1 {
                MenuItem(showMenuItem1: $showMenuItem1, showMenuItem2: $showMenuItem2, showMenuItem3: $showMenuItem3, icon:"camera.fill")
            }
            if showMenuItem2 {
                MenuItem(showMenuItem1: $showMenuItem1, showMenuItem2: $showMenuItem2, showMenuItem3: $showMenuItem3,icon:"camera.aperture")
            }
            if showMenuItem3 {
                MenuItem(showMenuItem1: $showMenuItem1, showMenuItem2: $showMenuItem2, showMenuItem3: $showMenuItem3,icon:"film.fill")
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
                showMenuItem3.toggle()
        }
        
        withAnimation{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                    self.showMenuItem2.toggle()
                }

        }
        withAnimation{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            self.showMenuItem1.toggle()
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
    
    @Binding var showMenuItem1: Bool
    @Binding var showMenuItem2: Bool
    @Binding var showMenuItem3: Bool
    
    var icon: String // icon을 받아서 처리하도록 변경
    var body: some View {
        Button{
            
            if showMenuItem1 {
                print("showMenuItem1")
            } else if showMenuItem2 {
                print("showMenuItem2")
            } else if showMenuItem3 {
                print("showMenuItem3")
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
