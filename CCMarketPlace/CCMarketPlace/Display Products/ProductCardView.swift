// Listing out Products For Search
//  ProductCardView.swift
//  CCMarketPlace
//
//  Created by Gwendolyn Hardwick on 3/29/24.
//

import SwiftUI

// Used for displaying results from search
struct ProductCardView: View {
    @EnvironmentObject var currentUser: CurrentUserManager
    var photoURL : String = "http://10.13.44.30:8080/api/image/downloadProduct/"
    var product: Product
    var body: some View {
        ZStack{
            Color("kBlueVar2")
            
            ZStack(alignment: .bottomTrailing){
                VStack(alignment: .leading){
                    ForEach(product.imageIds, id: \.self) { imageId in
                        var AsyncPhotoURL = URL(string : photoURL + imageId)!
                        AsyncImage( url: AsyncPhotoURL){ image
                            in image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 175, height: 160)
                                .cornerRadius(12)
                        } placeholder: { Text("Loading") }
                    }
                    
                    Text(product.title)
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.vertical, 1)
                    
                    Text(product.dateListed)
                        .foregroundColor(Color("kDGrey"))
                        .font(.caption)
                        .padding(.vertical, 0.5)
                    
                    Text(String(format: "$%.2f",product.buyPrice))
                        .bold()
                        .foregroundColor(.black)
                }
                Image(systemName: "circle.grid.2x2.fill")
                    .resizable()
                    .foregroundColor(Color("kDGrey"))
                    .frame(width: 20, height:20)
                    .padding(.trailing,3)
            }
        }
        .frame(width: 185, height:260)
        .cornerRadius(15)
    }
}

#Preview {
    ProductCardView(product: tempProductsList[1])
        .environmentObject(CurrentUserManager())
}
