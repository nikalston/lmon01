# IPMI DEFAULT R710 SETTINGS

# Modify to suit your needs.

IPMIHOST_R710=192.168.0.120
IPMIHOST_R430=192.168.0.130
IPMIUSER=root
IPMIPW=P@ssw0rd




ipmitool -I lanplus -H $IPMIHOST_R710 -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x01
ipmitool -I lanplus -H $IPMIHOST_R430 -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x01 

