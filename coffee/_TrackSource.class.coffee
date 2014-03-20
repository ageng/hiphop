request = require('request')

class TrackSource

    @search: (keywords, success) ->
        $.ajax
            url: 'http://itunes.apple.com/search?media=music&entity=song&limit=100&callback=cb&term=' + encodeURIComponent(keywords)
            jsonpCallback: 'cb'
            dataType: 'jsonp'
            error: (e) ->
                console.log e.message
            success: (data) ->
                tracks = []
                tracks_hash = []
                $.each data.results, (i, track) ->
                    track_hash = track.artistName + '___' + track.trackCensoredName
                    if track_hash not in tracks_hash
                        tracks.push
                            title: track.trackCensoredName
                            artist: track.artistName
                            cover_url_medium: track.artworkUrl60
                            cover_url_large: track.artworkUrl100
                        tracks_hash.push(track_hash)
                success? tracks


    @topTracks: (success) ->
        request 'http://itunes.apple.com/rss/topsongs/limit=50/explicit=true/json', (error, response, body) ->
            if not error and response.statusCode is 200
                data = JSON.parse(body)
                tracks = []
                tracks_hash = []
                $.each data.feed.entry, (i, track) ->
                    track_hash = track['im:artist'].label + '___' + track['im:name'].label
                    if track_hash not in tracks_hash
                        tracks.push
                            title: track['im:name'].label
                            artist: track['im:artist'].label
                            cover_url_medium: track['im:image'][1].label
                            cover_url_large: track['im:image'][2].label
                        tracks_hash.push(track_hash)
                success? tracks

    @history: (success) ->
        History.getTracks((tracks) ->
            success? tracks
        )


    @playlist: (playlist, success) ->
        Playlists.getTracksForPlaylist(playlist, ((tracks) ->
            success? tracks
        ))