import SwiftUI

struct QualityView: View {
    @ObservedObject var qualityModel: QualityModel
    var body: some View {
        VStack {
            if (qualityModel.last == true) {
                Spacer()
                Image(systemName: "plus")
                    .resizable()
                    .frame(width:150, height:150)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.accentColor)
                    .font(.system(size:12, weight: .thin))
                Spacer()
            } else {
                Text("Test")
            }
        }
    }
}
