pro bv_color_fit_new_effi_curve_141222
close,/all
;without CCD sensitivity curve
;inputfile=filepath('mag4lot_tyc.dat',$
;with CCD sensitivity curve
inputfile=filepath('mag4lot_tyc_bv_ccd.dat',$
root_dir='/home/han/WORK/LUT/LUT_mag_calibration/LUT_mag_calibration_141222/lut_optical_efficiency_curve/')
;without CCD sensitivity curve
;outputfile=filepath('v_color_fit',$
;with CCD sensitivity curve
outputfile=filepath('bv_color_abs_fit_ccd',$
root_dir='/home/han/WORK/LUT/LUT_mag_calibration/LUT_mag_calibration_141222/lut_optical_efficiency_curve/')
;outputfile1=filepath('mag4lot_tyc_limit',$
;root_dir='/Users/hanxuhui/WORK/LOT/tycho2/')
entry_device=!d.name
!p.multi=[1,1,1]
set_plot,'ps'
device,file=outputfile + '.ps',xsize=8,ysize=8,/inches,xoffset=0.1,yoffset=0.1,/Portrait
device,/color
loadct_plot
!p.position=0


if(n_elements(inputfile) eq 0) then $
message,'Argument FILE is underfined'
str=''
maxrec=linenum_multi_col(inputfile,str)
close,60
record={magab:0.0d,magvega_b:0.0d,magvega_v:0.0d,magvega_bv:0.0d,mag_minus:0.0d,magab_30:0.0d,magvega_30:0.0d,redleak_persent:0.0d}
data=replicate(record,maxrec-1)
openr,50,inputfile
point_lun,50,0
str=''
readf,50,str
readf,50,data
close,50

;PLOTSYM,8,1,/FILL
plot,data.magvega_bv,data.mag_minus ,$
;xrange=[-0.5,5.0],yrange=[-2.0,6.0],$
xstyle=1,$
;/XLOG,$
ystyle=1,$
xtitle='B-R',$
XCHARSIZE=1.5,$
ytitle='LUT mag(AB) - R mag',YCHARSIZE=1.5, $
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
label1=-2.0
label2=11.5
label3=-1
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


;mag1=-2.0
;x0=-0.5
;x1=3.0
;oplot,[x0,x1],[mag1,mag1],linestyle=1,thick=3,color=0
;oplot,[x0,x1],[mag1+2.0,mag1+2.0],linestyle=1,thick=3,color=0
;oplot,[x0,x1],[mag1+4.0,mag1+4.0],linestyle=1,thick=3,color=0
;oplot,[x0,x1],[mag1+6.0,mag1+6.0],linestyle=1,thick=3,color=0
;oplot,[x0,x1],[mag1+8.0,mag1+8.0],linestyle=1,thick=3,color=0
;oplot,[x0,x1],[mag1+10.0,mag1+10.0],linestyle=1,thick=3,color=0
;oplot,[x0,x1],[mag1+12.0,mag1+12.0],linestyle=1,thick=3,color=0

record1={magvega_bv:0.0d,mag_minus:0.0d}
data1=replicate(record1,maxrec+3)
for m=0 , maxrec-2 do begin
data1[m].magvega_bv = data[m].magvega_bv
data1[m].mag_minus = data[m].mag_minus
endfor

;without CCD sensitivity curve
;data1[maxrec-1].magvega_bv = 2.14
;data1[maxrec-1].mag_minus = 8.23
;data1[maxrec].magvega_bv = 2.24
;data1[maxrec].mag_minus = 8.33
;data1[maxrec+1].magvega_bv = 2.44
;data1[maxrec+1].mag_minus = 8.43
;data1[maxrec+2].magvega_bv = 2.64
;data1[maxrec+2].mag_minus = 8.53
;with CCD sensitivity curve
data1[maxrec-1].magvega_bv = 2.5
data1[maxrec-1].mag_minus = 3.3
data1[maxrec].magvega_bv = 2.7
data1[maxrec].mag_minus = 3.35
data1[maxrec+1].magvega_bv = 2.9
data1[maxrec+1].mag_minus = 3.4
data1[maxrec+2].magvega_bv = 3.0
data1[maxrec+2].mag_minus = 3.45


result=poly_fit(data1.magvega_bv, data1.mag_minus, 3, measure_error= measure_errors, $
sigma=sigma)

print, 'Coeffiencts:', result
print, 'Standard errors:', sigma

x2=( FindGen(450) * 0.01 ) - 1.0
y2=result[0] + result[1] * ( x2 ) + result[2] * ( x2 ^2 ) + result[3] * (x2^3) 
; + result[4] * (x2^4)
oplot,x2,y2,linestyle=1,color=0,thick=5

oplot,[data1[maxrec-1].magvega_bv,data1[maxrec-1].magvega_bv],[data1[maxrec-1].mag_minus,data1[maxrec-1].mag_minus],psym=1,thick=3,color=1
oplot,[data1[maxrec].magvega_bv,data1[maxrec].magvega_bv],[data1[maxrec].mag_minus,data1[maxrec].mag_minus],psym=1,thick=3,color=1
oplot,[data1[maxrec+1].magvega_bv,data1[maxrec+1].magvega_bv],[data1[maxrec+1].mag_minus,data1[maxrec+1].mag_minus],psym=1,thick=3,color=1
oplot,[data1[maxrec+2].magvega_bv,data1[maxrec+2].magvega_bv],[data1[maxrec+2].mag_minus,data1[maxrec+2].mag_minus],psym=1,thick=3,color=1
;xyouts,0.0,6.2,'red leak from 3340 A',charsize=csize,color=1,charthick=cthick

close,/all
device,/close_file
print,'Done'
end
