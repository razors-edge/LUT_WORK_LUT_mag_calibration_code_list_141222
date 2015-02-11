pro ck04_spec_2_mag_new_effi_curve_141222
;ck04 spectra red leak by new efficiency curve
close,/all
path='/home/han/WORK/LUT/LUT_mag_calibration/LUT_mag_calibration_141222/CK04_model/ckp00/'
list=findfile(path+'ckp00*_grav_part_interpol.txt')
file_number=n_elements(list)
print,file_number

inputfile1=filepath('Spectral_response_curve_20130909.txt',$
root_dir='/home/han/WORK/LUT/LUT_mag_calibration/LUT_mag_calibration_141222/lut_optical_efficiency_curve/data/')
outputfile=('/home/han/WORK/LUT/LUT_mag_calibration/LUT_mag_calibration_141222/'+$
'lut_optical_efficiency_curve/ck04_model_mag_ab.dat')

if(n_elements(inputfile1) eq 0) then $
message,'Argument FILE is underfined'
str=''
maxrec1=linenum_multi_col(inputfile1,str)
close,60
record1={wave:0L,effi:0.0d}
data1=replicate(record1,maxrec1)
openr,50,inputfile1
point_lun,50,0
readf,50,data1
close,50
data1.wave = data1.wave * 10.0
data1.effi = data1.effi

; Define the independent variable.  
x = FINDGEN(7000)+2000
effi = INTERPOL(data1.effi,data1.wave, x)
index1 = where(effi[*] le 0, count1)
effi[index1] = 0
max_effi = max(effi)
;print,'effi ',(1.0/max_effi)
;effi = effi * (1.0/max_effi)
effi_tot_a = tsum(x,effi)
;effi_hz = (effi * (x^2 ) / 2.997925e+18)
;y = alog((2.997925e+18 / x))
;y = (2.997925e+18 / x)
;effi_tot_hz = tsum(y,effi_hz)
;print,'effi_tot_a ',effi_tot_a
;print,'effi_tot_hz ',effi_tot_hz

openw,80,outputfile,width=360
for i=0L, file_number-1 do begin
inputfile=strcompress(list[i],/remove)
string = STRSPLIT(inputfile, '/', /EXTRACT)
record={wave:0.0d,flux:0.0d}
maxrec=7000L
frequ = FINDGEN(7000) 
flux1 = FINDGEN(7000) 
data=replicate(record,maxrec)
openr,50,inputfile
readf,50,data
close,50

flux1 = data.flux * effi
index2 = where(flux1[*] le 0, count2)
flux1[index2] = 0

;frequ = (2.997925e+18 / data.wave)
;;frequ = alog((2.997925e+18 / data.wave))
;fluxu1 = (flux1 * (data.wave^2 ) / 2.997925e+18)
;frequ_min = (2.997925e+18 / 2000)
;frequ_max = (2.997925e+18 / 9000)

;flux_nu=0.0d
;flux_lam=0.0d
;flux_hz=0.0d
;flux_tot_hz=0.0d
;flux_tot_hz_effi=0.0d

;Flux_tot_hz = tsum(frequ,fluxu1)
;;print,frequ,Flux_tot_hz
;;red leak is defined as wavelength of light longer than 3340 A (the blue edge of optical U band)
;Flux_tot_hz_redleak = tsum(frequ,fluxu1,1339,6999)
;redleak_persent = Flux_tot_hz_redleak / Flux_tot_hz
;;Flux_den_hz = Flux_tot_hz / (frequ_min - frequ_max)
;print,'Flux_tot_hz ',Flux_tot_hz
;Flux_den_hz = Flux_tot_hz / effi_tot_hz ;/ (frequ_min - frequ_max) 
;;Flux_den_hz = Flux_tot_hz 
;;Flux_den_hz = Flux_den_hz / alog(max(data.wave)/min(data.wave))
Flux_tot_a = tsum(data.wave,flux1)
Flux_tot_a_redleak = tsum(data.wave,flux1,1339,6999)
redleak_persent = Flux_tot_a_redleak / Flux_tot_a
;;Flux_den_a = Flux_tot_a / effi_tot_a
Flux_den_a = Flux_tot_a / (max(data.wave) - min(data.wave))
;Flux_den_a = Flux_tot_a 
;;print,Flux_tot_hz,Flux_den_hz

mag_AB = - 2.5 * alog10(Flux_den_a) + (15.222512 )
;mag_AB = - 2.5 * alog10(Flux_den_hz) ;- 48.60 ; - 17.52
print,string[8],Flux_den_a,mag_AB,redleak_persent
printf,80,string[8],Flux_den_a,mag_AB,redleak_persent

endfor

close,80
print,'done'
close,/all

end
