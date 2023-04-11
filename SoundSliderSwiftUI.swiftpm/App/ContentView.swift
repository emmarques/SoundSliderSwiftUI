/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            SliderBarView()
                .tabItem {
                    Label("Test bar", systemImage: "AppIcon")
                }

            SliderOffsetView()
                .tabItem {
                    Label("test offset", image: "AppIcon")
                }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
