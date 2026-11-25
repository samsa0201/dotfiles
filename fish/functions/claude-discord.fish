function claude-discord --wraps claude --description 'Claude Code, account 1 with Discord bot 1'
    env -u DISCORD_TOKEN DISCORD_STATE_DIR=$HOME/.claude/channels/discord command claude --settings $HOME/.claude/discord.settings.json $argv
end
