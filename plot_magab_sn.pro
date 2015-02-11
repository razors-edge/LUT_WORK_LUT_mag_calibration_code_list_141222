pro plot_magab_sn
close,/all
inputfile=filepath('expo_time_mag_limit_lunar_new_curve.dat',$
root_dir='E:\WORK\LUT\LUT_mag_calibration\LUT_mag_calibration_130909\lut_optical_efficiency_curve\')
outputfile=filepath('plot_magab_sn_new_curve',$
root_dir='E:\WORK\LUT\LUT_mag_calibration\LUT_mag_calibration_130909\lut_optical_efficiency_curve\')

entry_device=!d.name
!p.multi=[1,1,1]
set_plot,'ps'
device,file=outputfile + '.ps',xsize=8,ysize=8,/inches,xoffset=0.1,yoffset=0.1,/Portrait
device,/color
loadct_plot
!p.position=0

maxrec = file_lines(inputfile)
data = make_array(4,maxrec-1)
openr,50,inputfile
str=''
readf,50,str
readf,50,data
close,50

linethick = 5

plot,data[0,*],data[3,*],$
xrange=[15.5,12.5],$
yrange=[0,50],$
xstyle=1,$
ystyle=1,$
xtitle='mag limit AB',$
XCHARSIZE=1.5,$
ytitle='SN',YCHARSIZE=1.5, $
thick=linethick,$
color=0,$
linestyle=0,$
XTICKLEN=1,YTICKLEN=1,$
XGRIDSTYLE=1,YGRIDSTYLE=1,$
position=[0.2,0.15,0.9,0.9],$
/nodata
;/ylog,$
;ytickformat='(e8.1)'
csize=linethick
;y1=min(data.total)
;y2=max(data.total)
;y3=(y1+y2)/2

oplot,data[0,*],data[3,*],linestyle=0,thick=linethick,color=1
xyouts,15.2,40,'Rs = 11.7',charsize=2,color=1,charthick=linethick
oplot,data[1,*],data[3,*],linestyle=0,thick=linethick,color=2
xyouts,15.2,43,'Rs = 9.4',charsize=2,color=2,charthick=linethick
oplot,data[2,*],data[3,*],linestyle=0,thick=linethick,color=3
xyouts,15.2,46,'Rs = 0.6',charsize=2,color=3,charthick=linethick


close,/all
device,/close_file
print,'Done'
end