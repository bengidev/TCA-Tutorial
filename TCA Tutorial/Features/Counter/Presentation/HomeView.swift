import SwiftUI
import UIKit

// MARK: - DeviceType

enum DeviceType {
    case iPhoneMini // < 375pt width (iPhone SE, mini)
    case iPhoneStandard // 375-390pt (iPhone 12/13/14/15 standard)
    case iPhonePlus // 390-430pt (Pro Max, Plus models)
    case iPad // >= 768pt (iPad, iPad Pro)

    // MARK: Static Computed Properties

    static var current: DeviceType {
        let width = UIScreen.main.bounds.width
        switch width {
        case ..<375: return .iPhoneMini
        case 375 ..< 390: return .iPhoneStandard
        case 390 ..< 768: return .iPhonePlus
        default: return .iPad
        }
    }

    // MARK: Computed Properties

    var isIPad: Bool {
        self == .iPad
    }
}

// MARK: - ScreenSize

enum ScreenSize {
    // MARK: Static Properties

    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
    static let deviceType = DeviceType.current

    // MARK: Static Computed Properties

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
        44 // Apple HIG minimum tap target
    }
}

// MARK: - HapticManager

class HapticManager {
    // MARK: Static Properties

    static let shared = HapticManager()

    // MARK: Properties

    private let lightImpact = UIImpactFeedbackGenerator(style: .light)
    private let mediumImpact = UIImpactFeedbackGenerator(style: .medium)
    private let heavyImpact = UIImpactFeedbackGenerator(style: .heavy)

    // MARK: Lifecycle

    private init() {
        self.lightImpact.prepare()
        self.mediumImpact.prepare()
        self.heavyImpact.prepare()
    }

    // MARK: Functions

    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        switch style {
        case .light:
            self.lightImpact.impactOccurred()
            self.lightImpact.prepare()

        case .medium:
            self.mediumImpact.impactOccurred()
            self.mediumImpact.prepare()

        case .heavy:
            self.heavyImpact.impactOccurred()
            self.heavyImpact.prepare()

        case .soft:
            self.lightImpact.impactOccurred()
            self.lightImpact.prepare()

        case .rigid:
            self.heavyImpact.impactOccurred()
            self.heavyImpact.prepare()

        @unknown default:
            self.mediumImpact.impactOccurred()
            self.mediumImpact.prepare()
        }
    }
}

// MARK: - Task

struct Task: Identifiable, Equatable {
    // MARK: Nested Types

    enum Priority: String {
        case high = "High priority"
        case medium = "Medium"
        case low = "Low"
    }

    enum TaskStatus: String, CaseIterable {
        case notStarted = "Not Started"
        case inProgress = "In Progress"
        case completed = "Completed"

        // MARK: Computed Properties

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

    // MARK: Properties

    let id = UUID()
    let title: String
    let description: String
    let dueDate: Date
    let priority: Priority
    var status: TaskStatus // Changed to var for updates
    let meetingTime: String?
    let teamMembers: [User]?

    // MARK: Static Functions

    static func == (lhs: Task, rhs: Task) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - User

struct User: Identifiable, Equatable {
    // MARK: Properties

    let id = UUID()
    let name: String
    let avatar: String

    // MARK: Static Functions

    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Meeting

struct Meeting: Identifiable, Equatable {
    // MARK: Properties

    let id = UUID()
    let title: String
    let description: String
    let time: String
    let date: Date
    let participants: [User]
    let location: String?

    // MARK: Static Functions

    static func == (lhs: Meeting, rhs: Meeting) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - TaskManagementView

struct TaskManagementView: View {
    // MARK: SwiftUI Properties

    @State private var selectedTab: TabItem = .home
    @State private var isTabBarVisible: Bool = true

    // MARK: Content Properties

    var body: some View {
        TabView(selection: self.$selectedTab) {
            HomeTabView(isTabBarVisible: self.$isTabBarVisible)
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
            self.updateTabBarVisibility(self.isTabBarVisible)
        }
        .onChange(of: self.isTabBarVisible) { newValue in
            self.updateTabBarVisibility(newValue)
        }
        .onChange(of: self.selectedTab) { _ in
            HapticManager.shared.impact(.light)
        }
    }

    // MARK: Functions

    private func updateTabBarVisibility(_ isVisible: Bool) {
        UITabBar.appearance().isHidden = !isVisible
    }
}

// MARK: - HomeTabView

struct HomeTabView: View {
    // MARK: SwiftUI Properties

    @Binding var isTabBarVisible: Bool

    @State private var selectedFilter: Task.TaskStatus? = nil // nil = All tasks
    @State private var selectedTask: Task?
    @State private var showingTaskDetail = false
    @State private var selectedMeeting: Meeting?
    @State private var showingMeetingDetail = false
    @State private var lastScrollOffset: CGFloat = 0
    @State private var scrollOffset: CGFloat = 0

    // MARK: Properties

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

    // MARK: Content Properties

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
                                isSelected: self.selectedTask == nil && self.selectedMeeting == nil
                            ) {
                                self.selectedTask = nil
                                self.selectedMeeting = nil
                                print("Productivity card tapped")
                            }

                            TodayTasksSection(
                                tasks: self.todayTasks,
                                meeting: self.sampleMeeting,
                                selectedTask: self.$selectedTask,
                                selectedMeeting: self.$selectedMeeting,
                                onTaskTap: { task in
                                    HapticManager.shared.impact(.medium)

                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        self.selectedTask = task
                                        self.selectedMeeting = nil
                                    }

                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                        self.showingTaskDetail = true
                                    }
                                },
                                onMeetingTap: { meeting in
                                    HapticManager.shared.impact(.medium)

                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        self.selectedMeeting = meeting
                                        self.selectedTask = nil
                                    }

                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                        self.showingMeetingDetail = true
                                    }
                                }
                            )

                            AllTasksSection(
                                selectedFilter: self.$selectedFilter,
                                tasks: self.allTasks,
                                selectedTask: self.$selectedTask,
                                onTaskTap: { task in
                                    HapticManager.shared.impact(.medium)

                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        self.selectedTask = task
                                    }

                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                        self.showingTaskDetail = true
                                    }
                                }
                            )
                        }
                        .padding(.horizontal, ScreenSize.horizontalPadding)
                        .padding(.bottom, ScreenSize.verticalSpacing)
                    }
                    .coordinateSpace(name: "scroll")
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        let delta = value - self.lastScrollOffset
                        self.lastScrollOffset = value

                        // Hide tab bar when scrolling down (delta < 0)
                        // Show tab bar when scrolling up (delta > 0) or at top (value >= 0)
                        if value >= -10 {
                            // Near the top, always show tab bar
                            withAnimation(.easeInOut(duration: 0.25)) {
                                self.isTabBarVisible = true
                            }
                        } else if delta < -5 {
                            // Scrolling down significantly
                            withAnimation(.easeInOut(duration: 0.25)) {
                                self.isTabBarVisible = false
                            }
                        } else if delta > 5 {
                            // Scrolling up significantly
                            withAnimation(.easeInOut(duration: 0.25)) {
                                self.isTabBarVisible = true
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: self.$showingTaskDetail) {
                if let task = selectedTask {
                    TaskDetailView(task: task, isPresented: self.$showingTaskDetail)
                }
            }
            .sheet(isPresented: self.$showingMeetingDetail) {
                if let meeting = selectedMeeting {
                    MeetingDetailView(meeting: meeting, isPresented: self.$showingMeetingDetail)
                }
            }
        }
    }
}

// MARK: - FolderTabView

struct FolderTabView: View {
    // MARK: SwiftUI Properties

    @State private var isAnimating = false
    @State private var isPressed = false

    // MARK: Content Properties

    var body: some View {
        ZStack {
            Color(hex: "#1C1C1E")
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Image(systemName: "folder.fill")
                    .font(.system(size: ScreenSize.largeIconSize))
                    .foregroundColor(Color(hex: "#7FE8A8"))
                    .scaleEffect(self.isAnimating ? 1.1 : 1.0)
                    .animation(
                        .easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                        value: self.isAnimating
                    )

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
                .scaleEffect(self.isPressed ? 0.95 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: self.isPressed)
                .buttonStyle(PlainButtonStyle())
                .onLongPressGesture(
                    minimumDuration: 0.5,
                    pressing: { pressing in
                        withAnimation {
                            self.isPressed = pressing
                        }
                    }, perform: {}
                )
            }
        }
        .onAppear {
            self.isAnimating = true
        }
    }
}

// MARK: - AddTabView

struct AddTabView: View {
    // MARK: Nested Types

    enum AddOption {
        case task
        case meeting
        case note
    }

    // MARK: SwiftUI Properties

    @State private var isRotating = false
    @State private var selectedOption: AddOption? = nil

    // MARK: Content Properties

    var body: some View {
        ZStack {
            Color(hex: "#1C1C1E")
                .ignoresSafeArea()

            VStack(spacing: 32) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: ScreenSize.largeIconSize))
                    .foregroundColor(Color(hex: "#7FE8A8"))
                    .rotationEffect(.degrees(self.isRotating ? 90 : 0))
                    .animation(
                        .spring(response: 0.6, dampingFraction: 0.6).repeatForever(
                            autoreverses: true),
                        value: self.isRotating
                    )

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
                        isSelected: self.selectedOption == .task
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            self.selectedOption = .task
                        }
                        HapticManager.shared.impact(.medium)
                        print("New task selected")
                    }

                    AddOptionButton(
                        icon: "person.2.fill",
                        title: "New Meeting",
                        isSelected: self.selectedOption == .meeting
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            self.selectedOption = .meeting
                        }
                        HapticManager.shared.impact(.medium)
                        print("New meeting selected")
                    }

                    AddOptionButton(
                        icon: "note.text",
                        title: "New Note",
                        isSelected: self.selectedOption == .note
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            self.selectedOption = .note
                        }
                        HapticManager.shared.impact(.medium)
                        print("New note selected")
                    }
                }
                .padding(.horizontal, 40)
            }
        }
        .onAppear {
            self.isRotating = true
        }
    }
}

// MARK: - DocumentTabView

struct DocumentTabView: View {
    // MARK: SwiftUI Properties

    @State private var isAnimating = false
    @State private var isPressed = false

    // MARK: Content Properties

    var body: some View {
        ZStack {
            Color(hex: "#1C1C1E")
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Image(systemName: "doc.fill")
                    .font(.system(size: ScreenSize.largeIconSize))
                    .foregroundColor(Color(hex: "#7FE8A8"))
                    .offset(y: self.isAnimating ? -5 : 5)
                    .animation(
                        .easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                        value: self.isAnimating
                    )

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
                .scaleEffect(self.isPressed ? 0.95 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: self.isPressed)
                .buttonStyle(PlainButtonStyle())
                .onLongPressGesture(
                    minimumDuration: 0.5,
                    pressing: { pressing in
                        withAnimation {
                            self.isPressed = pressing
                        }
                    }, perform: {}
                )
            }
        }
        .onAppear {
            self.isAnimating = true
        }
    }
}

// MARK: - ProfileTabView

struct ProfileTabView: View {
    // MARK: SwiftUI Properties

    @State private var isPulsing = false
    @State private var isPressed = false

    // MARK: Content Properties

    var body: some View {
        ZStack {
            Color(hex: "#1C1C1E")
                .ignoresSafeArea()

            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "#7FE8A8").opacity(0.2))
                        .frame(width: 100, height: 100)
                        .scaleEffect(self.isPulsing ? 1.2 : 1.0)
                        .opacity(self.isPulsing ? 0 : 1)
                        .animation(
                            .easeOut(duration: 1.5).repeatForever(autoreverses: false),
                            value: self.isPulsing
                        )

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
            self.isPulsing = true
        }
    }
}

// MARK: - HeaderView

struct HeaderView: View {
    // MARK: SwiftUI Properties

    @State private var isMenuPressed = false
    @State private var isNotificationPressed = false

    // MARK: Content Properties

    var body: some View {
        HStack {
            Button(action: {
                print("Menu tapped")
            }) {
                Image(systemName: "line.3.horizontal")
                    .foregroundColor(.white)
                    .font(.system(size: ScreenSize.iconSize))
                    .frame(width: ScreenSize.minButtonHeight, height: ScreenSize.minButtonHeight)
                    .background(self.isMenuPressed ? Color.white.opacity(0.2) : Color.white.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .scaleEffect(self.isMenuPressed ? 0.95 : 1.0)
            .onLongPressGesture(
                minimumDuration: 0.1,
                pressing: { pressing in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        self.isMenuPressed = pressing
                    }
                }, perform: {}
            )

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
                        self.isNotificationPressed ? Color.white.opacity(0.2) : Color.white.opacity(0.1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .scaleEffect(self.isNotificationPressed ? 0.95 : 1.0)
            .onLongPressGesture(
                minimumDuration: 0.1,
                pressing: { pressing in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        self.isNotificationPressed = pressing
                    }
                }, perform: {}
            )
        }
        .padding(.horizontal, ScreenSize.horizontalPadding)
        .padding(.vertical, 10)
    }
}

// MARK: - ProductivityCard

struct ProductivityCard: View {
    let isSelected: Bool
    let onTap: () -> Void
    @State private var isPressed = false

    var body: some View {
        Button(action: self.onTap) {
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
                                weight: .bold
                            )
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
                    .stroke(self.isSelected ? Color.white : Color.clear, lineWidth: 2)
            )
            .shadow(
                color: self.isSelected ? Color(hex: "#7FE8A8").opacity(0.3) : .clear, radius: 8, x: 0,
                y: 4
            )
        }
        .scaleEffect(self.isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: self.isPressed)
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(
            minimumDuration: 0.5,
            pressing: { pressing in
                withAnimation(.easeInOut(duration: 0.1)) {
                    self.isPressed = pressing
                }
            }, perform: {}
        )
    }
}

// MARK: - TodayTasksSection

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

                Text("\(self.tasks.count) tasks")
                    .font(.system(size: ScreenSize.smallFontSize))
                    .foregroundColor(.gray)
                    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(self.tasks) { task in
                        TodayTaskCard(
                            task: task,
                            isSelected: self.selectedTask?.id == task.id,
                            onTap: { self.onTaskTap(task) }
                        )
                    }

                    TeamMeetingCard(
                        meeting: self.meeting,
                        isSelected: self.selectedMeeting?.id == self.meeting.id,
                        onTap: { self.onMeetingTap(self.meeting) }
                    )

                    AddMoreCard()
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 1)
            }
        }
    }
}

// MARK: - TodayTaskCard

struct TodayTaskCard: View {
    let task: Task
    let isSelected: Bool
    let onTap: () -> Void
    @State private var isPressed = false

    var body: some View {
        Button(action: self.onTap) {
            VStack(alignment: .leading, spacing: 12) {
                Text(self.task.title)
                    .font(.system(size: ScreenSize.bodyFontSize, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)

                Text(self.task.description)
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
            .background(self.isSelected ? Color(hex: "#3C3C3E") : Color(hex: "#2C2C2E"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(self.isSelected ? Color(hex: "#7FE8A8") : Color.clear, lineWidth: 2)
            )
            .shadow(
                color: self.isSelected ? Color(hex: "#7FE8A8").opacity(0.2) : .clear, radius: 8, x: 0,
                y: 4
            )
            .scaleEffect(self.isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: self.isPressed)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: self.isSelected)
        .onLongPressGesture(
            minimumDuration: 0.5,
            pressing: { pressing in
                withAnimation(.easeInOut(duration: 0.1)) {
                    self.isPressed = pressing
                }
            }, perform: {}
        )
    }
}

// MARK: - TeamMeetingCard

struct TeamMeetingCard: View {
    let meeting: Meeting
    let isSelected: Bool
    let onTap: () -> Void
    @State private var isPressed = false
    @State private var selectedMemberIndex: Int?

    var body: some View {
        Button(action: self.onTap) {
            VStack(alignment: .leading, spacing: 12) {
                Text(self.meeting.title)
                    .font(.system(size: ScreenSize.bodyFontSize, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)

                Text(self.meeting.description)
                    .font(.system(size: ScreenSize.smallFontSize))
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)

                HStack(spacing: -8) {
                    ForEach(Array(self.meeting.participants.prefix(4).enumerated()), id: \.offset) {
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
                                        self.selectedMemberIndex == index
                                            ? Color(hex: "#7FE8A8") : Color(hex: "#2C2C2E"),
                                        lineWidth: 2
                                    )
                            )
                            .scaleEffect(self.selectedMemberIndex == index ? 1.1 : 1.0)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    self.selectedMemberIndex = index
                                }
                            }
                    }
                }

                Spacer()

                Text("Today \(self.meeting.time)")
                    .font(.system(size: ScreenSize.captionFontSize))
                    .foregroundColor(.gray)
                    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
            }
            .frame(width: ScreenSize.cardWidth, height: ScreenSize.cardHeight)
            .padding(16)
            .background(self.isSelected ? Color(hex: "#3C3C3E") : Color(hex: "#2C2C2E"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(self.isSelected ? Color(hex: "#7FE8A8") : Color.clear, lineWidth: 2)
            )
            .shadow(
                color: self.isSelected ? Color(hex: "#7FE8A8").opacity(0.2) : .clear, radius: 8, x: 0,
                y: 4
            )
            .scaleEffect(self.isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: self.isPressed)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: self.isSelected)
        .onLongPressGesture(
            minimumDuration: 0.5,
            pressing: { pressing in
                withAnimation(.easeInOut(duration: 0.1)) {
                    self.isPressed = pressing
                }
            }, perform: {}
        )
    }
}

// MARK: - AddMoreCard

struct AddMoreCard: View {
    // MARK: SwiftUI Properties

    @State private var isPressed = false

    // MARK: Content Properties

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
            .scaleEffect(self.isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: self.isPressed)
        .onLongPressGesture(
            minimumDuration: 0.5,
            pressing: { pressing in
                withAnimation(.easeInOut(duration: 0.1)) {
                    self.isPressed = pressing
                }
            }, perform: {}
        )
    }
}

// MARK: - AllTasksSection

struct AllTasksSection: View {
    @Binding var selectedFilter: Task.TaskStatus?
    let tasks: [Task]
    @Binding var selectedTask: Task?
    let onTaskTap: (Task) -> Void
    @State private var tasksToDelete: Set<UUID> = []

    var filteredTasks: [Task] {
        let statusFiltered: [Task]
        if let filter = selectedFilter {
            statusFiltered = self.tasks.filter { $0.status == filter }
        } else {
            statusFiltered = self.tasks
        }
        // Filter out tasks marked for deletion
        return statusFiltered.filter { !self.tasksToDelete.contains($0.id) }
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
                    Text("\(self.filteredTasks.count)")
                        .font(.system(size: ScreenSize.smallFontSize, weight: .semibold))
                        .foregroundColor(Color(hex: "#7FE8A8"))
                        .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    FilterChip(
                        title: "All",
                        isSelected: self.selectedFilter == nil,
                        color: Color(hex: "#7FE8A8")
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            self.selectedFilter = nil
                        }
                    }

                    ForEach(Task.TaskStatus.allCases, id: \.self) { status in
                        FilterChip(
                            title: status.rawValue,
                            isSelected: self.selectedFilter == status,
                            color: status.color
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                self.selectedFilter = status
                            }
                        }
                    }
                }
                .padding(.vertical, 4)
            }

            // Native List with swipe actions
            List {
                ForEach(self.filteredTasks) { task in
                    TaskCard(
                        task: task,
                        isSelected: self.selectedTask?.id == task.id,
                        onTaskTap: { self.onTaskTap(task) }
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
                                self.tasksToDelete.insert(task.id)
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
            .frame(height: CGFloat(self.filteredTasks.count) * (ScreenSize.cardHeight + ScreenSize.cardSpacing))
        }
    }
}

// MARK: - ScrollContentBackgroundModifier

struct ScrollContentBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.scrollContentBackground(.hidden)
        } else {
            content
        }
    }
}

// MARK: - FilterChip

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    @State private var isPressed = false

    var body: some View {
        Button(action: self.action) {
            HStack(spacing: 6) {
                Circle()
                    .fill(self.color)
                    .frame(width: 8, height: 8)

                Text(self.title)
                    .font(.system(size: ScreenSize.smallFontSize, weight: .medium))
                    .foregroundColor(self.isSelected ? .white : .gray)
                    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(self.isSelected ? self.color.opacity(0.2) : Color.white.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(self.isSelected ? self.color : Color.clear, lineWidth: 1.5)
            )
        }
        .scaleEffect(self.isPressed ? 0.93 : 1.0)
        .animation(.spring(response: 0.2, dampingFraction: 0.6), value: self.isPressed)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: self.isSelected)
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(
            minimumDuration: 0.5,
            pressing: { pressing in
                withAnimation(.easeInOut(duration: 0.1)) {
                    self.isPressed = pressing
                }
            }, perform: {}
        )
    }
}

// MARK: - TaskCard

struct TaskCard: View {
    let task: Task
    let isSelected: Bool
    let onTaskTap: () -> Void
    @State private var isPressed = false

    var body: some View {
        Button(action: self.onTaskTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(self.task.title)
                        .font(.system(size: ScreenSize.bodyFontSize, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .dynamicTypeSize(...DynamicTypeSize.xxxLarge)

                    Spacer()

                    Text(self.task.priority.rawValue)
                        .font(.system(size: ScreenSize.captionFontSize, weight: .medium))
                        .foregroundColor(.white)
                        .dynamicTypeSize(...DynamicTypeSize.large)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(self.task.priority == .high ? Color(hex: "#FF6B6B") : Color.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Text(self.task.description)
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
                            Image(systemName: self.task.status.icon)
                                .font(.system(size: ScreenSize.captionFontSize))
                                .foregroundColor(self.task.status.color)
                            Text(self.task.status.rawValue)
                                .font(.system(size: ScreenSize.smallFontSize, weight: .medium))
                                .foregroundColor(self.task.status.color)
                                .lineLimit(1)
                                .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                        }
                    }
                }
            }
            .padding(16)
            .background(self.isSelected ? Color(hex: "#3C3C3E") : Color(hex: "#2C2C2E"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(self.isSelected ? Color(hex: "#7FE8A8") : Color.clear, lineWidth: 2)
            )
            .shadow(
                color: self.isSelected ? Color(hex: "#7FE8A8").opacity(0.2) : .clear, radius: 8, x: 0,
                y: 4
            )
        }
        .scaleEffect(self.isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: self.isPressed)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: self.isSelected)
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(
            minimumDuration: 0.5,
            pressing: { pressing in
                withAnimation(.easeInOut(duration: 0.1)) {
                    self.isPressed = pressing
                }
            }, perform: {}
        )
    }
}

// MARK: - TabItem

enum TabItem: String, CaseIterable {
    case home = "house.fill"
    case folder = "folder.fill"
    case add = "plus"
    case document = "doc.fill"
    case profile = "person.fill"
}

// MARK: - AddOptionButton

struct AddOptionButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    @State private var isPressed = false

    var body: some View {
        Button(action: self.action) {
            HStack {
                Image(systemName: self.icon)
                    .font(.system(size: ScreenSize.iconSize))
                Text(self.title)
                    .font(.system(size: ScreenSize.bodyFontSize, weight: .semibold))
                    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                Spacer()
                if self.isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(hex: "#7FE8A8"))
                }
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                self.isSelected
                    ? Color(hex: "#7FE8A8").opacity(0.2)
                    : Color(hex: "#2C2C2E")
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(self.isSelected ? Color(hex: "#7FE8A8") : Color.clear, lineWidth: 2)
            )
        }
        .scaleEffect(self.isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: self.isPressed)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: self.isSelected)
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(
            minimumDuration: 0.5,
            pressing: { pressing in
                withAnimation {
                    self.isPressed = pressing
                }
            }, perform: {}
        )
    }
}

// MARK: - ProfileOptionButton

struct ProfileOptionButton: View {
    let icon: String
    let title: String
    @State private var isPressed = false

    var body: some View {
        Button(action: {
            HapticManager.shared.impact(.medium)
            print("\(self.title) tapped")
        }) {
            HStack {
                Image(systemName: self.icon)
                    .font(.system(size: ScreenSize.iconSize))
                    .foregroundColor(Color(hex: "#7FE8A8"))
                    .frame(width: 30)
                Text(self.title)
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
        .scaleEffect(self.isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: self.isPressed)
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(
            minimumDuration: 0.5,
            pressing: { pressing in
                withAnimation {
                    self.isPressed = pressing
                }
            }, perform: {}
        )
    }
}

// MARK: - TaskDetailView

struct TaskDetailView: View {
    // MARK: SwiftUI Properties

    @Binding var isPresented: Bool
    @Environment(\.presentationMode) var presentationMode

    @State private var selectedStatus: Task.TaskStatus

    // MARK: Properties

    let task: Task

    // MARK: Lifecycle

    init(task: Task, isPresented: Binding<Bool>) {
        self.task = task
        self._isPresented = isPresented
        self._selectedStatus = State(initialValue: task.status)
    }

    // MARK: Content Properties

    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "#1C1C1E")
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        Text(self.task.title)
                            .font(.system(size: ScreenSize.largeTitleSize, weight: .bold))
                            .foregroundColor(.white)
                            .dynamicTypeSize(...DynamicTypeSize.xxxLarge)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.system(size: ScreenSize.smallFontSize, weight: .semibold))
                                .foregroundColor(.gray)

                            Text(self.task.description)
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
                                Text(self.task.priority.rawValue)
                                    .font(.system(size: ScreenSize.bodyFontSize, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        self.task.priority == .high
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
                                        isSelected: self.selectedStatus == status
                                    ) {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            self.selectedStatus = status
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
                                print("Save changes - Status: \(self.selectedStatus.rawValue)")
                            }) {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: ScreenSize.iconSize))
                                    Text("Save Changes")
                                        .font(
                                            .system(
                                                size: ScreenSize.bodyFontSize, weight: .semibold
                                            ))
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
                                                size: ScreenSize.bodyFontSize, weight: .semibold
                                            ))
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
                    self.isPresented = false
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

// MARK: - StatusOptionButton

struct StatusOptionButton: View {
    // MARK: Properties

    let status: Task.TaskStatus
    let isSelected: Bool
    let action: () -> Void

    // MARK: Content Properties

    var body: some View {
        Button(action: self.action) {
            HStack(spacing: 12) {
                Image(systemName: self.status.icon)
                    .font(.system(size: ScreenSize.iconSize))
                    .foregroundColor(self.isSelected ? self.status.color : .gray)
                    .frame(width: 30)

                Text(self.status.rawValue)
                    .font(
                        .system(
                            size: ScreenSize.bodyFontSize, weight: self.isSelected ? .semibold : .regular
                        )
                    )
                    .foregroundColor(self.isSelected ? .white : .gray)
                    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)

                Spacer()

                if self.isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: ScreenSize.iconSize))
                        .foregroundColor(self.status.color)
                }
            }
            .padding()
            .background(self.isSelected ? self.status.color.opacity(0.15) : Color.clear)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        self.isSelected ? self.status.color : Color.gray.opacity(0.2),
                        lineWidth: self.isSelected ? 2 : 1
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - MeetingDetailView

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
                        Text(self.meeting.title)
                            .font(.system(size: ScreenSize.largeTitleSize, weight: .bold))
                            .foregroundColor(.white)
                            .dynamicTypeSize(...DynamicTypeSize.xxxLarge)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.system(size: ScreenSize.smallFontSize, weight: .semibold))
                                .foregroundColor(.gray)

                            Text(self.meeting.description)
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

                                Text("Today, \(self.meeting.time)")
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
                            Text("Participants (\(self.meeting.participants.count))")
                                .font(.system(size: ScreenSize.smallFontSize, weight: .semibold))
                                .foregroundColor(.gray)

                            VStack(spacing: 12) {
                                ForEach(self.meeting.participants) { participant in
                                    HStack(spacing: 12) {
                                        Circle()
                                            .fill(Color.orange)
                                            .frame(width: 40, height: 40)
                                            .overlay(
                                                Text(String(participant.name.prefix(1)))
                                                    .font(
                                                        .system(
                                                            size: ScreenSize.titleFontSize,
                                                            weight: .semibold
                                                        )
                                                    )
                                                    .foregroundColor(.white)
                                            )

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(participant.name)
                                                .font(
                                                    .system(
                                                        size: ScreenSize.bodyFontSize,
                                                        weight: .medium
                                                    )
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
                                                size: ScreenSize.bodyFontSize, weight: .semibold
                                            ))
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
                                                size: ScreenSize.bodyFontSize, weight: .semibold
                                            ))
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
                    self.isPresented = false
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

// MARK: - ScrollOffsetPreferenceKey

struct ScrollOffsetPreferenceKey: PreferenceKey {
    // MARK: Static Properties

    static var defaultValue: CGFloat = 0

    // MARK: Static Functions

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
            opacity: Double(a) / 255
        )
    }
}

// MARK: - TaskManagementView_Previews

struct TaskManagementView_Previews: PreviewProvider {
    static var previews: some View {
        TaskManagementView()
    }
}
