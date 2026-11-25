# studio: NINEROUTER_API_KEY for team workers (key lives only in ~/dev/studio/.env)
if test -f ~/dev/studio/.env
    for line in (string match -r '^[A-Za-z_][A-Za-z0-9_]*=.*' < ~/dev/studio/.env)
        set -l kv (string split -m 1 = -- $line)
        set -gx $kv[1] $kv[2]
    end
end

# QA browser of team workers draws on the real X.org display streamed by Sunshine (Moonlight); unset for Xvfb + noVNC
set -gx TEAM_DISPLAY :0
