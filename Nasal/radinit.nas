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