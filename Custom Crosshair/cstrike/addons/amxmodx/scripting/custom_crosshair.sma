#include <amxmodx>
#include <cstrike>

#define PLUGIN "Custom Crosshair"
#define VERSION "1.6"
#define AUTHOR "tuty, Igoreso, Connor McLeod & hellmonja"

#define HUD_HIDE_CROSS (1<<6)
#define HUD_DRAW_CROSS (1<<7)

new iMsgCrosshair, g_msgHideWeapon;
new cvar_enabled, cvar_zoom4, cvar_snipers, cvar_knife;

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR);
	register_event("CurWeapon", "Event_CurWeapon", "be", "1=1");
	
	iMsgCrosshair = get_user_msgid("Crosshair");
	g_msgHideWeapon = get_user_msgid("HideWeapon");
	
	cvar_enabled = register_cvar("custom_cross_enable", "1");
	cvar_zoom4 = register_cvar("custom_cross_zoom4", "0");
	cvar_snipers = register_cvar("custom_cross_snipers", "0");
	cvar_knife = register_cvar("custom_cross_knife", "0");
}

public plugin_precache()
{
	precache_generic("sprites/observer.txt");
	precache_generic("sprites/csgo_crosshair_32.spr");
	precache_generic("sprites/csgo_crosshair_64.spr");
}

public Event_CurWeapon(id)
{
	new wpn = read_data(2), cvar = get_pcvar_num(cvar_enabled);

	if(cvar != 0 && cvar != 1)
	{
		Zoom4_CrossHair(id, 0);
		client_print(id, print_center, "Invalid value. Please set 'custom_cross_enable' to either '0' or '1'");
		return
	}
	
	if(wpn == CSW_KNIFE)
	{
		if(get_pcvar_num(cvar_knife) == 0)
		{
			Hide_NormalCrosshair(id, cvar);
			show_crosshair(id, 0);
			return
		}
	}
	
	if(get_pcvar_num(cvar_snipers) == 0)
	{
		if(wpn != CSW_AWP && wpn != CSW_SCOUT && wpn != CSW_G3SG1 && wpn != CSW_SG550)
		{
			Zoom4_CrossHair(id, cvar);
		}
	}
	else
	{
		if(cs_get_user_zoom(id) != 2 && cs_get_user_zoom(id) != 3)
			Zoom4_CrossHair(id, cvar);
	}
}

stock Zoom4_CrossHair(id, flag)
{
	if(get_pcvar_num(cvar_zoom4) == 0)
	{
		if(cs_get_user_zoom(id) != 4)
		{
			Hide_NormalCrosshair(id, flag);
			show_crosshair(id, flag);
		}
	}
	else
	{
		Hide_NormalCrosshair(id, flag);
		show_crosshair(id, flag);
	}

}

stock Hide_NormalCrosshair(id, flag)
{
	if(flag == 1)
	{
		message_begin(MSG_ONE, g_msgHideWeapon, _, id);
		write_byte(HUD_HIDE_CROSS);
		message_end();
	}
	else
	{
		message_begin(MSG_ONE, g_msgHideWeapon, _, id);
		write_byte(HUD_DRAW_CROSS);
		message_end();
	}
}

stock show_crosshair(id, flag)
{
	message_begin(MSG_ONE_UNRELIABLE, iMsgCrosshair, _, id);
	write_byte(flag);
	message_end();
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1033\\ f0\\ fs16 \n\\ par }
*/
