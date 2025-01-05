app "ulid-generator"
    packages {
        pf: "https://github.com/roc-lang/basic-cli/releases/download/0.18.0/0APbwVN1_p1mJ96tXjaoiUCr8NBGamr8G8Ac_DrXR-o.tar.br"
    }
    imports [pf.Stdout]
    provides [main] to pf

base32Chars = "0123456789ABCDEFGHJKMNPQRSTVWXYZ"

# Convertir un entier en Base32
toBase32 : Num.U64 -> Str
toBase32 = \num ->
    if num == 0u64 then
        "0"
    else
        digit = Num.rem num 32u64
        remaining = num // 32u64
        Str.concat (toBase32 remaining) (Str.repeat (List.get base32Chars (Num.toI64 digit) |> Result.withDefault "0") 1)

# Générer un pseudo-timestamp ULID (10 caractères Base32)
generateTimestamp : Str
generateTimestamp =
    List.range { start: At 0u64, end: Length 10u64 }
    |> List.map \i ->
        toBase32 (Num.rem (1234567890u64 + i) 32u64)
    |> Str.concat ""

# Générer une chaîne aléatoire ULID (16 caractères Base32 simulés)
generateRandom : Str
generateRandom =
    List.range { start: At 0u64, end: Length 16u64 }
    |> List.map \_ ->
        randomValue = Num.rem 42u64 32u64  # Valeur simulée
        Str.repeat (List.get base32Chars (Num.toI64 randomValue) |> Result.withDefault "0") 1
    |> Str.concat ""

# Générer un ULID complet
generateULID : Str
generateULID =
    Str.concat generateTimestamp generateRandom

# Point d'entrée principal
main = \_ ->
    ulid = generateULID
    Stdout.line! (Str.concat "Generated ULID: " ulid)
