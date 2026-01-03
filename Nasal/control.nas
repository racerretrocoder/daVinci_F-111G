# Phoenix
# Flightcontrol
setprop("controls/flight/manual-wing-sweep",0);
var sweepin = func() {
    var sweep = getprop("controls/flight/manual-wing-sweep");
    if (sweep == 0) {
        screen.log.write("Engaged manual wing sweep",0,1,0);
        screen.log.write("Wing sweep 0%",0,1,0);
        setprop("controls/flight/manual-wing-sweep",1);
    } elsif (sweep == 1) {
        screen.log.write("Wing sweep 20%",0,1,0);
        setprop("controls/flight/manual-wing-sweep",2);
    } elsif (sweep == 2) {
        screen.log.write("Wing sweep 40%",0,1,0);
        setprop("controls/flight/manual-wing-sweep",3);
    } elsif (sweep == 3) {
        screen.log.write("Wing sweep 60%",0,1,0);
        setprop("controls/flight/manual-wing-sweep",4);
    } elsif (sweep == 4) {
        screen.log.write("Wing sweep 80%",0,1,0);
        setprop("controls/flight/manual-wing-sweep",5);
    } elsif (sweep == 5) {
        screen.log.write("Wing sweep 100%",0,1,0);
        setprop("controls/flight/manual-wing-sweep",6);
    } elsif (sweep == 6) {
        screen.log.write("Wing sweep at 100% Cant sweep in further!",0,1,0);
        setprop("controls/flight/manual-wing-sweep",6);
    }
}

var sweepout = func() {
    var sweep = getprop("controls/flight/manual-wing-sweep");
    if (sweep == 0) {
        screen.log.write("Already in automatic sweep",0,1,0);
        setprop("controls/flight/manual-wing-sweep",0);
    } elsif (sweep == 1) {
        screen.log.write("Engaged Automatic wing sweep",0,1,0);
        setprop("controls/flight/manual-wing-sweep",0);
    } elsif (sweep == 2) {
        screen.log.write("Wing sweep 0%",0,1,0);
        setprop("controls/flight/manual-wing-sweep",1);
    } elsif (sweep == 3) {
        screen.log.write("Wing sweep 20%",0,1,0);
        setprop("controls/flight/manual-wing-sweep",2);
    } elsif (sweep == 4) {
        screen.log.write("Wing sweep 40%",0,1,0);
        setprop("controls/flight/manual-wing-sweep",3);
    } elsif (sweep == 5) {
        screen.log.write("Wing sweep 60%",0,1,0);
        setprop("controls/flight/manual-wing-sweep",4);
    } elsif (sweep == 6) {
        screen.log.write("Wing sweep 80%",0,1,0);
        setprop("controls/flight/manual-wing-sweep",5);
    }
}