# Phoenix
# Custom autostart


var enginecheck = func() {
    print("autostart engine run check!");
    if (getprop("engines/engine/n2") > 59.999 and getprop("engines/engine[1]/n2") > 59.999) {
        screen.log.write("Both engines started up successfully! Engines running");
        enginechecktimer.stop();
    }
    if (getprop("controls/engines/engine[0]/starter") == 0) {
        setprop("controls/engines/engine[0]/starter",1);
        setprop("controls/engines/engine[1]/starter",1);
    }
}

enginechecktimer = maketimer(0.5,enginecheck);

var fuelstart = func() {
    screen.log.write("Fuel cut-off's disengaged. The engines are getting fuel!");
    setprop("controls/engines/engine[0]/cutoff",0);
    setprop("controls/engines/engine[1]/cutoff",0);
    enginechecktimer.start();
    fuelstarttimer.stop();
}

fuelstarttimer = maketimer(5,fuelstart);
var start = func() {
    screen.log.write("Starting the F-111's TF30-P100's!");
    setprop("controls/engines/engine[0]/cutoff",1);
    setprop("controls/engines/engine[1]/cutoff",1);
    setprop("controls/engines/engine[0]/starter",1);
    setprop("controls/engines/engine[1]/starter",1);
    fuelstarttimer.start()
}

var stop = func() {
    screen.log.write("Cutting off the fuel! Engines shutting down!");
    setprop("controls/engines/engine[0]/cutoff",1);
    setprop("controls/engines/engine[1]/cutoff",1);
}