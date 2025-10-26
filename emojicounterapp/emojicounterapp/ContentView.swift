//
//  ContentView.swift
//  emojicounterapp
//
//  Created by Meghan Rockwood on 10/25/25.
//

import SwiftUI

// MARK: - Counter Model
struct EmojiCounter: Identifiable {
    let id = UUID()
    var emoji: String
    var count: Int
}

// MARK: - Main Content View
struct ContentView: View {
    @State private var counters = [
        EmojiCounter(emoji: "😀", count: 3),
        EmojiCounter(emoji: "😍", count: -2),
        EmojiCounter(emoji: "😎", count: 2),
        EmojiCounter(emoji: "😊", count: 1),
        EmojiCounter(emoji: "😂", count: -1)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.blue.opacity(0.05)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Main content
                List {
                    ForEach(counters.indices, id: \.self) { index in
                        CounterRowView(
                            counter: $counters[index],
                            onIncrement: {
                                counters[index].count += 1
                            },
                            onDecrement: {
                                counters[index].count -= 1
                            }
                        )
                        .listRowBackground(Color.white)
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Emoji Counter")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Counter Row View
struct CounterRowView: View {
    @Binding var counter: EmojiCounter
    let onIncrement: () -> Void
    let onDecrement: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // Emoji and counter label
            HStack(spacing: 8) {
                Text(counter.emoji)
                    .font(.system(size: 28))
                
                Text("Counter: \(counter.count)")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(counter.count >= 0 ? .blue : .red)
            }
            
            Spacer()
            
            // Buttons
            HStack(spacing: 12) {
                // Increment button
                Button(action: onIncrement) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.blue)
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .strokeBorder(Color.blue, lineWidth: 2)
                        )
                }
                .buttonStyle(.plain)
                
                // Decrement button
                Button(action: onDecrement) {
                    Image(systemName: "minus")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.blue)
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .strokeBorder(Color.blue, lineWidth: 2)
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
