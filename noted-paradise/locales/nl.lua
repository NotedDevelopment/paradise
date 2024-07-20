local Translations = {
    info = {
        close_camera = 'Sluit Camera',
    },
}


if GetConvar('qb_locale', 'en') == 'nl' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
