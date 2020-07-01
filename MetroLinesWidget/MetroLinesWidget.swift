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
    
    public func snapshot(with context: Context, completion: @escaping (LastMissionEntry) -> ()) {
        let fakeMission = ["Hey", "Bonjour"]
        let entry = LastMissionEntry(date: Date(), mission: fakeMission)
        completion(entry)
    }
    
    public func timeline(with context: Context, completion: @escaping (Timeline<LastMissionEntry>) -> ()) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
        
        MissionLoader.fetch { result in
            let missions: [String]
            if case .success(let fetchedMission) = result {
                missions = fetchedMission
            } else {
                missions = []
            }
            let entry = LastMissionEntry(date: currentDate, mission: missions)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }
    }
}

struct MissionLoader {
    //    static func fetch() -> AnyPublisher<[String], APIError> {
    //        URLSession.shared.dataTaskPublisher(for: APIService.BASE_URL)
    //            .tryMap({ result in
    //                guard let urlResponse = result.response as? HTTPURLResponse, (200...299).contains(urlResponse.statusCode) else {
    //                    throw APIError.unknown
    //                }
    //                return try! JSONDecoder().decode([String].self, from: result.data)
    //            })
    //            .receive(on: RunLoop.main)
    //            .mapError { APIError.parseError(reason: $0.localizedDescription) }
    //            .eraseToAnyPublisher()
    //    }
    
    static func fetch(completion: @escaping (Result<[String], Error>) -> Void) {
        URLSession.shared.dataTask(with: APIService.BASE_URL) { (data, response, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            let mission = try! JSONDecoder().decode([String].self, from: data!)
            completion(.success(mission))
        }.resume()
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
        VStack {
            ForEach(entry.mission, id: \.self) {
                MissionRow(result: $0)
            }
            .neumorphicShadowBlack(radius: 10)
            .neumorphicShadowWhite(radius: 10)
        }
        .frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: 0, idealHeight: 100, maxHeight: .infinity, alignment: .center)
        .padding()
    }
}

struct MissionRow : View {
    var result: String
    
    var body: some View {
        HStack(spacing: 10) {
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
