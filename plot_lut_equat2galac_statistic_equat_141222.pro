pro plot_lut_equat2galac_statistic_equat_130909
close,/all
inputfile=filepath('typho2_cata_4_lut_candidate_selection_30s.txt',$
root_dir='E:\WORK\LUT\LUT_mag_calibration\LUT_mag_calibration_130909\lut_optical_efficiency_curve\')
outputfile=filepath('plot_lut_equat2galac_statistic_equat',$
root_dir='E:\WORK\LUT\LUT_mag_calibration\LUT_mag_calibration_130909\lut_optical_efficiency_curve\')
print,'Start working.'

entry_device=!d.name
!p.multi=[1,1,1]
set_plot,'ps'
device,file=outputfile + '.ps',xsize=8,ysize=6,/inches,xoffset=0.1,yoffset=0.1,/Portrait
device,/color
loadct_plot
!p.position=0

if(n_elements(inputfile) eq 0) then $
message,'Argument FILE is underfined'
str=''
maxrec=linenum_multi_col(inputfile,str)
close,60
record={RAmdeg:0.0d,DEmdeg:0.0d,Bmag:0.0d,Vmag:0.0d,BV:0.0d,RAmdeg_gala:0.0d,DEmdeg_gala:0.0d}
data=replicate(record,maxrec)
openr,50,inputfile
point_lun,50,0
readf,50,data
close,50

map_set,0,180,/aitoff,/horizon,/noerase
map_grid
l=0L
m=0L
n=0L
o=0L

for i=0L, maxrec-1 do begin
if (data[i].DEmdeg_gala lt 30.0 ) then begin
oplot,[data[i].RAmdeg,data[i].RAmdeg],[data[i].DEmdeg,data[i].DEmdeg],$
psym=1,thick=0.1,$
color=0
l=l+1
endif 
if (data[i].DEmdeg_gala ge 30.0 ) and (data[i].DEmdeg_gala lt 40.0 ) then begin
oplot,[data[i].RAmdeg,data[i].RAmdeg],[data[i].DEmdeg,data[i].DEmdeg],$
psym=1,thick=0.1,$
color=1
m=m+1
endif 
if (data[i].DEmdeg_gala ge 40.0 ) and (data[i].DEmdeg_gala lt 50.0 ) then begin
oplot,[data[i].RAmdeg,data[i].RAmdeg],[data[i].DEmdeg,data[i].DEmdeg],$
psym=1,thick=0.1,$
color=2
n=n+1
endif
if (data[i].DEmdeg_gala ge 50.0 ) then begin
oplot,[data[i].RAmdeg,data[i].RAmdeg],[data[i].DEmdeg,data[i].DEmdeg],$
psym=1,thick=0.1,$
color=3
o=o+1
endif
endfor
print,l+m+n+o,l,m,n,o



;ra_moon:17h47m
;dec_moon:65.45 degree
;pi=3.14159
ra_moon=(47.0/60.0+17.0)/12*180
print,ra_moon
dec_moon=65.45
oplot,[ra_moon,ra_moon],[dec_moon,dec_moon],$
psym=2,thick=3,color=1
oplot,[180,180],[-90,90],$
linestyle=1,thick=5,color=1
cthick=5
csize=2
;xyouts,270,40,l,charsize=csize-0.5,color=0,charthick=cthick+1
xyouts,220,28,m,charsize=csize-0.5,color=0,charthick=cthick+1
xyouts,180,30,n,charsize=csize-0.5,color=0,charthick=cthick+1
xyouts,120,40,o,charsize=csize-0.5,color=0,charthick=cthick+1
;xyouts,70,40,p/(m+n+o+p+l+r),charsize=csize-0.5,color=0,charthick=cthick+1
;xyouts,30,40,r/(m+n+o+p+l+r),charsize=csize-0.5,color=0,charthick=cthick+1
xyouts,5,0,'0',charsize=csize,color=0,charthick=cthick
xyouts,180,0,'180',charsize=csize,color=0,charthick=cthick
xyouts,330,0,'360',charsize=csize,color=0,charthick=cthick
xyouts,180,80,'N',charsize=csize,color=0,charthick=cthick
xyouts,180,-90,'S',charsize=csize,color=0,charthick=cthick
xyouts,ra_moon+10,dec_moon,'N Pole (Moon)',charsize=csize-0.5,color=0,charthick=cthick+1
xyouts,90,-40,'Equatorial coordinate system',charsize=csize,color=0,charthick=cthick

close,/all
device,/close_file
print,'Done'
end