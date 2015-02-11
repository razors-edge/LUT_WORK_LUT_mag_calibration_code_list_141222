pro plot_CK04_spectrum_130909
close,/all
path='E:\WORK\LUT\LUT_mag_calibration\LUT_mag_calibration_130909\CK04_model\ckp00\'
list=findfile(path+'ckp00*_grav.txt')
file_number=n_elements(list)
print,file_number
;outputfile1='/Users/hanxuhui/WORK/LOT/LOT_mag/CASTELLI_KURUCZ_ATLAS/ckp00/flux_tot.dat'
;openw,80,outputfile1
for i=0L, file_number-1 do begin
inputfile=strcompress(list[i],/remove)
print,inputfile
string = STRSPLIT(inputfile, '.', /EXTRACT)
string1 = STRSPLIT(string[0], '\', /EXTRACT)
tem = STRSPLIT(string1[7], '_', /EXTRACT)
path_out = strcompress(path + 'ck04_spec\',/remove)
outputfile = strcompress(path_out+string1[7],/remove)
print,outputfile,tem[1]

entry_device=!d.name
!p.multi=[1,1,1]
set_plot,'ps'
device,file=outputfile + '.ps',xsize=8,ysize=8,/inches,xoffset=0.1,yoffset=0.1,/Portrait
device,/color
loadct_plot
!p.position=0

record={wave:0.0d,flux:0.0d}
maxrec=linenum_multi_col(inputfile,record)
close,60

data=replicate(record,maxrec)
openr,50,inputfile
readf,50,data
close,50


plot,data.wave,data.flux,$
xrange=[1000,11000],$
xstyle=1,$
ystyle=1,$
xtitle='Wavelength (A)',$
XCHARSIZE=1.5,$
ytitle='Flux (erg cm-2 s-1 A-1)',YCHARSIZE=1.5, $
thick=5,$
color=white,position=[0.15,0.15,0.9,0.9]
csize=2
y1=min(data.flux)
y2=max(data.flux)
y3=(y1+y2)/2
oplot,[2350,2350],[y1,y2],linestyle=0,thick=5,color=0
oplot,[3400,3400],[y1,y2],linestyle=0,thick=5,color=0
xyouts,2400,y3,'LUT',charsize=csize,color=0,charthick=5
oplot,[5480,5480],[y1,y2],linestyle=1,thick=5,color=0
xyouts,5510,y3,'V',charsize=csize,color=0,charthick=5
xyouts,7010,y3,'Tem:'+ tem[1],charsize=csize,color=0,charthick=5
;oplot,[8250,8250],[y1,y2],linestyle=0,thick=5,color=0
;xyouts,9150,y3,'A',charsize=csize,color=0
;oplot,[6250,6250],[y1,y2],linestyle=0,thick=5,color=0
;xyouts,7000,y3,'F',charsize=csize,color=0
;oplot,[4750,4750],[y1,y2],linestyle=0,thick=5,color=0
;xyouts,5200,y3,'G',charsize=csize,color=0
;oplot,[3760,3760],[y1,y2],linestyle=0,thick=5,color=0
;xyouts,4100,y3,'K',charsize=csize,color=0
;oplot,[3400,3400],[y1,y2],linestyle=0,thick=5,color=0
;xyouts,3410,y3,'M',charsize=csize,color=0
close,/all
device,/close_file
endfor
print,'Done'


end