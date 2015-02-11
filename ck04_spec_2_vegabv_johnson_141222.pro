pro ck04_spec_2_vegabv_johnson_141222
close,/all
path='/home/han/WORK/LUT/LUT_mag_calibration/LUT_mag_calibration_141222/CK04_model/ckp00/'
list=findfile(path+'ckp00*_grav_part_interpol.txt')
file_number=n_elements(list)
print,file_number
;inputfile1=filepath('johnson_b_004_syn_t1_all.txt',$
inputfile1=filepath('btrans.dat',$
root_dir='/home/han/WORK/LUT/LUT_mag_calibration/LUT_mag_calibration_141222/lut_optical_efficiency_curve/data/')
;inputfile2=filepath('johnson_v_004_syn_t1_all.txt',$
inputfile2=filepath('vtrans.dat',$
root_dir='/home/han/WORK/LUT/LUT_mag_calibration/LUT_mag_calibration_141222/lut_optical_efficiency_curve/data/')
inputfile3=filepath('CCD47-20UV.dat',$
;inputfile3=filepath('Spectral_response_curve_20130909.txt',$
root_dir='/home/han/WORK/LUT/LUT_mag_calibration/LUT_mag_calibration_141222/lut_optical_efficiency_curve/data/')

;without CCD sensitivity curve
;outputfile='E:\WORK\LOT\LOT_mag\CASTELLI_KURUCZ_ATLAS\CCD_response\filter_transmission_curve_LUT_20120827\mag_vega.dat'
;with CCD sensitivity curve
outputfile='/home/han/WORK/LUT/LUT_mag_calibration/LUT_mag_calibration_141222/lut_optical_efficiency_curve/ck04_model_mag_vegabv.dat'
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
print,'max_filter_b',(1.0/max_filter_b)
data1.filter = data1.filter * (1.0/max_filter_b)
filter_b = INTERPOL(data1.filter,data1.wave, x)
index1 = where((filter_b[*] le 0), count1)
filter_b[index1] = 0
index1_2 = where((x le min_wave_b), count1_2)
filter_b[index1_2] = 0
printf,83,inputfile1
for sas=0L, 35-1 do begin
printf,83,sas*200.0,x[sas*200.0],filter_b[sas*200.0]
endfor
;help,filter_b

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
min_wave_v = min(data2.wave)
max_wave_v = max(data2.wave)
max_filter_v = max(data2.filter)
print,'max_filter_v',(1.0/max_filter_v)
data2.filter = data2.filter * (1.0/max_filter_v)
;print,min_wave_v,max_wave_v
filter_v = INTERPOL(data2.filter,data2.wave, x)
index2 = where(((filter_v[*] le 0) ), count2)
filter_v[index2] = 0
index2_2 = where((x le min_wave_v), count2_2)
filter_v[index2_2] = 0
index2_3 = where(( (finite(filter_v[*]) eq 0)), count2_3)
filter_v[index2_3] = 0
printf,83,inputfile2
for sas=0L, 70-1 do begin
printf,83,sas*100.0,x[sas*100.0],filter_v[sas*100.0]
endfor

if(n_elements(inputfile3) eq 0) then $
message,'Argument FILE is underfined'
str=''
maxrec3=linenum_multi_col(inputfile3,str)
close,60
record3={wave:0L,ccd:0.0d,window:0.0d,total:0.0d}
;record3={wave:0L,ccd:0.0d}
data3=replicate(record3,maxrec3-1)
openr,50,inputfile3
point_lun,50,0
readf,50,str
readf,50,data3
close,50
data3.wave = data3.wave * 10.0
;data3.ccd = data3.total 
ccd = INTERPOL(data3.ccd,data3.wave, x)
max_ccd = max(ccd)
print,'max_ccd',(1.0/max_ccd)
;ccd = ccd * (1.0/max_ccd)


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
flux_lam_v = data.flux * filter_v * ccd
flux_tot_lam_b = tsum(data.wave,flux_lam_b)
throughput_tot_lam_b = tsum(data.wave,(filter_b * ccd))
flux_den_lam_b = flux_tot_lam_b / (wave_max - wave_min) ;/ throughput_tot_lam_b  / (wave_max - wave_min)
flux_tot_lam_v = tsum(data.wave,flux_lam_v)
throughput_tot_lam_v = tsum(data.wave,(filter_v * ccd))
flux_den_lam_v = flux_tot_lam_v / (wave_max - wave_min) ;/ throughput_tot_lam_v  / (wave_max - wave_min)
;mag_vega_b = -2.5 * alog10(flux_den_lam_b) + 2.5 * alog10(6.40e-9)
;mag_vega_v = -2.5 * alog10(flux_den_lam_v) + 2.5 * alog10(3.67e-9)
mag_vega_b = -2.5 * alog10(flux_den_lam_b) + 17.294266
mag_vega_v = -2.5 * alog10(flux_den_lam_v) + 16.765072
;zero_gap_bv = (2.5 * alog10(6.40e-9)) - ( 2.5 * alog10(3.67e-9) )
zero_gap_bv = 17.294266 - 16.765072
print,string[8],flux_tot_lam_b,flux_den_lam_b, mag_vega_b,flux_tot_lam_v,flux_den_lam_v, mag_vega_v,zero_gap_bv
printf,80,string[8],flux_den_lam_b, mag_vega_b,flux_den_lam_v, mag_vega_v,zero_gap_bv
endfor

close,80
close,83
print,'done'
close,/all
end
