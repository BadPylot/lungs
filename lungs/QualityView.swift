import SwiftUI

struct QualityView: View {
    @ObservedObject var qm: QualityModel
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(Color(.secondarySystemBackground))
            VStack {
                HStack {
                    if (qm.loading) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        Image(systemName:"arrow.clockwise")
                            .foregroundColor(.accentColor)
                            .onTapGesture {
                                qm.refresh(newLocation: nil)
                            }
                    }
                    if (qm.first) {
                        Spacer()
                        Image(systemName:"location.fill")
                            .foregroundColor(.gray)
                    }
                        Spacer()
                    Image(systemName:"plus")
                        .foregroundColor(.accentColor)
                }
                .padding(.all)
                VStack {
                    if (!qm.hasData) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        Text("\(qm.city), \(qm.province)")
                        Text("\(qm.country)")
                    }
                    Spacer()
                }
            }
        }
        .frame(width: 300, height: 500)
    }
}
