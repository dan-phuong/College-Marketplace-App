//
//  ProfileFullView.swift
//  CCMarketPlace
//
//  Created by Gwendolyn Hardwick on 3/28/24.
//

import SwiftUI


// the main user profile view
struct ProfileFullView: View {
    @EnvironmentObject var currentUser: CurrentUserManager
    @State var currentPTab: ProfileTab = .Liked
    
    var body: some View {
        NavigationStack {
        ZStack(alignment: .topLeading) {
            Color.white
                .edgesIgnoringSafeArea(.all)
            VStack{
                ProfileHeader()
                
                
                    
                    // tab view for changing between liked items, listings, and past purchases
                    TabView(selection: $currentPTab) {
                        DisplayLiked()
                            .tag(ProfileTab.Liked)
                        
                        DisplayListings()
                            .tag(ProfileTab.Listings)
                        
                        DisplayPurchases()
                            .tag(ProfileTab.Purchases)
                    }
                    .overlay(
                        HStack(spacing: 0){
                            ForEach(ProfileTab.allCases, id: \.rawValue){tab in
                                ProfileTabButton(tab: tab)
                            }
                            .padding(.vertical)
                            .background(Color(.white))
                            
                        }
                        ,
                        alignment: .top
                    )
                }
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
    
    // for the different options of the grid below the header
    enum ProfileTab: String, CaseIterable{
        case Liked = "heart"
        case Listings = "list.bullet"
        case Purchases = "bag"
        
        var Tabname: String{
            switch self{
            case .Liked:
                return "Liked Items"
            case .Listings:
                return "Your Listings"
            case .Purchases:
                return "Past Purchases"
            }
            
        }
    }
    
    func ProfileTabButton(tab: ProfileTab) -> some View{
        GeometryReader{proxy in
            Button(action: {
                withAnimation(.spring()){
                    currentPTab = tab
                }
            },label: {
                VStack(spacing: 0){
                    Image(systemName: tab.rawValue)
                        .resizable()
                        .foregroundColor(.black)
                        .aspectRatio( contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .frame(maxWidth: .infinity)
                        .background(
                            ZStack{
                                if currentPTab == tab {
                                    Text(tab.Tabname)
                                        .foregroundColor(.black)
                                        .font(.footnote)
                                        .padding(.top, 50)
                                    
                                    Rectangle()
                                        .clipShape(.rect(
                                            topLeadingRadius: 20,
                                            topTrailingRadius: 20)
                                        )
                                        .foregroundColor(.black)
                                        .frame(height: 3)
                                        .padding(.top, 78)
                                }
                                Rectangle()
                                    .foregroundColor(.black)
                                    .frame(height: 1)
                                    .padding(.top, 80)
                            }
                        ).contentShape(Rectangle())
                }
            }
            ).contentShape(Rectangle())
            //.offset(y: currentPTab == tab ? -30: 0)
        }
        .frame(height: 45)
    }
}
struct DisplayLiked: View {
    @EnvironmentObject var currentUser: CurrentUserManager
    var column = [GridItem(.adaptive(minimum: 160), spacing: 20)]
    var body: some View {
        NavigationView{
            ScrollView{
                Rectangle()
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                LazyVGrid(columns: column, spacing: 20){
                    ForEach(currentUser.likedSet, id: \.id){ product in
                        NavigationLink(destination: {
                            ProductDetailsView(product: product)
                        }, label: {
                            LikedByCurrentUserCardView(product: product)
                        })
                    }
                }
                .padding()
            }
            
        }
        .background(Color("kGreen"))
        
    }
}

struct DisplayListings: View {
    @EnvironmentObject var currentUser: CurrentUserManager
    var column = [GridItem(.adaptive(minimum: 160), spacing: 20)]
    var body: some View {
        NavigationView{
            ScrollView{
                Rectangle()
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                if currentUser.productSet.isEmpty{
                    NavigationLink(destination: {
                        AddNewListingView()
                    }, label: {
                        HStack{
                            Rectangle()
                                .frame(width:10)
                                .foregroundColor(Color("kYellow"))
                            
                            Spacer()
                            
                            Text("No Active Listings! Add One?")
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                            
                            Spacer()
                            
                            Rectangle()
                                .frame(width:10)
                                .foregroundColor(Color("kYellow"))
                            
                        }
                        .background(Color("kYellow"))
                        .frame(maxWidth: .infinity)
                        .cornerRadius(12)
                        .padding()
                    })
                } else{
                    LazyVGrid(columns: column, spacing: 20){
                        ForEach(currentUser.productSet, id: \.id){ product in
                            NavigationLink(destination: {
                                ProductDetailsView(product: product)
                            }, label: {
                                ListingFromCurrentUserCardView(product: product)
                            })
                        }
                    }
                    .padding()
                }
            }
            
        }
        
    }
}

struct DisplayPurchases: View {
    @EnvironmentObject var currentUser: CurrentUserManager
    var column = [GridItem(.adaptive(minimum: 160), spacing: 20)]
    var body: some View {
        NavigationView{
            ScrollView{
                Rectangle()
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                LazyVGrid(columns: column, spacing: 20){
                    ForEach(currentUser.purchases, id: \.id){ product in
                        NavigationLink(destination: {
                            ProductDetailsView(product: product)
                        }, label: {
                            PurchasedByCurrentUserCardView(product: product)
                        })
                    }
                }
                .padding()
            }
            
        }
        
    }
}

struct ProfileHeader: View{
    @EnvironmentObject var currentUser: CurrentUserManager
    var photoURL : String = "http://10.13.44.30:8080/api/image/downloadProduct/"
    var body: some View{
        HStack{
            var AsyncPhotoURL = URL(string : photoURL + currentUser.imageId)!
            AsyncImage( url: AsyncPhotoURL){ image
                in image.resizable()
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .clipped()
                    .padding(.trailing, 3)
            } placeholder: { 
                Image("BlankPFP")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .clipped()
                    .padding(.trailing, 3)
            }
            
            VStack{
                
                Text(currentUser.name)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                Spacer()
                
                Text(currentUser.email)
                    .font(.caption)
                Spacer()
                
                if (currentUser.phone != ""){
                    Text(currentUser.phone!)
                        .font(.caption)
                    Spacer()
                }
                
                if currentUser.userHasRating{
                    DisplayStar(userRating: currentUser.userRating)
                } else {
                    DisplayStar(userRating: nil)
                }
                
            }
            .frame(height: 125)
            
        }
        .padding()
    }
}


struct DisplayStar: View {
    var userRating: Double?
    
    var body: some View {
        if userRating != nil{
            let starArr = getNumStars(userRating: userRating)
            HStack(spacing: 5){
                ForEach(0..<starArr[0], id: \.self){index in
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.yellow)
                }
                ForEach(0..<starArr[1], id: \.self){index in
                    Image(systemName: "star.leadinghalf.filled")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.yellow)
                }
                ForEach(0..<starArr[2], id: \.self){index in
                    Image(systemName: "star")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.yellow)
                }
                Text(String(format: "(%.2f)", userRating!))
                    .foregroundColor(.gray)
            }
        }else{
            HStack(spacing: 5){
                ForEach(0..<5, id: \.self){index in
                    Image(systemName: "star.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color("kLGrey"))
                }
                Text("(New)")
                    .foregroundColor(.gray)
            }
        }
    }
    
    func getNumStars(userRating: Double?)-> [Int]{
        if (userRating != nil){
            var starArr = [0,0,0]
            starArr[0] = Int(self.userRating!.rounded(.down))
            starArr[1] = Int(self.userRating!.rounded(.toNearestOrAwayFromZero)) - starArr[0]
            starArr[2] = 5 - starArr[0] - starArr[1]
            return starArr
        }
        else{
            return [5]
        }
    }
}


#Preview {
    DisplayListings()
        .environmentObject(CurrentUserManager())
}
