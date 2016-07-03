# QRCode Card Manager
QRCode를 이용한 간단한 연락처 관리 Application.

1. App의 구성
  
  1) MainView
    
    - 전반적인 목록관리 및 검색 가능
  
  2) QRCodeMakeView
  
    - QRCode 생성 및 저장 가능
  
  3) QRCodeScanView
  
    - QRCode Scan 및 목록에 저장
  
  4) DetailView
  
    - 해당 목록의 상세 정보 열람
    
2. 사용한 FrameWork
  
  1) QRCode
    - QRCode 생성하기 위한 것
  
  2) QRCodeReader
    - QRCode Scan
  
  3) SnapKit
    - 쉽게 Programmatically UI 배치 가능 (AutoLayout)
  
  4) Alamofire
   - HTTP Networking 관련 동작들을 위한 FrameWork
   - 주로 API 용도로 사용
   
3. 동작관련
  
  1) Launch Scree 종료 후 서버에서 정보목록을 받아 TableView로 보여줍니다. 만약 통신이 실패할 경우 알림 창으로 사실을 알리고, 프로그램은 종료됩니다.
  
  2) 성공적으로 정보들을 받았다면, Add, Edit 버튼을 이용해서 추가 정보를 추가하거나 기존 정보를 삭제할 수 있습니다. (추가/삭제 동작을 할때 마다 그에 상응하는 통신을 수행하게 됩니다.)
  
  3) Make버튼을 통해서 QRCode를 생성할 수 있고, 생성된 QRCode를 기기의 사진첩에 저장하여 다른 사람에게 공유할 수도 있습니다.
  
  4) 특정 Cell를 검색하거나, 특정 Cell를 터치하면 상세 정보를 보기가 가능합니다.
  
4. Build 방법

  1) terminal 실행-> sudo gem install cocoapods 입력 -> 해당 컴퓨터 계정의 비밀번호 입력 -> 설치 완료시 pod setup입력 후 setup completed가 나온다면 정상적으로 설치가 완료된 것입니다.
  
  2) terminal 실행-> cd 다운 받은 프로젝트 폴더 -> pod install 입력
  
  3) 빌드를 실행할 Device를 컴퓨터에 연결 합니다.
  
  4) X-code에서 빌드할 Device를 선택한 후 빌드를 시작하면 됩니다.
  
5. 서버관련 ()
  1) python-flask를 이용해서 간단한 서버관련 코드 작성하였습니다.
  2) postgres DB를 사용하였습니다.
  3) heroku를 사용해서 서버를 운영 중입니다.
