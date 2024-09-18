//
//  CustomTabBar.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-12.
//

import SwiftUI
import UIKit

enum Tabs: Int {
    case language = 0
    case home = 1
    case profile = 2
}

struct CustomTabBar: View {
    
    @Binding var showSignInView: Bool
    @State private var selectedTab: Tabs = .home
    
    var body: some View {
        ZStack {
            // Main content area
            Group {
                switch selectedTab {
                case .language:
                    NavigationView {
                        LanguageView()
                    }
                case .home:
                    NavigationView {
                        HomeView()
                    }
                case .profile:
                    NavigationView {
                        ProfileView(showSignInView: $showSignInView)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            // Custom tab bar
            VStack {
                Spacer()
                HStack {
                    // Language Tab
                    Button(action: {
                        selectedTab = .language
                    }) {
                        TabBarButton(
                            buttonText: "Language",
                            imageName: "flag.fill",
                            isActive: selectedTab == .language
                        )
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Home Tab
                    Button(action: {
                        selectedTab = .home
                    }) {
                        TabBarButton(
                            buttonText: "Storybooks",
                            imageName: "books.vertical.fill",
                            isActive: selectedTab == .home
                        )
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Profile Tab
                    Button(action: {
                        selectedTab = .profile
                    }) {
                        TabBarButton(
                            buttonText: "Profile",
                            imageName: "brain.head.profile.fill",
                            isActive: selectedTab == .profile
                        )
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(height: 82)
                .padding(.horizontal)
                .background(Color("AppBackgroundColor"))
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}

#Preview {
    CustomTabBar(showSignInView: .constant(false))
}
