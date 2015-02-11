pro plot_color_vs_limit_mag_30s_new_effi_curve_130909
close,/all
inputfile=filepath('mag4lot_tyc_ccd.dat',$
root_dir='E:\WORK\LUT\LUT_mag_calibration\LUT_mag_calibration_130909\lut_optical_efficiency_curve\')
outputfile=filepath('mag4lot_mag_limit_30s_bv_ccd',$
root_dir='E:\WORK\LUT\LUT_mag_calibration\LUT_mag_calibration_130909\lut_optical_efficiency_curve\')
entry_device=!d.name
!p.multi=[1,1,1]
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

mag_limit_30 = 15.4
for i=0, 39 do begin
readf,50,str
word = STRSPLIT(str, /EXTRACT)
data[i].magvega_bv = word[3]
data[i].mag_minus = word[4]
mag_limit = mag_limit_30 - data[i].mag_minus
print,data[i].magvega_bv, data[i].mag_minus, mag_limit
endfor
close,50

x1=-0.4
x2=1.9
y1=9
y2=17.2
;PLOTSYM,8,1,/FILL
plot,data.magvega_bv,(mag_limit_30 - data.mag_minus),$
xrange=[x1,x2],yrange=[y1,y2],$
xstyle=1,$
ystyle=1,$
xtitle='B-V',$
XCHARSIZE=1.5,$
ytitle='V mag limit (AB mag limit of 15.4(30s))',YCHARSIZE=1.5, $
psym=1,thick=5,charthick=3,$
;XTICKLEN=1,$
YTICKLEN=1,$
;XGRIDSTYLE=1,$
YGRIDSTYLE=1,$
color=white,position=[0.1,0.15,0.9,0.9]


;Color Index  Spectral Type   Approximate Color
;1.41   M0  Red
;0.82   K0  Orange
;0.59   G0  Yellow
;0.31   F0  Yellowish
;0.00   A0  White
;-0.29  B0  Blue


cthick=3
csize=2
label1=2.8
label2=18.0
label3=10.0
oplot,[-2.9,-2.9],[label1,label2],linestyle=1,thick=3,color=0
xyouts,-2.9,label3,'B0',charsize=csize,color=1,charthick=cthick
oplot,[0,0],[label1,label2],linestyle=1,thick=3,color=0
xyouts,-0.05,label3,'A0',charsize=csize,color=1,charthick=cthick
oplot,[0.31,0.31],[label1,label2],linestyle=1,thick=3,color=0
xyouts,0.26,label3,'F0',charsize=csize,color=1,charthick=cthick
oplot,[0.59,0.59],[label1,label2],linestyle=1,thick=3,color=0
xyouts,0.54,label3,'G0',charsize=csize,color=1,charthick=cthick
oplot,[0.82,0.82],[label1,label2],linestyle=1,thick=3,color=0
xyouts,0.77,label3,'K0',charsize=csize,color=1,charthick=cthick
oplot,[1.41,1.41],[label1,label2],linestyle=1,thick=3,color=0
xyouts,1.36,label3,'M0',charsize=csize,color=1,charthick=cthick

close,/all
device,/close_file
print,'Done'
end