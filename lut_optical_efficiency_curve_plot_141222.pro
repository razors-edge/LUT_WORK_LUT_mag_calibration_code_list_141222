pro LUT_optical_efficiency_curve_plot_130909
close,/all
data_path = 'E:\WORK\LUT\LUT_mag_calibration\LUT_mag_calibration_130909\lut_optical_efficiency_curve\data\'
effi_curve_path = 'E:\WORK\LUT\LUT_mag_calibration\LUT_mag_calibration_130909\lut_optical_efficiency_curve'
inputfile1=filepath('Spectral_response_curve_20130909.txt',$
root_dir=data_path)

;inputfile1=filepath('test.dat',$
;root_dir='E:\WORK\LUT\LUT_mag_calibration\LUT_mag_calibration_130909\lut_optical_efficiency_curve\data\')

inputfile2=filepath('johnson_B.txt',$
;inputfile2=filepath('johnson_b_004_syn_t1.txt',$
root_dir=data_path)
inputfile3=filepath('johnson_V.txt',$
;inputfile3=filepath('johnson_v_004_syn_t1.txt',$
root_dir=data_path)

outputfile=filepath('Spectral_response_curve_20130909',$
root_dir=effi_curve_path)
entry_device=!d.name
!p.multi=[1,1,1]
set_plot,'ps'
device,file=outputfile + '.ps',xsize=8,ysize=8,/inches,xoffset=0.1,yoffset=0.1,/Portrait
device,/color
loadct_plot
!p.position=0

if(n_elements(inputfile1) eq 0) then $
message,'Argument FILE is underfined'
str=''
maxrec1=linenum_multi_col(inputfile1,str)
close,60
record1={wave:0L,filter:0.0d}
data1=replicate(record1,maxrec1)
openr,50,inputfile1
point_lun,50,0
readf,50,data1
close,50
data1.wave = data1.wave * 10.0

if(n_elements(inputfile2) eq 0) then $
message,'Argument FILE is underfined'
str=''
maxrec2=linenum_multi_col(inputfile2,str)
close,60
record2={wave:0L,persent:0.0d,filter:0.0d}
data2=replicate(record2,maxrec2)
openr,50,inputfile2
point_lun,50,0
readf,50,data2
close,50
data2.filter = data2.filter / 5.5

if(n_elements(inputfile3) eq 0) then $
message,'Argument FILE is underfined'
str=''
maxrec3=linenum_multi_col(inputfile3,str)
close,60
record3={wave:0L,persent:0.0d,filter:0.0d}
data3=replicate(record3,maxrec3)
openr,50,inputfile3
point_lun,50,0
readf,50,data3
close,50
data3.filter = data3.filter / 5.5

linethick = 5

plot,data1.wave,data1.filter,$
xrange=[1800,8200],$
yrange=[-0.01,0.2],$
xstyle=1,$
ystyle=1,$
xtitle='Wavelength (A)',$
XCHARSIZE=1.5,$
ytitle='Efficiency',YCHARSIZE=1.5, $
thick=linethick,$
linestyle=0,color=0,$
position=[0.2,0.15,0.9,0.9],$
;/ylog,$
ytickformat='(e8.1)'
csize=linethick
;y1=min(data.total)
;y2=max(data.total)
;y3=(y1+y2)/2
xyouts,2500,0.14,'LUT',charsize=2,color=0,charthick=linethick

oplot,data2.wave,data2.filter,linestyle=1,thick=linethick,color=3
xyouts,3400,0.14,'JohnsonB',charsize=2,color=3,charthick=linethick
oplot,data3.wave,data3.filter,linestyle=1,thick=linethick,color=2
xyouts,5200,0.14,'JohnsonV',charsize=2,color=2,charthick=linethick

x1=5000
y1=0.1
y2=0.07
y3=0.8

;oplot,[2000,2000],[-2,2],linestyle=1,thick=linethick,color=1
;oplot,[3000,3000],[-2,2],linestyle=1,thick=linethick,color=1
;oplot,[4000,4000],[-2,2],linestyle=1,thick=linethick,color=1

oplot,[2450,2450],[-2,2],linestyle=1,thick=linethick,color=1
oplot,[3400,3400],[-2,2],linestyle=1,thick=linethick,color=1

;fwhm_wave=fw_hm(data1.filter, CENTROID=cx)
;print,fwhm_wave,cx

close,/all
device,/close_file
print,'Done'
end
