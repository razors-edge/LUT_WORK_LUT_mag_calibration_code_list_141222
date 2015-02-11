pro plot_bv_vs_abv
close,/all
;without CCD sensitivity curve
;inputfile=filepath('mag4lot_tyc.dat',$
;with CCD sensitivity curve
inputfile=filepath('mag4lot_tyc_bv_ccd.dat',$
root_dir='/home/han/WORK/LUT/LUT_mag_calibration/LUT_mag_calibration_141222/lut_optical_efficiency_curve/')
;without CCD sensitivity curve
;outputfile=filepath('mag4lot_AB_bv',$
;with CCD sensitivity curve
outputfile=filepath('mag4lut_bv_vs_abv',$
root_dir='/home/han/WORK/LUT/LUT_mag_calibration/LUT_mag_calibration_141222/lut_optical_efficiency_curve/')
entry_device=!d.name
!p.multi=[1,1,1]
set_plot,'ps'
device,file=outputfile + '.ps',xsize=8,ysize=8,/inches,xoffset=0.1,yoffset=0.1,/Portrait
device,/color
;loadct_plot
!p.position=0


if(n_elements(inputfile) eq 0) then $
message,'Argument FILE is underfined'
;record={filename:'',type:'',tem:0L,magab:0.0d,magvega_b:0.0d,magvega_v:0.0d,magvega_bv:0.0d,mag_minus:0.0d,magab_30:0.0d,magvega_30:0.0d}
record={magab:0.0d,magvega_b:0.0d,magvega_v:0.0d,magvega_bv:0.0d,mag_minus:0.0d,magab_30:0.0d,magvega_30:0.0d,redleak_persent:0.0d}
data=replicate(record,40)
openr,50,inputfile
point_lun,50,0
str=''
readf,50,str
for i=0, 39 do begin
readf,50,str
word = STRSPLIT(str, /EXTRACT)
data[i].magvega_bv = word[3]
data[i].mag_minus = word[4]
data[i].redleak_persent = word[7]
print,data[i].magvega_bv, data[i].mag_minus,data[i].redleak_persent
endfor
close,50

x1=-0.5
x2=2
;without CCD sensitivity curve
;y1=1
;y2=9
;with CCD sensitivity curve
y1=-2
y2=5

;PLOTSYM,8,1,/FILL
plot,data.magvega_bv,data.mag_minus ,$
;xrange=[x1,x2],$
;yrange=[y1,y2],$
xstyle=1,$
;/XLOG,$
ystyle=1,$
xtitle='B-V',$
XCHARSIZE=1.5,$
ytitle='LOT mag(AB) - V mag',YCHARSIZE=1.5, $
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
label1=y1
label2=y2
label3=-1.3
csize_small=1
cthick_small=2
;for n=0L,N_ELEMENTS(data.redleak_persent)-1 do begin
;xyouts,data[n].magvega_bv,data[n].mag_minus,string(fix(data[n].redleak_persent*100))+"%",charsize=csize_small,color=1,charthick=cthick_small
;endfor
;xyouts,0.0,6.2,'red leak from 3340 A',charsize=csize,color=1,charthick=cthick 

;oplot,[-2.9,-2.9],[label1,label2],linestyle=1,thick=3,color=0
;xyouts,-2.9,label3,'B0',charsize=csize,color=1,charthick=cthick
;oplot,[0,0],[label1,label2],linestyle=1,thick=3,color=0
;xyouts,-0.05,label3,'A0',charsize=csize,color=1,charthick=cthick
;oplot,[0.31,0.31],[label1,label2],linestyle=1,thick=3,color=0
;xyouts,0.26,label3,'F0',charsize=csize,color=1,charthick=cthick
;oplot,[0.59,0.59],[label1,label2],linestyle=1,thick=3,color=0
;xyouts,0.54,label3,'G0',charsize=csize,color=1,charthick=cthick
;oplot,[0.82,0.82],[label1,label2],linestyle=1,thick=3,color=0
;xyouts,0.77,label3,'K0',charsize=csize,color=1,charthick=cthick
;oplot,[1.41,1.41],[label1,label2],linestyle=1,thick=3,color=0
;xyouts,1.36,label3,'M0',charsize=csize,color=1,charthick=cthick



close,/all
device,/close_file
print,'Done'
end
