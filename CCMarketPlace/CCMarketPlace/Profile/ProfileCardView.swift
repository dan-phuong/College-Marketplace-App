//
//  ProductCardView.swift
//  CCMarketPlace
//
//  Created by Gwendolyn Hardwick on 3/29/24.
//

import SwiftUI

//For on the user profile, card view for products that the current user has listed
struct ListingFromCurrentUserCardView: View {
    @EnvironmentObject var currentUser: CurrentUserManager
    var product: Product
    var body: some View {
        ZStack{
            Color("kYellowVarL")
            
            ZStack(alignment: .bottomTrailing){
                VStack(alignment: .leading){
                    Image(product.imageIds[0])
                        .resizable()
                        .frame(width: 175, height: 160)
                        .cornerRadius(12)
                    
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
                }
                
                Button{
                    EditListingView(product: product)
                        .environmentObject(currentUser)
                } label:{
                    Image(systemName: "square.and.pencil.circle.fill")
                        .resizable()
                        .foregroundColor(Color("kYellowVarD"))
                        .frame(width: 35, height:35)
                        .padding(.trailing, 2)
                }
            }
        }
        .frame(width: 185, height:260)
        .cornerRadius(15)
    }
}

//For on the user profile, card view for products that the current user has purchased before
struct PurchasedByCurrentUserCardView: View {
    @EnvironmentObject var currentUser: CurrentUserManager
    var product: Product
    var body: some View {
        ZStack{
            Color("kBlueVarL")
            
            ZStack(alignment: .bottomTrailing){
                VStack(alignment: .leading){
                    Image(product.imageIds[0])
                        .resizable()
                        .frame(width: 175, height: 160)
                        .cornerRadius(12)
                    
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
                }
                
                
            }
        }
        .frame(width: 185, height:260)
        .cornerRadius(15)
    }
}

//For on the user profile, card view for products that the current user has liked
struct LikedByCurrentUserCardView: View {
    @EnvironmentObject var currentUser: CurrentUserManager
    var photoURL : String = "http://10.13.44.30:8080/api/image/downloadProduct/"
    var product: Product
    var body: some View {
        ZStack{
            Color("kPurpleVarL")
            
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
                }
                
                Button{
                    currentUser.removeFromLikedSet(product: product)
                } label:{
                    Image(systemName: "heart.circle.fill")
                        .resizable()
                        .foregroundColor(Color("kPink"))
                        .frame(width: 35, height:35)
                        .padding(.trailing, 2)
                }
            }
        }
        .frame(width: 185, height:260)
        .cornerRadius(15)
    }
}


#Preview {
    PurchasedByCurrentUserCardView(product: tempProductsList[2])
        .environmentObject(CurrentUserManager())
}
