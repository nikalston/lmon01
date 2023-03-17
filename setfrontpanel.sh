# IPMI DEFAULT R710 SETTINGS

# Modify to suit your needs.

IPMIHOST_R710=192.168.0.120
IPMIHOST_R430=192.168.0.130
IPMIUSER=root
IPMIPW=P@ssw0rd



while :
do
   
   ipmitool -I lanplus -H $IPMIHOST_R710 -U $IPMIUSER -P $IPMIPW delloem lcd set mode ambienttemp
   ipmitool -I lanplus -H $IPMIHOST_R430 -U $IPMIUSER -P $IPMIPW delloem lcd set mode ambienttemp 
   sleep 15

   ipmitool -I lanplus -H $IPMIHOST_R710 -U $IPMIUSER -P $IPMIPW delloem lcd set mode systemwatt
   ipmitool -I lanplus -H $IPMIHOST_R430 -U $IPMIUSER -P $IPMIPW delloem lcd set mode systemwatt
   sleep 15

done
