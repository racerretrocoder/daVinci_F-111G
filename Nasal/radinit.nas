# INIT radar2.nas



var closebay = func() {
    setprop("controls/baydoors/AIM120locked",0);
    baydoortimer.stop();
}

baydoortimer = maketimer(1,closebay);


var fire = func(a,b) {
    print(a);
    print(b);
    setprop("controls/baydoors/AIM120locked",1);
    baydoortimer.start();
}
myRadar = radar.Radar.new();
myRadar.init();


setprop("instrumentation/radar/jam",1);
setprop("instrumentation/radar/jamlock",0);
# What happens when the radar Locks on, Goes into STT and spikes target (see lockhelper.nas)
# Also controls the radar mode, Scanning settings, Azimuth, Speed, etc
var tgtlock = func{
  if (getprop("instrumentation/radar/lock") == 1){
    var target1_x = radar.tgts_list[radar.Target_Index].TgtsFiles.getNode("h-offset",1).getValue();
    var target1_z = radar.tgts_list[radar.Target_Index].TgtsFiles.getNode("v-offset",1).getValue();
    setprop("instrumentation/radar2/lockmarker", target1_x / 10);
    setprop("instrumentation/radar2/lockmarker", target1_x / 10);
    #setprop("instrumentation/radar/az-field", 161);
    # setprop("instrumentation/radar/grid", 0);
    #print(target1_x / 10);
    setprop("instrumentation/radar2/sweep-speed", 10);
    setprop("instrumentation/radar/lock2", 2);
    if(getprop("instrumentation/radar/mode/main") == 4)
    {   # JAM
        setprop("instrumentation/radar/jamlock",1);
        if (getprop("controls/jammer/en") == 0) {
          jammer.start();
          screen.log.write("Jamming fake missile alerts to locked target!",0,1,0);
          setprop("controls/jammer/en",1);
        }
    } else {
        setprop("instrumentation/radar/jam",0);        
        if (getprop("controls/jammer/en") == 1) {
          jammer.stop();
          setprop("controls/jammer/en",0);
        }
    }
  } elsif (getprop("instrumentation/radar/lock") == 0){
    if(getprop("instrumentation/radar/mode/main") == 4)
    {   # JAM
        setprop("instrumentation/radar/jamlock",0);
        setprop("instrumentation/radar/jam",1);
        setprop("instrumentation/radar/az-field", 90);
        setprop("instrumentation/radar2/sweep-display-width", 0.1646);        
        setprop("instrumentation/radar2/sweep-speed", 5);   
        if (getprop("controls/jammer/en") == 1) {
          jammer.stop();
          setprop("controls/jammer/en",0);
        }
    } else {
        setprop("instrumentation/radar/jam",0);
        setprop("instrumentation/radar/jamlock",0);
    }
    if(getprop("instrumentation/radar/mode/main") == 3)
    {   # SLR
        setprop("instrumentation/radar/az-field", 280);
        setprop("instrumentation/radar2/sweep-display-width", 0.1646);        
        setprop("instrumentation/radar2/sweep-speed", 2);   
    }  
    if(getprop("instrumentation/radar/mode/main") == 1)
    {   # RWS
        setprop("instrumentation/radar/az-field", 120);
        setprop("instrumentation/radar2/sweep-display-width", 0.0846);        
        setprop("instrumentation/radar2/sweep-speed", 1);   
    }
    elsif(getprop("instrumentation/radar/mode/main") == 0)
    {
        # TWS
        setprop("instrumentation/radar/az-field", 60);
        setprop("instrumentation/radar2/sweep-display-width", 0.0446);        
        setprop("instrumentation/radar2/sweep-speed", 1);   
    }
    elsif(getprop("instrumentation/radar/mode/main") == 2)
    {
        setprop("instrumentation/radar/az-field", 60);
        setprop("instrumentation/radar2/sweep-display-width", 0.0446);        
        setprop("instrumentation/radar2/sweep-speed", 2);   
    }
  }
}

locktgt_timer = maketimer(0.1, tgtlock);
locktgt_timer.start();

var oppfunc = func(heading) {
  if (heading != nil) {
    var opposite = 0;
    if (heading == 0) {
      opposite == 180;
    } elsif (heading > 0) {
      opposite = heading - 180;
    } else {
      opposite = heading + 180
    }
    if (opposite < 0) {
      opposite = opposite + 360;
    }
    print("oppfunc: ",opposite);
    return opposite;
  } else {
    print("oppfunc(heading) - heading cant be nil!");
    return 0;
  }
}
setprop("controls/armament/master-arm",1);
setprop("f22/fcs/glimit",7.8);
setprop("f22/fcs/aoalimit",30);
setprop("autopilot/locks/fcs","");


var updateradarcs = func {
# Add a if lock 
if (getprop("/instrumentation/radar/lock2") != 0){
  print("f22.nas: Radar LOCKED!");
  var callsign = radar.tgts_list[radar.Target_Index].Callsign.getValue();
  var mpid = misc.smallsearch(callsign);
  var lockedalt = getprop("/ai/models/multiplayer[" ~ mpid ~ "]/position/altitude-ft");
  var lockedrng = getprop("/ai/models/multiplayer[" ~ mpid ~ "]/radar/range-nm");
  setprop("controls/radar/lockedalt",lockedalt);
  setprop("controls/radar/lockedrange",lockedrng);
  setprop("controls/radar/lockedcallsign", radar.tgts_list[radar.Target_Index].Callsign.getValue());
  } else {
  # Not locked on
  #print("aw not locked");
  setprop("controls/radar/lockedcallsign", "None");
  }
}

radartimer = maketimer(0.1,updateradarcs);
radartimer.start();

  setprop("controls/radar/lockedcallsign", "None");
setprop("autopilot/locks/altitude","");

var fcsloop = func() {
  var controlThresh = 0.01;
  var negcontrolThresh = -1 * controlThresh;
  var glimit = getprop("/f22/fcs/glimit");#g
  var alimit = getprop("/f22/fcs/aoalimit");#alpha
  var elevator = getprop("/controls/flight/elevator");
  var aileron = getprop("/controls/flight/aileron");
  var rudder = getprop("/controls/flight/rudder");
  var disable = 0;
    if (elevator > controlThresh or aileron > controlThresh) {
      disable = 1;
    }
    if (elevator < 0 or aileron < 0) {
      if (elevator < negcontrolThresh or aileron < negcontrolThresh){
        disable = 1;
      }
    }
    # final checks
    if (getprop("autopilot/locks/altitude") != "" or getprop("orientation/pitch-deg") < -70 or getprop("orientation/pitch-deg") > 70 or getprop("controls/gear/gear-down") == 1 or getprop("velocities/airspeed-kt") < 50 or getprop("velocities/airspeed-kt") > 900) {
      disable = 1;
    }

    if (disable == 0){
      # not moving controls, criteria met and fcs enabled
      setprop("/autopilot/locks/fcs","1g");
    } else {
      setprop("f22/fcs/controls/elevator",0);
      setprop("f22/fcs/controls/aileron",0);
      setprop("f22/fcs/controls/rudder",0);
      setprop("/autopilot/locks/fcs","");
    }
}
fcslooptimer = maketimer(0.1,fcsloop);
fcslooptimer.start();
setprop("controls/radar/cursormode",1);