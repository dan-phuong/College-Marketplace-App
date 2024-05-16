//
//  Product.swift
//  localmarketplace
//
//  Created by Gwendolyn Hardwick on 3/26/24.
//

import Foundation

struct Student: Identifiable, Codable {
    var id: UUID
    var name: String?
    var email: String
    var phone: String?
    var classYear: String
    var imageId: String?
    var userRating: Double?
    var status: String?
    var reviews: [UserReview]
    var productSet: [Product]
    var purchases: [Product]
    var likedSet: [Product]
    
    static func ==(lhs: Student, rhs: Student) -> Bool {
        return lhs.id == rhs.id
    }
    
    
}

struct Product: Identifiable, Codable {
    var id: UUID
    var title: String
    var description: String
    var dateListed: String
    var tags: [Tag]
    var imageIds: [String]
    var buyPrice: Double
    var status: String?
    var ownerId: UUID?
    
    static func ==(lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
}


struct Tag: Identifiable, Codable {
    var id: UUID
    var name: String
    var value: Int64
    
    static func ==(lhs: Tag, rhs: Tag) -> Bool {
        return lhs.id == rhs.id
    }
}

struct UserReview: Identifiable, Codable {
    var id: UUID
    var value: Int64
    var description: String
    var status: String
}


class CurrentUserManager: ObservableObject{
    @Published private(set) var id: UUID = UUID()
    @Published private(set) var name: String = ""
    @Published private(set) var email: String = ""
    @Published private(set) var phone: String?
    @Published private(set) var classYear: String = ""
    @Published private(set) var imageId: String = "BlankPFP"
    @Published private(set) var userRating: Double = 0.0
    @Published private(set) var userHasRating: Bool = false
    @Published private(set) var status: String?
    @Published private(set) var reviews: [UserReview] = []
    @Published private(set) var productSet: [Product] = []
    @Published private(set) var purchases: [Product] = []
    @Published private(set) var likedSet: [Product] = []
    
    func setUserFromStudent(user: Student){
        self.id = user.id
        self.name = user.name ?? ""
        self.email = user.email
        self.phone = user.phone ?? ""
        self.classYear = user.classYear
        self.imageId = user.imageId ?? "BlankPFP"
        if (user.userRating != nil){
            self.userRating = user.userRating!
            self.userHasRating = true
        }
        self.userRating = user.userRating ?? 0.0
        
        self.reviews = reviews
        self.productSet=productSet
        self.purchases=purchases
        self.likedSet=likedSet
    }
    
    func setName(name: String){
        self.name = name
    }
    
    func setPhone(phone: String){
        self.phone = phone
        self.userHasRating = false
    }
    func getNumStars()-> [Int]{
        var starArr = [0,0,0]
        starArr[0] = Int(self.userRating.rounded(.down))
        starArr[1] = Int(self.userRating.rounded(.toNearestOrAwayFromZero)) - starArr[0]
        starArr[2] = 5 - starArr[0] - starArr[1]
        return starArr
    }
    
    func alreadyLiked(product: Product) -> Bool{
        for liked in self.likedSet{
            if product==liked{
                return true
            }
        }
        return false
    }
    
    func isOwner(product: Product) -> Bool{
        if product.ownerId != nil{
            return product.ownerId==self.id
        } else{
            for owned in self.productSet{
                if product==owned{
                    return true
                }
            }
        }
        return false
    }
    //CONNECT THIS TO THE BACKEND
    func addToProductSet(product: Product){
        productSet.append(product)
    }
    func removeFromProductSet(product: Product){
        productSet = productSet.filter{ $0.id != product.id}
    }
    
    func addToPurchases(product: Product){
        purchases.append(product)
    }
    
    func addToLikedSet(product: Product){
        likedSet.append(product)
    }
    func removeFromLikedSet(product: Product){
        likedSet = likedSet.filter{ $0.id != product.id}
    }
}
