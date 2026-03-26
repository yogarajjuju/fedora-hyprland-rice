#!/bin/bash

STATUS=$(playerctl status 2>/dev/null)

# auto hide
if [ "$STATUS" != "Playing" ]; then
    echo ""
    exit 0
fi

# smoother fake animation
cava -p ~/.config/cava/cava.conf 2>/dev/null | awk '
{
    gsub(";", "");
    for(i=0;i<=7;i++){
        chars[i]="▁▂▃▄▅▆▇█";
    }

    out="";
    for(i=1;i<=length($0);i++){
        c=substr($0,i,1);
        if(c ~ /[0-7]/){
            out=out substr(chars[c],c+1,1);
        }
    }

    print out;
    fflush();
}'
