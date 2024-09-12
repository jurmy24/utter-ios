//
//  RootView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-03.
//

import SwiftUI

struct RootView: View {
    
    @State private var showSignInView: Bool = false
    @State var selectedTab: Tabs = .home
    
    var body: some View {
        // Conditionally display the settings page if the user is logged in
        ZStack {
            if !showSignInView {
                NavigationStack {
                    HomeView()
                    CustomTabBar(selectedTab: $selectedTab)
                }
            }
        }
        .onAppear{
            // Check if user is logged in using the auth manager and update showSignInView
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil ? true : false
        }
        .fullScreenCover(isPresented: $showSignInView) {
            // Display a full screen cover of the sign in page if the user is not signed in
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
        .background(Color("AppBackgroundColor"))
        
    }
}

#Preview {
    RootView()
}
