pro ck04_spec_multiply_new_effi_curve_141222
;ck04 spectra multiplied by new efficiency curve
close,/all
path='/home/han/WORK/LUT/LUT_mag_calibration/LUT_mag_calibration_141222/CK04_model/ckp00/'
list=findfile(path+'ckp00*_grav_part_interpol.txt')
file_number=n_elements(list)
print,file_number

inputfile1=filepath('Spectral_response_curve_20130909.txt',$
root_dir='/home/han/WORK/LUT/LUT_mag_calibration/LUT_mag_calibration_141222/lut_optical_efficiency_curve/data/')
outpath='/home/han/WORK/LUT/LUT_mag_calibration/LUT_mag_calibration_141222/CK04_model/ckp00/spec_multiply_efficiency_curve/'

if(n_elements(inputfile1) eq 0) then $
message,'Argument FILE is underfined'
str=''
maxrec1=linenum_multi_col(inputfile1,str)
close,60
record1={wave:0L,effi:0.0d}
data1=replicate(record1,maxrec1)
openr,50,inputfile1
point_lun,50,0
readf,50,data1
close,50
data1.wave = data1.wave * 10.0
data1.effi = data1.effi

; Define the independent variable.  
x = FINDGEN(7000)+2000 
effi = INTERPOL(data1.effi,data1.wave, x)
index1 = where(effi[*] le 0, count1)
effi[index1] = 0
max_effi = max(effi)
print,'effi ',(1.0/max_effi)
effi = effi * (1.0/max_effi)


for i=0L, file_number-1 do begin
inputfile=strcompress(list[i],/remove)
string = STRSPLIT(inputfile, '/', /EXTRACT)
print,string[8]
stringx = STRSPLIT(string[8], '.', /EXTRACT)
outputfile=outpath+stringx[0]+'_out.txt'
outputfile1=outpath+stringx[0]
openw,80,outputfile,width=360

record={wave:0.0d,flux:0.0d}
maxrec=7000L
data=replicate(record,maxrec)
flux1=FINDGEN(7000)
openr,50,inputfile
readf,50,data
close,50
flux1 = data.flux * effi
index1 = where(flux1[*] le 0, count1)
flux1[index1] = 0

for n=0L, 7000-1 do begin
printf,80,data[n].wave,flux1[n]
endfor
close,80

entry_device=!d.name
!p.multi=[1,1,1]
set_plot,'ps'
device,file=outputfile1 + '_red_leak.ps',xsize=8,ysize=8,/inches,xoffset=0.1,yoffset=0.1,/Portrait
device,/color
;loadct_plot
!p.position=0

xrange1=1800
;xrange2=4200
xrange2=9200
yrange1=min(flux1)
yrange2=max(flux1)
linethick = 5
plot,x,flux1,$
xrange=[xrange1,xrange2],$
;yrange=[yrange1,yrange2],$
xstyle=1,$
ystyle=1,$
xtitle='Wavelength (A)',$
XCHARSIZE=1.5,$
ytitle='Flux',YCHARSIZE=1.5, $
thick=linethick,$
linestyle=0,color=0,$
position=[0.2,0.15,0.9,0.9],$
;/ylog,$
ytickformat='(e8.1)'
csize=1.5

oplot,x,effi,linestyle=1,color=2,thick=linethick
;oplot,x,data.flux,linestyle=1,color=3,thick=linethick
oplot,[2450,2450],[yrange1,yrange2],linestyle=1,color=1,thick=linethick
oplot,[3400,3400],[yrange1,yrange2],linestyle=1,color=1,thick=linethick
xyouts,2500,yrange2*0.8,'LUT',charsize=2,color=0,charthick=linethick

oplot,[5500,5500],[yrange1,yrange2],linestyle=1,color=2,thick=linethick
xyouts,5200,yrange2*0.8,'JohnsonV',charsize=2,color=2,charthick=linethick

device,/close_file

endfor


print,'done'
close,/all

end
