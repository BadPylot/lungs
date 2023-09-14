import SwiftUI

@main
struct lungsApp: App {
    @StateObject var viewModel = ViewModel();
    var body: some Scene {
        WindowGroup {
            ContentView(vm: viewModel)
        }
    }
}
