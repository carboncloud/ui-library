module Ui.Typography exposing (..)

import Ui.Font as Font exposing (Font(..))
import Ui.Palette as Palette

{-|
    This module defines our Typography

    ### What is Typography?
    Typography is the art of arranging letters and text in a way that makes the copy legible, clear, and visually appealing to the reader.
-}
bodyS : Font
bodyS =
    Font
        { family = Font.bodyFamily
        , size = Font.small
        , weight = Font.regular
        , color = Font.black
        }


body : Font
body =
    Font
        { family = Font.bodyFamily
        , size = Font.normal
        , weight = Font.regular
        , color = Font.black
        }


bodyL : Font
bodyL =
    Font
        { family = Font.bodyFamily
        , size = Font.large
        , weight = Font.regular
        , color = Font.black
        }


label : Font
label =
    Font
        { family = Font.primary
        , size = Font.large
        , weight = Font.semiBold
        , color = Font.black
        }


h1 : Font
h1 =
    Font
        { family = Font.primary
        , size = Font.xxl
        , weight = Font.semiBold
        , color = Font.black
        }


h2 : Font
h2 =
    Font
        { family = Font.primary
        , size = Font.xl
        , weight = Font.semiBold
        , color = Font.black
        }


h3 : Font
h3 =
    Font
        { family = Font.primary
        , size = Font.large
        , weight = Font.semiBold
        , color = Font.black
        }


h4 : Font
h4 =
    Font
        { family = Font.primary
        , size = Font.normal
        , weight = Font.semiBold
        , color = Font.black
        }
