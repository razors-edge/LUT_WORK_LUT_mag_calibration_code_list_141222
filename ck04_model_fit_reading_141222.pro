pro CK04_model_fit_reading_141222
close,/all
path='/home/han/WORK/LUT/LUT_mag_calibration/LUT_mag_calibration_130909/CK04_model/ckp00/'
list=findfile(path+'*.fits')

file_number=n_elements(list)
for i=0L, file_number-1 do begin
inputfile=strcompress(list[i],/remove)
;print,inputfile
cobj=mrdfits(inputfile,1) ;The 1 signifies the 1st extension
maxrec=n_elements(cobj)
;print,'maxrec=',maxrec
string = STRSPLIT(inputfile, '.', /EXTRACT)
outputfile=strcompress(string[0] + '.txt',/remove)
string1 = STRSPLIT(outputfile, '/', /EXTRACT)
;print,string1[6]


openw,70,outputfile,width=360
printf,70,'WAVELENGTH     ','G00       ','G05         ','G10        ',$
'G15       ','G20        ',$
'G25       ','G30        ','G35         ',$
'G40        ','G45        ','G50         '
for j=0L, maxrec-1 do begin
printf,70,cobj[j].WAVELENGTH,' ',cobj[j].G00,' ',cobj[j].G05,' ',cobj[j].G10,' ',$
cobj[j].G15,' ',cobj[j].G20,' ',$
cobj[j].G25,' ',cobj[j].G30,' ',cobj[j].G35,' ',$
cobj[j].G40,' ',cobj[j].G45,' ',cobj[j].G50
endfor
close,70
endfor


print,'done'
close,/all



end