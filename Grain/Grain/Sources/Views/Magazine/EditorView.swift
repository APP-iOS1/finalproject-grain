//
//  EditorView.swift
//  Grain
//
//  Created by 윤소희 on 2023/02/03.
//

//네이버 블로그 클론코딩 ~

import SwiftUI

struct EditorView: View {
    //var data : MagazineDocument
    var body: some View {
        ScrollView {
                VStack{
                    //MARK: 장소
                    HStack{
                        Text("제주도")
                            .font(.subheadline)
                        Spacer()
                    }
                    .padding()
                    //MARK: 제목
                    HStack{
                        Text("필름에 담은 제주")
                            .font(.largeTitle)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, -5)
                    //MARK: 작성자 + 작성시간
                    HStack {
                        Circle()
                            .frame(width: 40)
                        VStack(alignment: .leading) {
                            //                    Text(data.fields.nickName.stringValue)
                            Text("wonder")
                                .bold()
                            HStack {
                                Text("1분전")
                                Spacer()
                                //   Text(data.fields.customPlaceName.stringValue)
                            }
                            .font(.caption)
                        }
                        Spacer()
                    }
                    .padding()
                    
                    Divider()
                        .padding(.horizontal)
                    
                    //MARK: 필름 사진
                    Image("jeju2")
                        .resizable()
                        .frame(width: Screen.maxWidth, height: Screen.maxWidth * 0.6)
                        .aspectRatio(contentMode: .fit)
                    
                    //MARK: 본문
                    Text("제주를 여행한다면 수많은 관광 명소 중 어디를 가야할 지 행복한 고민을 하게 되죠. 산과 오름, 해변, 폭포, 용암동굴, 주변 섬 등 어디를 가나 천혜의 아름다운 자연 경관을 만날 수 있어요. 걷기를 좋아한다면 올레, 숲길, 휴양림 등의 다양한 형태의 명소들을 찾을 수 있어요. 아이들과 함께 라면 박물관, 미술관, 과학관, 테마파크, 민속공원 등 수많은 선택지에 놀랄 거예요. 선택의 폭이 너무 넓기 때문에 일정과 숙소에 맞춰 사전 계획을 세우는 것은 필수예요.")
                        .lineSpacing(4.0)
                        .padding()
                    
                
                    //MARK: 필름 사진
                    Image("jeju1")
                        .resizable()
                        .frame(width: Screen.maxWidth, height: Screen.maxWidth * 0.6)
                        .aspectRatio(contentMode: .fit)
                    
                    
                    //MARK: 본문
                    VStack{
                        Text("제주를 여행한다면 수많은 관광 명소 중 어디를 가야할 지 행복한 고민을 하게 되죠. 산과 오름, 해변, 폭포, 용암동굴, 주변 섬 등 어디를 가나 천혜의 아름다운 자연 경관을 만날 수 있어요.")
                            .lineSpacing(4.0)
                            .padding()
                        Text("걷기를 좋아한다면 올레, 숲길, 휴양림 등의 다양한 형태의 명소들을 찾을 수 있어요. 아이들과 함께 라면 박물관, 미술관, 과학관, 테마파크, 민속공원 등 수많은 선택지에 놀랄 거예요. 선택의 폭이 너무 넓기 때문에 일정과 숙소에 맞춰 사전 계획을 세우는 것은 필수예요.")
                            .lineSpacing(4.0)
                            .padding()
                    }
                    
                    //MARK: 필름 사진
                    Image("jeju3")
                        .resizable()
                        .frame(width: Screen.maxWidth, height: Screen.maxWidth * 0.6)
                        .aspectRatio(contentMode: .fit)
                    
                    //MARK: 본문
                    Text("제주를 여행한다면 수많은 관광 명소 중 어디를 가야할 지 행복한 고민을 하게 되죠. 산과 오름, 해변, 폭포, 용암동굴, 주변 섬 등 어디를 가나 천혜의 아름다운 자연 경관을 만날 수 있어요. 걷기를 좋아한다면 올레, 숲길, 휴양림 등의 다양한 형태의 명소들을 찾을 수 있어요. 아이들과 함께 라면 박물관, 미술관, 과학관, 테마파크, 민속공원 등 수많은 선택지에 놀랄 거예요. 선택의 폭이 너무 넓기 때문에 일정과 숙소에 맞춰 사전 계획을 세우는 것은 필수예요.")
                        .lineSpacing(4.0)
                        .padding()
                }
                
            
        }
        .padding(.top, 1)
    }
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        EditorView()
    }
}
