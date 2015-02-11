pro gaussian_profile_2d_plot_130909
close,/all
outputfile=filepath('aperture_flux',$
root_dir='E:\WORK\LUT\LUT_mag_calibration\LUT_mag_calibration_130624\lut_optical_efficiency_curve\')
entry_device=!d.name
!p.multi=[1,1,1]
set_plot,'ps'
device,file=outputfile + '.ps',xsize=8,ysize=8,/inches,xoffset=0.1,yoffset=0.1,/Portrait
device,/color
loadct_plot
!p.position=0

v=findgen(90)* 0.1-4.5
x=rebin(v,90,90,/sample)
y=rebin(reform(v,1,90),90,90,/sample)
pi=3.1415
sigma = 1.08
e=2.72
r=sqrt(2*pi)*sigma
z= (1/r) * e^(-(x^2)/2*(sigma^2))*(1/r) * e^(-(y^2)/2*(sigma^2)) 
print,min(z),max(z)-min(z)

print,total(z)
total_z = 0
single_z = 0
x1=make_array(30,30)
y1=make_array(30,30)
z1=make_array(30,30)


for i=30,59 do begin
for j=30,59 do begin
total_z=total_z + z[i,j]
x1[i-30,j-30]=x[i,j]
y1[i-30,j-30]=y[i,j]
z1[i-30,j-30]=z[i,j]
;print,z1[i-30,j-30],z[i,j],i,j
endfor
endfor
for i=40,49 do begin
for j=40,49 do begin
single_z=single_z + z[i,j]
endfor
endfor
print,'total:',total_z
print,'total_z/total(z):',total_z/total(z)
print,'single z:',single_z
print,'single_z/total(z):',single_z/total(z)


; Create the Z variable:  
;Z = SHIFT(DIST(40), 20, 20)  
;Z = EXP(-(Z/10)^2)  
; NX and NY are the X and Y dimensions of the Z array:  
NX = (SIZE(Z))(1)   
NY = (SIZE(Z))(2)  
; Set up !P.T with default SURFACE transformation.  
SCALE3,az=40  
; Define the three-dimensional plot  
; window: x = 0.1 to 1, Y=0.1 to 1, and z = 0 to 1.  
POS=[.1, .1, 1, 1, 0, 1]  
; Make the stacked contours. Use 10 contour levels.  
;CONTOUR, Z, /T3D, NLEVELS=10, /NOCLIP, POSIT=POS, CHARSIZE=2 
shade_surf,z1,x1,y1, /T3D, /NOCLIP, POSIT=POS, CHARSIZE=2,$
zrange=[0,0.14],zstyle=1,$
xrange=[-1.5,1.5],xstyle=1,$
yrange=[-1.5,1.5],ystyle=1



; Swap y and z axes. The original xyz system is now xzy:  
T3D, /YZEXCH 
; Plot the column sums in front of the contour plot:  
x2=findgen(61)* 0.1-4.5
y2= (1/r) * e^(-(x2^2)/2*(sigma^2))
print,sigma,min(y2),max(y2)- min(y1)
;print,stddev(Y1) /sqrt(30)
;fwhm=2.35482 * stddev(y1)/sqrt(30)
;print,fwhm
PLOT, x2,y2, /NOERASE, /NOCLIP, /T3D, $  
    POSITION = POS, CHARSIZE = 2 ,thick=8,color=0,$
    xrange=[-1.5,1.5],xstyle=1,xthick=5,$
    yrange=[0.0,0.14],ystyle=1,ythick=5,/nodata 
OPLOT, x2,(y2-0.07) * 0.440 , /T3D, $
       thick=8,color=3
Y1=0.0
y2=0.14
csize=2 
oplot,[0,0],[y1,y2], /T3D,linestyle=0,thick=5,color=1
oplot,[-0.5,-0.5],[y1,y2], /T3D,linestyle=0,thick=5,color=0
oplot,[0.5,0.5],[y1,y2], /T3D,linestyle=0,thick=5,color=0
oplot,[-0.5,0.5],[0.11,0.11], /T3D,linestyle=0,thick=5,color=0
xyouts,-0.2,0.118, /T3D,'12.38%',charsize=csize,charthick=5,color=0
;oplot,[-1,-1],[y1,y2], /T3D,linestyle=0,thick=5,color=0
;oplot,[1,1],[y1,y2], /T3D,linestyle=0,thick=5,color=0
;oplot,[-1,1],[0.28,0.28], /T3D,linestyle=0,thick=5,color=0
;xyouts,-0.2,0.3, /T3D,'86.47%',charsize=csize,charthick=5,color=0
oplot,[-1.5,-1.5],[y1,y2], /T3D,linestyle=0,thick=5,color=0
oplot,[1.5,1.5],[y1,y2], /T3D,linestyle=0,thick=5,color=0
oplot,[-1.5,1.5],[0.01,0.01], /T3D,linestyle=0,thick=5,color=0
xyouts,-0.2,0.02, /T3D,'80.00%',charsize=csize,charthick=5,color=0

close,/all
device,/close_file
print,'Done'
end