date
echo fetching links
ruby fetch_links.rb -u http://www.comnet.org/mgp?purpose=0 > section_list.txt

echo Making destination directories
mkdir -p purpose_0
mkdir -p purpose_1
mkdir -p purpose_2
mkdir -p purpose_3

rm purpose_0/*
rm purpose_1/*
rm purpose_2/*
rm purpose_3/*

echo making script for p0
(ruby fetch_pdfs.rb 0  2>/dev/null | grep wkhtmltopdf > purpose_0/fetch_script.sh) && chmod u+x purpose_0/fetch_script.sh
echo making script for p1
(ruby fetch_pdfs.rb 1  2>/dev/null | grep wkhtmltopdf > purpose_1/fetch_script.sh) && chmod u+x purpose_1/fetch_script.sh
echo making script for p2
(ruby fetch_pdfs.rb 2  2>/dev/null | grep wkhtmltopdf > purpose_2/fetch_script.sh) && chmod u+x purpose_2/fetch_script.sh
echo making script for p3
(ruby fetch_pdfs.rb 3  2>/dev/null | grep wkhtmltopdf > purpose_3/fetch_script.sh) && chmod u+x purpose_3/fetch_script.sh

echo running script for p0
cd purpose_0
./fetch_script.sh
pdfunite *pdf purpose_0.pdf
cd ..

echo running script for p1
cd purpose_1
./fetch_script.sh
pdfunite *pdf purpose_1.pdf
cd ..

echo running script for p2
cd purpose_2
./fetch_script.sh
pdfunite *pdf purpose_2.pdf
cd ..

echo running script for p3
cd purpose_3
./fetch_script.sh
pdfunite *pdf purpose_3.pdf
cd ..

date
