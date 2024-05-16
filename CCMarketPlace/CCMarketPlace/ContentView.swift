//
//  ContentView.swift
//  CCMarketPlace
//
//  Created by JTT on 1/30/24.
//

import Foundation
import SwiftUI

class GlobalVariables : ObservableObject {
    //buggy behavoir when redirecting user back to sign about success making account
    //@Published var createAccount = false
    @Published var loggedIn = false
}

var globals : GlobalVariables = GlobalVariables()


struct ContentView: View {
    @StateObject var currentUser = CurrentUserManager()
    @State var currentTab: Tab = .Swipe
    @StateObject var contentGlobals = globals
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    @Namespace var animation
    
    var body: some View {
        Group {
            if contentGlobals.loggedIn {
                TabView(selection: $currentTab) {
                    
                    SearchOptionsView()
                        .environmentObject(currentUser)
                        .tag(Tab.Search)
                    
                    Text("Notifications View")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background()
                        .tag(Tab.Notifications)
                    
                    SwipeView()
                        .environmentObject(currentUser)
                        .tag(Tab.Swipe)
                    
                    AddNewListingView()
                        .environmentObject(currentUser)
                        .tag(Tab.newListing)
                    
                    ProfileFullView()
                        .environmentObject(currentUser)
                        .tag(Tab.Profile)
                }
                .overlay(
                    HStack(spacing: 0){
                        ForEach(Tab.allCases, id: \.rawValue){tab in
                            TabButton(tab: tab)
                        }
                        .padding(.vertical)
                        .padding(.bottom, getSafeArea().bottom == 0 ? 5 : (getSafeArea().bottom - 15))
                        .background(Color("kBlueVarL"))
                    }
                    ,
                    alignment: .bottom
                ).ignoresSafeArea(.all, edges: .bottom)
            }else {
                LogInView()
                    .environmentObject(currentUser)
            }
        }
        
    }
    func TabButton(tab: Tab) -> some View{
        GeometryReader{proxy in
            Button(action: {
                withAnimation(.spring()){
                    currentTab = tab
                }
            },label: {
                VStack(spacing: 0){
                    Image(systemName: currentTab == tab ? tab.rawValue + ".fill": tab.rawValue)
                        .resizable()
                        .foregroundColor(Color("kGreenVarD"))
                        .aspectRatio( contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .frame(maxWidth: .infinity)
                        .background(
                            ZStack{
                                if currentTab == tab {
                                    MaterialEffect(style: .light)
                                        .clipShape(Circle())
                                        .matchedGeometryEffect(id: "Tab", in: animation)
                                    
                                    Text(tab.Tabname)
                                        .foregroundColor(.primary)
                                        .font(.footnote)
                                        .padding(.top, 50)
                                }
                            }
                        ).contentShape(Rectangle())
                        .offset(y: currentTab == tab ? -15: 0)
                }
            })
        }
        .frame(height: 25)
    }
}

enum Tab: String, CaseIterable{
    case Search = "magnifyingglass.circle"
    case Notifications = "bell"
    case Swipe = "house"
    case newListing = "plus.circle"
    case Profile = "person"
    
    var Tabname: String{
        switch self{
        case .Search:
            return "Search"
        case .Notifications:
            return "Notifications"
        case .Swipe:
            return "Swipe"
        case .newListing:
            return "New Listing"
        case .Profile:
            return "Profile"
        }
        
    }
}

extension View{
    func getSafeArea() -> UIEdgeInsets{
        
        guard let screen = UIApplication.shared.connectedScenes.first as?
                UIWindowScene else{
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return safeArea
    }
}

struct MaterialEffect: UIViewRepresentable{
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) ->  UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style:style ))
        
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    }
    
}

