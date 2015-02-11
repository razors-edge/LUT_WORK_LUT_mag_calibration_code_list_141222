pro CK04_model_type_tem_match_141222
close,/all
path='/home/han/WORK/LUT/LUT_mag_calibration/LUT_mag_calibration_130909/CK04_model/'
matchfile=findfile(path+'type_tem_g.dat')

str=''
maxrec1=linenum_multi_col(matchfile,str)
close,60
record={type:'',tem:0L,name:'',g:''}
data=replicate(record,maxrec1)
openr,50,matchfile
point_lun,50,0
for k=0, maxrec1-1 do begin
readf,50,str
word = STRSPLIT(str, /EXTRACT)
data[k].type = word[0]
data[k].tem = word[1]
data[k].name = strcompress(word[2] + '.txt',/remove)
data[k].g = word[3]
endfor
close,50


path1 = '/home/han/WORK/LUT/LUT_mag_calibration/LUT_mag_calibration_130909/CK04_model/ckp00/'
list=findfile(path1+'ckp00_*0.txt')
file_number=n_elements(list)

for i=0L, file_number-1 do begin
inputfile=strcompress(list[i],/remove)
string = STRSPLIT(inputfile, '.', /EXTRACT)
string1 = STRSPLIT(inputfile, '/', /EXTRACT)
outputfile=strcompress(string[0] + '_grav.txt',/remove)


gravity=''
for l=0L, maxrec1-1 do begin
if string1[7] eq data[l].name then begin
print,string1[7],'   ',data[l].name,'   ', data[l].g
gravity = data[l].g
endif
endfor


g_num = 0
str=''
maxrec=linenum_multi_col(inputfile,str)
close,60
openr,70,inputfile
point_lun,70,0
readf,70,str
string2 = STRSPLIT(str, /EXTRACT)
for j=0L, 11 do begin
if(strupcase(gravity) eq string2[j])  then begin
g_num = j
;print,string2
print,'Name: ',string1[7],'  gra: ',strupcase(gravity),'  gra:  ',string2[j],'  g_num:  ',g_num
endif
endfor


if(g_num eq 0) then begin
print,string1[7] 
endif else begin
openw,80,outputfile
for m=0L, maxrec-2 do begin 
readf,70,str
word1 = STRSPLIT(str, ' ', /EXTRACT)
;print,word1
printf,80,word1[0],'   ',word1[g_num]
endfor
close,80
endelse
close,70
endfor

print,'done'
close,/all
end