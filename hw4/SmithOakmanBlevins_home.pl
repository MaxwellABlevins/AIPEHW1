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
0.90::wifi_on :- light_on.

% Query 1. P(faulty living room sensor | No motion in living room & light is off).
evidence(motion_detected(living_room), false).
evidence(light_on, false).

query(faulty_motion_sensor(living_room)).
clear_evidence().

% Query 2. P(heating | a flash freeze & a working thermostat)
evidence(flash_freeze).
evidence(faulty_thermostat, false).

query(heating_on).
clear_evidence().

% Query 3. P(Bathtub Motion | a tornado & bathroom light is off)
evidence(tornado).
evidence(light_switch_on, false).

query(motion_detected(bathtub)).
clear_evidence().

% Query 4. P(wifi_on | tornado & tsunami & flash_freeze & light off)
evidence(tornado).
evidence(tsunami).
evidence(flash_freeze).
evidence(light_on, false).

query(wifi_on).
clear_evidence().

% Query 5. P(someone is home | car is empty & oven is on)
evidence(car_in_garage, false).
evidence(oven_on).

query(someone_is_home).
