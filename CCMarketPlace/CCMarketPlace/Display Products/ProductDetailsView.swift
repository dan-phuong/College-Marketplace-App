//
//  ProfileDetailsView.swift
//  CCMarketPlace
//
//  Created by Gwendolyn Hardwick on 4/2/24.
//

import SwiftUI

//Once a product has been looked at, if they want to see more information they can 
//click on it and see this details page for the product
struct ProductDetailsView: View {
    @EnvironmentObject var currentUser: CurrentUserManager
    var photoURL : String = "http://10.13.44.30:8080/api/image/downloadProduct/"
    var product: Product
    var body: some View {
        ScrollView{
            ZStack{
                Color.white
                
                VStack(alignment: .leading){
                    ZStack(alignment: .topTrailing){
                        ForEach(product.imageIds, id: \.self) { imageId in
                            var AsyncPhotoURL = URL(string : photoURL + imageId)!
                            AsyncImage( url: AsyncPhotoURL){ image
                                in image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipped()
                            } placeholder: { Text("Loading") }
                        }
                    }
                    VStack(alignment: .leading){
                        HStack{
                            Text(product.title)
                                .font(.title2 .bold())
                            
                            Spacer()
                            
                            Text(String(format: "$%.2f",product.buyPrice))
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.horizontal)
                                .background(Color("kBlueVar2"))
                                .cornerRadius(12)
                            
                        }
                        .padding(.vertical)
                        
                        HStack{
                            /*
                             Image(seller.imageId ?? "BlankPFP")
                             .resizable()
                             .aspectRatio(contentMode: .fill)
                             .frame(width: 60, height: 60)
                             .clipShape(Circle())
                             .clipped()
                             .padding(.trailing, 1)
                             VStack(alignment: .leading){
                             
                             Text(seller.name)
                             .font(.title2)
                             .fontWeight(.medium)
                             .padding(.horizontal)
                             
                             DisplayStar(userRating: seller.userRating)
                             }
                             .padding(.vertical)
                             */
                            Text("")
                            
                            Spacer()
                            
                            if currentUser.alreadyLiked(product: product){
                                Button{
                                    currentUser.removeFromLikedSet(product: product)
                                } label:{
                                    Image(systemName: "heart.fill")
                                        .resizable()
                                        .foregroundColor(Color("kPink"))
                                        .frame(width: 35, height:35)
                                        .padding(.trailing, 2)
                                }
                            } else if currentUser.isOwner(product: product){
                                Button{
                                    EditListingView(product: product)
                                } label:{
                                    Image(systemName: "square.and.pencil.circle.fill")
                                        .resizable()
                                        .foregroundColor(Color("kYellowVarD"))
                                        .frame(width: 35, height:35)
                                        .padding(.trailing, 2)
                                }
                            } else{
                                Button{
                                    currentUser.addToLikedSet(product: product)
                                } label:{
                                    Image(systemName: "heart")
                                        .resizable()
                                        .foregroundColor(Color("kPink"))
                                        .frame(width: 35, height:35)
                                        .padding(.trailing, 2)
                                }
                            }
                        }
                        Text("Description")
                            .font(.title3)
                            .fontWeight(.medium)
                        
                        Text(product.description)
                    }
                    .padding()
                    .background(.white)
                    .cornerRadius(20)
                    .offset(y: -30)
                    
                }
                
            }
        }
        .ignoresSafeArea(edges:.top)
    }
}



struct ImageSliderView: View {
    @State private var currentIndex = 0
    var slides: [String]
    var body: some View {
        ZStack(alignment: .bottomLeading){
            ZStack(alignment: .trailing){
                Image(slides[currentIndex])
                    .resizable()
                    .ignoresSafeArea(edges: .top)
                    .frame(height: 350)
                    .scaledToFill()
            }
            HStack{
                ForEach(0..<slides.count){index in
                    Circle()
                        .fill(self.currentIndex == index ? Color("kBlueVarD") : Color("kBlueVarT"))
                        .frame(width: 10, height: 10)
                        .offset(y: -15)
                }
            }
            .padding()
        }
        //.ignoresSafeArea(edges:.top)
        .onAppear{
            Timer.scheduledTimer(withTimeInterval: 10, repeats: true){timer in
                if self.currentIndex + 1 == self.slides.count{
                    self.currentIndex = 0
                }else{
                    self.currentIndex+=1
                }
            }
        }
        
    }
}

#Preview {
    ProductDetailsView(product: tempProductsList[0])
        .environmentObject(CurrentUserManager())
}
