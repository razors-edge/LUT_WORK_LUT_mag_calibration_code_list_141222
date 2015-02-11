pro ck04_spec_mag_ab_vegabr_name_match_141222
close,/all

inputfile_ab=filepath('ck04_model_mag_ab.dat',$
root_dir='/home/han/WORK/LUT/LUT_mag_calibration/LUT_mag_calibration_141222/lut_optical_efficiency_curve/')
;without CCD sensitivity curve
;inputfile_vega=filepath('mag_vega.dat',$
;with CCD sensitivity curve
inputfile_vega=filepath('ck04_model_mag_vega.dat',$
root_dir='/home/han/WORK/LUT/LUT_mag_calibration/LUT_mag_calibration_141222/lut_optical_efficiency_curve/')
inputfile1=filepath('type_tem.dat',$
root_dir='/home/han/WORK/LUT/LUT_mag_calibration/LUT_mag_calibration_141222/CK04_model/')
;outputfile=filepath('mag4lot_final.dat',$
;root_dir='E:\WORK\LOT\LOT_mag\CASTELLI_KURUCZ_ATLAS\ckp00\')
;without CCD sensitivity curve
;outputfile=filepath('mag4lot_tyc.dat',$
;with CCD sensitivity curve
outputfile=filepath('mag4lot_tyc_ccd.dat',$
root_dir='/home/han/WORK/LUT/LUT_mag_calibration/LUT_mag_calibration_141222/lut_optical_efficiency_curve/')


if(n_elements(inputfile_ab) eq 0) then $
message,'Argument FILE is underfined'
record={filename:'',flux_den_lam:0.0D,magab:0.0d,redleak_persent:0.0d}
data=replicate(record,40)
openr,50,inputfile_ab
point_lun,50,0
str=''
for i=0, 39 do begin
readf,50,str
word = STRSPLIT(str, /EXTRACT)
data[i].filename = word[0]
data[i].flux_den_lam = word[1]
data[i].magab = word[2]
data[i].redleak_persent = word[3]
endfor
close,50


if(n_elements(inputfile_vega) eq 0) then $
message,'Argument FILE is underfined'
record={filename:'',flux_den_lam_b:0.0D,magvega_b:0.0d,flux_den_lam_r:0.0D,magvega_r:0.0d,zero_gap_br:0.0d}
data1=replicate(record,40)
openr,60,inputfile_vega
point_lun,60,0
str1=''
for j=0, 39 do begin
readf,60,str1
word1 = STRSPLIT(str1, /EXTRACT)
data1[j].filename = word1[0]
data1[j].flux_den_lam_b = word1[1]
data1[j].magvega_b = word1[2]
data1[j].flux_den_lam_r = word1[3]
data1[j].magvega_r = word1[4]
data1[j].zero_gap_br = word1[5]
endfor
close,60


if(n_elements(inputfile1) eq 0) then $
message,'Argument FILE is underfined'
record2={type:'',tem:0L}
data2=replicate(record2,40)
openr,70,inputfile1
point_lun,70,0
str2=''
readf,70,str2
for k=0, 39 do begin
readf,70,str2
word2 = STRSPLIT(str2, /EXTRACT)
data2[k].type=word2[0]
data2[k].tem=word2[1]
;print,data2[k].tem
endfor
close,70


record3={filename:'',type:'',tem:0L,magab:0.0d,magvega_b:0.0d,magvega_r:0.0d,magvega_br:0.0d,mag_minus:0.0d,magab_30:0.0d,magvega_30:0.0d,redleak_persent:0.0d}
data3 = replicate(record3,40)

openw,80,outputfile,width=300
;printf,80,'Filename,    Tpye,   Temperature,  mag(AB),   mag(Bvega),   mag(Vvega),   mag(B-V),',$
;'   mag(AB)-mag(Vvega),   mag(AB_30s),  mag(vega_30s)'
printf,80,'mag(AB),   mag(Bvega),   mag(Rvega),   mag(B-R),',$
'   mag(AB)-mag(Rvega),   mag(AB_30s),  mag(vega_30s), redleak_persentage'
for l=0, 39 do begin
for m=0, 39 do begin
filename_ab = strsplit(data[l].filename, '.',  /EXTRACT)
filename_vega = strsplit(data1[m].filename, '.',  /EXTRACT)
;print,filename_ab[0],filename_vega[0]
if (filename_ab[0] eq (filename_vega[0])) then begin
data3[l].filename= data[l].filename
data3[l].magab = data[l].magab
data3[l].redleak_persent = data[l].redleak_persent
data3[l].magvega_b = data1[m].magvega_b
data3[l].magvega_r = data1[m].magvega_r
data3[l].magvega_br = data1[m].magvega_b - data1[m].magvega_r ; + data1[m].zero_gap_br
data3[l].mag_minus = data3[l].magab - data3[l].magvega_r
data3[l].magab_30 = 15.2
data3[l].magvega_30 = 15.2 - data3[l].mag_minus
word3= strsplit(data3[l].filename, '_',  /EXTRACT)
data3[l].tem = long(word3[1])
print,data3[l].tem
endif
endfor
endfor


for n=0L, 39 do begin
for o=0L, 39 do begin
if (data2[n].tem eq data3[o].tem) then begin
print,data3[o].filename,'  ',data2[n].type,'  ',data3[o].tem
;printf,80,data3[o].filename,'  ',data2[n].type,'  ',data3[o].tem,data3[o].magab,$
;data3[o].magvega_b,data3[o].magvega_v,$
;data3[o].magvega_bv,data3[o].mag_minus,$
;data3[o].magab_05,data3[o].magvega_05
printf,80,data3[o].magab,$
data3[o].magvega_b,data3[o].magvega_r,$
data3[o].magvega_br,data3[o].mag_minus,$
data3[o].magab_30,data3[o].magvega_30,$
data3[o].redleak_persent
endif
endfor
endfor


print,'done'
close,/all
end
