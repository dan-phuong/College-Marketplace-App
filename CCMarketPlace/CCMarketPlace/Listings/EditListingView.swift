//
//  EditListingView.swift
//  CCMarketPlace
//
//  Created by Gwendolyn Hardwick on 3/30/24.
//

import SwiftUI

struct EditListingView: View {
    @EnvironmentObject var currentUser: CurrentUserManager
    var product: Product
    
    var body: some View {
        VStack(spacing: 20){
            Text("This is where a user will be able to edit a product they have have listed, ie changing price, name, or deleting it.")
            Text("This is editing \(product.title) which was listed by user \(currentUser.name)")
        }
        .padding(.horizontal)
    }
}

#Preview {
    EditListingView(product: tempProductsList[2])
        .environmentObject(CurrentUserManager())
}
