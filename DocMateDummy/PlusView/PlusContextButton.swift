import SwiftUI

struct PlusContextButton: View {

    @Binding var showScanner: Bool
    @Binding var showPhotoPicker: Bool

    @State private var showDialog = false

    var body: some View {
        
        Button {
            showDialog = true
        } label: {
            ZStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 56, height: 56)
                    .shadow(radius: 6)
                
                Image(systemName: "plus")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
            .offset(y:18)
        }
        
        .confirmationDialog("Add Document", isPresented: $showDialog) {
            
            Button("Scan from Camera") {
                showScanner = true
            }
            
            Button("Upload from Photos or Files") {
                showPhotoPicker = true
            }
            
            Button("Cancel", role: .cancel) {}
        }
    }
}
