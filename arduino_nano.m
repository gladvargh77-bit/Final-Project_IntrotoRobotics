clear all
a=arduino;
mc= motorCarrier(a);
m1=dcmotor(mc,"M1");
m2=dcmotor(mc,"M2");
m3=dcmotor(mc, "HA1A");

while(1)
    baseLeft(m1)
    pause(3);
    baseRight(m1)
    pause(3);

    shoulderUp(m2);
    pause(3);
    shoulderDown(m2);
    pause(3);
end


