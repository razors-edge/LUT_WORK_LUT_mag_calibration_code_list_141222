pro plot_lut_equat2galac_galac_polo_dec_130909
close,/all
inputfile=filepath('typho2_cata_4_lut_candidate_selection_30s.txt',$
root_dir='E:\WORK\LUT\LUT_mag_calibration\LUT_mag_calibration_130909\lut_optical_efficiency_curve\')
outputfile=filepath('plot_lut_equat2galac_galac_polo_dec_30',$
root_dir='E:\WORK\LUT\LUT_mag_calibration\LUT_mag_calibration_130909\lut_optical_efficiency_curve\')
print,'Start working'

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

;ra_moon:17h47m
;dec_moon:65.45 degree
;pi=3.14159
ra_moon=(47.0/60.0+17.0)/12*180
dec_moon=65.45
glactc,ra_moon,dec_moon,2000,gl_moon,gb_moon,1, /degree
ra_gala=((37.224/60+45)/60 + 17)/12*180
dec_gala=-28.936175
map_set,0,gl_moon,/aitoff,/horizon,/noerase
map_grid
m=0L
n=0L
o=0L
p=0L
r=0L
for i=0L, maxrec-1 do begin
if (data[i].DEmdeg_gala lt 30.0 ) then begin
oplot,[data[i].RAmdeg_gala,data[i].RAmdeg_gala],[data[i].DEmdeg_gala,data[i].DEmdeg_gala],$
psym=1,thick=0.1,$
color=0
m=m+1
endif 
if (data[i].DEmdeg_gala ge 30.0 ) and  (data[i].DEmdeg_gala lt 40.0 ) then begin
oplot,[data[i].RAmdeg_gala,data[i].RAmdeg_gala],[data[i].DEmdeg_gala,data[i].DEmdeg_gala],$
psym=1,thick=0.1,$
color=1
n=n+1
endif
if (data[i].DEmdeg_gala ge 40.0 ) and  (data[i].DEmdeg_gala lt 50.0 ) then begin
oplot,[data[i].RAmdeg_gala,data[i].RAmdeg_gala],[data[i].DEmdeg_gala,data[i].DEmdeg_gala],$
psym=1,thick=0.1,$
color=2
o=o+1
endif
if (data[i].DEmdeg_gala ge 50.0 ) then begin
oplot,[data[i].RAmdeg_gala,data[i].RAmdeg_gala],[data[i].DEmdeg_gala,data[i].DEmdeg_gala],$
psym=1,thick=0.1,$
color=3
p=p+1
endif
endfor
print,m+n+o+p,m,n,o,p

oplot,[gl_moon,gl_moon],[gb_moon,gb_moon],$
psym=2,thick=3,color=1
oplot,[180,180],[-90,90],$
linestyle=1,thick=5,color=1
cthick=5
csize=2


;sky field area(degree square): 
; 30-40        40-50        50-60  (dec in galactic correlation)
; 588.696      515.273      309.748
s1=588.696
s2=515.273
s3=309.748



xyouts,335,30,n,charsize=csize-0.5,color=0,charthick=cthick+1
xyouts,335,40,o,charsize=csize-0.5,color=0,charthick=cthick+1
xyouts,335,50,p,charsize=csize-0.5,color=0,charthick=cthick+1
label1 = (strtrim(strtrim(string(format='(f5.2)',n/s1)),1))
xyouts,140,35,label1+'/degree^2',charsize=csize-0.5,color=0,charthick=cthick+1
label1 = (strtrim(strtrim(string(format='(f5.2)',o/s2)),1))
xyouts,135,47,label1+'/degree^2',charsize=csize-0.5,color=0,charthick=cthick+1
label1 = (strtrim(strtrim(string(format='(f5.2)',p/s3)),1))
xyouts,130,58,label1+'/degree^2',charsize=csize-0.5,color=0,charthick=cthick+1

xyouts,5,-5,'0',charsize=csize,color=0,charthick=cthick
xyouts,180,-5,'180',charsize=csize,color=0,charthick=cthick
xyouts,330,-5,'360',charsize=csize,color=0,charthick=cthick
xyouts,180,80,'N',charsize=csize,color=0,charthick=cthick
xyouts,180,-90,'S',charsize=csize,color=0,charthick=cthick
xyouts,0,-40,'Galactic coordinate system',charsize=csize,color=0,charthick=cthick
;xyouts,ra_moon+10,dec_moon,'N Pole (Moon)',charsize=csize-0.5,color=0,charthick=cthick+1


close,/all
device,/close_file
print,'Done'
end