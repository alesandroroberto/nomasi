//
//  NavigationCoordinator.swift
//  nomasi
//
//  Created by Alexander Krupichko on 15.04.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import ComposableArchitecture

func navigationCoordinator(
  _ reducer: @escaping Reducer<AppState, AppAction, AppEnvironment>
) -> Reducer<AppState, AppAction, AppEnvironment> {

  return { state, action, environment in
    let effects = reducer(&state, action, environment)
    let navigationEffects: [Effect<AppAction>]
    switch action {
    case .exerciseGroupsView(.viewDidLoad):
        navigationEffects = [.sync(work: { .navigationView(.screenChangeStatus(.exercisesGroup(.appeared))) })]
    case .exerciseGroupsView(.disappeared):
        navigationEffects = [.sync(work: { .navigationView(.screenChangeStatus(.exercisesGroup(.disappeared))) })]
    case .exercisesView(.viewDidLoad):
        navigationEffects = [.sync(work: { .navigationView(.screenChangeStatus(.exercises(.appeared))) })]
    case .exercisesView(.disappeared):
        navigationEffects = [.sync(work: { .navigationView(.screenChangeStatus(.exercises(.disappeared))) })]
    case .exerciseDetailsView(.viewDidLoad):
        navigationEffects = [.sync(work: { .navigationView(.screenChangeStatus(.exerciseDetails(.appeared))) })]
    case .exerciseDetailsView(.disappeared):
        navigationEffects = [.sync(work: { .navigationView(.screenChangeStatus(.exerciseDetails(.disappeared))) })]
    case .navigationView(.lastScreenChanged(let screen)):
        switch screen {
        case .exercisesGroup:
            navigationEffects = [.sync(work: { .exerciseGroupsView(.lastViewInStack) })]
        case .exercises:
            navigationEffects = [.sync(work: { .exercisesView(.lastViewInStack) })]
        case .exerciseDetails:
            navigationEffects = [.sync(work: { .exerciseDetailsView(.lastViewInStack) })]
        }
    default:
        navigationEffects = []
    }
    return navigationEffects + effects
  }
}
