// THUMPER
Class Thumper : FenrisWeapon {

	bool isLoaded;
	
	property loaded: isLoaded;
	
	default {
		Inventory.pickupMessage "You respectfully cradle the beautiful bulk of a Thumper.";
		Weapon.slotNumber 5;
		Weapon.selectionOrder 5000;
		//Weapon.ammoType1 "ThumperMag";
		//Weapon.ammoUse1 0;
		//Weapon.ammoGive1 0;
		Weapon.ammoType "RocketAmmo";
		Weapon.ammoUse 0;
		Weapon.ammoGive 6;
		Weapon.bobRangeX 0.4;
		Weapon.bobRangeY 0.3;
		+Weapon.NODEATHINPUT;
		//+Weapon.ammo_Optional;
		//+Weapon.ammo_CheckBoth;
		Obituary "%o got blooped by %k's Thumper.";
		Thumper.loaded false;
	}
	
	states {
		Spawn:
			TLGL A -1; //no pickup sprite yet
			Stop;
		Ready:
			TNT1 A 0 {
				if (invoker.isLoaded) return ResolveState("Idle");
				else return ResolveState("IdleEmpty");
			}	
		Select:
			TNT1 A 0 {
				if (invoker.isLoaded) return ResolveState("Raise");
				else return ResolveState("RaiseEmpty");
			}
		Deselect:
			TNT1 A 0 {
				if (invoker.isLoaded) return ResolveState("Lower");
				else return ResolveState("LowerEmpty");
			}
		Idle:
			THMP A 1 A_WeaponReady();
			Loop;
		IdleEmpty:		
			THMP B 1 A_WeaponReady();
			Loop;
		Raise:
			THMP A 1 A_Raise();
			Loop;
		RaiseEmpty:		
			THMP B 1 A_Raise();
			Loop;
		Lower:
			THMP A 1 A_Lower();
			Loop;
		LowerEmpty:		
			THMP B 1 A_Lower();
			Loop;	
		Fire:
			TNT1 A 0 {
				if (invoker.isLoaded) return ResolveState("FireGrenade");
				else return ResolveState("Load");
			}
		FireGrenade:
			THMP C 3 {
				A_FireProjectile("ThumperGrenade",0,1,0,0,0,-1);
				A_PlaySound("weapons/thumper_fireamped", CHAN_WEAPON);
				invoker.isLoaded = false;
				A_WeaponOffset(0, 48, WOF_INTERPOLATE);
				}
			THMP D 3 A_WeaponOffset(-2, 48, WOF_INTERPOLATE);
			THMP B 8;
			THMP B 6 A_WeaponOffset(0, 48, WOF_INTERPOLATE);
			THMP B 2 A_WeaponOffset(0, 44, WOF_INTERPOLATE);
			THMP B 3 A_WeaponOffset(0, 39, WOF_INTERPOLATE);
			THMP B 3 A_WeaponOffset(0, 37, WOF_INTERPOLATE);
			THMP B 4 A_WeaponOffset(0, 32, WOF_INTERPOLATE);
			Goto Ready;
		Load:
			TNT1 A 0 {
				if (CountInv("RocketAmmo") < 1) {
					return ResolveState("NoAmmo");
				}
				else {
					return ResolveState(null);
				}
			}
			THMP B 10 {
				A_WeaponReady(WRF_NOBOB | WRF_NOFIRE | WRF_NOSWITCH);
				A_WeaponOffset(5, 48, WOF_INTERPOLATE);
				A_PlaySound("weapons/thumper_reloadshort", CHAN_BODY);
			}
			THMP B 5 A_WeaponOffset(0, 44, WOF_INTERPOLATE);
			TNT1 A 0 {
				invoker.isLoaded = true;
				A_TakeInventory("RocketAmmo", 1);
			}
			THMP A 1 A_WeaponReady(WRF_NOBOB);
			THMP A 8 A_WeaponOffset(0, 32, WOF_INTERPOLATE);
			Goto Ready;
		NoAmmo:
			THMP B 1 {
				//A_WeaponOffset(-2, 33, WOF_INTERPOLATE);
				A_PlaySound("weapons/noammo");
			}
			THMP B 1; //A_WeaponOffset(0, 33, WOF_INTERPOLATE);
			THMP B 1; //A_WeaponOffset(0, 32, WOF_INTERPOLATE);
			THMP B 15;
			Goto Ready;
	}
}

Class ThumperGrenade : Actor {
	
	default {
		Radius 16;
        Height 16;
        Speed 35;
        Scale 1.2;
        Damage 50;
        Gravity 0.80;
        DamageType "Explosive";
        Projectile;
		-NOGRAVITY
		+BOUNCEONWALLS
		+BOUNCEONCEILINGS
		+FORCEXYBILLBOARD;
		Obituary "%o acknowledges %k's mastery of the bloop tube.";
		DeathSound "weapons/thumper_explosionamped";
	}
	
	States {
		Spawn:
			SGRN A 1;
			Loop;
		Death:
			THXP ABCDEFGH 2 A_Explode(50,96);
			Stop;
	}
}