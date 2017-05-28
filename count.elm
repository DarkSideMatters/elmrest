import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode
import Html.Events exposing (onInput)

main =
  Html.program
    { init = (Model "", Cmd.none)
    , view = view
    , update = update
    , subscriptions = \x -> Sub.none }

type Msg
  = Count (Result Http.Error String)
  | GetCounter

type alias Model
  = { url : String }


-- view shows us Model
view : Model -> Html Msg -- user interaction
view model =
    div []
    [ button [onClick GetCounter ][ text "Get" ]
    , div [] [ text (toString model.url) ]
    ]

update : Msg -> Model -> (Model, Cmd Msg)
update message model =
    case message of
        Count (Ok value) -> (Model value, Cmd.none)
        Count (Err _) -> (model, Cmd.none)
        GetCounter -> (model, getCount "")

decodeGifUrl : Decode.Decoder String
decodeGifUrl = Decode.at ["data", "url"] Decode.string

getCount : String -> Cmd Msg
getCount topic =
    let
      url ="http://localhost:8080/JavaServer/api/count/" ++ topic
    in
      Http.send Count(Http.get url decodeGifUrl)
