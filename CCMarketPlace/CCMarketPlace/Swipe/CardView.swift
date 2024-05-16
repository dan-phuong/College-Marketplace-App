//
//  CardView.swift
//  ServerTester
//
//  Created by Dan Phuong on 4/1/24.
//

import Foundation
import SwiftUI

// Card view of product that allows for swiping
struct CardView: View {
    @EnvironmentObject var currentUser: CurrentUserManager
    @State private var translation: CGSize = .zero
    @State private var swipeStatus: LikeDislike = .none
    @State private var isModalPresented = false
    @State private var ownerName: String = ""
    
    //1
    private var product: Product
    private var onRemove: (_ Product: Product) -> Void
    
    //2
    // when the user has draged 50% the width of the screen in either direction
    private var thresholdPercentage: CGFloat = 0.5
    
    private enum LikeDislike: Int {
        case like, dislike, none
    }
    private var photoURL : String = "http://10.13.44.30:8080/api/image/downloadProduct/"
    
    // 3
    init(product: Product, onRemove: @escaping (_ product: Product) -> Void) {
        self.product = product
        self.onRemove = onRemove
    }
    
    
    func addToLiked(){
        let studentId = currentUser.id.uuidString
        let productId = product.id.uuidString
        print(studentId)
        print(productId)
        let endpoint = URL(string: "http://10.13.44.30:8080/api/product/addToLiked/"+studentId+"/product/"+productId)
        var request = URLRequest(url: endpoint!)
        request.httpMethod = "POST"
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            let statusCode = (response as! HTTPURLResponse).statusCode
            
            if statusCode == 200 {
                print("SUCCESS")
            } else {
                print("FAILURE")
            }
        }.resume()
    }
    
    // 4
    // What percentage of our own width have we swipped
    // - Parameters:
    //   - geometry: The geometry
    //   - gesture: The current gesture translation value
    private func getGesturePercentage(_ geometry: GeometryProxy, from gesture: DragGesture.Value) -> CGFloat {
        gesture.translation.width / geometry.size.width
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                ZStack(alignment: self.swipeStatus == .like ? .topLeading : .topTrailing) {
                    ForEach(product.imageIds, id: \.self) { imageId in
                        var AsyncPhotoURL = URL(string : photoURL + imageId)!
                        AsyncImage( url: AsyncPhotoURL){ image
                            in image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: geometry.size.height * 1.1)
                                .clipped()
                        } placeholder: { Text("Loading") }
                    }
                    
                    
                    if self.swipeStatus == .like {
                        Text("BUY")
                            .font(.headline)
                            .padding()
                            .cornerRadius(10)
                            .foregroundColor(Color.green)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.green, lineWidth: 3.0)
                            ).padding(24)
                            .rotationEffect(Angle.degrees(-45))
                    } else if self.swipeStatus == .dislike {
                        Text("NOPE")
                            .font(.headline)
                            .padding()
                            .cornerRadius(10)
                            .foregroundColor(Color.red)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.red, lineWidth: 3.0)
                            ).padding(.top, 45)
                            .rotationEffect(Angle.degrees(45))
                    }
                }
                
                HStack {
                    //5
                    VStack(alignment: .leading, spacing: 6) {
                        Text("\(self.product.title) \(String(format: "$%.2f", self.product.buyPrice))")
                            .font(.title)
                            .bold()
                            .foregroundColor(Color("kGreenVarD"))
                        Text("\(self.product.description)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(ownerName)
                            .font(.subheadline)
                            .foregroundColor(Color("kYellow"))
                        HStack{
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(product.tags, id: \.id) { tagged in
                                        NavigationLink(destination: SearchResultView(tagSearch: tagged.name)) {
                                            Text(tagged.name)
                                                .foregroundStyle(.white)
                                                .padding(3)
                                                .background(Color("kBlue")) // Greyish background
                                                .cornerRadius(10) // Optional: add corner radius for a rounded box
                                        }
                                        .padding(1)
                                        .buttonStyle(PlainButtonStyle()) // To remove the default button style
                                    }
                                }
                            }
                            
                            HStack(alignment: .bottom) {
                                //Spacer()
                                if(currentUser.alreadyLiked(product: product)){
                                    Button{
                                        currentUser.removeFromLikedSet(product: product)
                                    } label:{
                                        Image(systemName: "heart.fill")
                                            .resizable()
                                            .foregroundColor(Color("kPink"))
                                            .frame(width: 35, height:35)
                                            .padding(.trailing, 2)
                                    }}else{
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
                                Button(action: {
                                    self.isModalPresented = true
                                }) {
                                    Image(systemName: "exclamationmark.bubble")
                                        .foregroundColor(.gray)
                                }
                            }
                            .sheet(isPresented: $isModalPresented) {
                                ModalView()
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(5)
                }
            }
            // Add padding, corner radius and shadow with blur radius
            .padding(.bottom)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .animation(.interactiveSpring())
            .offset(x: self.translation.width, y: 0) // 2
            .rotationEffect(.degrees(Double(self.translation.width / geometry.size.width) * 25), anchor: .bottom)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        self.translation = value.translation
                        
                        if (self.getGesturePercentage(geometry, from: value)) >= self.thresholdPercentage {
                            self.swipeStatus = .like
                            addToLiked()
                            
                        } else if self.getGesturePercentage(geometry, from: value) <= -self.thresholdPercentage {
                            self.swipeStatus = .dislike
                        } else {
                            self.swipeStatus = .none
                        }
                        
                    }.onEnded { value in
                        // 6
                        // determine snap distance > 0.5 aka half the width of the screen
                        if abs(self.getGesturePercentage(geometry, from: value)) > self.thresholdPercentage {
                            self.onRemove(self.product)
                        } else {
                            self.translation = .zero
                        }
                    }
            ).onAppear {
                getOwner()
            }
        }
    }
    
    // Returns owner of product
    func getOwner(){
        let ownerId = product.ownerId?.uuidString
        let endpoint = URL(string: "http://10.13.44.30:8080/api/student/getStudentById/"+ownerId!)
        var request = URLRequest(url: endpoint!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                return
            }
            do {
                let posts = try JSONDecoder().decode(Student.self, from: data)
                DispatchQueue.main.async {
                    ownerName = posts.email
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}

// Moderation view
struct ModalView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Do you want to report this item?")
                .font(.title)
                .bold()
                .padding()
                .multilineTextAlignment(.center) // Center-align and allow wrapping
            
            HStack {
                Button(action: {
                    // Dismiss the modal
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("No")
                        .foregroundColor(.red)
                }
                .padding()
                
                Button(action: {
                    // Dismiss the modal
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Yes")
                        .foregroundColor(.blue)
                }
                .padding()
            }
        }
        .fixedSize(horizontal: false, vertical: true) // Adjust the size of the popup
        .padding() // Add padding to adjust the overall size
    }
}

// Bookmark button that appears on CardView
struct BookmarkButton: View {
    @State private var isBookmarked = false
    
    var body: some View {
        Button(action: {
            self.isBookmarked.toggle()
        }) {
            Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                .foregroundColor(isBookmarked ? .black : .gray)
        }
//        NavigationLink(destination: ProductOwnerView()) {
//            Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
//        }.foregroundColor(isBookmarked ? .black : .gray)
    }
}


