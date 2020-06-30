//
//  MetroLinesWidget.swift
//  MetroLinesWidget
//
//  Created by Chatharoo on 30/06/2020.
//

import WidgetKit
import SwiftUI
import Combine

struct LastMissionEntry: TimelineEntry {
    public let date: Date
    public let mission: [String]
}

struct MissionTimeLine: TimelineProvider {
    typealias Entry = LastMissionEntry
    @State var cancellables: AnyCancellable? = nil
    
    public func snapshot(with context: Context, completion: @escaping (LastMissionEntry) -> ()) {
        let fakeMission = ["Hey", "Bonjour"]
        let entry = LastMissionEntry(date: Date(), mission: fakeMission)
        completion(entry)
    }
    
    public func timeline(with context: Context, completion: @escaping (Timeline<LastMissionEntry>) -> ()) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
        var  mission: [String]
        
        cancellables = MissionLoader.fetch()
            .sink(receiveCompletion: { completion in
                if case .failure(let apiError) = completion {
                    print(apiError)
                }
            }, receiveValue: { (model: [String]) in
                print(model)
                mission = model
            })
        let entry = LastMissionEntry(date: currentDate, mission: mission)
        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
        completion(timeline)
    }
}

struct MissionLoader {
    static func fetch() -> AnyPublisher<[String], APIError> {
        URLSession.shared.dataTaskPublisher(for: APIService.BASE_URL)
            .tryMap({ result in
                guard let urlResponse = result.response as? HTTPURLResponse, (200...299).contains(urlResponse.statusCode) else {
                    throw APIError.unknown
                }
                return try! JSONDecoder().decode([String].self, from: result.data)
            })
            .receive(on: RunLoop.main)
            .mapError { APIError.parseError(reason: $0.localizedDescription) }
            .eraseToAnyPublisher()
    }
}

struct PlaceholderView: View {
    var body: some View {
        Text("Loading...")
    }
}

struct MissionWidgetView: View {
    let entry: LastMissionEntry
    
    var body: some View {
        List {
            ForEach(entry.mission, id: \.self) {
                MissionRow(result: $0)
            }
        }
        .background(Color.offWhite)
        .neumorphicShadowBlack(radius: 10)
        .neumorphicShadowWhite(radius: 10)
        .listStyle(InsetGroupedListStyle())
    }
}

struct MissionRow : View {
    var result: String
    
    var body: some View {
        HStack {
            Image("m13")
            Text(result)
        }
    }
}

@main
struct MetroLinesWidget: Widget {
    private let kind: String = "MetroLinesWidget"

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MissionTimeLine(), placeholder: PlaceholderView()) { entry in
            MissionWidgetView(entry: entry)
        }
        .configurationDisplayName("Metro Lines")
        .description("Montre les prochaines arrivées du métro")
    }
}
