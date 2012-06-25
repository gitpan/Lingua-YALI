
doc:
	version=`cat dist.ini  | grep version | cut -f3 -d" "`; \
	dzil build; pod2html --infile=Lingua-*-$$version/lib/Lingua/*.pm > doc.html; \
	echo `pwd`/doc.html
	
test-full:
	dzil test

test-simple:
	prove -lr t
	
build:
	version=`cat dist.ini  | grep version | cut -f3 -d" "`; \
	rm -rf Lingua-*-$$version*; \
	dzil build
	
	
# for f in *.txt.gz; do echo $f; lang=`echo $f | cut -f1 -d.`; echo $lang; echo 4 > $lang.yali; zcat $f >> $lang.yali; gzip -c $lang.yali > $lang.yali.gz; rm $lang.yali; done
