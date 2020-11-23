//
//  StackSwipableCardView.swift
//  yggdrasil-sprout
//
//  Created by fuziki on 2020/09/13.
//

import SwiftUI

public enum CardViewEndedMoveAction {
    case none
    case throwLeft
    case throwRight
}

public struct StackSwipableCardConfiguration {
    /// stackされたviewの小さくなる倍率
    public let calcScale: () -> CGFloat
    /// stackされたviewがずれる割合
    public let calcOffset: () -> CGSize
    /// 移動量に応じた回転量
    public let calcRotation: (_ translation: CGSize) -> Angle
    /// 左右に飛んでいった先の位置
    public let threwLeft: (point: CGSize, duration: Double)
    public let threwRight: (point: CGSize, duration: Double)
    internal static func makeDefault(sourcesSize: Int, index: Int, proxy: GeometryProxy) -> Self {
        func calcScale(sourcesSize: Int, index: Int, size: CGSize) -> CGFloat {
            return (size.width - 10 * (CGFloat(sourcesSize - 1 - index))) / size.width
        }
        func calcOffset(sourcesSize: Int, index: Int, size: CGSize) -> CGSize {
            return CGSize(width: 0,
                          height: size.height * (1 - calcScale(sourcesSize: sourcesSize, index: index, size: size)) / 2 + 5 * CGFloat(sourcesSize - 1 - index))
        }
        return Self.init(calcScale: { calcScale(sourcesSize: sourcesSize, index: index, size: proxy.size) },
                         calcOffset: { calcOffset(sourcesSize: sourcesSize, index: index, size: proxy.size) },
                         calcRotation: { .degrees(Double($0.width / 300) * 25) },
                         threwLeft: (point: CGSize(width: -300, height: 0), duration: 0.1),
                         threwRight: (point: CGSize(width: 300, height: 0), duration: 0.1))
    }
}

public struct StackSwipableCardView<Sources: RandomAccessCollection, CardContent: View> : View where Sources.Element : Identifiable {
    private let sources: Sources
    private let cardContent: (Sources.Element) -> CardContent
    private let onEndedMove: (Sources.Element, CGSize) -> CardViewEndedMoveAction
    private let onThrowAway: (Sources.Element) -> Void
    private var configuration: StackSwipableCardConfiguration? = nil
    public init(_ sources: Sources,
                @ViewBuilder cardContent: @escaping (Sources.Element) -> CardContent,
                             onEndedMove: @escaping (Sources.Element, CGSize) -> CardViewEndedMoveAction,
                             onThrowAway: @escaping (Sources.Element) -> Void,
                             configuration: StackSwipableCardConfiguration? = nil) {
        self.sources = sources
        self.cardContent = cardContent
        self.onEndedMove = onEndedMove
        self.onThrowAway = onThrowAway
        self.configuration = configuration
    }
    public var body: some View {
        GeometryReader { (proxy: GeometryProxy) in
            ZStack {
                ForEach(Array(self.sources.reversed().enumerated()), id: \.1.id) { (i: Int, source: Sources.Element) in
                    SwipableCardView(source: source,
                                     configuration: self.configuration ?? .makeDefault(sourcesSize: self.sources.count, index: i, proxy: proxy),
                                     cardContent: self.cardContent,
                                     onEndedMove: self.onEndedMove,
                                     onThrowAway: self.onThrowAway)
                }
                .animation(.spring())
            }
        }
    }
}

fileprivate struct SwipableCardView<Source, CardContent: View>: View {
    internal let source: Source
    internal let configuration: StackSwipableCardConfiguration
    internal let cardContent: (Source) -> CardContent
    internal let onEndedMove: (Source, CGSize) -> CardViewEndedMoveAction
    internal let onThrowAway: (Source) -> Void
    @State private var translation: CGSize = .zero

    public var body: some View {
        self.cardContent(source)
            .rotationEffect(configuration.calcRotation(translation), anchor: .bottom)
            .offset(x: translation.width, y: 0)
            .scaleEffect(configuration.calcScale())
            .offset(configuration.calcOffset())
            .gesture(gesture)
    }
    private var gesture: some Gesture {
        return DragGesture()
            .onChanged({ value in
                self.translation = value.translation
            })
            .onEnded({ value in
                let action = self.onEndedMove(self.source, value.translation)
                switch action {
                case .throwLeft:
                    withAnimation(.easeInOut(duration: self.configuration.threwLeft.duration), {
                        self.translation = self.configuration.threwLeft.point
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.configuration.threwLeft.duration) {
                        self.onThrowAway(self.source)
                    }
                case .throwRight:
                    withAnimation(.easeInOut(duration: self.configuration.threwRight.duration), {
                        self.translation = self.configuration.threwRight.point
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.configuration.threwRight.duration) {
                        self.onThrowAway(self.source)
                    }
                case .none:
                    self.translation = .zero
                }
            })
    }
}

struct SwipableCardView_Previews: PreviewProvider {
    static var previews: some View {
        ExamleSwipableCardView()
    }
}

struct ExamleSwipableCardView: View {
    struct Card: Identifiable {
        let id: Int
        let text: String
    }
    @State private var cardList: [Card] = (0..<10).map({ Card(id: $0, text: "Number \($0)") })
    var body: some View {
        GeometryReader { (proxy: GeometryProxy) in
            StackSwipableCardView(self.cardList.prefix(3),
                                  cardContent: { (card: Card) in
                                    Text(card.text)
                                        .font(.title)
                                        .frame(width: proxy.size.width - 16 * 2, height: proxy.size.height - 16 * 3, alignment: .center)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .shadow(radius: 5)
            },
                                  onEndedMove: { (card: Card, translation: CGSize) in
                                    switch translation.width {
                                    case let w where w < -0.3 * proxy.size.width:
                                        return .throwLeft
                                    case let w where w > 0.3 * proxy.size.width:
                                        return .throwRight
                                    default:
                                        return .none
                                    }
            },
                                  onThrowAway: { (card: Card) in
                                    self.cardList.removeAll(where: { $0.id == card.id })
            })
            .padding(.bottom, 16)
        }
    }
}
