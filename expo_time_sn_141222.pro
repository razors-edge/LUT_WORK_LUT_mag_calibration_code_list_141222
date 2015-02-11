pro expo_time_sn_130909
inputfile1=filepath('Spectral_response_curve_20130909.txt',$
root_dir='E:\WORK\LUT\LUT_mag_calibration\LUT_mag_calibration_130909\lut_optical_efficiency_curve\data\')
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
result = tsum(data.wave, data.effici)
print,'numerical integration result ',result
effici_mean = result / (wave_upper - wave_lower)
print,'mean efficiency ',effici_mean

;outputfile1='E:\WORK\LUT\LUT_mag_calibration\LUT_mag_calibration_130909\lut_optical_efficiency_curve\expo_time_SN.dat'
;;outputfile1='E:\WORK\LUT\LUT_mag_calibration\LUT_mag_calibration_130624\lut_optical_efficiency_curve\expo_time_mag_limit_lunar_effici_0.4.dat'
;openw,80,outputfile1,width=360
;printf,80,'expose time (s),   S/N (AB), mag AB'
print,'expose time (s),   S/N (AB), mag AB'
for i=1, 10 do begin
t= 5.0 * i
mab=15.4
G = 1.

Rsh = 11.7 ;Rs = 11.7 e- s^-1 pixel^-1 high value (Cao et al. 2010)
Rsm = 9.4 ;Rs = 9.4 e- s^-1 pixel^-1 middle value (Cao et al. 2010)
Rsl = 0.6 ;Rs = 0.6 e- s^-1 pixel^-1 low value (Cao et al. 2010)
;Rb = 1200.0 ;Rb ≤ 1.2×10^3 e- s^-1 pixel^-1 (upper limit, Wang et al. 2011)
Rb = 0 ;Rb ≤ 1.2×10^3 e- s^-1 pixel^-1 (upper limit, Wang et al. 2011)
RN = 11; RN = 11 e- pixel^-1 is the readout noise.

SN = make_array(3)
for z=0,2 do begin
case z of 
0: Rs = Rsh
1: Rs = Rsm
2: Rs = Rsl
endcase

; mab = -2.5 * alog10((N*6.63e-27)/alog(wave_upper/wave_lower)) - 48.6
;(mab + 48.6) * (-0.4) = alog10((N*6.63e-27)/alog(wave_upper/wave_lower))
;10 ^ ((mab + 48.6) * (-0.4)) = (N*6.63e-27)/alog(wave_upper/wave_lower))
;(N*6.63e-27) = 10 ^ ((mab + 48.6) * (-0.4)) * alog(wave_upper/wave_lower)
N = (1/6.63e-27) * (10 ^ ((mab + 48.6) * (-0.4))) * alog(wave_upper/wave_lower)
R = N * (3.14 * (15)^2 *  0.80 * effici_mean * 0.72 * 0.9 ) / 4.0
SN[z] = (R*t) / sqrt((R*t) + 9.0 * (Rs * t + Rb * t + 1 * t + 8^2 + (G^2.*0.289)))

endfor



print,t,mab,SN
;printf,80,t,SN,mab
endfor
close,/all
end