% How to run:
%     1. `pip install problog`
%     2. `problog ./SmithOakmanBlevins_home.pl`

0.0007::tornado.
0.000000004::tsunami.
0.007::flash_freeze.
0.33::light_switch_on.
0.6::car_in_garage.

% Prior likelihood for movement in an area.
0.35::movement(living_room).
0.15::movement(hallway).

0.85::movement(bathtub) :- tornado.
0.05::movement(bathtub) :- not(tornado).

0.05::faulty_motion_sensor(living_room).
0.05::faulty_motion_sensor(hallway).
0.004::faulty_motion_sensor(bathtub).

0.02::faulty_light_sensor.
0.03::faulty_temp_sensor.
0.01::faulty_thermostat.

0.01::power_failure.

0.3::broken_waterline :- tornado, flash_freeze.
0.02::broken_waterline :- tornado, \+flash_freeze.
0.28::broken_waterline :- \+tornado, flash_freeze.

0.5::someone_is_home :- car_in_garage.
0.3::someone_is_home :- \+car_in_garage.

motion_detected(Room) :- 
    not(faulty_motion_sensor(Room)),
    movement(Room).

light_on :- 
    not(faulty_light_sensor),
    light_switch_on.

heating_on :- 
    not(faulty_thermostat),
    not(power_failure),
    not(broken_waterline).

water_on :-
    not(broken_waterline).

oven_on :-
    not(power_failure),
    someone_is_home.

0.80::movement(kitchen) :- oven_on.
0.20::movement(kitchen) :- not(oven_on).

0.12::wifi_on :- not(light_on), not(heating_on).
0.70::wifi_on :- light_on, not(heating_on).
0.90::wifi_on :- light_on, heating_on.

% evidence
evidence(motion_detected(living_room), false).
evidence(light_on, false).
 
% Q1: given no motion in living room and lights off, is the sensor faulty?
query(faulty_motion_sensor(living_room)).

% Q2: given no motion and lights off, did power fail?
query(power_failure).

% Q3: given no motion and lights off, is the light sensor faulty?
query(faulty_light_sensor).

% Q4: given no motion and lights off, is heating on?
query(heating_on).

% Q5: given no motion and lights off, is someone home?
query(someone_is_home).
