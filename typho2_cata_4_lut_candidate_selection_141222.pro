pro typho2_cata_4_lut_candidate_selection_130909
close,/all
inputfile=filepath('mag4lot_tyc_ccd.dat',$
root_dir='E:\WORK\LUT\LUT_mag_calibration\LUT_mag_calibration_130909\lut_optical_efficiency_curve\')
;inputfile1=filepath('lot_cor_mag.dat',$
;root_dir='/Users/hanxuhui/WORK/LOT/tycho2/')
inputfile1=filepath('typho2_cata_4_lut_equat2galac.txt',$
root_dir='E:\WORK\LUT\LUT_mag_calibration\LUT_mag_calibration_130909\lut_optical_efficiency_curve\')
outputfile=filepath('typho2_cata_4_lut_candidate_selection_30s',$
root_dir='E:\WORK\LUT\LUT_mag_calibration\LUT_mag_calibration_130909\lut_optical_efficiency_curve\')
outputfile1=filepath('typho2_cata_4_lut_candidate_selection_30s.txt',$
root_dir='E:\WORK\LUT\LUT_mag_calibration\LUT_mag_calibration_130909\lut_optical_efficiency_curve\')

openw,80,outputfile1,width=300
entry_device=!d.name
!p.multi=[0,1,2]
set_plot,'ps'
device,file=outputfile + '.ps',xsize=8,ysize=8,/inches,xoffset=0.1,yoffset=0.1,/Portrait
device,/color
loadct_plot
!p.position=0


if(n_elements(inputfile) eq 0) then $
message,'Argument FILE is underfined'
record={magab:0.0d,magvega_b:0.0d,magvega_v:0.0d,magvega_bv:0.0d,mag_minus:0.0d,magab_05:0.0d,magvega_05:0.0d,redleak_persent:0.0d}
data=replicate(record,40)
openr,50,inputfile
point_lun,50,0
str=''
readf,50,str
readf,50,data
close,50

;mag_limit_30 = 15.4
mag_limit_30 = 17
xmin=-0.5
xmax=2.0
ymin=2.0
ymax=16.5
PLOTSYM,3,1.5,thick=5,/FILL
plot,data.magvega_bv,(mag_limit_30 - data.mag_minus),$
xrange=[xmin,xmax],yrange=[ymin,ymax],$
xstyle=1+4,$
ystyle=1,$
xthick=3,ythick=3,$
xtitle='B-V',$
XCHARSIZE=1.5,$
ytitle='V mag limit (15.4 AB (30s))',YCHARSIZE=1.5, $
psym=8,charthick=3,$
;XTICKLEN=1,$
YTICKLEN=1,$
;XGRIDSTYLE=1,$
YGRIDSTYLE=1,$
color=0,position=[0.15,0.4,0.9,0.9],/NODATA
axis,xaxis=1,xstyle=1,XCHARSIZE=0.001,xthick=3


;Color Index  Spectral Type   Approximate Color
;1.41   M0  Red
;0.82   K0  Orange
;0.59   G0  Yellow
;0.31   F0  Yellowish
;0.00   A0  White
;-0.29  B0  Blue


cthick=3
csize=2
label3=4.0
oplot,[-2.9,-2.9],[ymin,ymax],linestyle=1,thick=3,color=0
xyouts,-2.9,label3,'B0',charsize=csize,color=1,charthick=cthick
oplot,[0,0],[ymin,ymax],linestyle=1,thick=3,color=0
xyouts,-0.05,label3,'A0',charsize=csize,color=1,charthick=cthick
oplot,[0.31,0.31],[ymin,ymax],linestyle=1,thick=3,color=0
xyouts,0.26,label3,'F0',charsize=csize,color=1,charthick=cthick
oplot,[0.59,0.59],[ymin,ymax],linestyle=1,thick=3,color=0
xyouts,0.54,label3,'G0',charsize=csize,color=1,charthick=cthick
oplot,[0.82,0.82],[ymin,ymax],linestyle=1,thick=3,color=0
xyouts,0.77,label3,'K0',charsize=csize,color=1,charthick=cthick
oplot,[1.41,1.41],[ymin,ymax],linestyle=1,thick=3,color=0
xyouts,1.36,label3,'M0',charsize=csize,color=1,charthick=cthick


;----------------------------------------------------------------------------------
result=poly_fit(data.magvega_bv, (mag_limit_30 - data.mag_minus), 4, measure_error= measure_errors, $
sigma=sigma)

print, 'Coeffiencts:', result
print, 'Standard errors:', sigma

x2=( FindGen(220) * 0.01 ) - 0.4
y2=result[0] + result[1] * ( x2 ) + result[2] * ( x2 ) * ( x2 ) + result[3] * (x2^3) + result[4] * (x2^4)
;oplot,x2,y2,linestyle=0,color=0,thick=5

;-----------------------------------------------------------------------------------
if(n_elements(inputfile1) eq 0) then $
message,'Argument FILE is underfined'
str=''
;maxrec=92996L
maxrec=file_lines(inputfile1)
record1={RAmdeg:0.0d,DEmdeg:0.0d,Bmag:0.0d,Vmag:0.0d,BV:0.0d,RAmdeg_gala:0.0d,DEmdeg_gala:0.0d}
data1=replicate(record1,maxrec)
openr,50,inputfile1
point_lun,50,0
readf,50,data1
close,50


bin=( FindGen(11) * 0.2 ) - 0.4
n=make_array(11)
for j=0L, 10 do begin
n[j]=0L
for i=0L, maxrec-1 do begin
y=result[0] + result[1] * ( data1[i].BV ) + result[2] * ( data1[i].BV^2) + result[3] * (data1[i].BV^3) + result[4] * (data1[i].BV^4)
;if (data1[i].DEmdeg_gala gt 30.0) and (data1[i].Vmag le y ) and (data1[i].BV ge bin[j]) and (data1[i].BV lt bin[j]+0.2) then begin
x=0
if (data1[i].Vmag le y ) and (data1[i].BV ge bin[j]) and (data1[i].BV lt bin[j]+0.2) then begin
if (data1[i].DEmdeg_gala lt 10.0 ) and (data1[i].Vmag lt (12.5 - (15.4 - y))) then begin
x=1
endif 
if (data1[i].DEmdeg_gala ge 10.0 ) and (data1[i].DEmdeg_gala lt 15.0 ) and (data1[i].Vmag lt (13 - (15.4 - y))) then begin
x=1
endif 
if (data1[i].DEmdeg_gala ge 15.0 ) and (data1[i].DEmdeg_gala lt 25.0 ) and (data1[i].Vmag lt (13.5 - (15.4 - y))) then begin
x=1
endif
if (data1[i].DEmdeg_gala ge 25.0 ) and (data1[i].DEmdeg_gala lt 30.0 ) and (data1[i].Vmag lt (14 - (15.4 - y))) then begin
x=1
endif
if (data1[i].DEmdeg_gala ge 30.0 ) and (data1[i].Vmag lt (14.5 - (15.4 - y))) then begin
x=1
endif
if x eq 1 then begin
n[j]++



oplot,[data1[i].BV,data1[i].BV],[data1[i].Vmag,data1[i].Vmag],$
psym=1,thick=0.5,color=3
magab = 0.89 + (4.50*data1[i].BV) - (2.08 * (data1[i].BV^2)) + (0.38 * (data1[i].BV^3)) + data1[i].Vmag
printf,80,data1[i].RAmdeg,data1[i].DEmdeg,magab,data1[i].Bmag,data1[i].Vmag,data1[i].BV,data1[i].RAmdeg_gala,data1[i].DEmdeg_gala
endif
endif
endfor
print,bin[j],n[j]
endfor

ymin1=0
ymax1=60000
plot,bin,n,$
xrange=[xmin,xmax],yrange=[ymin1,ymax1],$
xstyle=1,$
ystyle=1,$
xthick=3,ythick=3,$
xtitle='B-V',$
XCHARSIZE=1.5,$
ytitle='Number',YCHARSIZE=1.5, $
psym=8,charthick=3,$
color=0,position=[0.15,0.15,0.9,0.4],/nodata
FOR z = 0, 10 DO EX_BOX, bin[z], !Y.CRANGE[0], bin[z]+0.2,$ 
n[z],1

close,80
close,/all
device,/close_file
print,'Done'
end