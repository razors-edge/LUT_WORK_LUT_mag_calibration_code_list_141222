pro ck04_spec_part_interpol_141222
close,/all
path='/home/han/WORK/LUT/LUT_mag_calibration/LUT_mag_calibration_141222/CK04_model/ckp00/'
list=findfile(path+'ckp00*_grav_part.txt')
file_number=n_elements(list)
;print,file_number
for i=0L, file_number-1 do begin
inputfile=strcompress(list[i],/remove)
;print,inputfile
record={wave:0.0d,flux:0.0d}
maxrec=file_lines(inputfile)
string = STRSPLIT(inputfile, '.', /EXTRACT)
outputfile=strcompress(string[0] + '_interpol.txt',/remove)
;print,outputfile
data=replicate(record,maxrec)
openr,50,inputfile
readf,50,data
close,50

openw,70,outputfile,width=360
X = FINDGEN(7000)
;help,X
result = INTERPOL(data.flux,data.wave, X+2000.0)
for k=0L, 6999 do begin
printf,70,2000.0 + X[k] ,result[k]
endfor
close,70
sum_inte = tsum(data.wave,data.flux)
sum_inte1 = tsum(X,result)
;print,sum_inte,sum_inte1
endfor
print,'done'
close,/all

end
