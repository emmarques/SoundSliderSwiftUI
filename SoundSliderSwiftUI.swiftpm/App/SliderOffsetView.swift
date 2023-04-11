/*
See the License.txt file for this sample’s licensing information.
*/

import SwiftUI
import Combine

struct SliderOffsetView: View {
    @State private var showAnimation = false
    private let maxTime: TimeInterval = 3
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var progress: Double = 0
    @State var startDate: Double = Date().timeIntervalSince1970
    @State var isPressing = false
    @State var barWidth: CGFloat = 0
    let maxAngle: Double = 45
    let maxHeight: CGFloat = 40
    let buttonHeight: CGFloat = 32
    @State var circlePoint: CGSize = CGSize.zero
    @State var isUp = false
    @State var isDown = false
    @State var isflying = false
    
    
    var body: some View {
        ZStack {
            HStack {
                GeometryReader { metrics in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .frame(maxWidth: buttonHeight * progress, maxHeight: buttonHeight)
                            .rotationEffect(.degrees(isPressing ? throwAngle() : 0))
                        Button {
                        } label: {
                            Image("sound-icon")
                                .resizable()
                        }
                            .foregroundColor(.gray)
                            .onLongPressGesture(minimumDuration: 0.1) {
                            } onPressingChanged: { isPressing in
                                withAnimation(.default) {
                                    if isPressing {
                                        timerStart()
                                    } else {
                                        finishTimerAndUpdateVolume()
                                    }
                                }
                            }
                    }
                        .background(Color.gray)
                        .mask {
                            Image("sound-icon")
                                .resizable()
                                .rotationEffect(.degrees(isPressing ? throwAngle() : 0))
                    }
                }.frame(width: 32, height: 32)
                GeometryReader { metrics in
                    ZStack(alignment: .bottomLeading) {
                        HStack {
                            Spacer()
                        }
                        .frame(maxWidth: metrics.size.width * progress, maxHeight: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.purple, lineWidth: 2)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.purple)
                                )
                        )
                        HStack {
                            Spacer()
                        }.onAppear {
                            barWidth = metrics.size.width
                        }
                        .frame(width: 15, height: 10)
                        .background(Color.purple)
                        .opacity(0.5)
                    }
                    .clipShape(Capsule())
                    Circle()
                        .opacity(isPressing ? 0 : 1)
                        .frame(width: 20, height: 20)
                        .background(Color.black)
                        .cornerRadius(10)
                        .offset(circlePoint)
                        .animation(.spring(), value: isflying)
                        .animation(.spring(), value: isUp)
                        .animation(.spring(), value: isDown)
                        
                        
                }
                .frame(maxWidth: .infinity, maxHeight: 10)
            }
        }
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        .onReceive(timer) { value in
            progress = min(value.timeIntervalSince1970 - startDate, maxTime) / maxTime
//            print(progress)
            }
    }
    
    func throwAngle() -> Double {
        -maxAngle * progress
    }
    
    func timerStart() {
        startDate = Date().timeIntervalSince1970
        timer.upstream.connect().cancel()
        timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
        progress = 0
        isPressing = true
        circlePoint = .zero
    }
    
    func finishTimerAndUpdateVolume() {
        timer.upstream.connect().cancel()
        isPressing = false
        
        animateCircleToPosition()
    }
    
    func animateCircleToPosition() {
        let midTopAngle = (barWidth * progress) / 2
        let startHeight = buttonHeight * progress
        circlePoint = CGSize(width: 0, height: -startHeight)
        isDown = false
        isflying = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isUp = true
            circlePoint = CGSize(width: midTopAngle, height: -maxHeight * progress)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isUp = false
            isDown = true
            circlePoint = CGSize(width: barWidth * progress - 10, height: -5)
        }
    }
    
}

struct StoryView_Previews: PreviewProvider {
    static var previews: some View {
        SliderOffsetView()
    }
}
