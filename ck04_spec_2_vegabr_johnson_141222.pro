pro ck04_spec_2_vegabr_johnson_141222
close,/all
path='/home/han/WORK/LUT/LUT_mag_calibration/LUT_mag_calibration_141222/CK04_model/ckp00/'
list=findfile(path+'ckp00*_grav_part_interpol.txt')
file_number=n_elements(list)
print,file_number
;inputfile1=filepath('johnson_b_004_syn_t1_all.txt',$
inputfile1=filepath('btrans.dat',$
root_dir='/home/han/WORK/LUT/LUT_mag_calibration/LUT_mag_calibration_141222/lut_optical_efficiency_curve/data/')
;inputfile2=filepath('johnson_v_004_syn_t1_all.txt',$
inputfile2=filepath('rtrans.dat',$
root_dir='/home/han/WORK/LUT/LUT_mag_calibration/LUT_mag_calibration_141222/lut_optical_efficiency_curve/data/')
inputfile3=filepath('CCD47-20UV.dat',$
root_dir='/home/han/WORK/LUT/LUT_mag_calibration/LUT_mag_calibration_141222/lut_optical_efficiency_curve/data/')

;without CCD sensitivity curve
;outputfile='E:\WORK\LOT\LOT_mag\CASTELLI_KURUCZ_ATLAS\CCD_response\filter_transmission_curve_LUT_20120827\mag_vega.dat'
;with CCD sensitivity curve
outputfile='/home/han/WORK/LUT/LUT_mag_calibration/LUT_mag_calibration_141222/lut_optical_efficiency_curve/ck04_model_mag_vega.dat'
openw,80,outputfile,width=360
outputfile1='test.dat'
openw,83,outputfile1,width=360

x = FINDGEN(7000)+2000
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
min_wave_b = min(data1.wave)
max_wave_b = max(data1.wave)
;print,min_wave_b,max_wave_b
max_filter_b = max(data1.filter)
print,(1.0/max_filter_b)
data1.filter = data1.filter * (1.0/max_filter_b)
filter_b = INTERPOL(data1.filter,data1.wave, x)
index1 = where((filter_b[*] le 0), count1)
filter_b[index1] = 0
index1_2 = where((x[*] le min_wave_b), count1_2)
filter_b[index1_2] = 0
printf,83,inputfile1
for sas=0L, 35-1 do begin
printf,83,sas*200.0,x[sas*200.0],filter_b[sas*200.0]
endfor
;filter_tot_lam_b = tsum(x,filter_b)

if(n_elements(inputfile2) eq 0) then $
message,'Argument FILE is underfined'
str=''
maxrec2=linenum_multi_col(inputfile2,str)
close,60
record2={wave:0L,filter:0.0d}
data2=replicate(record2,maxrec2)
openr,50,inputfile2
point_lun,50,0
readf,50,data2
close,50
data2.wave = data2.wave * 10.0
min_wave_r = min(data2.wave)
max_wave_r = max(data2.wave)
;print,min_wave_r,max_wave_r
max_filter_r = max(data2.filter)
print,'filter r',(1.0/max_filter_r)
data2.filter = data2.filter * (1.0/max_filter_r)
filter_r = INTERPOL(data2.filter,data2.wave, x)
index2 = where(filter_r[*] le 0, count2)
filter_r[index2] = 0
index2_2 = where((x[*] le min_wave_r), count2_2)
filter_r[index2_2] = 0
printf,83,inputfile2
for sas=0L, 70-1 do begin
printf,83,sas*100.0,x[sas*100.0],filter_r[sas*100.0]
endfor
;help,filter_r
;filter_tot_lam_r = tsum(x,filter_r)

if(n_elements(inputfile3) eq 0) then $
message,'Argument FILE is underfined'
str=''
maxrec3=linenum_multi_col(inputfile3,str)
close,60
record3={wave:0L,ccd:0.0d,window:0.0d,total:0.0d}
;record3={wave:0L,total:0.0d}
data3=replicate(record3,maxrec3-1)
openr,50,inputfile3
point_lun,50,0
readf,50,str
readf,50,data3
close,50
data3.wave = data3.wave * 10.0
data3.ccd = data3.total
ccd = INTERPOL(data3.ccd,data3.wave, x)
max_ccd = max(ccd)
;print,'ccd ',(1.0/max_ccd)
;ccd = ccd * (1.0/max_ccd)
;ccd_tot = tsum(x,ccd)

for i=0L, file_number-1 do begin
inputfile=strcompress(list[i],/remove)
string = STRSPLIT(inputfile, '/', /EXTRACT)
;print,string[8]
record={wave:0.0d,flux:0.0d}
;maxrec=linenum_multi_col(inputfile,record)
maxrec=7000L
close,60
data=replicate(record,maxrec)
openr,50,inputfile
readf,50,data
close,50
;print,data.wave

wave_min = 2000.
wave_max = 9000.
flux_lam_b = data.flux * filter_b * ccd
flux_lam_r = data.flux * filter_r * ccd
flux_tot_lam_b = tsum(data.wave,flux_lam_b)
;filter_tot_lam_b = tsum(data.wave,(filter_b * ccd))
flux_den_lam_b = flux_tot_lam_b / (wave_max - wave_min) ;/ (filter_tot_lam_b * ccd_tot)
flux_tot_lam_r = tsum(data.wave,flux_lam_r)
;filter_tot_lam_r = tsum(data.wave,(filter_r * ccd))
flux_den_lam_r = flux_tot_lam_r / (wave_max - wave_min) ;/ (filter_tot_lam_r * ccd_tot)
;mag_vega_b = -2.5 * alog10(flux_den_lam_b) + 2.5 * alog10(6.40e-9)
;mag_vega_v = -2.5 * alog10(flux_den_lam_v) + 2.5 * alog10(3.67e-9)
mag_vega_b = -2.5 * alog10(flux_den_lam_b) + 17.123966
mag_vega_r = -2.5 * alog10(flux_den_lam_r) + 16.433634
;zero_gap_br = (2.5 * alog10(6.40e-9)) - (2.5 * alog10(1.92e-9))
zero_gap_br = (17.123966 - 16.433634)
print,string[8],flux_tot_lam_b,flux_den_lam_b, mag_vega_b,flux_tot_lam_r,flux_den_lam_r, mag_vega_r,zero_gap_br
;print,tsum(data.wave,filter_r)

printf,80,string[8],flux_den_lam_b, mag_vega_b,flux_den_lam_r, mag_vega_r,zero_gap_br
endfor

close,80
close,83
print,'done'
close,/all
end
