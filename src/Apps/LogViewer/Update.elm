module Apps.LogViewer.Update exposing (update)

import Dict
import Core.Messages exposing (CoreMsg)
import Game.Models exposing (GameModel)
import Apps.LogViewer.Models
    exposing
        ( Model
        , initialLogViewer
        , toggleExpanded
        , LogEventStatus(..)
        )
import Apps.LogViewer.Messages exposing (Msg(..))
import Apps.LogViewer.Menu.Messages as MsgMenu
import Apps.LogViewer.Menu.Update
import Apps.LogViewer.Menu.Actions exposing (actionHandler)


update : Msg -> GameModel -> Model -> ( Model, Cmd Msg, List CoreMsg )
update msg game ({ app } as model) =
    case msg of
        -- -- Context
        MenuMsg (MsgMenu.MenuClick action) ->
            actionHandler action model game

        MenuMsg subMsg ->
            let
                ( menu_, cmd, coreMsg ) =
                    Apps.LogViewer.Menu.Update.update subMsg model.menu game

                cmd_ =
                    Cmd.map MenuMsg cmd
            in
                ( { model | menu = menu_ }, cmd_, coreMsg )

        -- -- Real acts
        ToogleLog logID ->
            let
                entries_ =
                    Dict.update logID
                        (Maybe.andThen
                            (\x -> Just { x | status = (toggleExpanded x.status) })
                        )
                        app.entries

                model_ =
                    { model | app = { app | entries = entries_ } }
            in
                ( model_, Cmd.none, [] )

        UpdateFilter filter ->
            let
                model_ =
                    { model | app = { app | filtering = filter } }
            in
                ( model_, Cmd.none, [] )

        EnterEditing logID ->
            let
                entries_ =
                    Dict.update logID
                        (Maybe.andThen
                            (\x -> Just { x | status = Editing x.src })
                        )
                        app.entries

                model_ =
                    { model | app = { app | entries = entries_ } }
            in
                ( model_, Cmd.none, [] )

        UpdateEditing logID input ->
            let
                entries_ =
                    Dict.update logID
                        (Maybe.andThen
                            (\x -> Just { x | status = Editing input })
                        )
                        apps.entries

                model_ =
                    { model | app = { app | entries = entries_ } }
            in
                ( model_, Cmd.none, [] )

        LeaveEditing logID ->
            let
                entries_ =
                    Dict.update logID
                        (Maybe.andThen
                            (\x -> Just { x | status = Normal True })
                        )
                        app.entries

                model_ =
                    { model | app = { app | entries = entries_ } }
            in
                ( model_, Cmd.none, [] )

        ApplyEditing logID ->
            let
                -- TODO: Sendo Update do Game Models
                entries_ =
                    Dict.update logID
                        (Maybe.andThen
                            (\x -> Just { x | status = Normal True })
                        )
                        app.entries

                model_ =
                    { model | app = { app | entries = entries_ } }
            in
                ( model_, Cmd.none, [] )
