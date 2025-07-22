import SwiftUI

@main
struct SitiesApp: App {
    @StateObject var listVM = CityListViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(listVM)
        }
    }
}
