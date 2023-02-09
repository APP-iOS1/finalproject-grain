//
//  TermsOfServiceView.swift
//  Grain
//
//  Created by 홍수만 on 2023/02/09.
//

import SwiftUI

struct TermsOfServiceView: View {
    var body: some View {
        ScrollView{
            VStack{
                Text("""
"**Grain에** **오신** **것을** **환영합니다!**
                 
본 이용 약관(또는 "약관")은 귀하의 Grain 사용에 적용됩니다. 단, 당사가 별도의 약관(본 약관이 아님)이 적용된다는 것을 명시하고 아래 설명된 Grain 서비스(이하 "서비스")에 대한 정보를 제공하는 경우는 예외로 합니다. 귀하가 Grain 계정을 만들거나 Grain을 이용하는 경우 본 약관에 동의하는 것으로 간주됩니다.

Grain 서비스는 Grain, Inc.에서 귀하에게 제공하는 Grain 제품 중 하나입니다. 따라서 본 이용 약관은 귀하와 Grain Inc. 사이의 계약에 해당됩니다.
""").padding()
            }
        }
    }
}

struct TermsOfServiceView_Previews: PreviewProvider {
    static var previews: some View {
        TermsOfServiceView()
    }
}
