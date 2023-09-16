import SwiftUI

struct QualityView: View {
    @ObservedObject var vm: ViewModel
    @ObservedObject var qm: QualityModel
    var index: Int
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
                    if (index == 0) {
                        Spacer()
                        Image(systemName:"location.fill")
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Image(systemName:"plus")
                        .foregroundColor(.accentColor)
                        .onTapGesture {
                            vm.addLoc = true
                        }
                }
                .padding(.all)
                VStack {
                    if (!qm.hasData && qm.loading) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else if (!qm.hasData) {
                        Spacer()
                        Image(systemName:"x.circle")
                            .foregroundColor(.red)
                            .padding(.bottom, 2)
                        Text("There was an error loading data for this location.")
                            .multilineTextAlignment(.center)
                            .font(.footnote)
                            .padding([.leading, .trailing])
                        Spacer()
                    } else {
                        VStack {
                            Text("\(qm.city != "" ? qm.city + "," : "") \(qm.province != "" ? qm.province + "," : "") \(qm.country)")
                            Spacer()
                            Group {
                                Text("The air quality is")
                                    .font(.caption)
                                Text("\(qm.health())")
                                    .font(.largeTitle)
                                Text("With an AQI of")
                                    .font(.caption)
                                Text(" \(qm.aqi).")
                                    .font(.largeTitle)
                                Text("\(qm.pol) is the primary pollutant.")
                                    .font(.caption)
                            }
                            Spacer()
                            Text(qm.healthDesc())
                            Spacer()
                            Spacer()
                        }
                        .multilineTextAlignment(.center)
                        .padding([.leading, .trailing])
                    }
                    Spacer()
                }
                HStack {
                    Text("\(index + 1)/\(vm.pageItems.count)")
                        .font(.footnote)
                    Spacer()
                    Text("Swipe left or right to change location.")
                        .font(.caption)
                    Spacer()
                    if (index != 0) {
                        Image(systemName:"trash")
                            .foregroundColor(.red)
                            .onTapGesture {
                                vm.removePage(index: self.index)
                                vm.page = .withIndex(vm.pageItems.count)
                            }
                    }
                }
                .padding()
            }
        }
        .frame(width: 300, height: 500)
    }
}

struct QualityView_Previews: PreviewProvider {
    static var previews: some View {
        QualityView(vm: ViewModel(demo: true), qm: QualityModel(), index: 0)
    }
}
