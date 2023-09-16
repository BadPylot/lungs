import SwiftUI
import CoreLocation

struct SearchView: View {
    @ObservedObject var vm: ViewModel
    var body: some View {
        VStack {
            Text("New Location")
                .font(.title2)
                .padding(.all)
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search", text: $vm.searchText)
                    .onChange(of: vm.searchText) { _ in
                        vm.handleSearchInput()
                    }
            }
            .padding(7)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)
            if (!vm.searchResults.isEmpty) {
                List(vm.searchResults, id: \.self) { result in
                    HStack {
                        Text("\(result.name != nil ? result.name! + "," : "") \(result.administrativeArea != nil ? result.administrativeArea! + "," : "") \(result.country ?? "")")
                        Spacer()
                        Image(systemName:"plus.circle")
                            .foregroundColor(.green)
                            .onTapGesture {
                                var location = result.location
                                // Cumbersome code to get a more central set of coordinates so we get the right station.
                                if ((result.region != nil) && (result.region! is CLCircularRegion)) {
                                    let circRegion:CLCircularRegion = result.region! as! CLCircularRegion
                                    location = CLLocation(latitude:circRegion.center.latitude, longitude:circRegion.center.longitude)
                                }
                                // I don't believe this can happen, but we should check to be safe.
                                if ((location == nil) || !vm.addPage(newLoc: location!)) {
                                    return
                                }
                                vm.addLoc = false
                                vm.page = .withIndex(vm.pageItems.count - 1)
                                vm.searchText = ""
                            }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5)
                }
                // Hide default background as it only shows when the list is populated, making appearence inconsistent.
                .scrollContentBackground(.hidden)
            } else {
                Spacer()
                Text("Start typing above to search.")
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            Spacer()
            Text("Swipe down from the top of the screen to close this view.")
                .font(.caption)
        }
    }
    struct SearchView_Previews: PreviewProvider {
        static var previews: some View {
            SearchView(vm: ViewModel(demo: true))
        }
    }
}
