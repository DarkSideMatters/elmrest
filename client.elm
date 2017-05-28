import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode
import Html.Events exposing (onInput)

main =
  Html.program
    { init = ({value = "nothing"}, Cmd.none)
    , view = view
    , update = update
    , subscriptions = \x -> Sub.none }

type Msg
  = DoPut
  | GetConnection String
  | NewConnection (Result Http.Error String)

type alias Model
  = { value : String
    , counter : int }

-- view shows us Model
view : Model -> Html Msg -- user interaction
view model =
    div []
    [ input [placeholder "Input number", onInput GetConnection][]
    , button [onClick DoPut ][ text "Put" ]
    , textarea [] [ text model.value ]
    , div [ ] [ text (toString "Hi") ]]


update : Msg -> Model -> (Model, Cmd Msg)
update message model =
    case message of
        GetConnection s -> (Model s, Cmd.none)
        DoPut -> (model, sendPutToServer model.value)
        NewConnection (Ok ok) -> (Model ok, Cmd.none)
        NewConnection (Err error) -> (Model (toString error), Cmd.none)

sendPutToServer : String -> Cmd Msg
sendPutToServer message =
    let
      request = Http.request
        { method = "PUT"
        , headers = []
        , url = "http://localhost:8080/JavaServer/api/count/put"
        , body = Http.emptyBody
        , expect = Http.expectString
        , timeout = Nothing
        , withCredentials = False
        }
    in
      Http.send NewConnection request
