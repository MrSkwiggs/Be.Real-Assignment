//
//  FileView.swift
//  Be.Folder
//
//  Created by Dorian on 30/11/2022.
//

import SwiftUI

struct FileView: View {
    
    @StateObject
    var viewModel: ViewModel
    
    var body: some View {
        Group {
            if !viewModel.hasError {
                switch viewModel.fileData {
                case let .raw(data):
                    if let string = String(data: data, encoding: .utf8) {
                        text(from: string)
                    } else {
                        Text("Unable to show raw data")
                    }
                case let .text(string):
                    text(from: string)
                    
                case let .image(data):
                    if let uiImage = UIImage(data: data) {
                        image(from: uiImage)
                    } else {
                        Text("Corrupt image data")
                    }
                    
                case .none:
                    Text("Loading...")
                }
            } else {
                Text("Something went wrong")
            }
        }
        .navigationTitle(viewModel.navbarTitle)
    }
    
    private func image(from image: UIImage) -> some View {
        GeometryReader { proxy in
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: proxy.size.width, height: proxy.size.height)
                .clipShape(Rectangle())
                .modifier(ImageModifier(contentSize: CGSize(width: proxy.size.width, height: proxy.size.height)))
        }
    }
    
    private func text(from string: String) -> some View {
        ScrollView {
            Text(string)
        }
        .padding(.horizontal)
    }
}

import UIKit

struct ImageModifier: ViewModifier {
    private var contentSize: CGSize
    private var min: CGFloat = 1.0
    private var max: CGFloat = 3.0
    @State var currentScale: CGFloat = 1.0
    
    init(contentSize: CGSize) {
        self.contentSize = contentSize
    }
    
    var doubleTapGesture: some Gesture {
        TapGesture(count: 2).onEnded {
            if currentScale <= min { currentScale = max } else
            if currentScale >= max { currentScale = min } else {
                currentScale = ((max - min) * 0.5 + min) < currentScale ? max : min
            }
        }
    }
    
    func body(content: Content) -> some View {
        ScrollView([.horizontal, .vertical]) {
            content
                .frame(width: contentSize.width * currentScale, height: contentSize.height * currentScale, alignment: .center)
                .modifier(PinchToZoom(minScale: min, maxScale: max, scale: $currentScale))
        }
        .gesture(doubleTapGesture)
        .animation(.easeInOut, value: currentScale)
    }
}

class PinchZoomView: UIView {
    let minScale: CGFloat
    let maxScale: CGFloat
    var isPinching: Bool = false
    var scale: CGFloat = 1.0
    let scaleChange: (CGFloat) -> Void
    
    init(minScale: CGFloat,
         maxScale: CGFloat,
         currentScale: CGFloat,
         scaleChange: @escaping (CGFloat) -> Void) {
        self.minScale = minScale
        self.maxScale = maxScale
        self.scale = currentScale
        self.scaleChange = scaleChange
        super.init(frame: .zero)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinch(gesture:)))
        pinchGesture.cancelsTouchesInView = false
        addGestureRecognizer(pinchGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc private func pinch(gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began:
            isPinching = true
            
        case .changed, .ended:
            if gesture.scale <= minScale {
                scale = minScale
            } else if gesture.scale >= maxScale {
                scale = maxScale
            } else {
                scale = gesture.scale
            }
            scaleChange(scale)
        case .cancelled, .failed:
            isPinching = false
            scale = 1.0
        default:
            break
        }
    }
}

struct PinchZoom: UIViewRepresentable {
    let minScale: CGFloat
    let maxScale: CGFloat
    @Binding var scale: CGFloat
    @Binding var isPinching: Bool
    
    func makeUIView(context: Context) -> PinchZoomView {
        let pinchZoomView = PinchZoomView(minScale: minScale, maxScale: maxScale, currentScale: scale, scaleChange: { scale = $0 })
        return pinchZoomView
    }
    
    func updateUIView(_ pageControl: PinchZoomView, context: Context) { }
}

struct PinchToZoom: ViewModifier {
    let minScale: CGFloat
    let maxScale: CGFloat
    @Binding var scale: CGFloat
    @State var anchor: UnitPoint = .center
    @State var isPinching: Bool = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale, anchor: anchor)
            .animation(.spring(), value: isPinching)
            .overlay(PinchZoom(minScale: minScale, maxScale: maxScale, scale: $scale, isPinching: $isPinching))
    }
}

//struct ImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageView()
//    }
//}
