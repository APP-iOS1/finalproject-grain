//
//  MyPagePlaceholderView.swift
//  Grain
//
//  Created by 조형구 on 2023/04/02.
//

import SwiftUI

struct MyPagePlaceholderView: View {
    @Binding var presented: Bool

    var body: some View {
        VStack{
            Spacer()
            Text("보관하고 싶은 첫번째 기억을 업로드하세요")
                .foregroundColor(.middleDarkGray)
                .font(.callout)
            
            Button {
                presented.toggle()
            } label: {
                RoundedRectangle(cornerRadius: 10)
//                    .stroke()
                    .foregroundColor(.black)
                    .frame(width: Screen.maxWidth * 0.8, height: 45 )
                    .overlay{
                        Text("업로드")
                            .bold()
                            .foregroundColor(.white)
                         
                            
                    }
            }
            .padding()
            .padding(.top, 5)
            Spacer()
        }
        .frame(height: 250)

    }
}

struct MyCommunityPlaceholderView: View {
    @Binding var presented: Bool

    var body: some View {
        VStack{
            Spacer()
            Text("글을 작성하여 의견을 나누고 소통해보세요")
                .foregroundColor(.middleDarkGray)
                .font(.callout)
            
            Button {
                presented.toggle()
            } label: {
                RoundedRectangle(cornerRadius: 10)
//                    .stroke()
                    .foregroundColor(.black)
                    .frame(width: Screen.maxWidth * 0.8, height: 45 )
                    .overlay{
                        Text("업로드")
                            .bold()
                            .foregroundColor(.white)
                         
                            
                    }
            }
            .padding()
            .padding(.top, 5)
            Spacer()
        }
        .frame(height: 250)

    }
}

struct BookmarkedCommunityPlaceholderView: View {
    var body: some View {
        VStack{
            Spacer()
            Image(systemName: "bookmark")
                .foregroundColor(.middleDarkGray)
                .font(.title)
                .padding(.bottom)
            
            Text("다시 보고싶은 글을 저장해보세요")
                .foregroundColor(.middleDarkGray)
                .font(.callout)
//                .bold()

            Spacer()
        }
        .frame(height: 250)

    }
}

struct BookmarkedMagazinePlaceholderView: View {
    var body: some View {
        VStack{
            Spacer()
            Image(systemName: "bookmark")
                .foregroundColor(.middleDarkGray)
                .font(.title)
                .padding(.bottom)
            
            Text("다시 보고싶은 필름을 저장해보세요")
                .foregroundColor(.middleDarkGray)
                .font(.callout)
            

            Spacer()
        }
        .frame(height: 250)

    }
}

struct BlockingPlaceholderView: View {
    var body: some View {
        VStack{
            Spacer()
            Image(systemName: "person.fill.xmark")
                .foregroundColor(.middleDarkGray)
                .font(.title)
                .padding(.bottom)
            
            Text("차단한 유저가 없습니다.")
                .foregroundColor(.middleDarkGray)
                .font(.callout)
            

            Spacer()
        }
        .frame(height: 250)

    }
}

struct CurrentUserFollowerPlaceholderView: View {
    let userNickName: String
    
    var body: some View {
        VStack{
            Spacer()
            
            Text("\(userNickName)님을 구독하는 유저가 없습니다.")
                .foregroundColor(.middleDarkGray)
                .font(.callout)
            

            Spacer()
        }
        .frame(height: 550)

    }
}

struct CurrentUserFollowingPlaceholderView: View {
    var body: some View {
        VStack{
            Spacer()
            
            Text("구독 중인 유저가 없습니다.")
                .foregroundColor(.middleDarkGray)
                .font(.callout)
            

            Spacer()
        }
        .frame(height: 550)

    }
}

struct FollowerPlaceholderView: View {
    let userNickName: String
    
    var body: some View {
        VStack{
            Spacer()
            
            Text("\(userNickName)님을 구독하는 유저가 없습니다.")
                .foregroundColor(.middleDarkGray)
                .font(.callout)
            

            Spacer()
        }
        .frame(height: 550)

    }
}

struct FollowingPlaceholderView: View {
    let userNickName: String

    var body: some View {
        VStack{
            Spacer()
            
            Text("\(userNickName)님이 구독 중인 유저가 없습니다.")
                .foregroundColor(.middleDarkGray)
                .font(.callout)
            

            Spacer()
        }
        .frame(height: 550)

    }
}

struct BookmarkedCommunityPlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        BookmarkedCommunityPlaceholderView()
//        MyPagePlaceholderView(presented: .constant(false))
    }
}
