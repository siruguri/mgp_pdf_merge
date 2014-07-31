date
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