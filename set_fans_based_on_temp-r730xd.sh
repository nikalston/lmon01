#!/bin/bash
#!/bin/sh
#
#
# Author: Cesar Zea Gomez.
# https://www.linkedin.com/in/cesarzea/
# Skype: cesar_zea_gomez
#
# © MIT License
# 
IDRACIP="192.168.0.142"
IDRACUSER="root"
IDRACPASSWORD="P@ssw0rd"


SECURITYSPEED=1000

while true; do 

echo "--------------------------"
DATE=$(date +%Y-%m-%d-%H:%M:%S)
echo "$DATE"

DATA=$(ipmitool -I lanplus -H $IDRACIP -U $IDRACUSER -P $IDRACPASSWORD sdr type temperature)
echo ""
echo "DATA = "
echo ""

# -----------------------------------------------------
# !!! CHECH IF YOUR IDRAC RETURN THE SAME RESPONSE !!!!
# -----------------------------------------------------
#
#Inlet Temp       | 04h | ok  |  7.1 | 26 degrees C
#Exhaust Temp     | 01h | ok  |  7.1 | 34 degrees C
#Temp             | 0Eh | ok  |  3.1 | 39 degrees C
#Temp             | 0Fh | ok  |  3.2 | 40 degrees C
#



speed=0
lineLog="$DATE"


get_speed_for_sensor() {
  
echo "in get_speed_for_sensor"

T=$(echo "$DATA" | grep $lineMark | cut -d"|" -f5 | cut -d" " -f2)
  echo "$T: $sensorName"
  
echo $T

  re='^[0-9]+$'
  if ! [[ $T =~ $re ]] ; then
     
     sensorSpeed=$((SECURITYSPEED))
     lineLog="$lineLog -1"
  else 
    lineLog="$lineLog $T"

    sensorSpeed=0
    i=0
    for limit in "${limits[@]}"
    do
#
echo "in limit loop"

      echo "$i $limit $((speeds[i]))"
#
      if [[ $T > $limit ]]
      then
        sensorSpeed=$((i))
        echo "Indice $i"
      fi
      i=$((i+1))
      echo "$limit "

    done
  fi

  if [[ $sensorSpeed > $speed ]]
  then
    speed=$((sensorSpeed))
    echo "    --> $speed"
  fi
echo "leaving get_speed_for_sensor"

}


#speeds=(0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100)
speeds=(5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 100 100)


#-----------------------
#-----------------------
sensorName='Inlet Temp'
lineMark='04h'

# -----------------------------------------------------
# CHECK IT FOR YOUR TEMPERATURE LIMITS
# -----------------------------------------------------
limits=(30  31  32  32  33  34  35  35  36  37  38  38  39  40  41  41  42  43  44  44  45)

get_speed_for_sensor

#-----------------------
sensorName='Exhaust Temp'
lineMark='01h'
# -----------------------------------------------------
# CHECK IT FOR YOUR TEMPERATURE LIMITS
# -----------------------------------------------------
limits=(40  42  43  45  46  48  49  51  52  54  55  57  58  60  61  63  64  66  67  69  70)

get_speed_for_sensor

# CPU
# -----------------------------------------------------
# CHECK IT FOR YOUR TEMPERATURE LIMITS
# -----------------------------------------------------
limits=(55  56  56  57  57  58  58  59  59  60  60  61  61  62  62  63  63  64  64  65  65)
#-----------------------
sensorName='CPU 1'
lineMark='0Eh'

get_speed_for_sensor

#-----------------------
sensorName='CPU 2'
lineMark='0Fh'

get_speed_for_sensor

#-----------------------
#-----------------------
echo "Speed= $speed"

speed=$((speeds[speed]))

lineLog="$lineLog $speed"

echo "Logging"
echo "$lineLog" >> ./temperatures.log
echo "Logged"

echo "Speed= $speed"


if [ $speed -lt 500 ]; then

    #speed=10

    p=$(echo "obase=16; $speed" | bc)
    #echo "dato $p"

    l=${#p}

    if [ $l -eq 1 ]; then
      p="0$p"
    #echo "dato $p"
    fi


    STATICSPEEDBASE16="0x$p"
    echo "$STATICSPEEDBASE16"

    echo "--> disable dynamic fan control"
    ipmitool -I lanplus -H $IDRACIP -U $IDRACUSER -P $IDRACPASSWORD raw 0x30 0x30 0x01 0x00
    echo "--> set static fan speed"
    #/opt/ipmitool/ipmitool -I lanplus -H $IDRACIP -U $IDRACUSER -P $IDRACPASSWORD raw 0x30 0x30 0x02 0xff $STATICSPEEDBASE16
    ipmitool -I lanplus -H $IDRACIP -U $IDRACUSER -P $IDRACPASSWORD raw 0x30 0x30 0x02 0xff $STATICSPEEDBASE16

fi

done

