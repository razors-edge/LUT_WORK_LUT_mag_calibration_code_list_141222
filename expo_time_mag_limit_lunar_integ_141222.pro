pro expo_time_mag_limit_lunar_integ_130909
close,/all
inputfile1=filepath('Spectral_response_curve_20130909.txt',$
root_dir='E:\WORK\LUT\LUT_mag_calibration\LUT_mag_calibration_130909\lut_optical_efficiency_curve\data\')
;inputfile2=filepath('CCD47-20UV.dat',$
;root_dir='E:\WORK\LOT\LOT_mag\CASTELLI_KURUCZ_ATLAS\CCD_response\')
;outputfile=filepath('test.dat',$
;root_dir='E:\WORK\LUT\LUT_mag_calibration\LUT_mag_calibration_130909\lut_optical_efficiency_curve\data\')
;openw,90,outputfile,width=360
record={wave:0.0d,effici:0.0d}
maxrec=6000L
data=replicate(record,maxrec)
data.wave = FINDGEN(6000) + 2000


if(n_elements(inputfile1) eq 0) then $
message,'Argument FILE is underfined'
str=''
maxrec1=linenum_multi_col(inputfile1,str)
close,60
record1={wave:0L,effici:0.0d}
data1=replicate(record1,maxrec1)
openr,50,inputfile1
point_lun,50,0
readf,50,data1
close,50
data1.wave = data1.wave * 10.0
data1.effici = data1.effici
data.effici = INTERPOL(data1.effici,data1.wave, data.wave)
;a_result = tsum(data.wave, data.effici)
;a_result1 = tsum(data1.wave, data1.effici)
;print,a_result,a_result1
;for x=0,6000-1 do begin
;print,data[x].wave,data[x].effici
;endfor


;wave_lower = 2450.0
;wave_upper = 3400.0
;fwhm_center = 3000
;fwhm_width  = ~500
;wave_lower = 2750.0
;wave_upper = 3250.0
wave_lower = 2000.0
wave_upper = 8000.0

n=0.0
effici=0.0d
;for i=0, maxrec1-1 do begin
;if (data1[i].wave Ge wave_lower and data1[i].wave Le wave_upper) then begin
;effici = effici + data1[i].effici
;n=n+1.0
;endif
;endfor
;effici_mean = effici / n
;effici_mean = 0.4 * 0.09 ;(Average CCD QE 0.4 and Optical efficiency 0.09)
;print,'efficience:',effici_mean
result = tsum(data.wave, data.effici)
print,'numerical integration result ',result
effici_mean = result / (wave_upper - wave_lower)
;effici_mean = 0.4 * 0.09 

;QE_mean = 0.4

;N=1/(6.63e-27)* alog(3300.0/2700.0) * 1e-(0.4*(mab+48.6))
;mab1s = -2.5 (alog10(N * (6.63e-27) / ( alog(3300.0/2700.0))+ 19.44)
;R = N * 3.14 * (15/2)^2 * 0.09 * 0.80 * QE_mean
;R = 65535/0.1238*0.8 = 423489
;N = 423489 / (3.14 * (15/2)^2 * 0.09 * 0.80 * effici_mean)
;window cut and mirror efficiency = 0.75 * 0.9 

N = 4 * 423489 / (3.14 * (15)^2 * 0.80 * effici_mean  * 0.72 * 0.9 )
print,'N:',N
print,'N*6.63e-27: ',N*6.63e-27
print, 'alog(',wave_upper,'/',wave_lower,')',alog(wave_upper/wave_lower)
mab1s = -2.5 * alog10((N*6.63e-27)/alog(wave_upper/wave_lower)) - 48.6 
print,'mab 1s: ',mab1s

close,/all
outputfile1='E:\WORK\LUT\LUT_mag_calibration\LUT_mag_calibration_130909\lut_optical_efficiency_curve\expo_time_mag_limit_lunar_new_curve.dat'
;outputfile1='E:\WORK\LUT\LUT_mag_calibration\LUT_mag_calibration_130624\lut_optical_efficiency_curve\expo_time_mag_limit_lunar_effici_0.4.dat'
openw,80,outputfile1,width=360
printf,80,'expose time (s),   mag full well(AB), mag limit(AB 30s)'
for i=1, 10 do begin
SN = 5
Rsh = 11.7 ;Rs = 11.7 e- s^-1 pixel^-1 high value (Cao et al. 2010)
Rsm = 9.4 ;Rs = 9.4 e- s^-1 pixel^-1 middle value (Cao et al. 2010)
Rsl = 0.6 ;Rs = 0.6 e- s^-1 pixel^-1 low value (Cao et al. 2010)
;Rb = 1200.0 ;Rb ≤ 1.2×10^3 e- s^-1 pixel^-1 (upper limit, Wang et al. 2011)
Rb = 0 ;Rb ≤ 1.2×10^3 e- s^-1 pixel^-1 (upper limit, Wang et al. 2011)
RN = 11; RN = 11 e- pixel^-1 is the readout noise.
t = 30.0

;t= 1.0 * i * 2.0
SN = 5 * i
mab=mab1s + 2.5 * alog10(t)

;when a x^2 + b x + c = 0, then x1,2 = (-b (+/-) sqrt(b^2 - 4ac))/2a
a = (t)^2
b = - SN^2 * (t)
mab_limit = make_array(3)
for z=0,2 do begin
case z of 
0: Rs = Rsh
1: Rs = Rsm
2: Rs = Rsl
endcase
c = - SN^2 * 9 * (Rs * t + Rb * t + 1 * t + RN^2)
R = (-b + sqrt(b^2 - 4*a*c))/(2*a)
;R = 58
;print,'R',R
N_limit =  4 * R / (3.14 * (15)^2 *  0.80 * effici_mean * 0.72 * 0.9 )
F_den = (N_limit*6.63e-27)
;mab_limit[z] = -2.5 * alog10((N_limit*6.63e-27)/alog(wave_upper/wave_lower)) - 48.6
mab_limit[z] = -2.5 * alog10(F_den/alog(wave_upper/wave_lower)) - 48.6
endfor
print,mab,mab_limit[0],mab_limit[1],mab_limit[2],SN
printf,80,mab,mab_limit[0],mab_limit[1],mab_limit[2],SN
endfor
close,/all
end