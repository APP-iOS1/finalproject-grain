////
////  MyPageView2.swift
////  Grain
////
////  Created by 홍수만 on 2023/02/03.
////
//
//import SwiftUI
//
//struct MyPageView2: View {
//
//    // Segment를 위한 변수 선언
////    let titles: [String] = ["나의 메거진", "나의 커뮤니티", "저장됨"]
////    @State private var selectedIndex: Int = 0
//
//    var body: some View {
//        VStack{
//
//            //MARK: - 사용자 정보 섹션
//            UserInfo()
//
//            //MARK: - 내가 작성한 피드, 게시물 segment 선택
////            MyPageSegment(titles: titles)
//
//            MyPageMyFeedView()
//        }
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                NavigationLink {
////                    MyPageOptionView()
//                } label: {
//                    Image(systemName: "ellipsis")
//                        .foregroundColor(.black)
//                }
//            }
//        }
//
//    }
//}
//
//struct MyPageView2_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack{
//            MyPageView2()
//        }
//    }
//}
//
//struct UserInfo: View {
//    var body: some View {
//        VStack(alignment: .leading){
//            HStack{
//                Image("1")
//                    .resizable()
//                    .scaledToFit()
//                    .clipShape(Circle())
//                    .frame(width: 120, height: 120)
//
//                Text("자기소개 bsdadfadfadfadfdafddddh")
//                    .lineLimit(4)
//
//                Spacer()
//            }
//
//            Text("닉네임")
//                .font(.title2)
//                .bold()
//                .padding(.leading, 25)
//        }
//    }
//}
//
//struct MyPageSegment: View {
//
//    // Segment를 위한 변수 선언
//    let titles: [String]
//    @State private var selectedIndex: Int = 0
//
//    var body: some View {
//        HStack{
//            Spacer()
//            SegmentedPicker(
//                titles,
//                selectedIndex: Binding(
//                    get: { selectedIndex },
//                    set: { selectedIndex = $0 ?? 0 }),
//                content: { item, isSelected in
//                    Text(item)
//                        .foregroundColor(isSelected ? Color.black : Color.gray )
//                        .padding(.horizontal, 16)
//                        .padding(.vertical, 8)
//                        .font(.title3)
//                        .bold()
//                },
//                selection: {
//                    VStack(spacing: 0) {
//                        Spacer()
//                        Rectangle()
//                            .fill(Color.black)
//                            .frame(height: 1)
//                    }
//                })
//
//            Spacer()
//        }
//    }
//}
