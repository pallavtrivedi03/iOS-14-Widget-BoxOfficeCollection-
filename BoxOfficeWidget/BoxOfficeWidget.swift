//
//  BoxOfficeWidget.swift
//  BoxOfficeWidget
//
//  Created by Pallav Trivedi on 01/09/20.
//

import WidgetKit
import SwiftUI
import SDWebImageSwiftUI

struct Provider: TimelineProvider {
    
    let dummyData = MovieInfo(name: "Some latest movie", releaseDate: "Release Date", daysSinceRelease: 1, collection: "Collection in Cr", posterUrl: "https://popcornusa.s3.amazonaws.com/placeholder-movieimage.png")
    
    func placeholder(in context: Context) -> MovieInfoEntry {
        MovieInfoEntry(date: Date(), movieInfo: dummyData)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (MovieInfoEntry) -> ()) {
        let entry = MovieInfoEntry(date: Date(), movieInfo: dummyData)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
        MovieInfoLoader.fetch { result in
            var movie: MovieInfo
            if case .success(let fetchedMovies) = result {
                movie = fetchedMovies.randomElement()!
            } else {
                movie = MovieInfo(name: "Some latest movie", releaseDate: "Release Date", daysSinceRelease: 1, collection: "Collection in Cr", posterUrl: "https://popcornusa.s3.amazonaws.com/placeholder-movieimage.png")
            }
            let entry = MovieInfoEntry(date: currentDate, movieInfo: movie)
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }
    }
}

struct MovieInfoEntry: TimelineEntry {
    public let date: Date
    public let movieInfo: MovieInfo
}

struct BoxOfficeWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            ZStack {
                moviePosterView()
                VStack(alignment: .leading, spacing: 4) {
                    Spacer()
                    Text(entry.movieInfo.name ?? "")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .bold()
                    
                    Text(entry.movieInfo.collection ?? "")
                        .font(.system(size: 17))
                        .foregroundColor(.white)
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                .padding()
                .foregroundColor(.clear)        // Making rectangle transparent
                .background(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom))
            }
        case .systemMedium:
            ZStack {
                moviePosterView()
                VStack(alignment: .leading, spacing: 4) {
                    Spacer()
                    Text(entry.movieInfo.name ?? "")
                        .font(.system(size: 26))
                        .foregroundColor(.white)
                        .bold()
                    Text(entry.movieInfo.releaseDate ?? "")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                    Text(entry.movieInfo.collection ?? "")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                .padding()
                .foregroundColor(.clear)        // Making rectangle transparent
                .background(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom))
            }
        case .systemLarge:
            ZStack {
                moviePosterView()
                VStack(alignment: .leading, spacing: 4) {
                    Spacer()
                    Text(entry.movieInfo.name ?? "")
                        .font(.system(size: 28))
                        .foregroundColor(.white)
                        .bold()
                    Text("\(entry.movieInfo.daysSinceRelease ?? 1) days collection: \(entry.movieInfo.collection ?? "")")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .bold()
                    Text("Released on: \(entry.movieInfo.releaseDate ?? "")")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                .padding()
                .foregroundColor(.clear)        // Making rectangle transparent
                .background(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom))
            }
        default:
            ZStack {
                moviePosterView()
                VStack(alignment: .leading, spacing: 4) {
                    Spacer()
                    Text(entry.movieInfo.name ?? "")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .bold()
                    
                    Text(entry.movieInfo.collection ?? "")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                .padding()
                .foregroundColor(.clear)        // Making rectangle transparent
                .background(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom))
            }
        }
    }
    
    func moviePosterView() -> some View {
        
        GeometryReader { geo in
            WebImage(url: URL(string:entry.movieInfo.posterUrl!))
                .resizable()
                .placeholder {
                    Image(uiImage: UIImage(named: "moviePlaceholder")!)
                }
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .frame(width: geo.size.width)
        }
    }
}

@main
struct BoxOfficeWidget: Widget {
    let kind: String = "BoxOfficeWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            BoxOfficeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Box Office")
        .description("Box office collection of latest movies")
    }
}
