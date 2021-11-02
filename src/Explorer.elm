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
import Html.Styled exposing (toUnstyled)

main : UIExplorerProgram {} () {}
main =
    explore
        defaultConfig
        [ storiesOf
            "Welcome"
            [ ( "Button", \_ -> toUnstyled <| Button.raised [] <| Button.Text "My button", {} )
            ]
        ]
