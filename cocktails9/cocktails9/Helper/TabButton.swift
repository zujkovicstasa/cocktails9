
import SwiftUI

struct TabButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let selectedColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? selectedColor : .secondary)
                Text(label)
                    .font(.caption2)
                    .lineLimit(1)
                    .foregroundColor(isSelected ? selectedColor : .secondary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
