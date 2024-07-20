local Translations = {
    info = {
        close_camera = 'Close Camera',
    },
}


if GetConvar('qb_locale', 'en') == 'fr' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
