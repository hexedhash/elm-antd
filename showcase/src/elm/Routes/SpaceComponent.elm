module Routes.SpaceComponent exposing (Model, Msg, route)

import Css exposing (displayFlex, maxWidth, pct)
import Html.Styled as Styled exposing (div, fromUnstyled, text)
import Html.Styled.Attributes exposing (css)
import Routes.SpaceComponent.BasicExample as BasicExample
import UI.Container as Container
import UI.Typography as Typography
    exposing
        ( documentationHeading
        , documentationSubheading
        , documentationText
        , documentationUnorderedList
        )
import Utils exposing (ComponentCategory(..), DocumentationRoute, SourceCode)


title : String
title =
    "Space"


type alias Model =
    { basicExample : Container.Model BasicExample.Model BasicExample.Msg
    }


type DemoBox
    = Basic


type Msg
    = DemoBoxMsg DemoBox (Container.Msg BasicExample.Msg)
    | ExampleSourceCodeLoaded (List SourceCode)


route : DocumentationRoute Model Msg
route =
    { title = title
    , category = Layout
    , view = view
    , update = update
    , initialModel =
        { basicExample =
            Container.initStatefulModel
                "BasicExample.elm"
                ()
                (\_ _ -> ( (), Cmd.none ))
        }
    , saveExampleSourceCodeToModel = ExampleSourceCodeLoaded
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DemoBoxMsg demoBox demoboxMsg ->
            case demoBox of
                Basic ->
                    let
                        ( basicModel, basicCmd ) =
                            Container.update (DemoBoxMsg Basic) demoboxMsg model.basicExample
                    in
                    ( { model | basicExample = basicModel }, basicCmd )

        ExampleSourceCodeLoaded examplesSourceCode ->
            ( { model
                | basicExample = Container.setSourceCode examplesSourceCode model.basicExample
              }
            , Cmd.none
            )


basicExample : Model -> Styled.Html Msg
basicExample model =
    let
        metaInfo =
            { title = "Basic"
            , content = "Basic usage example."
            , ellieDemo = "https://ellie-app.com/9mjyZ2xHwN9a1"
            }
    in
    Container.createDemoBox
        (DemoBoxMsg Basic)
        model.basicExample
        (\_ -> BasicExample.example)
        metaInfo


view : Model -> Styled.Html Msg
view model =
    div []
        [ documentationHeading title
        , documentationText <| text "Set Component Spacing"
        , documentationSubheading Typography.WithAnchorLink "When To Use"
        , documentationText <| text "To avoid components clinging together and to create unified spacing between components."
        , documentationSubheading Typography.WithoutAnchorLink "Examples"
        , div []
            [ div [ css [ maxWidth (pct 45) ] ] [ basicExample model ]
            , div [] []
            ]
        ]