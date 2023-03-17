



# IPMI DEFAULT R710 SETTINGS

# Modify to suit your needs.

IPMIHOST=192.168.0.140

IPMIUSER=root

IPMIPW=P@ssw0rd



# TEMPERATURE

# Change this to the temperature in celcius you are comfortable with. 

# If it goes above it will send raw IPMI command to enable dynamic fan control


MAXTEMP=27


# This variable sends a IPMI command to get the temperature, and outputs it as two digits.

# Do not edit unless you know what you do.

TEMP=$(ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW sdr type temperature |grep Ambient |grep degrees |grep -Po '\d{2}' | tail -1)


time=$(date +%r | head -c 8)
date=$(date +%F)
#echo "Date is $time $date"



echo $CMD

curl --retry 3 https://hc-ping.com/e0ee6265-0f6e-4bfe-8d6f-681ab7f54c17


if [[ $TEMP > $MAXTEMP ]];

  then

    printf "Temperature is too high! ($TEMP C) Activating dynamic fan control!" | systemd-cat -t R210ii-IPMI-TEMP

    echo "$date:$time Temperature is too high! ($TEMP C) Activating dynamic fan control!"

    ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x01

  else

    ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x00

    ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x02 0xff 0x0a

    printf "$date:$time Temperature is OK ($TEMP C)" | systemd-cat -t R210ii-IPMI-TEMP

    echo "Temperature is OK ($TEMP C) -setting fans to 2160"

fi
