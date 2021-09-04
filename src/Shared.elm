module Shared exposing (Data, Model, Msg(..), SharedMsg(..), template)

import Browser.Navigation
import Css
import Css.Global
import DataSource
import Html as HTML
import Html.Styled as Html exposing (div, text)
import Html.Styled.Attributes as Attr exposing (css)
import Html.Styled.Attributes.Aria as Aria
import Html.Styled.Events as Events
import Pages.Flags
import Pages.PageUrl exposing (PageUrl)
import Path exposing (Path)
import Route exposing (Route)
import SharedTemplate exposing (SharedTemplate)
import Svg.Styled as Svg exposing (path, svg)
import Svg.Styled.Attributes as AttrSvg
import Tailwind.Breakpoints as TwBp
import Tailwind.Utilities as Tw
import View exposing (View)


template : SharedTemplate Msg Model Data msg
template =
    { init = init
    , update = update
    , view = view
    , data = data
    , subscriptions = subscriptions
    , onPageChange = Just OnPageChange
    }


type Msg
    = OnPageChange
        { path : Path
        , query : Maybe String
        , fragment : Maybe String
        }
    | SharedMsg SharedMsg


type alias Data =
    ()


type SharedMsg
    = NoOp


type alias Model =
    { showMobileMenu : Bool
    }


init :
    Maybe Browser.Navigation.Key
    -> Pages.Flags.Flags
    ->
        Maybe
            { path :
                { path : Path
                , query : Maybe String
                , fragment : Maybe String
                }
            , metadata : route
            , pageUrl : Maybe PageUrl
            }
    -> ( Model, Cmd Msg )
init navigationKey flags maybePagePath =
    ( { showMobileMenu = False }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnPageChange _ ->
            ( { model | showMobileMenu = False }, Cmd.none )

        SharedMsg globalMsg ->
            ( model, Cmd.none )


subscriptions : Path -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none


data : DataSource.DataSource Data
data =
    DataSource.succeed ()


view :
    Data
    ->
        { path : Path
        , route : Maybe Route
        }
    -> Model
    -> (Msg -> msg)
    -> View msg
    -> { body : HTML.Html msg, title : String }
view sharedData page model toMsg pageView =
    { body =
          Html.div
              []
              [ Css.Global.global Tw.globalStyles
              , Html.main_
                  []
                  pageView.body
              , viewFooter
              ]
                 |> Html.toUnstyled

    , title = pageView.title
    }


type SocialIcons
    = Facebook
    | Instagram
    | Twitter
    | Github
    | Correo
    | LinkedIn

viewFooter : Html.Html msg
viewFooter =
    let
        svgSocialIcon ( atributos, superD ) =
            div
                [ Attr.css [ Tw.w_7 ] ]
                [ svg
                    ([ AttrSvg.fill "currentColor"
                     , AttrSvg.viewBox "0 0 24 24"
                     ]
                        ++ atributos
                    )
                    [ Svg.path
                        [ AttrSvg.fillRule "evenodd"
                        , AttrSvg.d superD
                        , AttrSvg.clipRule "evenodd"
                        ]
                        []
                    ]
                ]

        lineaHorizontal =
            div
                [ css
                    [ Tw.pt_3
                    , Tw.h_6
                    , Tw.w_64
                    , Tw.text_blue_600
                    , Tw.px_2
                    ]
                ]
                [ svg
                    [ AttrSvg.fill "currentColor"
                    ]
                    [ Svg.line
                        [ -- AttrSvg.viewBox "0 0 210 3"
                          AttrSvg.strokeWidth "1"
                        , AttrSvg.fill "none"
                        , AttrSvg.stroke "currentColor"
                        , AttrSvg.strokeLinecap "round"
                        , AttrSvg.strokeLinejoin "round"
                        , AttrSvg.x1 "0"
                        , AttrSvg.y1 "0"
                        , AttrSvg.x2 "210"
                        , AttrSvg.y2 "0"
                        ]
                        []
                    ]
                ]

        svgLinkedIn =
            svgSocialIcon
                ( []
                , "M18.4004 0H1.70893C0.796874 0 0 0.65625 0 1.55759V18.2862C0 19.1924 0.796874 20 1.70893 20H18.3955C19.3125 20 20 19.1871 20 18.2862V1.55759C20.0053 0.65625 19.3125 0 18.4004 0ZM6.19954 16.671H3.33437V7.7625H6.19954V16.671ZM4.86606 6.40804H4.84553C3.92856 6.40804 3.33482 5.72545 3.33482 4.87098C3.33482 4.00089 3.94419 3.33438 4.88169 3.33438C5.81919 3.33438 6.39285 3.99598 6.41338 4.87098C6.41294 5.72545 5.81919 6.40804 4.86606 6.40804ZM16.671 16.671H13.8058V11.8C13.8058 10.633 13.3888 9.83572 12.3522 9.83572C11.5603 9.83572 11.0915 10.3714 10.883 10.8933C10.8049 11.0808 10.7839 11.3362 10.7839 11.5969V16.671H7.91874V7.7625H10.7839V9.00223C11.2009 8.40848 11.8522 7.55402 13.3678 7.55402C15.2486 7.55402 16.6714 8.79375 16.6714 11.4665L16.671 16.671Z"
                )

        svgFacebook =
            svgSocialIcon
                ( []
                , "M22 12c0-5.523-4.477-10-10-10S2 6.477 2 12c0 4.991 3.657 9.128 8.438 9.878v-6.987h-2.54V12h2.54V9.797c0-2.506 1.492-3.89 3.777-3.89 1.094 0 2.238.195 2.238.195v2.46h-1.26c-1.243 0-1.63.771-1.63 1.562V12h2.773l-.443 2.89h-2.33v6.988C18.343 21.128 22 16.991 22 12z"
                )

        svgAtIcon =
            svgSocialIcon
                ( [ AttrSvg.strokeWidth "2"
                  , AttrSvg.fill "none"
                  , AttrSvg.stroke "currentColor"
                  , AttrSvg.strokeLinecap "round"
                  , AttrSvg.strokeLinejoin "round"
                  ]
                , "M16 12a4 4 0 10-8 0 4 4 0 008 0zm0 0v1.5a2.5 2.5 0 005 0V12a9 9 0 10-9 9m4.5-1.206a8.959 8.959 0 01-4.5 1.207"
                )

        svgGithub =
            svgSocialIcon
                ( []
                , "M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.531 1.032 1.531 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 17.522 2 12 2z"
                )

        svgTwitter =
            svgSocialIcon
                ( []
                , "M8.29 20.251c7.547 0 11.675-6.253 11.675-11.675 0-.178 0-.355-.012-.53A8.348 8.348 0 0022 5.92a8.19 8.19 0 01-2.357.646 4.118 4.118 0 001.804-2.27 8.224 8.224 0 01-2.605.996 4.107 4.107 0 00-6.993 3.743 11.65 11.65 0 01-8.457-4.287 4.106 4.106 0 001.27 5.477A4.072 4.072 0 012.8 9.713v.052a4.105 4.105 0 003.292 4.022 4.095 4.095 0 01-1.853.07 4.108 4.108 0 003.834 2.85A8.233 8.233 0 012 18.407a11.616 11.616 0 006.29 1.84"
                )

        svgInstagram =
            svgSocialIcon
                ( []
                , "M12.315 2c2.43 0 2.784.013 3.808.06 1.064.049 1.791.218 2.427.465a4.902 4.902 0 011.772 1.153 4.902 4.902 0 011.153 1.772c.247.636.416 1.363.465 2.427.048 1.067.06 1.407.06 4.123v.08c0 2.643-.012 2.987-.06 4.043-.049 1.064-.218 1.791-.465 2.427a4.902 4.902 0 01-1.153 1.772 4.902 4.902 0 01-1.772 1.153c-.636.247-1.363.416-2.427.465-1.067.048-1.407.06-4.123.06h-.08c-2.643 0-2.987-.012-4.043-.06-1.064-.049-1.791-.218-2.427-.465a4.902 4.902 0 01-1.772-1.153 4.902 4.902 0 01-1.153-1.772c-.247-.636-.416-1.363-.465-2.427-.047-1.024-.06-1.379-.06-3.808v-.63c0-2.43.013-2.784.06-3.808.049-1.064.218-1.791.465-2.427a4.902 4.902 0 011.153-1.772A4.902 4.902 0 015.45 2.525c.636-.247 1.363-.416 2.427-.465C8.901 2.013 9.256 2 11.685 2h.63zm-.081 1.802h-.468c-2.456 0-2.784.011-3.807.058-.975.045-1.504.207-1.857.344-.467.182-.8.398-1.15.748-.35.35-.566.683-.748 1.15-.137.353-.3.882-.344 1.857-.047 1.023-.058 1.351-.058 3.807v.468c0 2.456.011 2.784.058 3.807.045.975.207 1.504.344 1.857.182.466.399.8.748 1.15.35.35.683.566 1.15.748.353.137.882.3 1.857.344 1.054.048 1.37.058 4.041.058h.08c2.597 0 2.917-.01 3.96-.058.976-.045 1.505-.207 1.858-.344.466-.182.8-.398 1.15-.748.35-.35.566-.683.748-1.15.137-.353.3-.882.344-1.857.048-1.055.058-1.37.058-4.041v-.08c0-2.597-.01-2.917-.058-3.96-.045-.976-.207-1.505-.344-1.858a3.097 3.097 0 00-.748-1.15 3.098 3.098 0 00-1.15-.748c-.353-.137-.882-.3-1.857-.344-1.023-.047-1.351-.058-3.807-.058zM12 6.865a5.135 5.135 0 110 10.27 5.135 5.135 0 010-10.27zm0 1.802a3.333 3.333 0 100 6.666 3.333 3.333 0 000-6.666zm5.338-3.205a1.2 1.2 0 110 2.4 1.2 1.2 0 010-2.4z"
                )

        ligaIcono : String -> String -> SocialIcons -> Html.Html msg
        ligaIcono direccion srCual iconoSocial =
            Html.a
                [ Attr.href direccion
                , css
                    [ Tw.text_gray_400
                    , Css.hover [ Tw.text_gray_500 ]
                    ]
                ]
                [ Html.span
                    [ css [ Tw.sr_only ] ]
                    [ text srCual ]
                , case iconoSocial of
                    Facebook ->
                        svgFacebook

                    LinkedIn ->
                        svgLinkedIn

                    Correo ->
                        svgAtIcon

                    Instagram ->
                        svgInstagram

                    Twitter ->
                        svgTwitter

                    Github ->
                        svgGithub
                ]

        losIconos =
            div
                [ css
                    [ Tw.m_4
                    , Tw.flex
                    , Tw.justify_center
                    , Tw.space_x_6
                    ]
                ]
                [ ligaIcono "contacto" "correo" Correo
                , ligaIcono "github.com" "GitHub" Github
                , ligaIcono "twitter.com" "Twitter" Twitter
                , ligaIcono "linkedin.com" "linkedin" LinkedIn
                ]
    in
    Html.footer
        []
        [ div
            [ css
                [ Tw.mt_12
                , Tw.mx_auto
                , Tw.py_4
                , Tw.flex
                , Tw.justify_center
                , Tw.items_center
                , Tw.flex_col
                , TwBp.sm [ Tw.flex_row ]
                ]
            ]
            [ lineaHorizontal
            , losIconos
            , lineaHorizontal
            ]
        , Html.p
            [ css
                [ Tw.mt_8
                , Tw.text_center
                , Tw.text_base
                , Tw.text_gray_500
                ]
            ]
            [ text <| String.fromChar (Char.fromCode 169)
                      ++ " 2021 rolojf.com, Derechos reservados."
            ]
        ]
