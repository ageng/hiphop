Settings =
    get: (variable) ->
        localStorage['setting_' + variable]
    set: (variable, newValue) ->
        localStorage.setItem 'settings_' + variable, newValue

    init: ->
        @set('updateUrl', 'http://gethiphop.net/update.json') if not @get('updateUrl')


Settings.init()
