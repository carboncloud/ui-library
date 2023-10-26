module Ui.Palette exposing
    ( primary050, primary500, primary600
    , secondary050, secondary500, secondary600
    , success, success050, warn050, warn500, warn600, focus, disabled
    , black, white, gray050, gray100, gray200, gray300, gray500, gray800, gray900
    , textPrimary, textPrimaryWhite
    )

{-| This module defines a palette of available colors


# Primary colors

@docs primary050, primary500, primary600


# Secondary colors

@docs secondary050, secondary500, secondary600


# Status colors

@docs success, success050, warn050, warn500, warn600, focus, disabled


# Gray colors

@docs black, white, gray050, gray100, gray200, gray300, gray500, gray800, gray900


# Text colors

@docs textPrimary, textPrimaryWhite

-}

import Color exposing (Color)
import Ui.Color


{-| ![#CAE8E9](https://placehold.co/15x15/cae8e9/cae8e9.png) `#CAE8E9`
-}
primary050 : Color
primary050 =
    Ui.Color.fromHex "#CAE8E9"


{-| ![#28A0A6](https://placehold.co/15x15/287386/287386.png) `#28A0A6`
-}
primary500 : Color
primary500 =
    Ui.Color.fromHex "#28A0A6"


{-| ![#226174](https://placehold.co/15x15/226174/226174.png) `#226174`
-}
primary600 : Color
primary600 =
    Ui.Color.fromHex "#226174"


{-| ![#E6E8F5](https://placehold.co/15x15/E6E8F5/E6E8F5.png) `#E6E8F5`
-}
secondary050 : Color
secondary050 =
    Ui.Color.fromHex "#E6E8F5"


{-| ![#364286](https://placehold.co/15x15/364286/364286.png) `#364286`
-}
secondary500 : Color
secondary500 =
    Ui.Color.fromHex "#364286"


{-| ![#2F3974](https://placehold.co/15x15/2F3974/2F3974.png) `#2F3974`
-}
secondary600 : Color
secondary600 =
    Ui.Color.fromHex "#2F3974"


{-| ![#FCFCFC](https://placehold.co/15x15/FCFCFC/FCFCFC.png) `#FCFCFC`
-}
gray050 : Color
gray050 =
    Ui.Color.fromHex "#FCFCFC"


{-| ![#f8f8f8](https://placehold.co/15x15/f8f8f8/f8f8f8.png) `#f8f8f8`
-}
gray100 : Color
gray100 =
    Ui.Color.fromHex "#f8f8f8"


{-| ![#e8e8e8](https://placehold.co/15x15/e8e8e8/e8e8e8.png) `#e8e8e8`
-}
gray200 : Color
gray200 =
    Ui.Color.fromHex "#e8e8e8"


{-| ![#D0D5DD](https://placehold.co/15x15/D0D5DD/D0D5DD.png) `#D0D5DD`
-}
gray300 : Color
gray300 =
    Ui.Color.fromHex "#D0D5DD"


{-| ![#858585](https://placehold.co/15x15/858585/858585.png) `#858585`
-}
gray500 : Color
gray500 =
    Ui.Color.fromHex "#858585"


{-| ![#444444](https://placehold.co/15x15/444444/444444.png) `#444444`
-}
gray800 : Color
gray800 =
    Ui.Color.fromHex "#444444"


{-| ![#102B2B](https://placehold.co/15x15/102B2B/102B2B.png) `#102B2B`
-}
gray900 : Color
gray900 =
    Ui.Color.fromHex "#102B2B"


{-| ![#ffffff](https://placehold.co/15x15/2F3974/2F3974.png) `#ffffff`
-}
white : Color
white =
    Ui.Color.fromHex "#ffffff"


{-| ![#05050a](https://placehold.co/15x15/05050a/05050a.png) `#05050a`
-}
black : Color
black =
    Ui.Color.fromHex "#05050a"


{-| ![#b5f7b5](https://placehold.co/15x15/b5f7b5/b5f7b5.png) `#b5f7b5`
-}
success : Color
success =
    Ui.Color.fromHex "#b5f7b5"


{-| ![#FEEFEC](https://placehold.co/15x15/FEEFEC/FEEFEC.png) `#FEEFEC`
-}
warn050 : Color
warn050 =
    Ui.Color.fromHex "#FEEFEC"


{-| ![#fa876a](https://placehold.co/15x15/fa876a/fa876a.png) `#fa876a`
-}
warn500 : Color
warn500 =
    Ui.Color.fromHex "#fa876a"


{-| ![#D95E3F](https://placehold.co/15x15/D95E3F/D95E3F.png) `#D95E3F`
-}
warn600 : Color
warn600 =
    Ui.Color.fromHex "#D95E3F"


{-| ![#4B5FD1](https://placehold.co/15x15/4B5FD1/4B5FD1.png) `#4B5FD1`
-}
focus : Color
focus =
    primary500


{-| ![#172D69](https://placehold.co/15x15/172D69/172D69.png) `#172D69`
-}
success050 : Color
success050 =
    Ui.Color.fromHex "#172D69"


{-| Color of disabled objects
-}
disabled : Color
disabled =
    gray500

{-|
-}
textPrimary : Color
textPrimary =
    gray900


{-| ![#FCFCFC](https://placehold.co/15x15/172D69/172D69.png) `#FCFCFC`
-}
textPrimaryWhite : Color
textPrimaryWhite =
    Ui.Color.fromHex "#FCFCFC"
