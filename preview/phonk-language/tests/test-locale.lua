local I=dofile('preview/phonk-language/i18n.lua')
for _,v in ipairs({'en-us','EN_US','en'})do assert(I.Resolve(v)=='en')end
assert(I.Resolve('tl-PH')=='fil');assert(I.Resolve('fil-ph')=='fil');assert(I.Resolve('pt-PT')=='pt');assert(I.Resolve('in-ID')=='id');assert(I.Resolve('zh-cn')=='en')
local l=I.new('Automatic (Roblox)','ru-ru');assert(l:T('Settings')=='Settings');l:Set('Русский');assert(l:T('Settings')=='Настройки')
assert(l:T('Session · 12:34:56')=='Сеанс · 12:34:56');assert(l:T('3 / 1800 characters')=='3 / 1800 символов')
assert(l:T('Settings / Appearance')=='Настройки / Оформление');assert(l:T('Unknown phrase')=='Unknown phrase')
for _,name in ipairs(I.Options)do l:Set(name);assert(type(l:T('Settings'))=='string')end
for lang,pack in pairs(I.Packs)do local n=0;for k,v in pairs(pack)do n=n+1;assert(type(v)=='string' and #v>0);assert(utf8.len(v),'invalid UTF8: '..lang..' '..k)end;assert(n==118)end
local manifest=dofile('preview/phonk-language/phonk-language-manifest.lua')
for _,page in ipairs(manifest.Pages)do for _,feature in ipairs(page.Features)do for _,control in ipairs(feature.Controls)do
    assert(not control.Callback and not control.Changed)
    for lang,pack in pairs(I.Packs)do assert(pack[control.Title],'missing label: '..lang..' '..control.Title) end
end end end
print('PASS: all Phonk control labels covered in nine translation packs, UTF-8 validity, locale aliases, dynamic strings, English fallback, no automation callbacks.')
