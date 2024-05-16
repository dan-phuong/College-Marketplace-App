//
//  Swipe.swift
//  ServerTester
//
//  Created by Dan Phuong on 4/1/24.
//

import SwiftUI

struct SwipeView: View {
    @EnvironmentObject var currentUser: CurrentUserManager
    // 1
    // List of items
    @State private var products: [Product] = []
    
    // 2
    //Return the CardViews width for the given offset in the array
    //- Parameters:
    // - geometry: The geometry proxy of the parent
    //- id: The ID of the current student
    private func getCardWidth(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        let offset: CGFloat = CGFloat(products.count - 1 - id) * 10
        return geometry.size.width - offset
    }
    
    // 3
    // Return the CardViews frame offset for the given offset in the array
    // - Parameters:
    // - geometry: The geometry proxy of the parent
    // - id: The ID of the current student
    private func getCardOffset(_ geometry: GeometryProxy, id: Int) -> CGFloat {
        return  CGFloat(products.count - 1 - id) * 10
    }
    //    // Compute what the max ID in the given student array is.
    //    private var maxID: Int {
    //        return self.products.map { $0.id }.max() ?? 0
    //    }
    
    var body: some View {
        NavigationStack {
            VStack {
                GeometryReader { geometry in
                    VStack {
                        //DateView()
                        ZStack {
                            ForEach(Array(self.products.enumerated()), id: \.offset) { index, product in
                                Group {
                                    // Checks last 3
                                    if (products.count - 2)...products.count ~= index {
                                        CardView(product: product, onRemove: { removedProduct in
                                            // Remove that user from our array
                                            self.products.removeAll { $0.id == removedProduct.id }
                                        })
                                        .animation(.spring())
                                        .frame(width: self.getCardWidth(geometry, id: index), height: 450)
                                        .offset(x: 0, y: self.getCardOffset(geometry, id: index))
                                    }
                                }
                            }
                        }
                        Spacer()
                        //BottomBarView()
                    }
                }
            }.padding()
        }.onAppear {
            fetchData() }
    }
    
    func fetchData() {
        guard let url = URL(string: "http://10.13.44.30:8080/api/product/getAllProducts") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let posts = try JSONDecoder().decode([Product].self, from: data)
                DispatchQueue.main.async {
                    self.products = posts
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}

struct DateView: View {
    var body: some View {
        // Container to add background and corner radius to
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("CC MarketPlace")
                        .font(.title)
                        .bold()
                    Text("Swipe!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                
                NavigationLink(destination: SearchOptionsView()) {
                    Image(systemName: "magnifyingglass").imageScale(.large)
                }
                NavigationLink(destination: ProfileFullView()) {
                    Image(systemName: "person.crop.circle").imageScale(.large)
                }
                
            }.padding()
            
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct BottomBarView: View{
    var body: some View {
        HStack {
            NavigationLink(destination: SearchOptionsView()) {
                Image("Wishlist_Icon")
                    .resizable()
                    .frame(width: 50, height: 50)
                
            }
            Spacer()
            NavigationLink(destination: AddNewListingView()) {
                Image("Buy_Icon")
                    .resizable()
                    .frame(width: 130, height: 100)
                
            }
            Spacer()
            NavigationLink(destination: SearchOptionsView()) {
                Image("Bid_Icon")
                    .resizable()
                    .frame(width: 60, height: 60)
            }
        }.padding(.top, 150)
    }
}
