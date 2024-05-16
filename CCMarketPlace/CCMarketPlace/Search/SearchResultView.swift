import SwiftUI

// this show the results from search
struct SearchResultView: View {
    @EnvironmentObject var currentUser: CurrentUserManager
    @State private var data: [Product] = []
    
    var photoURL : String = "http://10.13.44.30:8080/api/image/downloadProduct/"
    var tagSearch: String
    var column = [GridItem(.adaptive(minimum: 160), spacing: 20)]
    var body: some View {
        //the search box remains
        HStack{
            HStack{
                Image(systemName: "magnifyingglass")
                    .padding(.leading)
                
                Text("Showing results for "+tagSearch)
                    .padding()
                    .font(.headline)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color("kLGrey"))
            .cornerRadius(12)
            
        }
        .padding(.horizontal)
        //the actual results, as little cards as given in Display Products/Product Card View
            ScrollView{
                LazyVGrid(columns: column, spacing: 8){
                    ForEach(data, id: \.id){ product in
                        NavigationLink(destination: {
                            ProductDetailsView(product: product)
                        }, label: {
                            ProductCardView(product: product)
                        })
                    }
                }
                .padding()
            
        }
        .onAppear {
            fetchSearch(tagSearch: tagSearch)
        }
    }
    // this is the call to send a get requrest for the products from the backend
    func fetchSearch(tagSearch: String) {
        guard let url = URL(string: "http://10.13.44.30:8080/api/product/findProductsByTags/"+tagSearch) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let posts = try JSONDecoder().decode([Product].self, from: data)
                DispatchQueue.main.async {
                    self.data = posts
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}
