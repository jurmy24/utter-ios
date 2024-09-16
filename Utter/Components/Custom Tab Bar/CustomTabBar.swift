//
//  CustomTabBar.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-12.
//

import SwiftUI

enum Tabs: Int {
    case language = 0
    case home = 1
    case profile = 2
}

struct CustomTabBar: View {
    
    @Binding var selectedTab: Tabs
    
    var body: some View {
        // Background of the Tab Bar
        HStack (alignment: .center) {
            // Language Button
            Button {
                selectedTab = .language
            } label: {
                TabBarButton(buttonText: "Language",
                             imageName: "flag.fill",
                             isActive: selectedTab == .language)
            }
            
            // Home Button
            Button {
                selectedTab = .home
            } label: {
                TabBarButton(buttonText: "Storybooks",
                             imageName: "books.vertical.fill",
                             isActive: selectedTab == .home)
            }
            
            // Profile Button
            Button {
                selectedTab = .profile
            } label: {
                TabBarButton(buttonText: "Profile",
                             imageName: "brain.head.profile.fill",
                             isActive: selectedTab == .profile)
            }
        }
        .frame(height: 82)
        .background(Color("AppBackgroundColor"))
        .shadow(color: .gray.opacity(0.3), radius: 5)
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(.home))
}
