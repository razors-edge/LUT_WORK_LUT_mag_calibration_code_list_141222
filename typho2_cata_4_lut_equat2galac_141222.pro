pro typho2_cata_4_lut_equat2galac_130909
close,/all
inputfile=filepath('lut_mag_typho_catalog_cross.dat',$
root_dir='E:\WORK\LUT\LUT_mag_calibration\LUT_mag_calibration_130909\lut_optical_efficiency_curve\')
outputfile=filepath('typho2_cata_4_lut_equat2galac.txt',$
root_dir='E:\WORK\LUT\LUT_mag_calibration\LUT_mag_calibration_130909\lut_optical_efficiency_curve\')
print,'Start working.'

if(n_elements(inputfile) eq 0) then $
message,'Argument FILE is underfined'
str=''
;maxrec=435961L
maxrec = file_lines(inputfile)
record={RAmdeg:0.0d,DEmdeg:0.0d,Bmag:0.0d,Vmag:0.0d,BV:0.0d}
data=replicate(record,maxrec)
openr,50,inputfile
point_lun,50,0
readf,50,data
close,50


record1={RAmdeg_gala:0.0d,DEmdeg_gala:0.0d}
data1=replicate(record1,maxrec)
openw,60,outputfile,width=300

l=0L
m=0L
n=0L
o=0L
p=0L

for i=0L, maxrec-1 do begin
glactc,data[i].RAmdeg,data[i].DEmdeg,2000,gl,gb,1, /degree
data1[i].RAmdeg_gala = gl
data1[i].DEmdeg_gala = gb
printf,60,data[i].RAmdeg,data[i].DEmdeg,data[i].Bmag,data[i].Vmag,data[i].BV,data1[i].RAmdeg_gala,data1[i].DEmdeg_gala

if (data1[i].DEmdeg_gala lt 10.0 ) then begin
l=l+1
endif 
if (data1[i].DEmdeg_gala ge 10.0 ) and (data1[i].DEmdeg_gala lt 15.0 ) then begin
m=m+1
endif 
if (data1[i].DEmdeg_gala ge 15.0 ) and (data1[i].DEmdeg_gala lt 25.0 ) then begin
n=n+1
endif
if (data1[i].DEmdeg_gala ge 25.0 ) and (data1[i].DEmdeg_gala lt 30.0 ) then begin
o=o+1
endif
if (data1[i].DEmdeg_gala ge 30.0 ) then begin
p=p+1
endif
endfor
print,'l',l
print,l+m+n+o+p,l,m,n,o,p

close,/all
print,'Done'
end