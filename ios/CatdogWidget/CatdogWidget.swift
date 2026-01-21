//
//  CatdogWidget.swift
//  CatdogWidget
//

import WidgetKit
import SwiftUI

// 1. 데이터 모델 (TimelineEntry)
struct SimpleEntry: TimelineEntry {
    let date: Date
    let image: UIImage? // 이미지를 미리 다운로드해서 들고 있음
}

// 2. 타임라인 제공자 (TimelineProvider)
struct Provider: TimelineProvider {
    let appGroupId = "group.com.team.catdog.catdog"
    let userDefaultsKey = "latest_image_url"

    // UserDefaults에서 URL 가져오기
    func getImageUrl() -> String? {
        let userDefaults = UserDefaults(suiteName: appGroupId)
        return userDefaults?.string(forKey: userDefaultsKey)
    }
    
    // URL에서 이미지 다운로드
    func downloadImage(from urlStr: String?) -> UIImage? {
        guard let urlStr = urlStr, let url = URL(string: urlStr) else { return nil }
        // 동기적으로 다운로드 (Provider 내부에서는 허용됨)
        if let data = try? Data(contentsOf: url) {
            return UIImage(data: data)
        }
        return nil
    }

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), image: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let urlStr = getImageUrl()
        let image = downloadImage(from: urlStr)
        let entry = SimpleEntry(date: Date(), image: image)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let currentDate = Date()
        let urlStr = getImageUrl()
        let image = downloadImage(from: urlStr)
        
        let entry = SimpleEntry(date: currentDate, image: image)

        // 15분 후 갱신
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
        completion(timeline)
    }
}

// 3. 위젯 뷰 (SwiftUI)
struct CatdogWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        GeometryReader { geometry in
            if let uiImage = entry.image {
                // 1) 이미지가 있을 때
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            } else {
                // 2) 이미지가 없을 때
                Image("android_2")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            }
        }
        .containerBackground(for: .widget) {
             Color.white
        }
    }
}

// 4. 위젯 진입점
@main
struct CatdogWidget: Widget {
    let kind: String = "CatdogWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                CatdogWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                CatdogWidgetEntryView(entry: entry)
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .configurationDisplayName("댕냥댕냥 위젯")
        .description("반려동물 사진을 홈 화면에서 확인하세요.")
        .supportedFamilies([.systemSmall, .systemLarge])
        .contentMarginsDisabled()
    }
}
