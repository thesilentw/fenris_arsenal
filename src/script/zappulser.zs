// zappulser.zsc
//
//
Class ZapPulser : Actor {
	BlockThingsIterator nearbyActors;
	Actor testActor;
	bool loggingEnabled;
	
	property loggingEnabled : loggingEnabled;
	
	default {
	    Radius 8;
        Height 8;
		+NOINTERACTION;
		+NOCLIP;
		ZapPulser.loggingEnabled true;
	}
	
	States {
		Spawn:
			TNT1 A 0 {
				if (!tracer) {
					return ResolveState("NullTracer");
				}
				master = target = players[consoleplayer].mo;				
				return ResolveState("Null");
			}
				
		MainLoop:
			TNT1 A 20 {
				if (!tracer) {
					return ResolveState("NullTracer");
				}
				if (CountInv("ZapTracker", AAPTR_TRACER) > 0) {
					return ResolveState("DoPulse");
				}
				else {
					return ResolveState("Expire");
				}
			}
			
		DoPulse:
			TNT1 A 20 {
				if (tracer) {
					nearbyActors = BlockThingsIterator.Create(tracer, 192);
					while (nearbyActors.Next()) {
						if (CheckSight(nearbyActors.thing, 0)) {
							SpawnMissile(nearbyActors.thing, "ZapPulseBouncer");
						}
					}
					return ResolveState("Null");
				}
				else {
					Console.printf("invalid tracer for pulse, expiring");
					return ResolveState("Expire");
				}
			}
			Goto WarpCheck;
		
		WarpCheck:
			TNT1 A 0 A_Warp(AAPTR_TRACER, flags: WARPF_NOCHECKPOSITION, success_state: "MainLoop", heightoffset: 0.5);

		Expire:
			TNT1 A 0 {
				if (loggingEnabled) {Console.printf("ZapPulser can't find ZapTracker, destroying");}
			}
			Stop;
				
		NullTracer:
			TNT1 A 0 {
				if (loggingEnabled) {Console.printf("ZapPulser has null tracer, destroying");}
			}
			Stop;
    }
}

Class ZapPulseBouncer : Actor {

	default {
		Decal "Scorch";
		Radius 8;
		Speed 35;
		Damage 40;
		Gravity 0;
		BounceFactor 0.99;
		BounceCount 2;
		Scale 0.4;
		Projectile;
		Alpha 0.9;
		RenderStyle "Add";
		BounceType "Hexen";
		+BOUNCEONACTORS;
		MissileType "ZapPulseBouncerTrail";
		+HITOWNER;
		//DeathSound "weapons/sprf_hit";
		//BounceSound "weapons/sprf_ricochet";
	}
	States {
		Spawn:
			LTLP ABC 3;
			Loop;
		Death:
			LTXL ABCDEFG 3; //A_Explode(128,64);
			Stop;
	}
}

class ZapPulseBouncerTrail : Actor {
   default {
      RenderStyle "Add";
      Scale 0.15;
      Alpha 0.5;
      //Translation "160:167=192:199", "64:79=197:201";
      +BRIGHT
      +NOINTERACTION
   }
   states {
   Spawn:
      LTLP ABC 1 A_FadeOut(0.05);
      wait;
   }
}