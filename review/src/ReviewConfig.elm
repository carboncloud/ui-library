module ReviewConfig exposing (config)

{-| Do not rename the ReviewConfig module or the config function, because
`elm-review` will look for these.

To add packages that contain rules, add them to this review project using

    `elm install author/packagename`

when inside the directory containing this file.

-}

import NoDuplicatePorts
import NoMissingSubscriptionsCall
import NoMissingTypeAnnotation
import NoMissingTypeAnnotationInLetIn
import NoPrematureLetComputation
import NoRecursiveUpdate
import NoUnsafePorts
import NoUnused.CustomTypeConstructorArgs
import NoUnused.CustomTypeConstructors
import NoUnused.Dependencies
import NoUnused.Exports
import NoUnused.Parameters
import NoUnused.Patterns
import NoUnused.Variables
import NoUnusedPorts
import NoUselessSubscriptions
import Review.Rule exposing (Rule)


config : List Rule
config =
    [ NoMissingSubscriptionsCall.rule
    , NoUnused.Patterns.rule
    , NoUnused.Dependencies.rule
    , NoDuplicatePorts.rule
    , NoUnusedPorts.rule
    , NoRecursiveUpdate.rule
    , NoMissingTypeAnnotation.rule
    ]
