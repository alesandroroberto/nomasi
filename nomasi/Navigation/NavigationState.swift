//
//  NavigationState.swift
//  nomasi
//
//  Created by Alexander Krupichko on 15.04.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

//import CasePaths
//import ComposableArchitecture
//import Prelude
//
//struct NavigationState: Equatable {
//    var screens: [Screen]
//}
//
//extension NavigationState {
//    static let initial = NavigationState(screens: [])
//}
//
//enum ScreenStatus: Equatable {
//    case appeared
//    case disappeared
//}
//
//enum Screen: Equatable {
//    case exercisesGroup(ScreenStatus)
//    case exercises(ScreenStatus)
//    case exerciseDetails(ScreenStatus)
//
//    var status: ScreenStatus {
//        switch self {
//        case .exercisesGroup(let status),
//             .exercises(let status),
//             .exerciseDetails(let status):
//            return status
//        }
//    }
//}
//
//enum NavigationAction {
//    case screenChangeStatus(Screen)
//    case lastScreenChanged(Screen)
//}
//
//func navigationReducer(
//    state: inout NavigationState,
//    action: NavigationAction,
//    environment: Void
//) -> [Effect<NavigationAction>] {
//    switch action {
//    case .screenChangeStatus(let screen):
//        if let index = state.screens.firstIndex(where: equalsWithoutStatus(screen: screen)) {
//            state.screens[index] = screen
//            state.screens.removeLast(popLength(screens: state.screens))
//            return [state.screens.last.map { screen in .sync(work: { .lastScreenChanged(screen) })}].compactMap(id)
//        } else {
//            state.screens.append(screen)
//            return []
//        }
//    case .lastScreenChanged:
//        return []
//    }
//}
//
//private func equalsWithoutStatus(screen: Screen) -> (Screen) -> Bool {
//    return { anotherScreen in
//        switch (screen, anotherScreen) {
//        case (.exercisesGroup, .exercisesGroup),
//             (.exercises, .exercises),
//             (.exerciseDetails, .exerciseDetails):
//            return true
//        case (.exercises, _),
//             (.exercisesGroup, _),
//             (.exerciseDetails, _):
//            return false
//        }
//    }
//}
//
//private func popLength(screens: [Screen]) -> Int {
//    let lastAppeared: Int? = screens.lastIndex(where: { $0.status == .appeared })
//    let popLength = { screens.distance(from: $0, to: screens.count - 1) }
//    return lastAppeared.map(popLength) ?? 0
//}
