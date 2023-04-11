/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI
import Combine
import MediaPlayer

struct SliderBarView: View {
    @State private var showAnimation = false
    private let maxTime: TimeInterval = 3
    @State var progress: Double = 0
    @State var startDate: Double = Date().timeIntervalSince1970
    @State var isPressing = false
    @State var barWidth: CGFloat = 0
    let maxAngle: Double = 70
    let maxHeight: CGFloat = 40
    let buttonHeight: CGFloat = 32
    let maxStartAngle: CGFloat = 10
    let maxEndAngle: CGFloat = 180
    @State var throwStartAngle: CGFloat = 10
    @State var throwEndAngle: CGFloat = 180
    @State var timer: Timer?
    
    var body: some View {
        ZStack {
            HStack {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(maxWidth: buttonHeight * progress, maxHeight: buttonHeight)
                        .rotationEffect(.degrees(isPressing ? throwAngle() : 0))
                    soundButton
                }
                .background(Color.gray)
                .mask {
                    Image("sound-icon")
                        .resizable()
                        .rotationEffect(.degrees(isPressing ? throwAngle() : 0))
                }
                circleBar
            }
        }
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
    }
    
    func throwAngle() -> Double {
        -maxAngle * progress
    }
    
    func timerStart() {
        startDate = Date().timeIntervalSince1970
        progress = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
            progress = min(Date().timeIntervalSince1970 - startDate, maxTime) / maxTime
            throwStartAngle = maxStartAngle * progress
        })
        isPressing = true
    }
    
    func finishTimerAndUpdateVolume() {
        timer?.invalidate()
        throwEndAngle = maxEndAngle
        isPressing = false
        
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
          slider?.value = Float(progress)
        }
    }
}

extension SliderBarView {
    private var soundButton: some View {
        Button {
        } label: {
            Image("sound-icon")
                .resizable()
                .frame(width: 32, height: 32)
        }
        .foregroundColor(.gray)
        .onLongPressGesture(minimumDuration: 0.1) {
        } onPressingChanged: { isPressing in
            if isPressing {
                timerStart()
            } else {
                withAnimation(.default) {
                    finishTimerAndUpdateVolume()
                }
            }
        }
    }
}

extension SliderBarView {
    private var circleBar: some View {
        GeometryReader { metrics in
            //barra roxa
            HStack {
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.purple)
            .opacity(0.5)
            .cornerRadius(8)
            .onAppear {
                barWidth = metrics.size.width
            }
            //barra verde
            HStack {
                Circle()
                    .foregroundColor(isPressing ? .clear : .black)
                    .frame(width: 20, height: 20)
                    .opacity(isPressing ? 0 : 1)
                Spacer()
            }
            .frame(width: barWidth * progress, height: 10)
//            .background(Color.green)
            .rotationEffect(.degrees(isPressing ? throwStartAngle : throwEndAngle), anchor: .center)
        }
        .frame(maxWidth: .infinity, maxHeight: 10)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        SliderBarView()
    }
}
