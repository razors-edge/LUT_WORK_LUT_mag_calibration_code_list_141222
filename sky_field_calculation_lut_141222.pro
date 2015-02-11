function area_calcul,dec
pi=3.1415926
r=30.0
h=r-dec
a=acos(dec/r)
sit=a*180.0/pi
;print,sit
s=0.5*(r^2)*(2*a-sin(2*a))
;print,s
return,s
end

pro sky_field_calculation_lut_130909
dec0=0
dec1=10
dec2=20
dec3=30

inputfile=filepath('typho2_cata_4_lut_candidate_selection_30s.txt',$
root_dir='E:\WORK\LUT\LUT_mag_calibration\LUT_mag_calibration_130909\lut_optical_efficiency_curve\')

if(n_elements(inputfile) eq 0) then $
message,'Argument FILE is underfined'
str=''
maxrec=file_lines(inputfile)
close,60
;record={RAmdeg:0.0d,DEmdeg:0.0d,Bmag:0.0d,Vmag:0.0d,BV:0.0d,RAmdeg_gala:0.0d,DEmdeg_gala:0.0d}
;data=replicate(record,maxrec)
data=make_array(maxrec,7)
openr,50,inputfile
point_lun,50,0
readf,50,data
close,50



s0=area_calcul(dec0)
s1=area_calcul(dec1)
s2=area_calcul(dec2)
s3=area_calcul(dec3)
s_0_10=s0-s1
s_10_20=s1-s2
s_20_30=s2-s3
;print,s0,s1,s2,s3
print,s_0_10,s_10_20,s_20_30
index1=where(data[*,6] gt 0 and data[*,6] lt 10, n_0_10)
index2=where(data[*,6] gt 10 and data[*,6] lt 20, n_10_20)
index3=where(data[*,6] gt 20 and data[*,6] lt 30, n_20_30)
m_0_10=n_0_10/s_0_10
m_10_20=n_10_20/s_10_20
m_20_30=n_20_30/s_20_30
print,n_0_10,n_10_20,n_20_30
print,m_0_10,m_10_20,m_20_30

print,'done'
close,/all
end