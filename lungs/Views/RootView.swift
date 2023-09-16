import SwiftUI
import SwiftUIPager

struct RootView: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var vm: ViewModel
    var body: some View {
        VStack {
            BrandingView()
            Pager(page: vm.page,
                  data: vm.pageItems,
                  id: \.hashValue,
                  content: { qualityModel in
                let pageIndex = vm.pageItems.firstIndex(where: {
                    $0.hashValue == qualityModel.hashValue })!
                QualityView(vm: vm, qm: qualityModel, index: pageIndex)
            })
            .onPageChanged({ newIndex in
                let pageItem = vm.pageItems[newIndex]
                if (!pageItem.hasData) {
                    pageItem.refresh(newLocation: nil)
                }
            })
            .sheet(isPresented:$vm.addLoc) {
                VStack {
                    BrandingView()
                    SearchView(vm: vm)
                }
                // Hack to get around (inferior) Apple-provided colors.
                .background(colorScheme == .dark ? Color.black : Color.white)
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(vm: ViewModel(demo: true))
    }
}
