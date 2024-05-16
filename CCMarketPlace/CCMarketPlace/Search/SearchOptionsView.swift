//
//  SearchOptionsView.swift
//  CCMarketPlace
//
//  Created by Gwendolyn Hardwick on 3/27/24.
//

import SwiftUI

// the main search page, with query and categorical search
struct SearchOptionsView: View {
    @EnvironmentObject var currentUser: CurrentUserManager
    @State private var search: String = "" //this is the keyword search term
    var body: some View {
        NavigationView{
            ScrollView(.vertical,showsIndicators: false){
                HStack{
                    HStack{
                        Image(systemName: "magnifyingglass")
                            .padding(.leading)
                        
                        TextField("Search for Tag", text: self.$search)
                            .padding()
                    }
                    .background(Color("kLGrey"))
                    .cornerRadius(12)
                    
                    NavigationLink(
                        destination: SearchResultView(tagSearch: search)
                            .environmentObject(currentUser)
                    ){
                        Image(systemName: "return")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color("kDGrey"))
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                //the hardcoded categories to search by
                
                VStack(spacing: 10){
                    HStack{
                        NavigationLink(
                            destination: SearchResultView(tagSearch: "Furniture")
                        ){
                            Text("Furniture")
                        }
                        .buttonStyle(TealButtonStyle())
                        
                        NavigationLink(
                            destination: SearchResultView(tagSearch: "Plants")
                        ) {
                            Text("Plants")
                        }
                        .buttonStyle(YellowButtonStyle())
                    }
                    HStack{
                        NavigationLink(
                            destination: SearchResultView(tagSearch: "Outdoor Gear")
                        ) {
                            Text("Outdoor Gear")
                        }
                        .buttonStyle(PurpleButtonStyle())
                        
                        NavigationLink(
                            destination: SearchResultView(tagSearch: "Crafts")
                        ) {
                            Text("Crafts")
                        }
                        .buttonStyle(BlueButtonStyle())
                    }
                    HStack{
                        NavigationLink(
                            destination: SearchResultView(tagSearch: "Jewelry")
                                .environmentObject(currentUser)
                        ) {
                            Text("Jewelry")
                        }
                        .buttonStyle(YellowButtonStyle())
                        
                        NavigationLink(
                            destination: SearchResultView(tagSearch: "Housing")
                        ) {
                            Text("Housing")
                        }
                        .buttonStyle(GreenButtonStyle())
                    }
                    HStack{
                        NavigationLink(
                            destination: SearchResultView(tagSearch: "Electronics")
                        ) {
                            Text("Electronics")
                        }
                        .buttonStyle(BlueButtonStyle())
                        
                        NavigationLink(
                            destination: SearchResultView(tagSearch: "Appliances")
                        ) {
                            Text("Appliances")
                        }
                        .buttonStyle(PurpleButtonStyle())
                    }
                    HStack{
                        NavigationLink(
                            destination: SearchResultView(tagSearch: "Storage")
                        ) {
                            Text("Storage")
                        }
                        .buttonStyle(YellowButtonStyle())
                        
                        NavigationLink(
                            destination: SearchResultView(tagSearch: "Tickets")
                        ) {
                            Text("Tickets")
                        }
                        .buttonStyle(TealButtonStyle())
                    }
                    HStack{
                        NavigationLink(
                            destination: SearchResultView(tagSearch: "Lighting")
                        ) {
                            Text("Lighting")
                        }
                        .buttonStyle(GreenButtonStyle())
                        
                        NavigationLink(
                            destination: SearchResultView(tagSearch: "Decor")
                        ) {
                            Text("Decor")
                        }
                        .buttonStyle(YellowButtonStyle())
                    }
                }
            }
        }
    }
    
     //the pretty button styles!
    struct BlueButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(5)
                .frame(width: 175, height: 100)
                .font(.title)
                .foregroundColor(.black)
                .background(configuration.isPressed ? Color("kBlueVarD") : Color("kBlueVarT"))
                .cornerRadius(5)
        }
    }
    
    struct GreenButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(5)
                .frame(width: 175, height: 100)
                .font(.title)
                .foregroundColor(.black)
                .background(configuration.isPressed ? Color("kGreenVarD") : Color("kGreenVarT"))
                .cornerRadius(5)
        }
    }
    
    struct PurpleButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(5)
                .frame(width: 175, height: 100)
                .font(.title)
                .foregroundColor(.black)
                .background(configuration.isPressed ? Color("kPurpleVarD") : Color("kPurpleVarT"))
                .cornerRadius(5)
        }
    }
    
    struct TealButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(5)
                .frame(width: 175, height: 100)
                .font(.title)
                .foregroundColor(.black)
                .background(configuration.isPressed ? Color("kTealVarD") : Color("kTealVarT"))
                .cornerRadius(5)
        }
    }
    
    struct YellowButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(5)
                .frame(width: 175, height: 100)
                .font(.title)
                .foregroundColor(.black)
                .background(configuration.isPressed ? Color("kYellowVarD") : Color("kYellowVarT"))
                .cornerRadius(5)
        }
    }
}

struct SearchOptionsView_Previews: PreviewProvider{
    static var previews: some View {
        SearchOptionsView()
            .environmentObject(CurrentUserManager())
    }
}
