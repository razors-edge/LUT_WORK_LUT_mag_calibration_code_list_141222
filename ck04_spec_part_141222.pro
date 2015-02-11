pro ck04_spec_part_141222
close,/all
path='/home/han/WORK/LUT/LUT_mag_calibration/LUT_mag_calibration_130909/CK04_model/ckp00/'
list=findfile(path+'ckp00*_grav.txt')
file_number=n_elements(list)
print,file_number
;outputfile1='/Users/hanxuhui/WORK/LOT/LOT_mag/CASTELLI_KURUCZ_ATLAS/ckp00/flux_tot.dat'
;openw,80,outputfile1
for i=0L, file_number-1 do begin
inputfile=strcompress(list[i],/remove)
print,inputfile
record={wave:0.0d,flux:0.0d}
maxrec=linenum_multi_col(inputfile,record)
close,60
string = STRSPLIT(inputfile, '.', /EXTRACT)
outputfile=strcompress(string[0] + '_part.txt',/remove)
print,outputfile
data=replicate(record,maxrec)
openr,50,inputfile
readf,50,data
close,50

openw,70,outputfile
for j=0L, maxrec-1 do begin
if (data[j].wave Ge 2000 and data[j].wave Le 8000) then begin
printf,70,data[j].wave,data[j].flux

endif
endfor
close,70
endfor

print,'done'
close,/all

end