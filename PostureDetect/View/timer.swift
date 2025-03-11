import SwiftUI

struct CircularSlider: View {
    @Binding var selectedTime: Double // In minutes
    @Binding var timeRemaining: Double // In minutes
    @Binding var timerRunning: Bool

    let markers: [Double] = [0, 5, 10, 15, 20, 25, 30]
    let markerSize: CGFloat = 30
    let startAngle: Double = 240 // Start at 240° (but moving counterclockwise)
    let endAngle: Double = 300 // End at 300°
    let totalAngle: Double = 360 - 60 // Covers almost full circle except gap

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let radius = size / 2
            let progress = timeRemaining / 30
            let currentAngle = startAngle - (progress * totalAngle) // Move counterclockwise

            ZStack {
                Circle()
                    .foregroundColor(.white)

                // Background Circle
                Circle()
                    .stroke(Color("disableButton"), lineWidth: 20)

                // Progress Arc (skipping 250° - 290°)
                Path { path in
                    let progressEndAngle = startAngle - (progress * totalAngle) // Counterclockwise angle

                    for angle in stride(from: 240, to: progressEndAngle, by: -1) { // Moving counterclockwise
                        if angle < 250 || angle > 290 { // Skip the gap
                            let radian = angle * .pi / 180
                            let x = radius + radius * cos(radian)
                            let y = radius + radius * sin(radian)

                            if angle == 240 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                    }
                }
                .stroke(Color("StrokeColor"), style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .animation(.easeInOut(duration: 0.2), value: timeRemaining)
                
                

                // Minute Markers (Clickable)
                ForEach(markers, id: \.self) { minute in
                    let angle = startAngle - (Double(minute) / 30 * totalAngle)
                    if angle < 250 || angle > 290 { // Skip the gap
                        let x = radius + radius * cos(angle * .pi / 180)
                        let y = radius + radius * sin(angle * .pi / 180)

                        Text("\(Int(minute) == 0 ? "0" : "\(Int(minute))m")")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.clear)
                            .position(x: x, y: y)
                            .onTapGesture {
                                selectedTime = Double(minute)
                                timeRemaining = selectedTime
                            }
                    }
                }
                
                
                ForEach(0..<7) { index in
                    let minute = Double(index * 5)
                    let angle = startAngle - (minute / 30 * totalAngle)
                    let outerRadius = radius + 55 // Position it outside the main circle

                    let x = outerRadius * cos(angle * .pi / 180) + radius
                    let y = outerRadius * sin(angle * .pi / 180) + radius

                    Text("\(Int(minute) == 0 ? "0" : "\(Int(minute))m")")
                        .font(.system(size: 30, weight: .bold)) // Bigger font size
                        .foregroundColor(.black)
                        .position(x: x, y: y)
                }

                // Draggable Handle
                Circle()
                    .fill(Color("StrokeColor"))
                    .frame(width: 40, height: 40)
                    .offset(
                        x: radius * cos(currentAngle * .pi / 180),
                        y: radius * sin(currentAngle * .pi / 180)
                    )
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let vector = CGVector(
                                    dx: value.location.x - radius,
                                    dy: value.location.y - radius
                                )
                                let angle = atan2(vector.dy, vector.dx) * 180 / .pi
                                let adjustedAngle = (angle < 0 ? angle + 360 : angle)

                                // Ensure angle is within allowed range (except skipped section)
                                if (adjustedAngle < 250 || adjustedAngle > 290) {
                                    let time = (startAngle - adjustedAngle) / totalAngle * 30

                                    // Snap to nearest marker
                                    let snappedTime = markers.map { Double($0) }
                                        .min(by: { abs($0 - time) < abs($1 - time) }) ?? time

                                    selectedTime = min(max(snappedTime, 0), 30)
                                    timeRemaining = selectedTime
                                }
                            }
                    )

                // Timer text
                VStack {
                    if timerRunning {
                        // Display time in mm:ss format when the timer is running
                        Text(timeString(from: timeRemaining))
                            .font(.system(size: 96, weight: .bold))
                            .foregroundColor(Color("StrokeColor"))
                    } else {
                        // Display time in minutes only when the timer is not running
                        Text("\(Int(selectedTime))")
                            .font(.system(size: 96, weight: .bold))
                            .foregroundColor(Color("StrokeColor"))
                    }

                    Text("minutes")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(Color("StrokeColor"))
                }
            }
            .frame(width: size, height: size)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }

    // Helper function to convert time in minutes to mm:ss format
    private func timeString(from timeInMinutes: Double) -> String {
        let totalSeconds = Int(timeInMinutes * 60)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
