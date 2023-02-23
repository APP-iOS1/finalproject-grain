//
//  GeocodeAPI.swift
//  Grain
//
//  Created by 지정훈 on 2023/02/01.
//

import Foundation

///https://velog.io/@j_aion/iOS-%EB%84%A4%EC%9D%B4%EB%B2%84-%ED%81%B4%EB%A1%9C%EB%B0%94-API-%EC%97%B0%EB%8F%99 <- 참고자료


/*
 curl -G "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode" \
--data-urlencode "query={주소}" \
--data-urlencode "coordinate={검색_중심_좌표}" \
-H "X-NCP-APIGW-API-KEY-ID: {애플리케이션 등록 시 발급받은 client id값}" \
-H "X-NCP-APIGW-API-KEY: {애플리케이션 등록 시 발급받은 client secret값}" -v
*/
///따라 해보면서 enum으로 만들어 보기 naver api에 쿼리에 들어야 할 헤더 값
enum NaverAPIEnum {
    case naverApI
    // MARK: 네이버 클라우드 플랫폼 Client ID
    var clientHeaderKeyID: String {
        switch self {
        case .naverApI: return "X-NCP-APIGW-API-KEY-ID"
        }
    }
    // MARK: 네이버 클라우드 플랫폼 Client Secret
    var clientHeaderSecretID: String {
        switch self {
        case .naverApI: return "X-NCP-APIGW-API-KEY"
        }
    }
}
