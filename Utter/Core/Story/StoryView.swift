//
//  StoryView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-16.
//

import SwiftUI

struct StoryView: View {
    let storyMetadata: Story
    @Binding var showStoryView: Bool
    @StateObject private var viewModel: StoryViewModel
    @State private var displayContinueButton: Bool = true
    
    init(storyMetadata: Story, showStoryView: Binding<Bool>) {
        self.storyMetadata = storyMetadata
        self._showStoryView = showStoryView
        let chapter = storyMetadata.currentChapter
        let userLevel = storyMetadata.userProgress?.currentCefr ?? .a1
        self._viewModel = StateObject(wrappedValue: StoryViewModel(chapterId: chapter, userLevel: userLevel))
    }
    
    var body: some View {
        ZStack {
            Color("AppBackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                chapterTitleView
                
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 16) {
                            ForEach(viewModel.displayedBlocks.indices, id: \.self) { index in
                                blockView(for: viewModel.displayedBlocks[index], at: index)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        
                        Color.clear.frame(height: 1).id("bottomID")
                    }
                    
                    continueButton(proxy: proxy)
                }
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 20)
            }
        }
        .navigationBarBackButtonHidden(true)
        .scrollIndicators(.hidden)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                progressBar
            }
            exitButton
        }
        .task { await loadStory() }
    }
    
    private var chapterTitleView: some View {
        Text("\(viewModel.chapterId). " + (viewModel.currentChapter?.title ?? "Title not found"))
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(Color("TextColor"))
            .padding()
    }
    
    @ViewBuilder
    private func blockView(for block: Block, at index: Int) -> some View {
        switch block.blockType {
        case .story:
            StoryBlockView(
                block: block,
                currentLineIndex: index == viewModel.displayedBlocks.count - 1 ? viewModel.currentLineIndex : .max,
                modifications: viewModel.lineModifications
            )
            .id(index)
        case .exercise:
            if let selectedExercise = viewModel.selectedExercises[block.id] {
                ExerciseBlockView(exercise: selectedExercise, story: viewModel.story, displayContinueButton: $displayContinueButton)
                    .id(index)
            }
        }
    }
    
    private func continueButton(proxy: ScrollViewProxy) -> some View {
        StoryButton(text: "Continue", color: displayContinueButton ? Color("ButtonColor") : Color.gray) {
            viewModel.playNextLine()
            withAnimation {
                proxy.scrollTo("bottomID", anchor: .bottom)
            }
            showStoryView = !viewModel.chapterComplete
        }
        .allowsHitTesting(displayContinueButton ? true : false)
        .padding()
    }
    
    private var exitButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                showStoryView = false
            } label: {
                Image(systemName: "xmark")
                    .font(.headline)
            }
        }
    }
    
    private func loadStory() async {
        guard let storageLocation = storyMetadata.storageLocation else {
            showStoryView = false
            print("Story storage location could not be found.")
            return
        }
        do {
            try await viewModel.loadStory(path: storageLocation)
        } catch {
            showStoryView = false
            print("Failed to load story: \(error)")
        }
    }
    
    // Progress bar at the top of the view, placed in the toolbar
    private var progressBar: some View {
        ProgressView(value: viewModel.progress)
            .progressViewStyle(LinearProgressViewStyle())
            .frame(width: UIScreen.main.bounds.width * 0.8)
            .foregroundStyle(Color("AccentColor").opacity(0.7))
            .controlSize(.large)
    }
}




//#Preview {
//    StoryView(storyMetadata: Story.sample1, showStoryView: .constant(true))
//}
