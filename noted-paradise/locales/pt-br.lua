local Translations = {
    info = {
        close_camera = 'Fechar Câmera',
    },
}


if GetConvar('qb_locale', 'en') == 'pt-br' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
