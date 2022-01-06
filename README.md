# Splash

## 스토리보드 by [Figma](https://www.figma.com/file/LFHpvCuXqlfKr5hrJSTUwB/Splash?node-id=61%3A340)
| Home |  Discover |
|---|---|
| <img src="https://user-images.githubusercontent.com/38883364/148422628-52cc9dbb-e7ce-4c56-82b7-3ebe54b8abc3.png">  | <img src="https://user-images.githubusercontent.com/38883364/148422620-c9bc3096-5463-4f3a-aeea-3285629603cc.png">  |


## 기능
| 사진 목록 | 사진 상세보기 |  사진 검색  |
|---|---|---|
| <img src="https://user-images.githubusercontent.com/38883364/148421281-99eb1cb0-8de3-4d5a-a92d-56e596abb0f6.gif">  | <img src="https://user-images.githubusercontent.com/38883364/148421565-82422200-40e1-4b36-951d-201eee61acf2.gif"> |  <img src="https://user-images.githubusercontent.com/38883364/148421849-401c5c76-8374-400d-b59d-9f5a5cdcdff7.gif"> |

## 구성 및 역할
<img src="https://user-images.githubusercontent.com/38883364/148432942-f7556124-356f-48a0-a35d-3231d72c0814.png">

* [MainTabbarController](./Splash/Splash/Presentation/MainTabBarController.swift) 
    * HomeViewController, DiscoverViewController 의존성 주입
    * Tab 변경시 다운로드 취소

* [HomeViewController](./Splash/Splash/Presentation/HomeViewController.swift)
    * Topic 별 사진 리스트

* [DiscoverViewController](./Splash/Splash/Presentation/DiscoverViewController.swift)
    * 검색 결과 사진 리스트

* [PhotoLoader](./Splash/Splash/Infrastructure/PhotoLoader.swift)
    * 이미지 캐싱, 다운로드 및 취소


## 문제해결

### 사진을 빠르게 스크롤 할 때 다운로드 취소가 바로 안 되는 문제     
기존에 Cell이 reuse될때 URLSessionDataTask를 취소하는 방식으로 구현
Cell이 화면에서 사라질 때 바로 reuse가 되지 않아 사용자는 해당 사진을 이미 넘겼음에도 다운로드를 진행할 가능성이 존재함   

해결: collectionview의 didEndDisplaying 메소드를 사용해 이미 지나간 항목들에 대해서 다운로드를 취소

### 사진 -> 사진 상세보기로 넘어갈 때 다른 사진이 나오는 문제
처음 사진들은 같은 사진을 넘어가다가 하단부로 지나갈수록 더 뒤의 사진이 나옴   
예시) 1번 사진 클릭 -> 1번사진, 5번 사진 클릭 -> 5번사진, 8번사진 클릭 -> 9번사진, 20번사진 클릭 -> 22번사진   
scrollToItem 메소드를 viewdidload에서 호출했는데 이 시점에서 이동하고자 하는 셀이 생성되지 않아서 문제가 발생

해결: viewDidLayoutSubviews에서 scrollToItem을 호출하는 것으로 문제 해결
