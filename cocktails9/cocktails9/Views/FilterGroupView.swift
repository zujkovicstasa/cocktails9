import SwiftUI

struct FilterGroupView: View {
    let title: String
    let options: [String]
    @Binding var selectedOption: String?
    
    @State private var isExpanded: Bool = false  // State to control if the filter group is expanded
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .onTapGesture {
                    isExpanded.toggle()  // Toggle the section when tapped
                }
            
            if isExpanded {  // Only show options if expanded
                ForEach(options, id: \.self) { option in
                    HStack {
                        Text(option)
                        Spacer()
                        if selectedOption == option {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    .background(
                        selectedOption == option ? Color.blue.opacity(0.2) : Color.clear
                    )
                    .cornerRadius(8)
                    .onTapGesture {
                        selectedOption = option
                    }
                }
            }
        }
        .animation(.easeInOut, value: isExpanded) // Smooth animation for expand/collapse
    }
}
