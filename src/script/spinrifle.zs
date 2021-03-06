// Karbunkl Kinetics Model 23 "волчо́к" / "Spinner"
// New this year from Karbunkl, the Model 23 is a solid iteration in KK's line of
// kinetic-kill weapons. Nothing fancy here- just a well-designed rifle that uses
// nothing more than centrifugal force to fling a ultra-low-velocity 20mm alloy
// projectile clean through your target. The proprietary composition of the projectile
// means you to make banked and ricochet shots with ease, scoring hits on your enemies
// no matter where they hide.
//
// Karbunkl Kinetics - "победа через Энергия!" - "Victory Through Inertia!"
//
Class Spinrifle : FenrisWeapon {
	
	default {
		inventory.pickupMessage "Snagged a Spinner!";
		weapon.ammoType "Clip";
		weapon.ammoUse 1;
		weapon.slotNumber 3;
		weapon.SelectionOrder 3000;
		weapon.ammoGive 20;
		weapon.upSound "weapons/sprf_deploy";
	}
	
	States {		
		Ready:
			TNT1 A 0 A_WeaponOffset(0, 32);
			SPRF A 1 A_WeaponReady();
			Loop;
		
		Select:
			SPRF A 1 A_Raise();
			Loop;
		
		Deselect:
			SPRF A 1 {
				A_StopSound(CHAN_WEAPON);
				A_Lower();
			}
			Loop;
		
		Fire:
			SPRF A 1 A_WeaponOffset(0, 38, WOF_INTERPOLATE);
			SPRF B 2 A_WeaponOffset(0, 42, WOF_INTERPOLATE);
			TNT1 A 0 {
				A_StopSound(CHAN_WEAPON);
				A_FireProjectile("SpinShot", 1, 1);
				A_PlaySound("weapons/sprf_fire");
			}
			SPRF C 4 A_WeaponOffset(0, 43, WOF_INTERPOLATE);
			SPRF B 4 A_WeaponOffset(0, 40, WOF_INTERPOLATE);
			SPRF A 3 A_ReFire("AutoFireStart");
			Goto Recovery;
			
		Recovery:
			TNT1 A 0 {
				A_StopSound(CHAN_WEAPON);
				A_PlaySound("weapons/sprf_fireend", CHAN_AUTO);
			}
			SPRF E 3 A_WeaponOffset(0, 35, WOF_INTERPOLATE);
			SPRF F 3 A_WeaponOffset(0, 33.5, WOF_INTERPOLATE);
			SPRF G 3 A_WeaponOffset(0, 32, WOF_INTERPOLATE);
			Goto Ready;
		
		AutoFireStart:
			TNT1 A 0 A_PlaySound("weapons/sprf_fireloop", CHAN_WEAPON, 1.0, true);
			Goto AutoFire;
		
		AutoFire:
			SPRF C 2 A_WeaponOffset(0, 42, WOF_INTERPOLATE);
			TNT1 A 0 A_FireProjectile("SpinShot", 1, 1, 0.0, 9);
			SPRF D 2 A_WeaponOffset(0, 38, WOF_INTERPOLATE);
			SPRF C 1 A_WeaponOffset(0, 39, WOF_INTERPOLATE);
			TNT1 A 0 A_ReFire("AutoFire");
			Goto Recovery;
		
		Spawn:
			TLGL A -1;
			Stop;
	}
}

Class SpinShot : Actor {
	default {
		Obituary "%o got spun right 'round  by %k's Spinner.";
		Decal "BulletChip";
		Radius 5;
		Speed 80;
		Damage 10;
		Gravity 1;
		BounceFactor 0.99;
		BounceCount 5;
		Scale 0.3;
		Projectile;
		Alpha 0.9;
		BounceType "Hexen";
		//DeathSound "weapons/sprf_hit";
		BounceSound "weapons/sprf_ricochet";
	}
	States {
		Spawn:
			SPBL A 3;
			SPBL B 3;
			SPBL C 3;
			SPBL D 3;
			Loop;
		Death:
			SPBL EFG 3;
			Stop;
	}
}