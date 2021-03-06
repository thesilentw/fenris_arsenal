// zapmaster.zsc
//
//
Class ZapMaster : Actor {
	bool loggingEnabled;
	int maxLifetime, currentLifetime, flashInterval, flashCount;
	int lifetimeCountdown;
	
	property loggingEnabled : loggingEnabled;
	property maxLifetime : maxLifetime;
	property flashInterval : flashInterval;
	
	default {
		Radius 8;
		Height 8;
		+DONTGIB
		+NOINTERACTION
		+NOCLIP
		ZapMaster.loggingEnabled true;
		ZapMaster.maxLifetime 70;
		ZapMaster.flashInterval 3;
	}

	States {
		Spawn:
			TNT1 A 0 {
				flashCount = currentLifetime = lifetimeCountdown = 0;				
			}
			Goto MainLoop;

		MainLoop:
			TNT1 A 1 { // this state must take at least 1 tic to set the tracer's state correctly
				if (tracer) {
					tracer.setStateLabel("Pain");
					if (flashCount >= flashInterval) {
						tracer.A_SetTranslation("BlueLightning");
						flashCount = 0;
					}
					else {
						tracer.A_SetTranslation("Base");
						flashCount++;
					}
					return ResolveState(Null);
				}
				else return ResolveState("NullTracer");
			}
			TNT1 A 0 {
				if (currentLifetime > maxLifetime) {
					if (loggingEnabled) {Console.printf("ZapMaster lifetime exceeded, destroying");}
					return ResolveState("Death");
				}
				else {
					currentLifetime++;
					return ResolveState("WarpCheck");
				}
			}
			Goto Death;
		
		WarpCheck:
			TNT1 A 0 A_Warp(AAPTR_TRACER, flags: WARPF_NOCHECKPOSITION, success_state: "MainLoop", heightoffset: 0.5);
			Goto Death;
			
		NullTracer:
			TNT1 A 0 {
				if (loggingEnabled) {Console.printf("ZapMaster has null tracer, destroying");}
			}
			Goto Death;
			
		Death:
			TNT1 A 1 { //needs to be at least 1 tic for the remove to work
				A_SetInventory("ZapTracker", 0, AAPTR_TRACER);
				if (tracer.health < 1) {
					tracer.setStateLabel("Death");
				}
				tracer.A_SetTranslation("Base");
				if (loggingEnabled) {
					Console.printf("Removing ZapTracker from target");
				}
			}
			Stop;
	}
}
//eof