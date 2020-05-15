//
//  WorkoutEffects.swift
//  nomasi
//
//  Created by Alexander Krupichko on 19.04.2020.
//  Copyright © 2020 Krupichko. All rights reserved.
//

import ComposableArchitecture
import Combine
import NOWorkout
import NOExercises

enum WorkoutEffects {
    static func loadExercises(workoutsWithLink: @escaping GetDocuments<WorkoutWithLink>,
                              exercise: @escaping GetDocument<Exercise>)
        -> (WorkoutEnvironment.WorkoutId) -> Effect<WorkoutAction> {
            return { workoutId in
                return workoutsWithLink("/workouts/" + workoutId + "/exercises")
                    .flatMap { workouts -> AnyPublisher<[WorkoutExercise], NSError> in
                        let ss = workouts.map { workout in
                            exercise(workout.exercise).map { exercise in
                                WorkoutExercise(id: workout.id, name: exercise.name, repeats: workout.repeats, weight: workout.weight)
                            }.eraseToAnyPublisher()
                        }
                        return Publishers.MergeMany(ss).collect(ss.count).eraseToAnyPublisher()
                }
                .map { WorkoutAction.exercisesLoaded($0) }
                .catch { _ in Just(.exercisesLoaded([])) }
                .eraseToAnyPublisher()
                .receive(on: DispatchQueue.main)
                .eraseToEffect()
            }
    }
    
    static func logExerciseResult(setUserData: @escaping (String, [String: Any]) -> Future<Void,NSError>)
        -> (WorkoutEnvironment.WorkoutUser) -> Effect<WorkoutAction> {
        return { userDefinedWorkoutExercise in
            return setUserData(
                "/workouts/",
                [
                    "workoutExerciseId": userDefinedWorkoutExercise.0,
                    "repeats": userDefinedWorkoutExercise.1,
                    "weight": userDefinedWorkoutExercise.2
                ]
            )
                .map { WorkoutAction.exerciseResultLogged(id: userDefinedWorkoutExercise.0) }
                .catch { _ in Just(.exerciseResultLogged(id: userDefinedWorkoutExercise.0)) }
                .eraseToAnyPublisher()
                .receive(on: DispatchQueue.main)
                .eraseToEffect()
        }
    }
}

extension WorkoutEnvironment {
    static func live(provider: FirebaseProvider) -> WorkoutEnvironment {
        .init(
            loadExercises: WorkoutEffects.loadExercises(
                workoutsWithLink: provider.documents,
                exercise: provider.document
            ),
            logExerciseResult: WorkoutEffects.logExerciseResult(setUserData: provider.addUserDataWithTimestamp)
        )
    }
}

struct WorkoutWithLink: Decodable {
    var id: String
    var ord: Int
    var repeats: Int
    var weight: Double
    var exercise: String
}
