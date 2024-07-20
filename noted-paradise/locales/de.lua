local Translations = {
    info = {
        close_camera = 'Kamera Schließen',
    },
}


if GetConvar('qb_locale', 'en') == 'de' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
