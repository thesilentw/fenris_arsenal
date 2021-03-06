/* My next guests need little introduction. Hailing from the farthest north, the brainiacs at Raptor Labs
have a reputation for doing what others can't or won't.

Enter the last word in crowd control - The Raptor Labs Static Cannon.
Give your enemies the world's worst case of static cling...


HOW IT WORKY

CURRENT VERSION
	Uncharged shoots a wide spray of lightning that stuns everythng it hits. At the end of the stun, the enemies each launch a seeker bolt.
	
	Charged shoots a more focused spray of lighting that stuns everything it hits, and the stunned enemies pulse out additional lightning bolts every so often, before exploding.



VERSION 2	
	You can shoot charged or uncharged projectiles.
	Uncharged projectiles only explode, but you can rapidly tap-fire them.
	Charged projectiles explode and spawn seekers.
	
	Uncharged projectiles give their target ActorHasStaticCharge.
	This custominventory stuns the enemy for a time.
	On completion of the timer, it explodes, and zaps enemies around it, stunning them. They will not explode, though.
	
	Charged projectiles give their target ActorHasStaticChargeMega.
	This custominventory stuns the enemy for a time, and fires seekers every so often into the enemies around it.
	On completion of the timer, it explodes, and zaps enemies around it for pure damage.
	
VERSION 1
	Shooting fires LGTracer, which does a RadiusGive of GiveActorStaticCharge.
	GiveActorStaticCharge spawns ActorHasStaticCharge, which continuously warps to its owner and fires StunnerProjectiles to keep the owner stunned.
	Once ActorHasStaticCharge expires, it gives its target ActorStaticDischarge.
	ActorStaticDischarge finds out how many actors are nearby, and then explodes, multiplying its damage by the number of nearby enemies.
	ActorStaticDischarge also launches seekers out that zap nearby enemies depending on the explosion damage that the actor got.
*/ 
Class LightningGun: FenrisWeapon {	
	
	int charge, chargeMax, vfxlid, shake;

	property chargeAmt : charge;
	property chargeMaxAmt : chargeMax;
	property vfxLayerId : vfxlid;
	
	default {
		inventory.pickupMessage "Lifted a Static Cannon!\nSeriously, lifting it alone is enough of a challenge. Shooting is extra.";
		weapon.slotNumber 7;
		weapon.SelectionOrder 7000;
		Weapon.AmmoUse 1;
		Weapon.AmmoGive 40;
		Weapon.AmmoType "Cell";
		Obituary "%k has successfully proved to %o that nothing is grounded when the current runs high enough.";
		LightningGun.chargeAmt 0;
		LightningGun.chargeMaxAmt 10;
		LightningGun.vfxLayerId -8000;
	}
	
	states {
		Ready:
			LITE A 1 A_WeaponReady();
			Loop;
		
		Select:
			LITE A 1 A_Raise();
			Loop;
		
		Deselect:
			LITE A 1 A_Lower();
			Loop;
		
		Fire:
			LITE A 4 {
				A_WeaponReady(WRF_NOBOB | WRF_NOFIRE);
				A_PlaySound("weapons/lgun_chargeloop", CHAN_WEAPON | CHAN_NOSTOP, looping: true);
				A_WeaponOffset(0, 32, WOF_INTERPOLATE);
			}
			TNT1 A 0 {
				A_Overlay(-8000, "ChargeVFX", true);
				invoker.charge = 1;
				A_Refire("Charging");
			}
			Goto Quickfire;
		
		Charging:
			TNT1 A 0 {
				if (invoker.charge < invoker.chargeMax) {
					return ResolveState("AccumulateCharge");
				}
				if (invoker.charge >= invoker.chargeMax) {
					return ResolveState("ChargedFire");
				}
				else return ResolveState("Quickfire");
			}
	
		Quickfire:
			TNT1 A 0 A_ClearOverlays((invoker.vfxlid+1), (invoker.vfxlid-1));
			LITE B 3 {
				A_WeaponReady(WRF_NOBOB | WRF_NOFIRE);
				A_WeaponOffset(0, 5, WOF_ADD | WOF_INTERPOLATE);
				A_PlaySound("weapons/lgun_fire", CHAN_WEAPON);
				
				A_FireProjectile("LGSeeker", angle: frandom(-4,4), useammo: false, flags: FPF_NOAUTOAIM, pitch: frandom(-4,4));
				A_FireProjectile("LGSeeker", angle: frandom(-4,4), useammo: false, flags: FPF_NOAUTOAIM, pitch: frandom(-4,4));
				A_FireProjectile("LGSeeker", angle: frandom(-4,4), useammo: false, flags: FPF_NOAUTOAIM, pitch: frandom(-4,4));
				A_FireProjectile("LGSeeker", angle: frandom(-4,4), useammo: false, flags: FPF_NOAUTOAIM, pitch: frandom(-4,4));				
				A_FireProjectile("LGTracerWimpy", 0, useammo: false); // no ammo yet
				
				invoker.charge = 0;	
			}
			LITE A 15 {
				A_PlaySound("weapons/lgun_rechargebeep", CHAN_6);
				A_WeaponOffset(0, -5, WOF_ADD | WOF_INTERPOLATE);
			}
			LITE A 35;
			Goto Ready;
			
		ChargedFire:
			TNT1 A 0 A_ClearOverlays((invoker.vfxlid+1), (invoker.vfxlid-1));
			LITE B 3 A_WeaponReady(WRF_NOBOB | WRF_NOFIRE);
			LITE C 2 {
				A_WeaponOffset(0, 5, WOF_ADD | WOF_INTERPOLATE);
				A_PlaySound("weapons/lgun_fire", CHAN_WEAPON);
				
				A_FireProjectile("LGSeeker", angle: frandom(-4,4), useammo: false, flags: FPF_NOAUTOAIM, pitch: frandom(-4,4));
				A_FireProjectile("LGSeeker", angle: frandom(-4,4), useammo: false, flags: FPF_NOAUTOAIM, pitch: frandom(-4,4));
				A_FireProjectile("LGSeeker", angle: frandom(-4,4), useammo: false, flags: FPF_NOAUTOAIM, pitch: frandom(-4,4));
				A_FireProjectile("LGSeeker", angle: frandom(-4,4), useammo: false, flags: FPF_NOAUTOAIM, pitch: frandom(-4,4));
				A_FireProjectile("LGSeeker", angle: frandom(-4,4), useammo: false, flags: FPF_NOAUTOAIM, pitch: frandom(-4,4));
				A_FireProjectile("LGSeeker", angle: frandom(-4,4), useammo: false, flags: FPF_NOAUTOAIM, pitch: frandom(-4,4));
				A_FireProjectile("LGSeeker", angle: frandom(-4,4), useammo: false, flags: FPF_NOAUTOAIM, pitch: frandom(-4,4));				
				A_FireProjectile("LGTracer", 0, useammo: false); // no ammo yet
				
				invoker.charge = 0;
			}
			LITE A 3 {
				A_WeaponOffset(0, 3, WOF_ADD | WOF_INTERPOLATE);
				A_PlaySound("weapons/lgun_rechargebeep", CHAN_6);
			}
			LITE A 12 A_WeaponOffset(0, -8, WOF_ADD | WOF_INTERPOLATE);
			LITE A 35;
			Goto Ready;
		
		AccumulateCharge:
			TNT1 A 0 {
				invoker.charge++;
				A_Overlay(invoker.vfxlid, "ChargeVFX", true);
				invoker.shake = (invoker.charge * 0.5) + 2;
			}
			LITE D 2 A_WeaponOffset(invoker.shake, 0, WOF_ADD | WOF_INTERPOLATE);
			LITE D 2 A_WeaponOffset(-invoker.shake, invoker.shake, WOF_ADD | WOF_INTERPOLATE);
			LITE D 2 A_WeaponOffset(invoker.shake, -invoker.shake, WOF_ADD | WOF_INTERPOLATE);
			LITE D 2 A_WeaponOffset(-invoker.shake, 0, WOF_ADD | WOF_INTERPOLATE);
			TNT1 A 0 A_Refire("Charging");
			Goto ChargedFire;
		
		ChargeVFX:
			LSTR A 1 {
				A_OverlayFlags(invoker.vfxlid, PSPF_ADDWEAPON | PSPF_RENDERSTYLE | PSPF_ALPHA, true);
				//A_OverlayAlpha(invoker.vfxlid, 0.9);
				//A_OverlayRenderstyle(invoker.vfxlid, STYLE_Translucent);
				A_OverlayOffset(invoker.vfxlid, 132, 91);	
			}
			LSTR BCDEFGH 1 {
				//A_OverlayOffset(invoker.vfxlid, (180+random(-7,7)), (65+random(-5,5)) );
			}
			Stop;	
			
		Spawn:
			TLGL A -1;
			Stop;
	}
}

class LGTracer : FastProjectile {

	default {
		Radius 8;
		Height 8;
		Speed 60;
		Damage 0;
		Projectile;
		+FORCEPAIN;
		+HITTRACER; // sets the thing it hits to AAPTR_TRACER
	}
	
	States {
		Spawn:
			TNT1 A 1;
			Loop;
		Death:
			TNT1 A 0; //A_JumpIfInventory("StaticChargeActive", 1, "ExtendCharge", AAPTR_TRACER);
			TNT1 A 0 A_Warp(AAPTR_TRACER, flags: WARPF_NOCHECKPOSITION, success_state: "GiveItem", pitch: 0.5);
			Stop;
		XDeath:
			Goto Death;
		ExtendCharge:
			TNT1 A 0; //A_GiveInventory("StaticChargeActive", 1, AAPTR_TRACER);
			Stop;
		GiveItem:
			//TNT1 A 0 A_RadiusGive("GiveActorStaticCharge", 128, RGF_MONSTERS, 1);
			TNT1 A 0 {
				A_SpawnItemEx("ActorHasStaticCharge", flags: SXF_NOCHECKPOSITION | SXF_TRANSFERPOINTERS);
				A_SpawnItemEx("ActorStaticVFX", flags: SXF_NOCHECKPOSITION | SXF_TRANSFERPOINTERS);
			}
			Stop;
	}
}

class LGTracerWimpy : LGTracer {

}

class LGSeeker : FastProjectile {
	
	default {
		Radius 8;
		Height 8;
		Speed 60;
		Damage 15;
		Projectile;
		//+FORCEPAIN;
		//+HITTRACER; // sets the thing it hits to AAPTR_TRACER
		+SEEKERMISSILE;
		+SCREENSEEKER;
		//Decal "BulletChip";
		MissileType "SeekerTrail";
	}
	
	States {
		Spawn:
			//FWDP A 1 Bright;
			TNT1 A 0 A_SeekerMissile(2, 20, SMF_LOOK | SMF_PRECISE, 100);
			TNT1 A 1 A_SpawnItemEx("LTrail");
			Loop;
		Death:
			TNT1 A 0; //A_JumpIfInventory("StaticChargeActive", 1, "ExtendCharge", AAPTR_TRACER);
			//TNT1 A 0 A_Warp(AAPTR_TRACER, flags: WARPF_NOCHECKPOSITION, success_state: "GiveItem", pitch: 0.5);
			Stop;
		XDeath:
			Goto Death;
	}
}

class LTrail : Actor {
   default {
      RenderStyle "Add";
      Scale 0.3;
      Alpha 0.5;
      Translation "160:167=192:199", "64:79=197:201";
      +BRIGHT
      +NOINTERACTION
   }
   states {
   Spawn:
      LTLP ABC 1 A_FadeOut(0.05);
      wait;
   }
}


class GiveActorStaticCharge : CustomInventory {
    States {
		Pickup:
			TNT1 A 0 {
				//A_SpawnItemEx("ActorStaticVFX",0,0,0,0,0,0,0,SXF_NOCHECKPOSITION | SXF_SETTRACER);
				A_SpawnItemEx("ActorHasStaticCharge", flags: SXF_NOCHECKPOSITION | SXF_TRANSFERPOINTERS);
				Console.printf("GiveActorStaticCharge finished pickup state, destroying");
			}
			stop;
    }
}

class ActorHasStaticCharge : Actor {
	
	int chargeLifetime, slowDuration, stunDuration, baseDamage;

    default {
		
		+NOINTERACTION;
		+NOCLIP;
    }

    override void BeginPlay() {
		chargeLifetime = 0; // track how long it's been alive
		slowDuration = 105; //3 seconds in tics
		stunDuration = 70; // 2 seconds in tics
		baseDamage = 15;
	}

    States {
		Spawn:
		SpawnLoop:
			TNT1 A 1 {
				//A_SpawnParticle(33ff33, SPF_FULLBRIGHT | SPF_RELATIVE, random(35,105), random(1,10), frandom(0,360), random(-50,50),random(-50,50),random(-50,50), 0,0,0, 0,0,frandom(-0.25,0.25), 0.5, -1);
			}
			TNT1 A 0 {
				statelabel nextstate = "SpawnLoop";
				if (tracer == NULL) {
					return ResolveState("DeathNull");
				}
				if (tracer.health <= 0) {
					return ResolveState("Death");
				}
				A_Warp(AAPTR_TRACER);
				//A_StopSound(CHAN_WEAPON);
				chargeLifetime++;
				if ((chargeLifetime <= stunDuration) && (tracer)) {
					tracer.setStateLabel("Pain");
					
					//A_SpawnProjectile("StunProj", 0, 0, 0, CMF_AIMDIRECTION | CMF_TRACKOWNER, 0, AAPTR_TRACER);
					// This stuns, and because there is only one tic at the start of the loop,
					// the monster never gets to play a painsound.
					// This is probably not intended behavior.
				}
				else {
					nextstate = "Death";
				}
				return ResolveState(nextstate);
			}
			stop;
		
		Death:
		TNT1 A 1 {
				int blastradius = 256;
				int radiustracker = 0;
				Actor testActor;
				BlockThingsIterator list = BlockThingsIterator.Create(self, 256);
				list.next();
				do {
					testActor = list.thing;
					if (testActor.bIsMonster)  {
						if ( (Distance2D(testActor) < blastradius) && CheckSight(testActor) ) {
							radiustracker++;
						}
					}
				} while (list.next());
				int totalDamage = radiusTracker*baseDamage;
				A_Explode(totaldamage, 92);
				Console.printf("ActorHasStaticCharge destroying - Will catch target + %i monsters, doing %i damage to each", radiusTracker, totalDamage);
			}
			stop;	
		
		DeathNull: //if we have a null tracer
			TNT1 A 0 {
				Console.printf("ActorHasStaticCharge destroyed, null tracer");
			}
			stop;
    }
}

class ActorHasStaticChargeMega : ActorHasStaticCharge {}

class ActorStaticVFX : Actor {
	int randomx, randomy, randomz;
    int lifetime, lifecheck;

    default {
        Radius 8;
        Height 8;
        Scale 0.85;
        Alpha 0.85;
        RenderStyle "Add";
        +NOBLOCKMAP;
        +NOGRAVITY;
        +FORCEXYBILLBOARD;
    }

    override void BeginPlay() {
        lifecheck = 0;
        lifetime = 35;
    }

    States {
		Spawn:
			TNT1 A 1;
			TNT1 A 0 {
				if (!tracer) {
					return ResolveState("SpawnEnd");
				}
				else if (tracer.health > 0) {
					A_PlaySound("weapons/lgun_elecloop", CHAN_7, looping: true);
					randomx = frandom((-tracer.radius * 0.05), (tracer.radius * 0.05));
					//frandom((tracer.radius / 1.5), (tracer.radius / 1.5));
					randomy = frandom((-tracer.radius * 0.05), (tracer.radius * 0.05));
					randomz = frandom((tracer.height * 0.52), (tracer.height * 0.57));
				}
				else {
					return ResolveState("SpawnEnd");
				}
				return ResolveState(Null);
			}
			
		SpawnLoop:
			LTXS ABCDEF 2 BRIGHT {
				if (!tracer) {
					return ResolveState("SpawnEnd");
				}
			    A_Warp(AAPTR_TRACER,randomx,randomy,randomz,0,WARPF_NOCHECKPOSITION | WARPF_INTERPOLATE);
			    lifecheck += 1;
			    if (lifecheck >= lifetime) {
					return ResolveState("SpawnEnd");
				}
			    if (tracer.health <= 0) {
					return ResolveState("SpawnEnd");
				}
				return ResolveState(Null);
			}
			loop;
		
		SpawnEnd:
			LTXS ABCDE 1 Bright;
			LTXS F 1 Bright A_StopSound(CHAN_7);
			stop;
    }
}

/*
class StunProj : Actor {
	default {
		Radius 6;
		Height 6;
		Speed 5;
		Damage 0;
		Projectile;
		+FORCEPAIN
	}
	States {
		Spawn:
			TNT1 A 1;
			Loop;
		Death:
			TNT1 A 1;
			Stop;
	}
}

Class StaticChargeActive : Powerup {
	Default {
		+INVENTORY.ADDITIVETIME;
		Powerup.Duration 70;
	}
}

class ActorHasStaticCharge_AA : Actor {
	
	int chargeLifetime, chargeDuration, slowDuration, stunDuration, baseDamage, radiusTracker;
	
	override void BeginPlay() {
		chargeLifetime = 0; // track how long it's been alive
		chargeDuration = 105;
		
		slowDuration = 105; //3 seconds in tics
		stunDuration = 35; // 2 seconds in tics
		baseDamage = 25;
		radiusTracker = 0;
	}	
	
	default {
		Radius 6;
		Height 6;
		RenderStyle "Add";
		Alpha 0.95;
		+FORCEXYBILLBOARD;
		+NOINTERACTION;
		+NOCLIP;
	}
    States {
		Spawn:
			TNT1 A 0;
			TNT1 A 0 A_GiveInventory("StaticChargeActive", 1, AAPTR_TRACER);
			Goto StunLoop;
		StunLoop:
			TNT1 A 1 A_SpawnProjectile("StunProj", 0, 0, 0, CMF_AIMDIRECTION | CMF_TRACKOWNER, 0, AAPTR_TRACER);
			// above has to be long because it needs all 0s to work
			TNT1 A 0 A_JumpIfInventory("StaticChargeActive", 1, "StunLoopWarpCheck", AAPTR_TRACER);
			//TNT1 A 0 A_StopSound(CHAN_WEAPON);
			Goto Death;
			//Stop;
		StunLoopWarpCheck:
			TNT1 A 0 A_Warp(AAPTR_TRACER, flags: WARPF_NOCHECKPOSITION, success_state: "StunLoop", pitch: 0.5);
			//TNT1 A 0 A_StopSound(CHAN_WEAPON);
			Goto Death;
			//Stop;
		Death:
			TNT1 A 10 {
				int blastradius = 256;
				Actor testActor;
				BlockThingsIterator list = BlockThingsIterator.Create(self, 256);
				while (testActor = list.thing) {
					if ( (Distance2D(testActor) < blastradius) && CheckSight(testActor) ) {
						radiustracker++;
					}
					list.next();
				}
				//radiusTracker = A_Explode(0, 256);
				int totalDamage = (radiusTracker+1)*baseDamage;
				A_Explode(totaldamage, 256);
				Console.printf("ActorHasStaticCharge_AA destroying - Will catch target + %i monsters, doing %i damage to each", radiusTracker, totalDamage);
			}
			Stop;
    }
}
*/
//
