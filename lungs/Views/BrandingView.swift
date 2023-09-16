import SwiftUI
struct BrandingView: View {
    var body: some View {
        ZStack {
            Rectangle().fill(Color(.secondarySystemBackground)).frame(height:100)
            HStack {
                Image(systemName: "lungs")
                    .font(.system(size: 35))
                    .padding(.leading)
                HStack {
                    Text("lungs")
                    Text(".")
                        .padding([.leading], -8)
                }
                .font(.system(size: 35))
            }
        }
    }
}
