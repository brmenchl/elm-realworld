module Form exposing (Validator, all, atLeastMinimum, atMostMaximum, firstOf, fromValid, required, validate)


type Valid subject
    = Valid subject


fromValid : Valid subject -> subject
fromValid (Valid subject) =
    subject


type Validator error subject
    = Validator (subject -> List error)


all : List (Validator error form) -> Validator error form
all validators =
    let
        getAllErrors subject =
            List.foldl (\(Validator getErrors) allErrors -> allErrors ++ getErrors subject) [] validators
    in
    Validator getAllErrors


validate : Validator error subject -> subject -> Result (List error) (Valid subject)
validate (Validator getErrors) subject =
    case getErrors subject of
        [] ->
            Ok (Valid subject)

        errors ->
            Err errors



-- Validators


firstOf : List (Validator error subject) -> Validator error subject
firstOf validators =
    let
        getFirstError subject =
            case all validators of
                Validator getErrors ->
                    getErrors subject |> List.take 1
    in
    Validator getFirstError


required : (subject -> String) -> String -> Validator String subject
required subjectToString fieldName =
    Validator
        (\subject ->
            let
                value =
                    subjectToString subject
            in
            if String.isEmpty value then
                [ requiredErrorMessage fieldName ]

            else
                []
        )


atLeastMinimum : (subject -> String) -> String -> Int -> Validator String subject
atLeastMinimum subjectToString fieldName minimum =
    Validator
        (\subject ->
            let
                value =
                    subjectToString subject
            in
            if String.length value < minimum then
                [ minimumErrorMessage fieldName minimum ]

            else
                []
        )


atMostMaximum : (subject -> String) -> String -> Int -> Validator String subject
atMostMaximum subjectToString fieldName maximum =
    Validator
        (\subject ->
            let
                value =
                    subjectToString subject
            in
            if String.length value > maximum then
                [ maximumErrorMessage fieldName maximum ]

            else
                []
        )



-- Error Messages


requiredErrorMessage : String -> String
requiredErrorMessage fieldName =
    fieldName ++ " can't be blank"


minimumErrorMessage : String -> Int -> String
minimumErrorMessage fieldName minimum =
    fieldName ++ " is too short (minimum is " ++ String.fromInt minimum ++ " " ++ pluralize "character" "characters" minimum ++ ")"


maximumErrorMessage : String -> Int -> String
maximumErrorMessage fieldName maximum =
    fieldName ++ " is too long (maximum is " ++ String.fromInt maximum ++ " " ++ pluralize "character" "characters" maximum ++ ")"


pluralize : String -> String -> Int -> String
pluralize singular plural number =
    if number == 1 then
        singular

    else
        plural
