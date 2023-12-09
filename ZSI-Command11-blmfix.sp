#include <sourcemod>
#include <sdktools>
#include <multicolors> 

#pragma newdecls required
#pragma semicolon 1

float g_fSeconds[MAXPLAYERS + 1];
ConVar gcv_WaitTime;

public Plugin myinfo =
{
    name = "ZSI-Command",
    author = "ArmadiLo",
    description = "Trigger to print link to the user chat",
    version = "1.0",
    url = "github.com/afaqih"
};

public void OnPluginStart()
{
    RegConsoleCmd("sm_discord", Command_discord);
    gcv_WaitTime = CreateConVar("sm_discord_command_wait_time", "5.0", "!discord Wait time");
    RegConsoleCmd("sm_steamgroup", Command_steam);
    gcv_WaitTime = CreateConVar("sm_steamgroup_command_wait_time", "5.0", "!steamgroup Wait time");
}

public void OnClientConnected(int client)
{
    g_fSeconds[client] = 0.0;
}

public void OnClientDisconnect(int client)
{
    g_fSeconds[client] = 0.0;
}

public Action Command_discord(int client, int args)
{
    if (IsClientInGame(client) && !IsFakeClient(client))
    {
    	if (args > 0)
	{
	
	CPrintToChat(client, "{gray}[{green}ZSI{gray}] {white}Wrong command, usage {purple}!discord {white}without numbers or anything");
	return Plugin_Handled;
}
        if (g_fSeconds[client] > 0.0)
        {
            CPrintToChat(client, "{lightgreen}You need to wait {green}%f {lightgreen}more time to use this command.", g_fSeconds[client]);
        }
        else
        {
            CPrintToChatAll("{gray}[{green}ZSI{gray}] {green}Discord {lightgreen}Group : {white}https://discord.gg/QUQMAbXX5b");
        }
        
        g_fSeconds[client] = GetConVarFloat(gcv_WaitTime);
        CreateTimer(1.0, Timer_Cooldown, client, TIMER_REPEAT);
    }
    return Plugin_Handled;
}

public Action Timer_Cooldown(Handle timer, any data)
{
    int client = data;
    if (g_fSeconds[client] > 0.0)
    {
        g_fSeconds[client]--;
    }
    else
    {
        return Plugin_Stop;
    }
    return Plugin_Continue;
} 

public Action Command_steam(int client, int args)
{
    if (IsClientInGame(client) && !IsFakeClient(client))
    {
    	if (args > 0)
	{
	CPrintToChat(client, "{gray}[{green}ZSI{gray}] {white}Wrong command, usage {purple}!discord {white}without numbers or anything");
	return Plugin_Handled;
}
        if (g_fSeconds[client] > 0.0)
        {
            CPrintToChat(client, "{lightgreen}You need to wait {green}%f {lightgreen}more time to use this command.", g_fSeconds[client]);
        }
        else
        {
            CPrintToChatAll("{gray}[{green}ZSI{gray}] {green}Steam {lightgreen}Group : {white}https://steamcommunity.com/groups/offlinersv");
        }
        g_fSeconds[client] = GetConVarFloat(gcv_WaitTime);
        CreateTimer(1.0, Timer_Cooldown, client, TIMER_REPEAT);
    }
    return Plugin_Handled;
}

