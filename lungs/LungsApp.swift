import SwiftUI

@main
struct LungsApp: App {
    @StateObject var viewModel = ViewModel();
    var body: some Scene {
        WindowGroup {
            RootView(vm: viewModel)
        }
    }
}
