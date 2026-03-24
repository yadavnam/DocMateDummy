import SwiftUI

struct AllBillsView: View {
    
    @Environment(AppViewModel.self) var viewModel
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 16) {
                
                ForEach(viewModel.inFetch) { doc in
                    
                    AllBillsCard(doc: doc) {
                        refreshBill(doc)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("All Bills")
    }
    
    // 🔥 Refresh Logic
    func refreshBill(_ doc: infetch) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            
            let isPaid = Bool.random() // API replace later
            
            if isPaid {
                withAnimation {
                    viewModel.inFetch.removeAll { $0.id == doc.id }
                }
            }
        }
    }
}
