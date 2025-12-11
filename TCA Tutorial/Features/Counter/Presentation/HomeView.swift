import SwiftUI
import UIKit

// MARK: - Screen Size Helper

enum DeviceType {
    case iPhoneMini  // < 375pt width (iPhone SE, mini)
    case iPhoneStandard  // 375-390pt (iPhone 12/13/14/15 standard)
    case iPhonePlus  // 390-430pt (Pro Max, Plus models)
    case iPad  // >= 768pt (iPad, iPad Pro)

    static var current: DeviceType {
        let width = UIScreen.main.bounds.width
        switch width {
        case ..<375: return .iPhoneMini
        case 375..<390: return .iPhoneStandard
        case 390..<768: return .iPhonePlus
        default: return .iPad
        }
    }

    var isIPad: Bool {
        self == .iPad
    }
}

enum ScreenSize {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
    static let deviceType = DeviceType.current

    // MARK: - Card Sizing

    static var cardWidth: CGFloat {
        switch deviceType {
        case .iPhoneMini:
            let availableWidth = width - (horizontalPadding * 2)
            return max(availableWidth * 0.43, 150)
        case .iPhoneStandard:
            let availableWidth = width - (horizontalPadding * 2)
            return max(availableWidth * 0.45, 160)
        case .iPhonePlus:
            let availableWidth = width - (horizontalPadding * 2)
            return max(availableWidth * 0.45, 180)
        case .iPad:
            let availableWidth = width - (horizontalPadding * 2)
            return max(availableWidth * 0.28, 220)
        }
    }

    static var cardHeight: CGFloat {
        cardWidth * 0.78
    }

    // MARK: - Spacing

    static var horizontalPadding: CGFloat {
        switch deviceType {
        case .iPhoneMini: return 16
        case .iPhoneStandard: return 20
        case .iPhonePlus: return 24
        case .iPad: return 32
        }
    }

    static var verticalSpacing: CGFloat {
        switch deviceType {
        case .iPhoneMini: return 16
        case .iPhoneStandard: return 20
        case .iPhonePlus: return 20
        case .iPad: return 24
        }
    }

    static var cardSpacing: CGFloat {
        deviceType.isIPad ? 16 : 12
    }

    // MARK: - Typography

    static var largeTitleSize: CGFloat {
        switch deviceType {
        case .iPhoneMini: return 26
        case .iPhoneStandard: return 28
        case .iPhonePlus: return 30
        case .iPad: return 34
        }
    }

    static var titleFontSize: CGFloat {
        switch deviceType {
        case .iPhoneMini: return 18
        case .iPhoneStandard: return 20
        case .iPhonePlus: return 22
        case .iPad: return 24
        }
    }

    static var bodyFontSize: CGFloat {
        switch deviceType {
        case .iPhoneMini: return 14
        case .iPhoneStandard: return 16
        case .iPhonePlus: return 16
        case .iPad: return 18
        }
    }

    static var captionFontSize: CGFloat {
        switch deviceType {
        case .iPhoneMini: return 11
        case .iPhoneStandard: return 12
        case .iPhonePlus: return 13
        case .iPad: return 14
        }
    }

    static var smallFontSize: CGFloat {
        switch deviceType {
        case .iPhoneMini: return 12
        case .iPhoneStandard: return 13
        case .iPhonePlus: return 14
        case .iPad: return 15
        }
    }

    static var buttonFontSize: CGFloat {
        switch deviceType {
        case .iPhoneMini: return 14
        case .iPhoneStandard: return 16
        case .iPhonePlus: return 16
        case .iPad: return 18
        }
    }

    // MARK: - Icons

    static var iconSize: CGFloat {
        switch deviceType {
        case .iPhoneMini: return 18
        case .iPhoneStandard: return 20
        case .iPhonePlus: return 22
        case .iPad: return 24
        }
    }

    static var largeIconSize: CGFloat {
        switch deviceType {
        case .iPhoneMini: return 50
        case .iPhoneStandard: return 60
        case .iPhonePlus: return 70
        case .iPad: return 80
        }
    }

    // MARK: - Layout

    static var gridColumns: Int {
        deviceType.isIPad ? 2 : 1
    }

    static var minButtonHeight: CGFloat {
        44  // Apple HIG minimum tap target
    }
}

// MARK: - Haptic Manager

class HapticManager {
    static let shared = HapticManager()

    private let lightImpact = UIImpactFeedbackGenerator(style: .light)
    private let mediumImpact = UIImpactFeedbackGenerator(style: .medium)
    private let heavyImpact = UIImpactFeedbackGenerator(style: .heavy)

    private init() {
        lightImpact.prepare()
        mediumImpact.prepare()
        heavyImpact.prepare()
    }

    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        switch style {
        case .light:
            lightImpact.impactOccurred()
            lightImpact.prepare()
        case .medium:
            mediumImpact.impactOccurred()
            mediumImpact.prepare()
        case .heavy:
            heavyImpact.impactOccurred()
            heavyImpact.prepare()
        case .soft:
            lightImpact.impactOccurred()
            lightImpact.prepare()
        case .rigid:
            heavyImpact.impactOccurred()
            heavyImpact.prepare()
        @unknown default:
            mediumImpact.impactOccurred()
            mediumImpact.prepare()
        }
    }
}

// MARK: - Models (UPDATED)

struct Task: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let description: String
    let dueDate: Date
    let priority: Priority
    var status: TaskStatus  // Changed to var for updates
    let meetingTime: String?
    let teamMembers: [User]?

    enum Priority: String {
        case high = "High priority"
        case medium = "Medium"
        case low = "Low"
    }

    enum TaskStatus: String, CaseIterable {
        case notStarted = "Not Started"
        case inProgress = "In Progress"
        case completed = "Completed"

        var color: Color {
            switch self {
            case .notStarted:
                return Color.gray
            case .inProgress:
                return Color.blue
            case .completed:
                return Color(hex: "#7FE8A8")
            }
        }

        var icon: String {
            switch self {
            case .notStarted:
                return "circle"
            case .inProgress:
                return "arrow.clockwise.circle.fill"
            case .completed:
                return "checkmark.circle.fill"
            }
        }
    }

    static func == (lhs: Task, rhs: Task) -> Bool {
        lhs.id == rhs.id
    }
}

struct User: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let avatar: String

    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}

struct Meeting: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let description: String
    let time: String
    let date: Date
    let participants: [User]
    let location: String?

    static func == (lhs: Meeting, rhs: Meeting) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Main View (UPDATED - Using native TabView)

struct TaskManagementView: View {
    @State private var selectedTab: TabItem = .home
    @State private var isTabBarVisible: Bool = true

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeTabView(isTabBarVisible: $isTabBarVisible)
                .tabItem {
                    Label("Home", systemImage: TabItem.home.rawValue)
                }
                .tag(TabItem.home)

            FolderTabView()
                .tabItem {
                    Label("Folders", systemImage: TabItem.folder.rawValue)
                }
                .tag(TabItem.folder)

            AddTabView()
                .tabItem {
                    Label("Add", systemImage: TabItem.add.rawValue)
                }
                .tag(TabItem.add)

            DocumentTabView()
                .tabItem {
                    Label("Documents", systemImage: TabItem.document.rawValue)
                }
                .tag(TabItem.document)

            ProfileTabView()
                .tabItem {
                    Label("Profile", systemImage: TabItem.profile.rawValue)
                }
                .tag(TabItem.profile)
        }
        .accentColor(Color(hex: "#7FE8A8"))
        .onAppear {
            // Set initial tab bar visibility
            updateTabBarVisibility(isTabBarVisible)
        }
        .onChange(of: isTabBarVisible) { newValue in
            updateTabBarVisibility(newValue)
        }
        .onChange(of: selectedTab) { _ in
            HapticManager.shared.impact(.light)
        }
    }

    private func updateTabBarVisibility(_ isVisible: Bool) {
        UITabBar.appearance().isHidden = !isVisible
    }
}

// MARK: - Home Tab View

struct HomeTabView: View {
    @Binding var isTabBarVisible: Bool
    @State private var selectedFilter: Task.TaskStatus? = nil  // nil = All tasks
    @State private var selectedTask: Task?
    @State private var showingTaskDetail = false
    @State private var selectedMeeting: Meeting?
    @State private var showingMeetingDetail = false
    @State private var lastScrollOffset: CGFloat = 0
    @State private var scrollOffset: CGFloat = 0

    let currentDate = Date()

    let sampleMeeting = Meeting(
        title: "Team Meeting",
        description:
            "Discuss the overview of the project and plan for next sprint. Review team progress and address any blockers.",
        time: "11:00-12:15",
        date: Date(),
        participants: [
            User(name: "Sarah Kim", avatar: "👤"),
            User(name: "John Doe", avatar: "👤"),
            User(name: "Mike Ross", avatar: "👤"),
            User(name: "Jane Smith", avatar: "👤"),
        ],
        location: "Conference Room A"
    )

    let todayTasks = [
        Task(
            title: "Research plan",
            description: "Prepare a research plan for a new project",
            dueDate: Date(),
            priority: .medium,
            status: .notStarted,
            meetingTime: nil,
            teamMembers: nil
        ),
        Task(
            title: "Design Review",
            description: "Review the new UI/UX designs for the mobile app",
            dueDate: Date(),
            priority: .high,
            status: .inProgress,
            meetingTime: nil,
            teamMembers: nil
        ),
        Task(
            title: "Code Review",
            description: "Review pull requests from team members",
            dueDate: Date(),
            priority: .medium,
            status: .inProgress,
            meetingTime: nil,
            teamMembers: nil
        ),
        Task(
            title: "Client Meeting",
            description: "Discuss project requirements with client",
            dueDate: Date(),
            priority: .high,
            status: .notStarted,
            meetingTime: nil,
            teamMembers: nil
        ),
        Task(
            title: "Sprint Planning",
            description: "Plan tasks and user stories for next sprint",
            dueDate: Date(),
            priority: .high,
            status: .completed,
            meetingTime: nil,
            teamMembers: nil
        ),
        Task(
            title: "Update API",
            description: "Update REST API endpoints and documentation",
            dueDate: Date(),
            priority: .medium,
            status: .inProgress,
            meetingTime: nil,
            teamMembers: nil
        ),
        Task(
            title: "Testing Session",
            description: "Run automated tests on new features",
            dueDate: Date(),
            priority: .low,
            status: .completed,
            meetingTime: nil,
            teamMembers: nil
        ),
    ]

    let allTasks = [
        Task(
            title: "Plan for the next month",
            description: "Prepare a content plan for Dribble for September",
            dueDate: Date(),
            priority: .high,
            status: .notStarted,
            meetingTime: nil,
            teamMembers: nil
        ),
        Task(
            title: "Update documentation",
            description: "Update API documentation for the new endpoints",
            dueDate: Date(),
            priority: .medium,
            status: .inProgress,
            meetingTime: nil,
            teamMembers: nil
        ),
        Task(
            title: "Bug fixes",
            description: "Fix critical bugs reported by QA team",
            dueDate: Date(),
            priority: .high,
            status: .inProgress,
            meetingTime: nil,
            teamMembers: nil
        ),
        Task(
            title: "Team standup",
            description: "Daily standup meeting with development team",
            dueDate: Date(),
            priority: .medium,
            status: .completed,
            meetingTime: nil,
            teamMembers: nil
        ),
        Task(
            title: "Database optimization",
            description: "Optimize database queries for better performance",
            dueDate: Date(),
            priority: .high,
            status: .inProgress,
            meetingTime: nil,
            teamMembers: nil
        ),
        Task(
            title: "Write unit tests",
            description: "Write unit tests for the new features",
            dueDate: Date(),
            priority: .medium,
            status: .notStarted,
            meetingTime: nil,
            teamMembers: nil
        ),
        Task(
            title: "Security audit",
            description: "Perform security audit on the application",
            dueDate: Date(),
            priority: .high,
            status: .completed,
            meetingTime: nil,
            teamMembers: nil
        ),
    ]

    var body: some View {
        ZStack {
            Color(hex: "#1C1C1E")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HeaderView()

                GeometryReader { _ in
                    ScrollView(showsIndicators: false) {
                        GeometryReader { innerGeometry in
                            Color.clear.preference(
                                key: ScrollOffsetPreferenceKey.self,
                                value: innerGeometry.frame(in: .named("scroll")).minY
                            )
                        }
                        .frame(height: 0)
                        VStack(alignment: .leading, spacing: ScreenSize.verticalSpacing) {
                            ProductivityCard(
                                isSelected: selectedTask == nil && selectedMeeting == nil
                            ) {
                                selectedTask = nil
                                selectedMeeting = nil
                                print("Productivity card tapped")
                            }

                            TodayTasksSection(
                                tasks: todayTasks,
                                meeting: sampleMeeting,
                                selectedTask: $selectedTask,
                                selectedMeeting: $selectedMeeting,
                                onTaskTap: { task in
                                    HapticManager.shared.impact(.medium)

                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedTask = task
                                        selectedMeeting = nil
                                    }

                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                        showingTaskDetail = true
                                    }
                                },
                                onMeetingTap: { meeting in
                                    HapticManager.shared.impact(.medium)

                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedMeeting = meeting
                                        selectedTask = nil
                                    }

                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                        showingMeetingDetail = true
                                    }
                                }
                            )

                            AllTasksSection(
                                selectedFilter: $selectedFilter,
                                tasks: allTasks,
                                selectedTask: $selectedTask,
                                onTaskTap: { task in
                                    HapticManager.shared.impact(.medium)

                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedTask = task
                                    }

                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                        showingTaskDetail = true
                                    }
                                }
                            )
                        }
                        .padding(.horizontal, ScreenSize.horizontalPadding)
                        .padding(.bottom, ScreenSize.verticalSpacing)
                    }
                    .coordinateSpace(name: "scroll")
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        let delta = value - lastScrollOffset
                        lastScrollOffset = value

                        // Hide tab bar when scrolling down (delta < 0)
                        // Show tab bar when scrolling up (delta > 0) or at top (value >= 0)
                        if value >= -10 {
                            // Near the top, always show tab bar
                            withAnimation(.easeInOut(duration: 0.25)) {
                                isTabBarVisible = true
                            }
                        } else if delta < -5 {
                            // Scrolling down significantly
                            withAnimation(.easeInOut(duration: 0.25)) {
                                isTabBarVisible = false
                            }
                        } else if delta > 5 {
                            // Scrolling up significantly
                            withAnimation(.easeInOut(duration: 0.25)) {
                                isTabBarVisible = true
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showingTaskDetail) {
                if let task = selectedTask {
                    TaskDetailView(task: task, isPresented: $showingTaskDetail)
                }
            }
            .sheet(isPresented: $showingMeetingDetail) {
                if let meeting = selectedMeeting {
                    MeetingDetailView(meeting: meeting, isPresented: $showingMeetingDetail)
                }
            }
        }
    }
}

// MARK: - Placeholder Tab Views

struct FolderTabView: View {
    @State private var isAnimating = false
    @State private var isPressed = false

    var body: some View {
        ZStack {
            Color(hex: "#1C1C1E")
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Image(systemName: "folder.fill")
                    .font(.system(size: ScreenSize.largeIconSize))
                    .foregroundColor(Color(hex: "#7FE8A8"))
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(
                        .easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                        value: isAnimating)

                Text("Folders")
                    .font(.system(size: ScreenSize.titleFontSize, weight: .bold))
                    .foregroundColor(.white)

                Text("Organize your tasks and projects")
                    .font(.system(size: ScreenSize.bodyFontSize))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Button(action: {
                    HapticManager.shared.impact(.medium)
                    print("Create folder tapped")
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Create Folder")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color(hex: "#7FE8A8"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
                .buttonStyle(PlainButtonStyle())
                .onLongPressGesture(
                    minimumDuration: 0.5,
                    pressing: { pressing in
                        withAnimation {
                            isPressed = pressing
                        }
                    }, perform: {})
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct AddTabView: View {
    @State private var isRotating = false
    @State private var selectedOption: AddOption? = nil

    enum AddOption {
        case task, meeting, note
    }

    var body: some View {
        ZStack {
            Color(hex: "#1C1C1E")
                .ignoresSafeArea()

            VStack(spacing: 32) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: ScreenSize.largeIconSize))
                    .foregroundColor(Color(hex: "#7FE8A8"))
                    .rotationEffect(.degrees(isRotating ? 90 : 0))
                    .animation(
                        .spring(response: 0.6, dampingFraction: 0.6).repeatForever(
                            autoreverses: true),
                        value: isRotating)

                Text("Create New")
                    .font(.system(size: ScreenSize.titleFontSize, weight: .bold))
                    .foregroundColor(.white)

                Text("What would you like to create?")
                    .font(.system(size: ScreenSize.bodyFontSize))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)

                VStack(spacing: 12) {
                    AddOptionButton(
                        icon: "checklist",
                        title: "New Task",
                        isSelected: selectedOption == .task
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedOption = .task
                        }
                        HapticManager.shared.impact(.medium)
                        print("New task selected")
                    }

                    AddOptionButton(
                        icon: "person.2.fill",
                        title: "New Meeting",
                        isSelected: selectedOption == .meeting
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedOption = .meeting
                        }
                        HapticManager.shared.impact(.medium)
                        print("New meeting selected")
                    }

                    AddOptionButton(
                        icon: "note.text",
                        title: "New Note",
                        isSelected: selectedOption == .note
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedOption = .note
                        }
                        HapticManager.shared.impact(.medium)
                        print("New note selected")
                    }
                }
                .padding(.horizontal, 40)
            }
        }
        .onAppear {
            isRotating = true
        }
    }
}

struct DocumentTabView: View {
    @State private var isAnimating = false
    @State private var isPressed = false

    var body: some View {
        ZStack {
            Color(hex: "#1C1C1E")
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Image(systemName: "doc.fill")
                    .font(.system(size: ScreenSize.largeIconSize))
                    .foregroundColor(Color(hex: "#7FE8A8"))
                    .offset(y: isAnimating ? -5 : 5)
                    .animation(
                        .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                        value: isAnimating)

                Text("Documents")
                    .font(.system(size: ScreenSize.titleFontSize, weight: .bold))
                    .foregroundColor(.white)

                Text("Access your important files")
                    .font(.system(size: ScreenSize.bodyFontSize))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Button(action: {
                    HapticManager.shared.impact(.medium)
                    print("Browse documents tapped")
                }) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("Browse Documents")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.black)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color(hex: "#7FE8A8"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
                .buttonStyle(PlainButtonStyle())
                .onLongPressGesture(
                    minimumDuration: 0.5,
                    pressing: { pressing in
                        withAnimation {
                            isPressed = pressing
                        }
                    }, perform: {})
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct ProfileTabView: View {
    @State private var isPulsing = false
    @State private var isPressed = false

    var body: some View {
        ZStack {
            Color(hex: "#1C1C1E")
                .ignoresSafeArea()

            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "#7FE8A8").opacity(0.2))
                        .frame(width: 100, height: 100)
                        .scaleEffect(isPulsing ? 1.2 : 1.0)
                        .opacity(isPulsing ? 0 : 1)
                        .animation(
                            .easeOut(duration: 1.5).repeatForever(autoreverses: false),
                            value: isPulsing)

                    Image(systemName: "person.fill")
                        .font(.system(size: 50))
                        .foregroundColor(Color(hex: "#7FE8A8"))
                }

                Text("Profile")
                    .font(.system(size: ScreenSize.titleFontSize, weight: .bold))
                    .foregroundColor(.white)

                Text("Manage your account settings")
                    .font(.system(size: ScreenSize.bodyFontSize))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                VStack(spacing: 12) {
                    ProfileOptionButton(icon: "person.circle", title: "Edit Profile")
                    ProfileOptionButton(icon: "gear", title: "Settings")
                    ProfileOptionButton(icon: "bell.badge", title: "Notifications")
                }
                .padding(.horizontal, 40)
            }
        }
        .onAppear {
            isPulsing = true
        }
    }
}

// MARK: - Header View (Same)

struct HeaderView: View {
    @State private var isMenuPressed = false
    @State private var isNotificationPressed = false

    var body: some View {
        HStack {
            Button(action: {
                print("Menu tapped")
            }) {
                Image(systemName: "line.3.horizontal")
                    .foregroundColor(.white)
                    .font(.system(size: ScreenSize.iconSize))
                    .frame(width: ScreenSize.minButtonHeight, height: ScreenSize.minButtonHeight)
                    .background(isMenuPressed ? Color.white.opacity(0.2) : Color.white.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .scaleEffect(isMenuPressed ? 0.95 : 1.0)
            .onLongPressGesture(
                minimumDuration: 0.1,
                pressing: { pressing in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isMenuPressed = pressing
                    }
                }, perform: {})

            Spacer()

            VStack(spacing: 2) {
                Text("August 25")
                    .font(.system(size: ScreenSize.titleFontSize, weight: .semibold))
                    .foregroundColor(.white)
                Text("Wednesday")
                    .font(.system(size: ScreenSize.captionFontSize))
                    .foregroundColor(.gray)
            }

            Spacer()

            Button(action: {
                print("Notifications tapped")
            }) {
                Image(systemName: "bell.badge")
                    .foregroundColor(.white)
                    .font(.system(size: ScreenSize.iconSize))
                    .frame(width: ScreenSize.minButtonHeight, height: ScreenSize.minButtonHeight)
                    .background(
                        isNotificationPressed ? Color.white.opacity(0.2) : Color.white.opacity(0.1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .scaleEffect(isNotificationPressed ? 0.95 : 1.0)
            .onLongPressGesture(
                minimumDuration: 0.1,
                pressing: { pressing in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isNotificationPressed = pressing
                    }
                }, perform: {})
        }
        .padding(.horizontal, ScreenSize.horizontalPadding)
        .padding(.vertical, 10)
    }
}

// MARK: - Productivity Card (Same)

struct ProductivityCard: View {
    let isSelected: Bool
    let onTap: () -> Void
    @State private var isPressed = false

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                Text("7 tasks to complete today")
                    .font(.system(size: ScreenSize.titleFontSize, weight: .bold))
                    .foregroundColor(.black)
                    .minimumScaleFactor(0.8)
                    .lineLimit(2)
                    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)

                Text("Your productivity for the day is shown here")
                    .font(.system(size: ScreenSize.smallFontSize))
                    .foregroundColor(.black.opacity(0.6))
                    .minimumScaleFactor(0.9)
                    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)

                HStack {
                    Text("Complete")
                        .font(.system(size: ScreenSize.smallFontSize, weight: .medium))
                        .foregroundColor(.black)
                        .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.white.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                    Spacer()

                    Text("4/7")
                        .font(
                            .system(
                                size: min(ScreenSize.largeTitleSize + 4, ScreenSize.width * 0.08),
                                weight: .bold)
                        )
                        .foregroundColor(.black.opacity(0.2))
                }
            }
            .padding(ScreenSize.horizontalPadding)
            .background(
                LinearGradient(
                    colors: [Color(hex: "#7FE8A8"), Color(hex: "#9FEDB8")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color.white : Color.clear, lineWidth: 2)
            )
            .shadow(
                color: isSelected ? Color(hex: "#7FE8A8").opacity(0.3) : .clear, radius: 8, x: 0,
                y: 4)
        }
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(
            minimumDuration: 0.5,
            pressing: { pressing in
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = pressing
                }
            }, perform: {})
    }
}

// MARK: - Today Tasks Section (Same)

struct TodayTasksSection: View {
    let tasks: [Task]
    let meeting: Meeting
    @Binding var selectedTask: Task?
    @Binding var selectedMeeting: Meeting?
    let onTaskTap: (Task) -> Void
    let onMeetingTap: (Meeting) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: ScreenSize.verticalSpacing) {
            HStack {
                Text("Today Tasks")
                    .font(.system(size: ScreenSize.titleFontSize, weight: .bold))
                    .foregroundColor(.white)
                    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)

                Spacer()

                Text("\(tasks.count) tasks")
                    .font(.system(size: ScreenSize.smallFontSize))
                    .foregroundColor(.gray)
                    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(tasks) { task in
                        TodayTaskCard(
                            task: task,
                            isSelected: selectedTask?.id == task.id,
                            onTap: { onTaskTap(task) }
                        )
                    }

                    TeamMeetingCard(
                        meeting: meeting,
                        isSelected: selectedMeeting?.id == meeting.id,
                        onTap: { onMeetingTap(meeting) }
                    )

                    AddMoreCard()
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 1)
            }
        }
    }
}

// MARK: - Today Task Card (Same)

struct TodayTaskCard: View {
    let task: Task
    let isSelected: Bool
    let onTap: () -> Void
    @State private var isPressed = false

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                Text(task.title)
                    .font(.system(size: ScreenSize.bodyFontSize, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)

                Text(task.description)
                    .font(.system(size: ScreenSize.smallFontSize))
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)

                Spacer()

                HStack {
                    Image(systemName: "calendar")
                        .font(.system(size: ScreenSize.captionFontSize))
                        .foregroundColor(.gray)
                    Text("Aug 25")
                        .font(.system(size: ScreenSize.captionFontSize))
                        .foregroundColor(.gray)
                        .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                }
            }
            .frame(width: ScreenSize.cardWidth, height: ScreenSize.cardHeight)
            .padding(16)
            .background(isSelected ? Color(hex: "#3C3C3E") : Color(hex: "#2C2C2E"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color(hex: "#7FE8A8") : Color.clear, lineWidth: 2)
            )
            .shadow(
                color: isSelected ? Color(hex: "#7FE8A8").opacity(0.2) : .clear, radius: 8, x: 0,
                y: 4
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
        .onLongPressGesture(
            minimumDuration: 0.5,
            pressing: { pressing in
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = pressing
                }
            }, perform: {})
    }
}

// MARK: - Team Meeting Card (Same)

struct TeamMeetingCard: View {
    let meeting: Meeting
    let isSelected: Bool
    let onTap: () -> Void
    @State private var isPressed = false
    @State private var selectedMemberIndex: Int?

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                Text(meeting.title)
                    .font(.system(size: ScreenSize.bodyFontSize, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)

                Text(meeting.description)
                    .font(.system(size: ScreenSize.smallFontSize))
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)

                HStack(spacing: -8) {
                    ForEach(Array(meeting.participants.prefix(4).enumerated()), id: \.offset) {
                        index, participant in
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 28, height: 28)
                            .overlay(
                                Text(String(participant.name.prefix(1)))
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                            )
                            .overlay(
                                Circle()
                                    .stroke(
                                        selectedMemberIndex == index
                                            ? Color(hex: "#7FE8A8") : Color(hex: "#2C2C2E"),
                                        lineWidth: 2
                                    )
                            )
                            .scaleEffect(selectedMemberIndex == index ? 1.1 : 1.0)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedMemberIndex = index
                                }
                            }
                    }
                }

                Spacer()

                Text("Today \(meeting.time)")
                    .font(.system(size: ScreenSize.captionFontSize))
                    .foregroundColor(.gray)
                    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
            }
            .frame(width: ScreenSize.cardWidth, height: ScreenSize.cardHeight)
            .padding(16)
            .background(isSelected ? Color(hex: "#3C3C3E") : Color(hex: "#2C2C2E"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color(hex: "#7FE8A8") : Color.clear, lineWidth: 2)
            )
            .shadow(
                color: isSelected ? Color(hex: "#7FE8A8").opacity(0.2) : .clear, radius: 8, x: 0,
                y: 4
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
        .onLongPressGesture(
            minimumDuration: 0.5,
            pressing: { pressing in
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = pressing
                }
            }, perform: {})
    }
}

// MARK: - Add More Card (Same)

struct AddMoreCard: View {
    @State private var isPressed = false

    var body: some View {
        Button(action: {
            print("Add more tasks")
        }) {
            VStack(alignment: .center, spacing: 12) {
                Spacer()

                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(Color(hex: "#7FE8A8"))

                Text("Add Task")
                    .font(.system(size: ScreenSize.bodyFontSize, weight: .semibold))
                    .foregroundColor(.white)
                    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)

                Spacer()
            }
            .frame(width: ScreenSize.cardWidth, height: ScreenSize.cardHeight)
            .padding(16)
            .background(Color(hex: "#2C2C2E"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(hex: "#7FE8A8").opacity(0.3), lineWidth: 2)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(hex: "#7FE8A8").opacity(0.05))
                    )
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onLongPressGesture(
            minimumDuration: 0.5,
            pressing: { pressing in
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = pressing
                }
            }, perform: {})
    }
}

// MARK: - All Tasks Section (UPDATED - iPad Grid Layout)

struct AllTasksSection: View {
    @Binding var selectedFilter: Task.TaskStatus?
    let tasks: [Task]
    @Binding var selectedTask: Task?
    let onTaskTap: (Task) -> Void
    @State private var tasksToDelete: Set<UUID> = []

    var filteredTasks: [Task] {
        let statusFiltered: [Task]
        if let filter = selectedFilter {
            statusFiltered = tasks.filter { $0.status == filter }
        } else {
            statusFiltered = tasks
        }
        // Filter out tasks marked for deletion
        return statusFiltered.filter { !tasksToDelete.contains($0.id) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: ScreenSize.verticalSpacing) {
            HStack {
                Text("All Tasks")
                    .font(.system(size: ScreenSize.titleFontSize, weight: .bold))
                    .foregroundColor(.white)
                    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)

                Spacer()

                HStack(spacing: 4) {
                    Text("\(filteredTasks.count)")
                        .font(.system(size: ScreenSize.smallFontSize, weight: .semibold))
                        .foregroundColor(Color(hex: "#7FE8A8"))
                        .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    FilterChip(
                        title: "All",
                        isSelected: selectedFilter == nil,
                        color: Color(hex: "#7FE8A8")
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedFilter = nil
                        }
                    }

                    ForEach(Task.TaskStatus.allCases, id: \.self) { status in
                        FilterChip(
                            title: status.rawValue,
                            isSelected: selectedFilter == status,
                            color: status.color
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedFilter = status
                            }
                        }
                    }
                }
                .padding(.vertical, 4)
            }

            // Native List with swipe actions
            List {
                ForEach(filteredTasks) { task in
                    TaskCard(
                        task: task,
                        isSelected: selectedTask?.id == task.id,
                        onTaskTap: { onTaskTap(task) }
                    )
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: ScreenSize.cardSpacing / 2, leading: 0, bottom: ScreenSize.cardSpacing / 2, trailing: 0))
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button {
                            HapticManager.shared.impact(.medium)
                            print("Mark as completed: \(task.title)")
                        } label: {
                            Label("Complete", systemImage: "checkmark.circle.fill")
                        }
                        .tint(Color(hex: "#7FE8A8"))
                        
                        Button {
                            HapticManager.shared.impact(.light)
                            print("Mark as in progress: \(task.title)")
                        } label: {
                            Label("Progress", systemImage: "arrow.clockwise.circle.fill")
                        }
                        .tint(.blue)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            HapticManager.shared.impact(.heavy)
                            _ = withAnimation {
                                tasksToDelete.insert(task.id)
                            }
                            print("Delete task: \(task.title)")
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                        
                        Button {
                            HapticManager.shared.impact(.light)
                            print("Edit task: \(task.title)")
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.orange)
                    }
                }
            }
            .listStyle(.plain)
            .modifier(ScrollContentBackgroundModifier())
            .frame(height: CGFloat(filteredTasks.count) * (ScreenSize.cardHeight + ScreenSize.cardSpacing))
        }
    }
}

// MARK: - Scroll Content Background Modifier

struct ScrollContentBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.scrollContentBackground(.hidden)
        } else {
            content
        }
    }
}

// MARK: - Filter Chip (UPDATED - With color)

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)

                Text(title)
                    .font(.system(size: ScreenSize.smallFontSize, weight: .medium))
                    .foregroundColor(isSelected ? .white : .gray)
                    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? color.opacity(0.2) : Color.white.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? color : Color.clear, lineWidth: 1.5)
            )
        }
        .scaleEffect(isPressed ? 0.93 : 1.0)
        .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isPressed)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(
            minimumDuration: 0.5,
            pressing: { pressing in
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = pressing
                }
            }, perform: {})
    }
}

// MARK: - Task Card (UPDATED - Show status instead of assigned to)

struct TaskCard: View {
    let task: Task
    let isSelected: Bool
    let onTaskTap: () -> Void
    @State private var isPressed = false

    var body: some View {
        Button(action: onTaskTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(task.title)
                        .font(.system(size: ScreenSize.bodyFontSize, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .dynamicTypeSize(...DynamicTypeSize.xxxLarge)

                    Spacer()

                    Text(task.priority.rawValue)
                        .font(.system(size: ScreenSize.captionFontSize, weight: .medium))
                        .foregroundColor(.white)
                        .dynamicTypeSize(...DynamicTypeSize.large)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(task.priority == .high ? Color(hex: "#FF6B6B") : Color.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Text(task.description)
                    .font(.system(size: ScreenSize.smallFontSize))
                    .foregroundColor(.gray)
                    .lineLimit(2)

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Due date")
                            .font(.system(size: ScreenSize.captionFontSize))
                            .foregroundColor(.gray)

                        HStack(spacing: 6) {
                            Image(systemName: "calendar")
                                .font(.system(size: ScreenSize.captionFontSize))
                                .foregroundColor(.white)
                            Text("Aug 25")
                                .font(.system(size: ScreenSize.smallFontSize, weight: .medium))
                                .foregroundColor(.white)
                                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                        }
                    }

                    Spacer()

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Status")
                            .font(.system(size: ScreenSize.captionFontSize))
                            .foregroundColor(.gray)

                        HStack(spacing: 6) {
                            Image(systemName: task.status.icon)
                                .font(.system(size: ScreenSize.captionFontSize))
                                .foregroundColor(task.status.color)
                            Text(task.status.rawValue)
                                .font(.system(size: ScreenSize.smallFontSize, weight: .medium))
                                .foregroundColor(task.status.color)
                                .lineLimit(1)
                                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                        }
                    }
                }
            }
            .padding(16)
            .background(isSelected ? Color(hex: "#3C3C3E") : Color(hex: "#2C2C2E"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color(hex: "#7FE8A8") : Color.clear, lineWidth: 2)
            )
            .shadow(
                color: isSelected ? Color(hex: "#7FE8A8").opacity(0.2) : .clear, radius: 8, x: 0,
                y: 4)
        }
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(
            minimumDuration: 0.5,
            pressing: { pressing in
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = pressing
                }
            }, perform: {})
    }
}

// MARK: - Tab Item Enum

enum TabItem: String, CaseIterable {
    case home = "house.fill"
    case folder = "folder.fill"
    case add = "plus"
    case document = "doc.fill"
    case profile = "person.fill"
}

// MARK: - Interactive Button Components

struct AddOptionButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: ScreenSize.iconSize))
                Text(title)
                    .font(.system(size: ScreenSize.bodyFontSize, weight: .semibold))
                    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(hex: "#7FE8A8"))
                }
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                isSelected
                    ? Color(hex: "#7FE8A8").opacity(0.2)
                    : Color(hex: "#2C2C2E")
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color(hex: "#7FE8A8") : Color.clear, lineWidth: 2)
            )
        }
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(
            minimumDuration: 0.5,
            pressing: { pressing in
                withAnimation {
                    isPressed = pressing
                }
            }, perform: {})
    }
}

struct ProfileOptionButton: View {
    let icon: String
    let title: String
    @State private var isPressed = false

    var body: some View {
        Button(action: {
            HapticManager.shared.impact(.medium)
            print("\(title) tapped")
        }) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: ScreenSize.iconSize))
                    .foregroundColor(Color(hex: "#7FE8A8"))
                    .frame(width: 30)
                Text(title)
                    .font(.system(size: ScreenSize.bodyFontSize, weight: .medium))
                    .foregroundColor(.white)
                    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: ScreenSize.smallFontSize))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color(hex: "#2C2C2E"))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(
            minimumDuration: 0.5,
            pressing: { pressing in
                withAnimation {
                    isPressed = pressing
                }
            }, perform: {})
    }
}

// MARK: - Task Detail View (UPDATED - Status selector)

struct TaskDetailView: View {
    let task: Task
    @Binding var isPresented: Bool
    @State private var selectedStatus: Task.TaskStatus
    @Environment(\.presentationMode) var presentationMode

    init(task: Task, isPresented: Binding<Bool>) {
        self.task = task
        self._isPresented = isPresented
        self._selectedStatus = State(initialValue: task.status)
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#1C1C1E")
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        Text(task.title)
                            .font(.system(size: ScreenSize.largeTitleSize, weight: .bold))
                            .foregroundColor(.white)
                            .dynamicTypeSize(...DynamicTypeSize.xxxLarge)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.system(size: ScreenSize.smallFontSize, weight: .semibold))
                                .foregroundColor(.gray)

                            Text(task.description)
                                .font(.system(size: ScreenSize.bodyFontSize))
                                .foregroundColor(.white)
                                .lineSpacing(4)
                                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(hex: "#2C2C2E"))
                        .cornerRadius(12)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Priority")
                                .font(.system(size: ScreenSize.smallFontSize, weight: .semibold))
                                .foregroundColor(.gray)

                            HStack {
                                Text(task.priority.rawValue)
                                    .font(.system(size: ScreenSize.bodyFontSize, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        task.priority == .high
                                            ? Color(hex: "#FF6B6B") : Color.orange
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 10))

                                Spacer()
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(hex: "#2C2C2E"))
                        .cornerRadius(12)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Due Date")
                                .font(.system(size: ScreenSize.smallFontSize, weight: .semibold))
                                .foregroundColor(.gray)

                            HStack(spacing: 8) {
                                Image(systemName: "calendar")
                                    .font(.system(size: ScreenSize.bodyFontSize))
                                    .foregroundColor(Color(hex: "#7FE8A8"))

                                Text("August 25, 2025")
                                    .font(.system(size: ScreenSize.bodyFontSize))
                                    .foregroundColor(.white)

                                Spacer()
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(hex: "#2C2C2E"))
                        .cornerRadius(12)

                        // Status Selector
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Status")
                                .font(.system(size: ScreenSize.smallFontSize, weight: .semibold))
                                .foregroundColor(.gray)

                            VStack(spacing: 12) {
                                ForEach(Task.TaskStatus.allCases, id: \.self) { status in
                                    StatusOptionButton(
                                        status: status,
                                        isSelected: selectedStatus == status
                                    ) {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7))
                                        {
                                            selectedStatus = status
                                            HapticManager.shared.impact(.light)
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(hex: "#2C2C2E"))
                        .cornerRadius(12)

                        // Action Buttons
                        VStack(spacing: 12) {
                            Button(action: {
                                print("Save changes - Status: \(selectedStatus.rawValue)")
                            }) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: ScreenSize.iconSize))
                                    Text("Save Changes")
                                        .font(
                                            .system(
                                                size: ScreenSize.bodyFontSize, weight: .semibold))
                                }
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "#7FE8A8"))
                                .cornerRadius(12)
                            }

                            Button(action: {
                                print("Edit task")
                            }) {
                                HStack {
                                    Image(systemName: "pencil.circle.fill")
                                        .font(.system(size: ScreenSize.iconSize))
                                    Text("Edit Task")
                                        .font(
                                            .system(
                                                size: ScreenSize.bodyFontSize, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "#2C2C2E"))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.top, 8)
                    }
                    .padding(20)
                    .padding(.bottom, 40)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: {
                    isPresented = false
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(Color(hex: "#7FE8A8"))
                },
                trailing: Button(action: {
                    print("More options")
                }) {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(Color(hex: "#7FE8A8"))
                        .font(.system(size: 20))
                }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - Status Option Button (NEW)

struct StatusOptionButton: View {
    let status: Task.TaskStatus
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: status.icon)
                    .font(.system(size: ScreenSize.iconSize))
                    .foregroundColor(isSelected ? status.color : .gray)
                    .frame(width: 30)

                Text(status.rawValue)
                    .font(
                        .system(
                            size: ScreenSize.bodyFontSize, weight: isSelected ? .semibold : .regular
                        )
                    )
                    .foregroundColor(isSelected ? .white : .gray)
                    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: ScreenSize.iconSize))
                        .foregroundColor(status.color)
                }
            }
            .padding()
            .background(isSelected ? status.color.opacity(0.15) : Color.clear)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        isSelected ? status.color : Color.gray.opacity(0.2),
                        lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Meeting Detail View (Same)

struct MeetingDetailView: View {
    let meeting: Meeting
    @Binding var isPresented: Bool
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#1C1C1E")
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        Text(meeting.title)
                            .font(.system(size: ScreenSize.largeTitleSize, weight: .bold))
                            .foregroundColor(.white)
                            .dynamicTypeSize(...DynamicTypeSize.xxxLarge)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.system(size: ScreenSize.smallFontSize, weight: .semibold))
                                .foregroundColor(.gray)

                            Text(meeting.description)
                                .font(.system(size: ScreenSize.bodyFontSize))
                                .foregroundColor(.white)
                                .lineSpacing(4)
                                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(hex: "#2C2C2E"))
                        .cornerRadius(12)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Time")
                                .font(.system(size: ScreenSize.smallFontSize, weight: .semibold))
                                .foregroundColor(.gray)

                            HStack(spacing: 8) {
                                Image(systemName: "clock.fill")
                                    .font(.system(size: ScreenSize.bodyFontSize))
                                    .foregroundColor(Color(hex: "#7FE8A8"))

                                Text("Today, \(meeting.time)")
                                    .font(.system(size: ScreenSize.bodyFontSize))
                                    .foregroundColor(.white)

                                Spacer()
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(hex: "#2C2C2E"))
                        .cornerRadius(12)

                        if let location = meeting.location {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Location")
                                    .font(
                                        .system(size: ScreenSize.smallFontSize, weight: .semibold)
                                    )
                                    .foregroundColor(.gray)

                                HStack(spacing: 8) {
                                    Image(systemName: "location.fill")
                                        .font(.system(size: ScreenSize.bodyFontSize))
                                        .foregroundColor(Color(hex: "#7FE8A8"))

                                    Text(location)
                                        .font(.system(size: ScreenSize.bodyFontSize))
                                        .foregroundColor(.white)

                                    Spacer()
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(hex: "#2C2C2E"))
                            .cornerRadius(12)
                        }

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Participants (\(meeting.participants.count))")
                                .font(.system(size: ScreenSize.smallFontSize, weight: .semibold))
                                .foregroundColor(.gray)

                            VStack(spacing: 12) {
                                ForEach(meeting.participants) { participant in
                                    HStack(spacing: 12) {
                                        Circle()
                                            .fill(Color.orange)
                                            .frame(width: 40, height: 40)
                                            .overlay(
                                                Text(String(participant.name.prefix(1)))
                                                    .font(
                                                        .system(
                                                            size: ScreenSize.titleFontSize,
                                                            weight: .semibold)
                                                    )
                                                    .foregroundColor(.white)
                                            )

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(participant.name)
                                                .font(
                                                    .system(
                                                        size: ScreenSize.bodyFontSize,
                                                        weight: .medium)
                                                )
                                                .foregroundColor(.white)

                                            Text("Team Member")
                                                .font(.system(size: ScreenSize.smallFontSize))
                                                .foregroundColor(.gray)
                                        }

                                        Spacer()

                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.system(size: ScreenSize.iconSize))
                                            .foregroundColor(Color(hex: "#7FE8A8"))
                                    }
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(hex: "#2C2C2E"))
                        .cornerRadius(12)

                        VStack(spacing: 12) {
                            Button(action: {
                                print("Join meeting")
                            }) {
                                HStack {
                                    Image(systemName: "video.fill")
                                        .font(.system(size: ScreenSize.iconSize))
                                    Text("Join Meeting")
                                        .font(
                                            .system(
                                                size: ScreenSize.bodyFontSize, weight: .semibold))
                                }
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "#7FE8A8"))
                                .cornerRadius(12)
                            }

                            Button(action: {
                                print("Add to calendar")
                            }) {
                                HStack {
                                    Image(systemName: "calendar.badge.plus")
                                        .font(.system(size: ScreenSize.iconSize))
                                    Text("Add to Calendar")
                                        .font(
                                            .system(
                                                size: ScreenSize.bodyFontSize, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "#2C2C2E"))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.top, 8)
                    }
                    .padding(20)
                    .padding(.bottom, 40)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: {
                    isPresented = false
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(Color(hex: "#7FE8A8"))
                },
                trailing: Button(action: {
                    print("More options")
                }) {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(Color(hex: "#7FE8A8"))
                        .font(.system(size: 20))
                }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - Scroll Offset Preference Key

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a: UInt64
        let r: UInt64
        let g: UInt64
        let b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255,
            opacity: Double(a) / 255)
    }
}

// MARK: - Preview

struct TaskManagementView_Previews: PreviewProvider {
    static var previews: some View {
        TaskManagementView()
    }
}
