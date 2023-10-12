//
//  TransactionDetailsView.swift
//  WorldOfPAYBACK
//

import SwiftUI

struct TransactionDetailsView: View {
    private let partnerDisplayName: String
    private let description: String?
    
    init(partnerDisplayName: String, description: String?) {
        self.partnerDisplayName = partnerDisplayName
        self.description = description
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(partnerDisplayName)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.bottom, 20)
                    .padding(.top, 40)
                
                Text(description ?? "")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
                
                Spacer()
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

struct TransactionDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionDetailsView(partnerDisplayName: "title", description: "desc")
    }
}
