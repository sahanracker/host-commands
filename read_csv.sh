INPUT=DSB-Formatted.csv
OLDIFS=$IFS
IFS=','
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read Hostname FQDN Instance_Type Tag
do
    echo "Hostname : $Hostname"
    echo "FQDN : $FQDN"
    echo "Instance_Type : $Instance_Type"
    echo "Tags : $Tag"
    
done < $INPUT
IFS=$OLDIFS