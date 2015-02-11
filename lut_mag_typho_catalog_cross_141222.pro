pro lut_mag_typho_catalog_cross_130909
close,/all
inputfile=filepath('tyc2_cor_mag.dat',$
root_dir='E:\WORK\LUT\LUT_mag_calibration\LUT_mag_calibration_130909\tycho2\')
outputfile=filepath('lut_mag_typho_catalog_cross.dat',$
root_dir='E:\WORK\LUT\LUT_mag_calibration\LUT_mag_calibration_130909\lut_optical_efficiency_curve\')

if(n_elements(inputfile) eq 0) then $
message,'Argument FILE is underfined'
str=''
maxrec=file_lines(inputfile)
;maxrec=535207
record={RAmdeg:0.0d,DEmdeg:0.0d,BTmag:0.0d,VTmag:0.0d}
data=replicate(record,maxrec)
openr,50,inputfile
point_lun,50,0
readf,50,data
close,50
openw,70,outputfile,width=360
;ra_moon:17h47m
;dec_moon:65.45 degree
pi=3.14159
ra_moon=(47.0/60.0+17.0)/24*360
dec_moon=65.45
ra_moon_rad=ra_moon/180*pi  ; ra_moon_rad is RA in radians
dec_moon_rad=dec_moon/180*pi ; dec_moon_rad is DEC in radians
dis_in=7.0
dis_out=60.0


n=0L
for i=0L, maxrec-1 do begin
;for i=0, 11 do begin
RA_rad=data[i].RAmdeg/180*pi ; RA_rad is RA in radians
Dec_rad=data[i].DEmdeg/180*pi ; Dec_rad is DEC in radians
dis=(cos(Dec_rad)*sin(RA_rad-ra_moon_rad))^2+(cos(dec_moon_rad)*sin(Dec_rad)-sin(dec_moon_rad)*cos(Dec_rad)*cos(RA_rad-ra_moon_rad))^2 
dis=sqrt(dis)/(sin(dec_moon_rad)*sin(Dec_rad)+cos(dec_moon_rad)*cos(Dec_rad)*cos(RA_rad-ra_moon_rad))
dis=atan(dis,1)
;dis=dis*3600*180/pi
dis=dis*180/pi
dis=abs(dis) ; dis is the distance in degree
;dis=(cos(dec_moon_rad)*sin(ra_moon_rad-RA_rad))^2+(cos(Dec_rad)*sin(dec_moon_rad)-sin(Dec_rad)*cos(dec_moon_rad)*cos(ra_moon_rad-RA_rad))^2 
;dis=sqrt(dis)/(sin(Dec_rad)*sin(dec_moon_rad)+cos(Dec_rad)*cos(dec_moon_rad)*cos(ra_moon_rad-RA_rad))
;dis=atan(dis,1)
;;dis=dis*3600*180/pi
;dis=dis*180/pi
;dis=abs(dis)
if((dis le dis_out) and (dis ge dis_in)) then begin
;and (data[i].BTmag lt 12.8) and (data[i].VTmag lt 11.8) then begin
V=data[i].VTmag-0.090*(data[i].BTmag-data[i].VTmag)
BV=0.850*(data[i].BTmag-data[i].VTmag)
B=V+BV
n=n+1
print,n,dis,data[i].RAmdeg,data[i].DEmdeg,B,V,BV
printf,70,data[i].RAmdeg,data[i].DEmdeg,B,V,BV
endif
endfor

close,70

print,'done'
end