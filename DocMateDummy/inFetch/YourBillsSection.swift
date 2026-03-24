import SwiftUI

struct YourBillsSection: View {
    
    var bills: [infetch]
    
    @State private var currentIndex = 0
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            
            // Header
            HStack {
                Text("Your Bills")
                    .font(.title3)
                    .fontWeight(.bold)
                
                NavigationLink(destination: AllBillsView()) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
            }
            
            // 🔥 Apple Style Card Transition
            if !bills.isEmpty {
                
                ZStack {
                    InfetchBillCard(doc: bills[currentIndex])
                        .id(currentIndex) // 🔥 important
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                }
                .animation(.easeInOut(duration: 0.5), value: currentIndex)
                .onAppear {
                    startAutoScroll()
                }
            }
        }
    }
    
    // 🔥 Auto Change
    func startAutoScroll() {
        
        Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { _ in
            
            if bills.isEmpty { return }
            
            withAnimation {
                currentIndex = Int.random(in: 0..<bills.count)
            }
        }
    }
}
