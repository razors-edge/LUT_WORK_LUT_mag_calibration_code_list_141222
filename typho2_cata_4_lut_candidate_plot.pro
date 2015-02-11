pro typho2_cata_4_lut_candidate_plot
inputfile=filepath('typho2_cata_4_lut_candidate_selection_30s.txt',$
root_dir='E:\WORK\LUT\LUT_mag_calibration\LUT_mag_calibration_130909\lut_optical_efficiency_curve\')
outputfile=filepath('typho2_cata_4_lut_candidate_plot',$
root_dir='E:\WORK\LUT\LUT_mag_calibration\LUT_mag_calibration_130909\lut_optical_efficiency_curve\')

entry_device=!d.name
!p.multi=[0,1,0]
set_plot,'ps'
device,file=outputfile + '.ps',xsize=8,ysize=8,/inches,xoffset=0.1,yoffset=0.1,/Portrait
device,/color
loadct_plot
!p.position=0

if(n_elements(inputfile) eq 0) then $
message,'Argument FILE is underfined'
maxrec=file_lines(inputfile)
record={RAmdeg:0.0d,DEmdeg:0.0d,Bmag:0.0d,Vmag:0.0d,BV:0.0d,RAmdeg_gala:0.0d,DEmdeg_gala:0.0d}
data=replicate(record,maxrec)
openr,50,inputfile
point_lun,50,0
;str=''
;readf,50,str
readf,50,data
close,50


;mag_limit_30 = 15.4
xmin=0
xmax=360
ymin=0
ymax=90
PLOTSYM,3,1.5,thick=5,/FILL
plot,data.RAmdeg,data.DEmdeg,$
xrange=[xmin,xmax],yrange=[ymin,ymax],$
xstyle=1,$
ystyle=1,$
xthick=3,ythick=3,$
xtitle='RA',$
XCHARSIZE=1.5,$
ytitle='DEC',YCHARSIZE=1.5, $
psym=1,$
charthick=1,$
XTICKLEN=1,$
YTICKLEN=1,$
XGRIDSTYLE=1,$
YGRIDSTYLE=1,$
color=3,position=[0.15,0.4,0.9,0.9]
;axis,xaxis=1,xstyle=1,XCHARSIZE=0.001,xthick=3


close,/all
device,/close_file
print,'Done'
end