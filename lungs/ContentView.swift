import SwiftUI
import SwiftUIPager

struct ContentView: View {
    @ObservedObject var vm: ViewModel
    var body: some View {
        VStack {
            ZStack {
                Rectangle().fill(.bar).frame(height:100)
                HStack {
                        Image(systemName: "lungs")
                            .font(.system(size: 35))
                            .padding(.leading)
                        HStack {
                            Text("lungs")
                            Text(".")
                                .padding([.leading], -8)
                        }
                        .font(.custom("AppleGothic", size: 33))
                        .padding([.leading], -15)
                        .bold()
                    .padding(.leading)
                }
            }
            Pager(page: vm.page,
                  data: vm.pageItems,
                  id: \.hashValue,
                  content: { qualityModel in
                QualityView(qualityModel: qualityModel)
             })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(vm: ViewModel())
    }
}
