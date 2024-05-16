//import SwiftUI
//
//struct GetProductsView: View {
//    @State private var data: [Product] = []
//
//    var body: some View {
////        List(data, id: \.id) { product in
////            VStack(alignment: .leading) {
////                Text(product.title)
////                    .font(.headline)
////                    .foregroundColor(.black)
////                Text(product.description)
////                    .font(.subheadline)
////                    .foregroundColor(.black)
////                var priceString = String(product.price)
////                Text(priceString)
////                    .font(.subheadline)
////                    .foregroundColor(.black)
////            }
////        }
//        VStack{
//            NavigationStack {
//                NavigationLink(destination: SwipeView()) {
//                    Text("Continue")
//                        .font(.headline)
//                        .foregroundColor(.black)
//                }
//            }
//        }
//        .onAppear {
//            getFirstProduct()
//            Text(firstProduct.firstTitle)
//                .font(.headline)
//                .foregroundColor(.black)
//            
//        }
//    }
//    
//    
//    func getFirstProduct(){
//        fetchProductData()
//
//        if let selectedProduct = data.first {
//            firstProduct.firstTitle = selectedProduct.title
//            print(firstProduct.firstTitle)
//            firstProduct.firstDescription = selectedProduct.description
//            firstProduct.firstPrice = String(format: "$%.2f", selectedProduct.price)
//        }
//    }
//
//    func fetchProductData() {
//        guard let url = URL(string: "http://10.13.44.30:8080/api/product/getAllProducts") else { return }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data else { return }
//            do {
//                let products = try JSONDecoder().decode([Product].self, from: data)
//                DispatchQueue.main.async {
//                    self.data = products
//                }
//            } catch {
//                //print(error.localizedDescription)
//                print(String(describing: error))
//            }
//        }.resume()
//    }
//}
//
//struct Product: Codable {
//    let id: Int64
//    let title: String
//    let description: String
//    let dateListed: String
//    let tags: [String]
//    let imageIds: [Int]
//    let price: Double
//    let biddable: Bool
//}
//
//struct firstProduct {
//    static var firstTitle = "1title"
//    static var firstDescription = "1description"
//    static var firstPrice = "1price"
//}
