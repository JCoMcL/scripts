#!/usr/bin/env -S awk -f

BEGIN{i=0}
{i++;print "-i "$0}
END{
	print "-filter_complex";
	for(j=0;j<i;j++)
		printf "["j":v:0]["j":a:0]";
	print "concat=n="i":v=1:a=1[outv][outa]";
	print "-map [outv]";
	print "-map [outa]";
	print "tales.webm"

}

 

