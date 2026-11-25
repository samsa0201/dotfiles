function claude2 --wraps claude --description 'Claude Code, account 2 (Discord bot 2)'
    # Own bot: token from ~/.claude-acc2/channels/discord/.env, not the shared universal DISCORD_TOKEN.
    env -u DISCORD_TOKEN DISCORD_STATE_DIR=$HOME/.claude-acc2/channels/discord CLAUDE_CONFIG_DIR=$HOME/.claude-acc2 command claude --settings $HOME/.claude-acc2/discord.settings.json $argv
end
