//
//
Class Lasrifle: FenrisWeapon {

	int heat, heatMax, steamLID;
	bool needsCooling;
	bool logging;
	
	property pr_heat : heat;
	property pr_heatMax : heatMax;
	property pr_steamLID : steamLID;
	property pr_needsCooling : needsCooling;
	property pr_logging : logging;
	
	default {
		inventory.pickupMessage "Looted a Laser Rifle!";
		weapon.slotNumber 6;
		weapon.SelectionOrder 4000;
		Weapon.AmmoUse 1;
		Weapon.AmmoGive 40;
		Weapon.AmmoType "Cell";
		Obituary "%k shootybang maek ded %o";
		Lasrifle.pr_heat 0;
		Lasrifle.pr_heatMax 1500;
		Lasrifle.pr_needsCooling false;
		Lasrifle.pr_steamLID -7000;
		Lasrifle.pr_logging true;
	}
	
	states {
		Spawn:
			TLGL A -1;
			Stop;
		Ready:
			TNT1 A 0 {
				if (invoker.heat >= invoker.heatMax) {
					return ResolveState("DoCooling");
				}
				else {
					return ResolveState("Idle");
				}
			}
		Idle:		
			LSRF A 1 {
				A_WeaponReady();
				if (invoker.heat > 0) {
					invoker.heat -= 5;
				}
			}
			Loop;
		Select:
			LSRF A 1 A_Raise();
			Loop;			
		Deselect:
			LSRF A 1 A_Lower();
			Loop;
		Fire:
			TNT1 A 0 {
				if (invoker.heat >= invoker.heatMax) {
					A_WeaponReady(WRF_NOFIRE);
					return ResolveState("DoCooling");
				}
				else {
					return ResolveState("DoFire");
				}
			}
		DoFire:
			TNT1 A 0 A_Jump(256, "DoFireF", "DoFireG", "DoFireH");
			Stop;
		DoFireF:
			LSRF F 2 {
				A_WeaponOffset(0, 34, WOF_INTERPOLATE);
				A_FireProjectile("LasrifleShot", angle: frandom((invoker.heat/-1000)-1, (invoker.heat/1000)+1), useammo: true, flags: FPF_NOAUTOAIM, pitch: frandom((invoker.heat/-1000)-1, (invoker.heat/1000)+1));
				//A_SetPitch(invoker.pitch + random(0, -0.2));
				//A_FireBullets(1, 1, 1, random(10,30));
				A_PlaySound("weapons/lsrf_fireold", CHAN_WEAPON);
				invoker.heat += 80;
				if (invoker.logging) Console.printf("SHOOTING, LASRIFLE HEAT IS %i", invoker.heat);
			}
			LSRF B 2 A_WeaponOffset(0, 33, WOF_INTERPOLATE);
			LSRF C 2 A_WeaponOffset(0, 32, WOF_INTERPOLATE);
			LSRF A 1 A_Refire("Fire");
			Goto Ready;
		
		DoFireG:	
			LSRF G 2 {
				A_WeaponOffset(0, 34, WOF_INTERPOLATE);
				A_FireProjectile("LasrifleShot", angle: frandom((invoker.heat/-1000)-1, (invoker.heat/1000)+1), useammo: true, flags: FPF_NOAUTOAIM, pitch: frandom((invoker.heat/-1000)-1, (invoker.heat/1000)+1));
				//A_SetPitch(invoker.pitch + random(0, -0.2));
				//A_FireBullets(1, 1, 1, random(10,30));
				A_PlaySound("weapons/lsrf_fireold", CHAN_WEAPON);
				invoker.heat += 80;
				if (invoker.logging) Console.printf("SHOOTING, LASRIFLE HEAT IS %i", invoker.heat);
			}
			LSRF B 2 A_WeaponOffset(0, 33, WOF_INTERPOLATE);
			LSRF C 2 A_WeaponOffset(0, 32, WOF_INTERPOLATE);
			LSRF A 1 A_Refire("Fire");
			Goto Ready;
		
		DoFireH:
			LSRF H 2 {
				A_WeaponOffset(0, 34, WOF_INTERPOLATE);
				A_FireProjectile("LasrifleShot", angle: frandom((invoker.heat/-1000)-1, (invoker.heat/1000)+1), useammo: true, flags: FPF_NOAUTOAIM, pitch: frandom((invoker.heat/-1000)-1, (invoker.heat/1000)+1));
				//A_SetPitch(invoker.pitch + random(0, -0.2));
				//A_FireBullets(1, 1, 1, random(10,30));
				A_PlaySound("weapons/lsrf_fireold", CHAN_WEAPON);
				invoker.heat += 80;
				if (invoker.logging) Console.printf("SHOOTING, LASRIFLE HEAT IS %i", invoker.heat);
			}
			LSRF B 2 A_WeaponOffset(0, 33, WOF_INTERPOLATE);
			LSRF C 2 A_WeaponOffset(0, 32, WOF_INTERPOLATE);
			LSRF A 1 A_Refire("Fire");
			Goto Ready;
			
		DoCooling: //48 tics
			TNT1 A 0 {
				A_Overlay(invoker.steamLID, "Steamjet", true);
				A_Playsound("weapons/lsrf_steamfade", CHAN_BODY);
			}
			LSRF B 5 A_WeaponOffset(3, 2, WOF_INTERPOLATE | WOF_ADD);
			LSRF D 3 A_WeaponOffset(3, 4, WOF_INTERPOLATE | WOF_ADD);
			LSRF DDDD 8 {
				if (invoker.heat > 0) {
					invoker.heat -= 250;
					if (invoker.logging) Console.printf("COOLING, LASRIFLE HEAT IS %i", invoker.heat);
				}
				else
					invoker.heat = 0;
			}
			LSRF D 5 A_WeaponOffset(-4, -2, WOF_INTERPOLATE | WOF_ADD);
			LSRF B 3 A_WeaponOffset(-2, -4, WOF_INTERPOLATE | WOF_ADD);
			TNT1 A 0 {
				invoker.needsCooling = false;
				return ResolveState("Ready");
			}
		Steamjet: //48 tics
			STPL A 4 {
				A_OverlayFlags(invoker.steamLID, PSPF_ADDWEAPON | PSPF_RENDERSTYLE | PSPF_ALPHA, true);
				A_OverlayAlpha(invoker.steamLID, 0.8);
				A_OverlayRenderstyle(invoker.steamLID, STYLE_Translucent);
				A_OverlayOffset(invoker.steamLID, 180, 90);
			}
			STPL BCDEFGHIJAB 4 {
				A_OverlayOffset(invoker.steamLID, (180 + frandom(-3, 3)), (90 + frandom(-2, 2)));
			}
			Stop;
	}
}

Class LasrifleShot : FastProjectile {
	default {
		Decal "DoomImpScorch";
		Radius 4;
		Height 4;
		Speed 70;
		DamageFunction random(35,55);
		DamageType "Laser";
		Scale 0.3;
		Projectile;
		RenderStyle "Add";
		Alpha 0.8;
		DeathSound "weapons/LSRF_impact";
		Obituary "%o got cored like an apple by %k's Laser Rifle.";
	}
	States {
		Spawn:
			LSBG ABCB 2;
			Loop;
		Death:
			LSBG ADEFG 2;
			Stop;
	}


}