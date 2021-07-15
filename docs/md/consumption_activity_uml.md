@startuml

start

:totalConsumption = 0;
:i=1;
repeat
  :point1 = get point at i;
  :point2 = get point at i-1;
  :speed = calculate vehicle speed between point i and point i-1;
  :grade = calculate grade between point i and point i-1;
  :acceleration = calculate acceleration between point i and point i-1;
  :vsp = calculate vsp using formula;
  :vspMode = get vsp mode for vsp value;
  :currentConsumption = get consumption for vsp;
  :totalConsumption = currentConsumption + currentConsumption;

repeat while (last point) is (no)
->yes;
stop

@enduml
