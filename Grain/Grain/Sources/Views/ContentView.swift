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
                            HStack {
                                Button {
                                    presented.toggle()
                                    //글쓰기 취소
                                } label: {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.black)
                                        .frame(width: 50, height: 50)
                                }
                                Spacer()
                                if self.selectedIndex == 0 {
                                    Text("매거진")
                                } else  if self.selectedIndex == 1 {
                                    Text("커뮤니티")
                                }
                                Spacer()
                                Button {
                                    presented.toggle()
                                    //글쓰기 동작 함수
                                } label: {
                                    Text("글쓰기")
                                        .foregroundColor(.black)
                                }

                            }
                            .padding(.horizontal)
                            Spacer()
                            if self.selectedIndex == 0 {
                                //매거진 글쓰기 뷰
                            } else if self.selectedIndex == 1{
                                AddCommunityView()
                            }
                            Spacer()

                        }
                    }
                    
                    switch selectedIndex {
                    case 0:
                        NavigationStack {
                            MagazineBestView()
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
