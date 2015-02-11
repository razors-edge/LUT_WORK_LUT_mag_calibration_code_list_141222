pro LUT_optical_efficiency_curve_130909
close,/all
data_path = 'E:\WORK\LUT\LUT_mag_calibration\LUT_mag_calibration_130624\lut_optical_efficiency_curve\data\'
effi_curve_path = 'E:\WORK\LUT\LUT_mag_calibration\LUT_mag_calibration_130624\lut_optical_efficiency_curve'
inputfile1=filepath('Spectral_response_curve_20130909.txt',$
root_dir=data_path)
outputfile_txt=filepath('LUT_optical_efficiency_curve.txt',$
root_dir=effi_curve_path)

maxrec1=FILE_LINES(inputfile1)
record1={wave:0.0d,filter:0.0d}
data1=replicate(record1,maxrec1)
openr,50,inputfile1
point_lun,50,0
readf,50,data1
close,50
data1.wave = data1.wave * 1.0

data_wave_7 = FindGen(81)*5+405
data_7_filter = INTERPOL(data7.filter,data7.wave,data_wave_7)
print,data7.filter
print,data_7_filter


openw,70,outputfile_txt
for i=0L, 40 do begin
printf,70,data1[i].wave,data1[i].filter
endfor
for i=0L, 79 do begin
printf,70,data_wave_7[i],data_7_filter[i]*1.3
endfor


close,/all
device,/close_file
print,'Done'
end
