#last digit os speed

# 0x09 1560 RPM
# 0x0a 2160 RPM
# 0x10 3000 RPM

ipmitool -I lanplus -H 192.168.0.120 -U root -P P@ssw0rd raw 0x30 0x30 0x01 0x00

ipmitool -I lanplus -H 192.168.0.120 -U root -P P@ssw0rd raw 0x30 0x30 0x02 0xff 0x09

