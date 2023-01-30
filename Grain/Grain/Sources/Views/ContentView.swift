//
//  ContentView.swift
//  Grain
//
//  Created by 조형구 on 2023/01/18.
//

import SwiftUI

import FirebaseAuth


struct ContentView: View {
    @EnvironmentObject var authenticationStore: AuthenticationStore
    
    @State private var tabSelection: Int = 0
    @State var selectedIndex = 0
    @State var presented = false
    
    let icons = ["magazine", "note.text", "plus","map", "person"]
    
    var body: some View {
        switch authenticationStore.authenticationStatus {
        case .unAuthenticated:
            NavigationStack{
                AuthenticationView()
            }
            
        case.authenticated(let user):
            VStack{
                Spacer()
                //EditorView()
                ZStack {
                    Spacer().fullScreenCover(isPresented: $presented) {
                        VStack {

                            if self.selectedIndex == 0 {
                                MagazineContentAddView(presented: $presented)
                            } else if self.selectedIndex == 1{
                                AddCommunityView()
                            }
                            Spacer()

                        }
                    }
                    
                    switch selectedIndex {
                    case 0:
                        NavigationStack {
                            MagazineMainView()
                        }
                    case 1:
                        NavigationStack {
                            CommunityView()
                        }
                    case 2:
                        NavigationStack {
                            CommunityView()
                        }
                    case 3:
                        NavigationStack {
                            MapView()
                        }
                    case 4:
                        NavigationStack {
                            //프로필 뷰
                        }
                    default:
                        NavigationStack {
                            VStack {
                                Text("second screen")
                            }
                        }
                    }
                    Spacer()

                    
                }
                Divider()
                HStack {
                    ForEach(0..<5, id: \.self) { number in
                        Spacer()
                        Button {
                            if number == 2 {
                                presented.toggle()
                            } else {
                                self.selectedIndex = number
                            }
                        } label: {
                            if number == 2 {
                                Image(systemName: icons[number])
                                    .font(.system(size: 25,
                                                  weight: .regular,  design: .default))
                                    .foregroundColor(.white)
                                    .frame(width: 60, height: 60)
                                    .background(.black)
                                    .cornerRadius(30)
                                
                            }
                            else {
                                Image(systemName: icons[number])
                                    .font(.system(size: 25,
                                                  weight: .regular,  design: .default))
                                    .foregroundColor(selectedIndex == number ? .black : Color(UIColor.lightGray))
                            }
                        }
                        Spacer()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("Grain")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            Button {
                                //검색
                            } label: {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.black)
                            }
                            Button {
                                //글쓰기
                            } label: {
                                Image(systemName: "plus")
                                    .foregroundColor(.black)
                            }
                        }
                    }
                }
            }
        }
    }
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthenticationStore())
    }
}
