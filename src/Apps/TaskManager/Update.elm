module Apps.TaskManager.Update exposing (update)

import Dict
import Time exposing (Time)
import Core.Dispatch as Dispatch exposing (Dispatch)
import Game.Models as Game
import Game.Servers.Models exposing (getServerByID, getProcesses)
import Game.Servers.Processes.Types.Local exposing (ProcessState(StateRunning))
import Game.Servers.Processes.Models exposing (Processes, ProcessProp(LocalProcess))
import Game.Servers.Processes.Messages as Processes exposing (Msg(..))
import Apps.TaskManager.Models
    exposing
        ( Model
        , onlyLocalTasks
        , updateTasks
        )
import Apps.TaskManager.Messages as TaskManager exposing (Msg(..))
import Apps.TaskManager.Menu.Messages as Menu
import Apps.TaskManager.Menu.Update as Menu
import Apps.TaskManager.Menu.Actions as Menu


processComplete : Processes -> Time -> Dispatch
processComplete tasks now =
    tasks
        |> Dict.values
        |> List.filterMap
            (\process ->
                case process.prop of
                    LocalProcess prop ->
                        let
                            completed =
                                prop.eta
                                    |> Maybe.map ((>) now)
                                    |> Maybe.withDefault False
                        in
                            if (prop.state == StateRunning) && completed then
                                Just
                                    (Dispatch.processes "localhost"
                                        (Processes.Complete process.id)
                                    )
                            else
                                Nothing

                    _ ->
                        Nothing
            )
        |> Dispatch.batch


update :
    Game.Model
    -> TaskManager.Msg
    -> Model
    -> ( Model, Cmd TaskManager.Msg, Dispatch )
update game msg ({ app } as model) =
    case msg of
        -- -- Context
        MenuMsg (Menu.MenuClick action) ->
            Menu.actionHandler game action model

        MenuMsg msg ->
            let
                ( menu_, cmd, coreMsg ) =
                    Menu.update game msg model.menu

                cmd_ =
                    Cmd.map MenuMsg cmd
            in
                ( { model | menu = menu_ }, cmd_, coreMsg )

        --- Every update
        Tick now ->
            let
                newApp =
                    updateTasks
                        game.servers
                        --TODO: Recalculate limits
                        app.limits
                        app

                server =
                    getServerByID game.servers "localhost"

                tasks =
                    getProcesses server

                completeMsgs =
                    case tasks of
                        Just tasks ->
                            processComplete tasks now

                        Nothing ->
                            Dispatch.none
            in
                ( { model | app = newApp }, Cmd.none, completeMsgs )