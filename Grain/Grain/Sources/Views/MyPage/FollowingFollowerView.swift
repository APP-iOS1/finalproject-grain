//
//  FollowingFollowerView.swift
//  Grain
//
//  Created by 홍수만 on 2023/02/28.
//

import SwiftUI
import FirebaseAuth

struct FollowingFollowerView: View {
    @ObservedObject var userVM : UserViewModel
    var userData: UserDocument
    @ObservedObject var magazineVM: MagazineViewModel

    @State var selectedIndex: Int
    @State private var isShownPickerProgress: Bool = false
    
    let titles: [String] = ["구독자", "구독중"]

    var body: some View {
        VStack{
            SegmentedPicker(
                titles,
                selectedIndex: Binding(
                    get: { selectedIndex },
                    set: { selectedIndex = $0 ?? 0 }),
                content: { item, isSelected in
                    Text(item)
                        .foregroundColor(isSelected ? Color.black : Color.gray )
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .bold()
                        .frame(width: Screen.maxWidth * 0.48)
                },
                selection: {
                    VStack(spacing: 0) {
                        Spacer()
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: Screen.maxWidth * 0.4, height: 1)
                            .animation(.easeInOut.speed(1.5), value: selectedIndex)
                    }
                    
                })
            
            switch selectedIndex {
            case 0:
                FollowerListView(userVM: userVM, user: userData, magagineVM: magazineVM)
            case 1:
                FollowingListView(userVM: userVM, user: userData, magagineVM: magazineVM)
            default:
                FollowerListView(userVM: userVM, user: userData, magagineVM: magazineVM)
            }
//            .onChange(of: selectedIndex) { value in
//                self.isShownPickerProgress = true
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    self.isShownPickerProgress = false
//                }
//            }
        }
        .onAppear{
            userVM.fetchUser(nextPageToken: "")
            userVM.fetchCurrentUser(userID: Auth.auth().currentUser?.uid ?? "")
            print("Ddd")
        }
    }
}

struct CurrentUserFollowingFollowerView: View {
    @ObservedObject var userVM : UserViewModel
    @ObservedObject var magazineVM: MagazineViewModel
    
    @State var selectedIndex: Int
    @State private var isShownPickerProgress: Bool = false
    
    let titles: [String] = ["구독자", "구독중"]

    var body: some View {
        VStack{
            SegmentedPicker(
                titles,
                selectedIndex: Binding(
                    get: { selectedIndex },
                    set: { selectedIndex = $0 ?? 0 }),
                content: { item, isSelected in
                    Text(item)
                        .foregroundColor(isSelected ? Color.black : Color.gray )
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .bold()
                        .frame(width: Screen.maxWidth * 0.48)
                },
                selection: {
                    VStack(spacing: 0) {
                        Spacer()
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: Screen.maxWidth * 0.4, height: 2)
                            .animation(.easeInOut.speed(1.5), value: selectedIndex)
                    }
                    
                })
            
            switch selectedIndex {
            case 0:
                CurrentUserFollowerListView(userVM: userVM, magagineVM: magazineVM)
            case 1:
                CurrentUserFollowingListView(userVM: userVM, magagineVM: magazineVM)
            default:
                CurrentUserFollowerListView(userVM: userVM, magagineVM: magazineVM)
            }
//            .onChange(of: selectedIndex) { value in
//                self.isShownPickerProgress = true
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    self.isShownPickerProgress = false
//                }
//            }
        }
        .onAppear{
            userVM.fetchUser(nextPageToken: "")
            userVM.fetchCurrentUser(userID: Auth.auth().currentUser?.uid ?? "")
            print("Ddd")
        }
    }
}


//struct FollowingFollowerView_Previews: PreviewProvider {
//    static var previews: some View {
//        FollowingFollowerView(userVM: UserViewModel(), selectedIndex: 0)
//    }
//}
