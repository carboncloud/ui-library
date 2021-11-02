module Explorer exposing (main)

import Html
import UIExplorer
    exposing
        ( UIExplorerProgram
        , defaultConfig
        , explore
        , storiesOf
        )

import Button

main : UIExplorerProgram {} () {}
main =
    explore
        defaultConfig
        [ storiesOf
            "Welcome"
            [ ( "Button", \_ -> Button.raised [] <| Button.Text "My button", {} )
            ]
        ]
