module Game.Storyline.Emails.Contents.View exposing (..)

import Html exposing (Html, text)
import Game.Storyline.Emails.Contents exposing (Content(..))
import Game.Storyline.Emails.Contents.Config exposing (..)
import UI.Inlines.Networking exposing (..)


view : Config msg -> Content -> List (Html msg)
view { onOpenBrowser, username } content =
    case content of
        HelloWorld some ->
            [ text <| "hello world! " ++ some ]

        WelcomePCSetup ->
            [ text <|
                "Hey, "
                    ++ username
                    ++ "! There are some rumours you just got out of jail..."
            ]

        BackThanks ->
            [ text "Yep, the king is back! I'm needing a starter kit for getting back to work!"
            , text " Care to share one with me?"
            ]

        DownloadCrackerPublicFTP downloadCenterIP ->
            [ text "Sure. I've set up a public FTP server at "
            , addr onOpenBrowser downloadCenterIP
            , text ", you probably need that cracker for starters..."
            ]

        MoreInfo ->
            [ text "Tell me more..." ]

        Sure ->
            [ text "Sure" ]

        GiveMoreInfo step ->
            [ text "Blabla" ]
