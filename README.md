
<p align="center">
<img width="1838" alt="스크린샷 2023-04-12 오후 3 52 02" src="https://user-images.githubusercontent.com/73868968/231423605-b0e9583e-b514-4817-8038-be1225b07b4c.png">

 ## 앱스토어
 > <A href = https://apps.apple.com/kr/app/grain-그레인-필름-카메라-감성-sns/id6446666081 >앱스토어 설치 링크</A>
</p>


### 페르소나
> 필름카메라를 취미로 갖거나, 직업으로 가진 사람들

### ADS
> 그레인은 나만의 필름감성을 공유하고, 필름사진과 관련된 정보들을 공유하고, 필름 유저들을 위한 커뮤니티를 제공하는 앱이다.

### 개발 기간 
> 2023.01.16 ~ 2023.02.16 , 2023.02.27 ~ 2023.04.18

<br>

## How to build 🧐
### 설치 / 실행 방법

### 1단계
* 아래 파일은 필수 파일이므로 파일을 요청해주세요 😄
```
- Config.xcconfig       
```
### 2단계
Firebase 콘솔 세팅을 진행해주세요 😄
```
- 번들ID: com.TeamGrain.Grain
```
### 3단계
Podfile 확인 후 pod 파일을 설치해 주세요 😊
```sh
$ pod install
```
### 4단계
- Grain.xcworkspace 파일을 열어서 실행해 주세요 😁
- PROJECT -> Grain -> Info -> Configurations -> Debug, Release 아래에 있는 Grain, GrainNotification을 1단계에서 받은 Config로 설정해 주세요 😗
### 문의 
- 기타 문의사항은 https://bit.ly/Grain_FAQ 통해 작성해 주세요!

<br>


## 주요기능과 스크린샷

### 피드 탭

- Grain 에디터가 작성한 큐레이션 피드도 제공됩니다.
- 인기 피드글은 좋아요 순으로, 실시간 피드글은 최신순으로 정렬됩니다.
- 실시간 피드글에서는 구독자 필터 기능을 이용하여 자신이 구독한 사람의 피드글만 확인할 수 있습니다.
- 피드에서는 찍은 사진에 대한 카메라, 필름, 렌즈 정보를 함께 공유할 수 있습니다.
- 댓글, 대댓글 기능을 통해 다른 사용자와 소통할 수 있으며, 피드에 대한 좋아요와 저장 기능도 있습니다.
- 자신이 작성한 피드의 제목과 내용만 수정, 삭제할 수 있습니다.
- 다른 유저의 피드에 대한 신고 기능도 있습니다.
- 피드에 대한 공유 기능이 있습니다.
- 피드 작성 기능에서는 사진 5장까지 업로드 가능하며, 피드에 보여줄 장비(카메라, 렌즈, 필름), 제목과 내용은 필수 입력사항입니다. 또한 지도에서 필름사진의 포토스팟 위치를 정해야 합니다. 나만의 장소를 입력해야 업로드가 가능하며, 검색 기능을 이용하여 원하는 지역 근처로 지도를 이동할 수 있습니다.

 <div id="feed">

 | 큐레이션 피드 | 인기, 실시간, 구독 피드 | 피드 상세 기능 |
 |-------|-------|-------|
 | <img src="https://github.com/APPSCHOOL1-REPO/finalproject-grain/assets/73868968/950f0cea-dbca-4e36-8e85-e878a54bc3f0" alt="피드 1" width="150" height="300">| <img src="https://github.com/APPSCHOOL1-REPO/finalproject-grain/assets/73868968/07f7c80f-954b-4b50-baa4-6dcf3abf2654" alt="피드 2,3" width="150" height="300"> | <img src="https://github.com/APPSCHOOL1-REPO/finalproject-grain/assets/73868968/3ef66dea-259a-4e18-867b-940c462c34bf" alt="피드4,5" width="150" height="300"> |
 | 피드 수정, 삭제 | 피드 신고 | 피드 공유 |
 | <img src="https://github.com/APPSCHOOL1-REPO/finalproject-grain/assets/73868968/4c4dfc28-dc0e-4e37-9e5a-52efeacf6ae9" alt="피드6" width="150" height="300">| <img src="https://github.com/APPSCHOOL1-REPO/finalproject-grain/assets/73868968/27cd1367-cadc-4047-8d1b-ee6dbb043d8e" alt="피드7" width="150" height="300">| <img src="https://github.com/APPSCHOOL1-REPO/finalproject-grain/assets/73868968/b4ab150a-3cfb-4b31-90e1-6bd8932d8d26" alt="피드8" width="150" height="300"> | 
| 피드 업로드 |
| <img src="https://github.com/APPSCHOOL1-REPO/finalproject-grain/assets/73868968/e08025e3-3522-4dd9-b80d-60feeb67f2d6" alt="피드9" width="150" height="300">|
</div>


### 커뮤니티 탭

- 매칭, 마켓, 클래스, 정보 카테고리에서 각 분야별 모집글을 확인할 수 있습니다.
- 댓글, 대댓글 기능을 통해 다른 사용자와 소통할 수 있습니다.
- 모든 게시글은 최신순으로 정렬됩니다.
- 모집완료, 판매완료 등의 게시글은 스크롤 아래에 배치됩니다.
- 커뮤니티 작성 기능은 사진 5장까지 업로드 가능하며, 제목과 내용은 필수 입력 사항입니다.
- 작성한 게시글의 제목과 내용만 수정 가능하며, 모집/판매 상태를 변경하거나 삭제할 수 있습니다.
- 커뮤니티 게시글은 저장 기능이 있어 마이 페이지에서 확인 가능합니다.
- 다른 유저 게시글에 대한 신고 기능도 있습니다.


<div id="community">
 
 | 분야별 모집 글 | 업로드, 수정, 상태 모집/판매 변경 | 신고 기능 |
  |-------|-------|-------|
 | <img src="https://github.com/APPSCHOOL1-REPO/finalproject-grain/assets/73868968/141cce08-801b-497b-865b-e5c494f1b3c1" alt="커뮤1,2" width="150" height="300">| <img src="https://github.com/APPSCHOOL1-REPO/finalproject-grain/assets/73868968/737395e2-0b5a-41e1-b980-42306fc5da65" alt="커뮤5,6" width="150" height="300"> | <img src="https://github.com/APPSCHOOL1-REPO/finalproject-grain/assets/73868968/5e76c676-846f-4bff-b8c9-15a6a7cee84a" alt="커뮤8" width="150" height="300">|
| 수정, 삭제 |
| <img src="https://github.com/APPSCHOOL1-REPO/finalproject-grain/assets/73868968/e1779d18-97eb-4c76-a559-7565eef01e84" alt="커뮤9" width="150" height="300">| 

</div>

### 지도 탭

- 현재 위치에서 가까운 포토스팟, 현상소, 수리점을 지도상에 표시해줍니다.
- 피드에 글을 등록하면 해당 위치가 지도에 표시되어 다른 사용자들도 확인할 수 있습니다.
- 포토스팟 마커를 클릭하면 가까운 포토스팟 피드도 확인할 수 있습니다.
- 검색 기능을 이용하여 원하는 지역 근처의 포토스팟, 현상소, 수리점을 찾아볼 수 있습니다.
- 제보 기능을 이용하여 등록되지 않은 현상소, 수리점 위치 정보를 제보할 수 있습니다.

 <div id="feed">

 | 카테고리 별 마커 표시 | 현상소, 수리점 정보 표시 | 포토스팟 피드 확인 |
 |-------|-------|-------|
 | <img src="https://github.com/APPSCHOOL1-REPO/finalproject-grain/assets/73868968/7c997670-3a20-4622-8470-6cf7c911ffd4" alt="지도1" width="150" height="300">| <img src="https://github.com/APPSCHOOL1-REPO/finalproject-grain/assets/73868968/56d9b787-e75d-4e98-a07e-9f6bf47757a8" alt="지도2" width="150" height="300"> | <img src="https://github.com/APPSCHOOL1-REPO/finalproject-grain/assets/73868968/63816f74-8606-4f40-9466-1177ab06026c" alt="지도3" width="150" height="300"> |
 | 이 지역 재검색 | 지역 검색 | 현상소, 수리점 제보 |
 | <img src="https://github.com/APPSCHOOL1-REPO/finalproject-grain/assets/73868968/43db18c6-5bf4-4807-b2c2-709258f1c65a" alt="지도4" width="150" height="300">| <img src="https://github.com/APPSCHOOL1-REPO/finalproject-grain/assets/73868968/428525ef-aef0-4de1-9737-3c701fe2d3ab" alt="지도5" width="150" height="300">| <img src="https://github.com/APPSCHOOL1-REPO/finalproject-grain/assets/73868968/ec50f5ee-9cf5-43d2-be5f-2e17692cafb6" alt="피드8" width="150" height="300"> | 

</div>


### 마이 페이지 탭

- Grain에서 다른 사용자에게 공개되는 내 정보를 확인할 수 있습니다.
- 구독자 및 현재 구독 중인 사용자 목록을 확인할 수 있습니다.
- 보유한 카메라 및 렌즈 등의 장비 정보를 확인할 수 있습니다.
- 내가 업로드한 피드들을 모아 볼 수 있는 기능이 제공됩니다.

<div id="myPage">
 
 | 프로필 편집 | 고객센터, 피드백, 문의사항 | 로그아웃, 회원탈퇴 |
  |-------|-------|-------|
 | <img src="https://github.com/APPSCHOOL1-REPO/finalproject-grain/assets/73868968/0499812f-a921-4caa-81ba-b87fce33888c" alt="마이1" width="150" height="300">| <img src="https://github.com/APPSCHOOL1-REPO/finalproject-grain/assets/73868968/765efa1c-1df7-4366-8df6-873016a1d65e" alt="마이3" width="150" height="300">| <img src="https://github.com/APPSCHOOL1-REPO/finalproject-grain/assets/73868968/0adafc63-2469-42c6-82f8-8b0f8a71e16f" alt="마이4" width="150" height="300">| 
| 구독/차단/저장/작성 글 확인  | 유저 구독, 차단 기능 ( 필터링 ) | 차단계정 관리 |
| <img src="https://github.com/APPSCHOOL1-REPO/finalproject-grain/assets/73868968/c70b075f-225d-4ba4-b67c-7dff95626b92" alt="마이2" width="150" height="300"> | <img src="https://github.com/APPSCHOOL1-REPO/finalproject-grain/assets/73868968/bd8246b4-9a29-4261-93df-c6b159591d2d" alt="차단1" width="150" height="300"> | <img src="https://github.com/APPSCHOOL1-REPO/finalproject-grain/assets/73868968/3036ea35-492f-489f-8cd4-dfc3cd74801e" alt="차단2" width="150" height="300"> |

</div>



### 검색

- 다른 사용자들이 업로드한 피드 및 커뮤니티 글을 검색하여 찾아볼 수 있습니다.
- 사용자 검색 기능을 이용하여 Grain에 가입한 다른 사용자들을 검색하고, 해당 사용자들을 구독할 수 있습니다.

<div id="search">
 
 | 검색 기능 |
  |-------|
 | <img src="https://github.com/APPSCHOOL1-REPO/finalproject-grain/assets/73868968/4aba7664-12d5-4a0f-8822-b024c41ea4d7" alt="검색1" width="150" height="300">|

</div>

### 알림

- 다른 사용자가 내 피드를 좋아요를 누르면 알림을 받을 수 있습니다.
- 다른 사용자가 내 피드에 댓글을 달면 알림을 받을 수 있습니다.
- 다른 사용자가 내 댓글에 대댓글을 달면 알림을 받을 수 있습니다.
- 다른 사용자가 나를 구독하면 알림을 받을 수 있습니다.

### 설정

- 사용자 프로필을 편집할 수 있습니다.
- 보유한 장비 정보를 변경할 수 있습니다.
- 내가 작성한 커뮤니티 글을 확인할 수 있습니다.
- 저장된 피드 및 커뮤니티 글을 확인할 수 있습니다.
- 고객센터 또는 피드백 기능을 이용하여 문의사항을 제출할 수 있습니다.
- 로그아웃 기능이 제공됩니다.
- 계정 삭제 기능을 이용하여 사용자 계정을 삭제할 수 있습니다.


## 개발 환경
<img src="https://img.shields.io/badge/Xcode-147EFB?style=&logo=Xcode&logoColor=white"> <img src="https://img.shields.io/badge/v14.2-147EFB?"> 
<img src="https://img.shields.io/badge/Postman-FF6C37?style=&logo=Postman&logoColor=white">

## 사용 기술 
<img src="https://img.shields.io/badge/Swift-F05138?style=&logo=Swift&logoColor=white"> <img src="https://img.shields.io/badge/v5.7.2-F05138?"> <img src="https://img.shields.io/badge/SwiftUI-0d42a0?style=&logo=swift&logoColor=white">

## 라이브러리 및 프레임워크
<img src="https://img.shields.io/badge/AppleLogin-000000?style=&logo=Apple&logoColor=white"> <img src="https://img.shields.io/badge/GoogleLogin-4285F4?style=&logo=Google&logoColor=white"> 
<img src="https://img.shields.io/badge/KingFisher-f06d3b?style=&logo=fluentbit&logoColor=white">
<img src="https://img.shields.io/badge/NaverMap-03C75A?style=&logo=Naver&logoColor=white">
<img src="https://img.shields.io/badge/FirebaseAuth-FFCA28?style=&logo=Firebase&logoColor=white"> <img src="https://img.shields.io/badge/FirebaseStore-FFCA28?style=&logo=Firebase&logoColor=white"> <img src="https://img.shields.io/badge/FirebaseStorage-FFCA28?style=&logo=Firebase&logoColor=white"> <img src="https://img.shields.io/badge/FirebaseMessage-FFCA28?style=&logo=Firebase&logoColor=white">

## 도구
<img src="https://img.shields.io/badge/Figma-F24E1E?style=&logo=Figma&logoColor=white"> <img src="https://img.shields.io/badge/Discord-5865F2?style=&logo=Discord&logoColor=white"> <img src="https://img.shields.io/badge/Notion-000000?style=&logo=Notion&logoColor=white">

<br>

## 데이터 구조
<img width="1838" alt="dataStructure" src="https://user-images.githubusercontent.com/73868968/231422977-1dc57493-63f9-4440-b911-c8e272f2651f.png">

<br>

## 사용자 시나리오
<img width="1838" alt="UserScenarioImage" src="https://user-images.githubusercontent.com/73868968/230912884-0e56764e-0cf6-47a3-8eff-db4f3afa9d48.png">

## 참여자
<div align="center">
<table style="font-weight : bold">
<tr>
<td align="center">
<a href="https://github.com/kyungeee">                 
<img alt="박희경" src="https://avatars.githubusercontent.com/kyungeee" width="80" />            
</a>
</td>
<td align="center">
<a href="https://github.com/sohee120">                 
<img alt="윤소희" src="https://avatars.githubusercontent.com/sohee120" width="80" />            
</a>
</td>
<td align="center">
<a href="https://github.com/suman0204">                 
<img alt="홍수만" src="https://avatars.githubusercontent.com/u/18048754?v=4" width="80" />            
</a>
</td>
<td align="center">
<a href="https://github.com/xngsoo96">                 
<img alt="한승수" src="https://avatars.githubusercontent.com/u/113982605?v=4" width="80" />            
</a>
</td>
<td align="center">
<a href="https://github.com/cho407">                 
<img alt="조형구" src="https://avatars.githubusercontent.com/cho407" width="80" />            
</a>
</td>
<td align="center">
<a href="https://github.com/jeonghoonji">                 
<img alt="지정훈" src="https://avatars.githubusercontent.com/u/73868968?v=4" width="80" /
</tr>
<tr>
<td align="center">박희경</td>
<td align="center">윤소희</td>
<td align="center">홍수만</td>
<td align="center">한승수</td>
<td align="center">조형구</td>
<td align="center">지정훈</td>
</tr>
</table>
</div>

## 라이센스
GRAIN is released under the MIT license. See [LICENSE](https://github.com/APPSCHOOL1-REPO/finalproject-grain/tree/main/LICENSE) for details.
