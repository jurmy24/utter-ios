//
//  LiveInteractionView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-21.
//

import SwiftUI
import Vapi
import Combine

class CallManager: ObservableObject {
    enum CallState {
        case started, loading, ended
    }
    
    @Published var callState: CallState = .ended
    var vapiEvents = [Vapi.Event]()
    private var cancellables = Set<AnyCancellable>()
    let vapi: Vapi
    
    @Published var progress: Double = 0
    private var timer: Timer?
    
    func startTimer() {
            progress = 0
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                if self.progress < 1.0 {
                    self.progress += 1.0 / 60.0 // Increase by 1/60 each second
                } else {
                    self.stopTimer()
                }
            }
        }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        progress = 0
    }
    
    
    // TODO: This should be run on my own server as its really bad practice to put in the app bundle
    init() {
        // Load the plist file
        if let path = Bundle.main.path(forResource: "TokensInfo", ofType: "plist"),
           let plistData = NSDictionary(contentsOfFile: path),
           let publicKey = plistData["VAPI_PUBLIC_KEY"] as? String {
            
            // Initialize vapi with the fetched public key
            vapi = Vapi(
                publicKey: publicKey
            )
        } else {
            // Handle the case where the plist could not be loaded or the key is missing
            fatalError("Unable to load public key from TokensInfo.plist")
        }
    }
    
    func setupVapi() {
        vapi.eventPublisher
            .sink { [weak self] event in
                self?.vapiEvents.append(event)
                switch event {
                case .callDidStart:
                    self?.callState = .started
                case .callDidEnd:
                    self?.callState = .ended
                case .speechUpdate:
                    print(event)
                case .conversationUpdate:
                    print(event)
                case .functionCall:
                    print(event)
                case .hang:
                    print(event)
                case .metadata:
                    print(event)
                case .transcript:
                    print(event)
                case .error(let error):
                    print("Error: \(error)")
                }
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    func handleCallAction(firstMessage: String, extraContext: String) async {
        if callState == .ended {
            await startCall(firstMessage: firstMessage, extraContext: extraContext)
        } else {
            endCall()
        }
    }
    
    @MainActor
    func startCall(firstMessage: String, extraContext: String) async {
        callState = .loading

        let context = "STORY HISTORY:\n" + extraContext + "\nGUIDANCE: Make sure the user speaks the language of the story and help them as needed. Speak in simple terminology in the language. You can also provide hints if they are struggling."
        
        let overrides = [
            "firstMessage": firstMessage,
            "context": context,
        ] as [String : Any]
        do {
            try await vapi.start(assistantId: "0568bfab-7ac5-4ee8-9a94-0e7b919331ce", assistantOverrides: overrides) //77c55889-6355-45e7-ac59-bd040ca3a14e
            startTimer() // Start the timer when the call starts
        } catch {
            print("Error starting call: \(error)")
            callState = .ended
        }
    }
    
    func endCall() {
        stopTimer() // Stop the timer when the call ends
        vapi.stop()
    }
}

struct LiveInteractionView: View {
    @Binding var isInteractive: Bool
    @StateObject private var callManager = CallManager()
    @State private var isAnimating = false
    let firstMessage: String
    let extraContext: String?
    
    var body: some View {
        VStack {
            ZStack {
                // Background gradient
                LinearGradient(gradient: Gradient(colors: [Color("AppBackgroundColor").opacity(1), Color("AccentColor").opacity(1)]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    
                    Spacer()
                    
                    if callManager.callState == .started {
                        Circle()
                            .fill(Color.green.opacity(0.6))
                            .frame(width: 100, height: 100)
                            .scaleEffect(isAnimating ? 1.2 : 1.0)
                            .opacity(isAnimating ? 0.6 : 1.0)
                            .animation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isAnimating)
                            .onAppear {
                                isAnimating = true
                            }
                            .onDisappear {
                                isAnimating = false
                            }
                    } else {
                        Text(callManager.callStateText)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                            .background(callManager.callStateColor)
                            .cornerRadius(10)
                    }

                    Spacer()
                    
                    Button(action: {
                        Task {
                            await callManager.handleCallAction(firstMessage: firstMessage, extraContext: extraContext ?? "")
                        }
                    }) {
                        Text(callManager.buttonText)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(callManager.buttonColor)
                            .cornerRadius(10)
                    }
                    .disabled(callManager.callState == .loading)
                    .padding(.horizontal, 20)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    if callManager.callState == .started {
                        ProgressView(value: callManager.progress, total: 1.0)
                            .progressViewStyle(LinearProgressViewStyle())
                            .frame(width: 100)
                    }
                    Button {
                        callManager.endCall()
                        isInteractive = false
                    } label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                    }
                }
            }
        }
        .onAppear {
            callManager.setupVapi()
        }
    }
}

extension CallManager {
    var callStateText: String {
        switch callState {
        case .started: return "..Active.."
        case .loading: return "Connecting..."
        case .ended: return "Press start to connect"
        }
    }
    
    var callStateColor: Color {
        switch callState {
        case .started: return .green.opacity(0.8)
        case .loading: return .orange.opacity(0.8)
        case .ended: return .gray.opacity(0.8)
        }
    }
    
    var buttonText: String {
        callState == .loading ? "Loading..." : (callState == .ended ? "Start" : "Stop")
    }
    
    var buttonColor: Color {
        callState == .loading ? .gray : (callState == .ended ? Color("LogoBackgroundColor") : .red)
    }
}

#Preview {
    NavigationStack{
        LiveInteractionView(isInteractive: .constant(false), firstMessage: "Potato", extraContext: "Nuggets")
    }
    
}
