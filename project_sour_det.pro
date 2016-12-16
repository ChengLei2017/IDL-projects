pro sour_det

am = [1.10412, 1.09226,  1.06748, 1.06900] ;airmasses for NGC6940 (R then V) and NGC7140 (R then V)
c0 = [ -3.814, -5.2, -3.646, -3.716] ; average offsets from standard stars in same order

;extinction coefficients
kb = 0.4
kv = 0.2
kr = 0.1

;errors on the published values
erra337R = .0014
erra337V = .0020
errstandardR = .04
errstandardV = .005

;find images
shift_list = file_search('*shift*.fits', count = nfiles)

;put images in an array
fits_read, shift_list[0], sl0, hdr0

xsz = sxpar(hdr0, 'NAXIS1')
ysz = sxpar(hdr0, 'NAXIS2')



sarray = fltarr(xsz, ysz, nfiles)
std3 = [12.0,12.0,4.0, 4.0, 8.0,8.0,5.0, 5.0]
a = fltarr(nfiles)


for i = 0, nfiles - 1 do begin
   fits_read, shift_list[i], shift, hdr
   print, shift_list[i]
   exptime = sxpar(hdr,'EXPTIME')
   std3[i] = 3.5*std3[i]/exptime
   sarray[*,*,i] = shift/exptime
   a[i] = 60000./exptime
endfor





fw = [7,8]; FWHMs for the stars in same order as above

medarr, sarray, medshift ; creating medshift as a median of sarray using the ASTROLIB routine

;std3 = ((3.0*(fw/2.36)) + medshift); 3 times the stdev of sarrray above the median of the array

;ap = [9.0, 10.0, 11.0, 12.0]    ;various aperatures to be tried

ap = [10.5] ; try this for all cases.

;use find program to fill out arrays where star are located (only the one array is needed for each object as they can be fed to the aper program for both filters
find, sarray[*,*,0], x1, y1, flux1, sharp1, round1, std3[0], fw[0] ; correct syntax should have std3 before the FWHM
;find, sarray[*,*,1], x2, y2, flux2, sharp2, round2, fw[1], 3*std3[1] 
find, sarray[*,*,2], x3, y3, flux3, sharp3, round3, std3[2], fw[0] 
;find, sarray[*,*,3], x4, y4, flux4, sharp4, round4,fw[3],  3*std3[3] 
find, sarray[*,*,4], x5, y5, flux5, sharp5, round5, std3[4], fw[1]  
;find, sarray[*,*,5], x6, y6, flux6, sharp6, round6,fw[5],  3*std3[5] 
find, sarray[*,*,6], x7, y7, flux7, sharp7, round7, std3[6], fw[1]
;find, sarray[*,*,7], x8, y8, flux8, sharp8, round8,fw[7],  3*std3[7] 

;run aper to find magnitudes
aper, sarray[*,*,0], x1, y1, mags1, errap1, sky1, skyerr1,  1.4, ap, [15,25],[0, a[0]]
aper, sarray[*,*,1], x1, y1, mags2, errap2, sky2, skyerr2,  1.4, ap, [15,25], [0, a[1]]
aper, sarray[*,*,2], x3, y3, mags3, errap3, sky3, skyerr3,  1.4, ap, [15,25], [0, a[2]]
aper, sarray[*,*,3], x3, y3, mags4, errap4, sky4, skyerr4,  1.4, ap, [15,25], [0, a[3]]
aper, sarray[*,*,4], x5, y5, mags5, errap5, sky5, skyerr5,  1.4, ap, [15,25]
aper, sarray[*,*,5], x5, y5, mags6, errap6, sky6, skyerr6,  1.4, ap, [15,25]
aper, sarray[*,*,6], x7, y7, mags7, errap7, sky7, skyerr7,  1.4, ap, [15,25]
aper, sarray[*,*,7], x7, y7, mags8, errap8, sky8, skyerr8,  1.4, ap, [15,25]

safe6940=[where(mags1 ne 99.9999 and mags2 ne 99.999 and mags1 ne 20.000 and mags2 ne 20.000 and mags1 gt 0.0 and mags2 gt 0.0)]

safe7160=[where(mags3 ne 99.9999 and mags4 ne 99.999 and mags3 ne 20.000 and mags4 ne 20.000 and mags3 gt 0.0 and mags4 gt 0.0)]

safea337=[where(mags5 ne 99.9999 and mags6 ne 99.999 and mags5 ne 20.000 and mags6 ne 20.000 and mags5 gt 0.0 and mags6 gt 0.0)]

safestandard=[where(mags7 ne 99.9999 and mags8 ne 99.999 and mags7 ne 20.000 and mags8 ne 20.000 and mags7 gt 0.0 and mags8 gt 0.0)]

mags1 = mags1[safe6940]
mags2 = mags2[safe6940]
mags3 = mags3[safe7160]
mags4 = mags4[safe7160]
mags5 = mags5[safea337]
mags6 = mags6[safea337]
mags7 = mags7[safestandard]
mags8 = mags8[safestandard]

; try skyrad = [20,30], [25,35]
; check using 'p' in atv

; empirically test background by plotting
;plot,mags1,sky1, psym =5 

;calibrate magitudes
mags1_cal = mags1 - kr*am[0] + c0[0]
mags2_cal = mags2 - kv*am[1] + c0[1]
mags3_cal = mags3 - kr*am[2] + c0[2]
mags4_cal = mags4 - kv*am[3] + c0[3]

; here, try plotting
;plot,mags2-mags1,mags1, psym = 6


;after applying offset, 6 < mags1 < 15

;calculate errors on the offset
errc01 = sqrt(erra337R^2 + errap1^2)
errc02 = sqrt(erra337V^2 + errap2^2)
errc03 = sqrt(errstandardR^2 + errap3^2)
errc04 = sqrt(errstandardV^2 + errap4^2)

;calculate errors on the measured magnitudes
err1 = sqrt(errap1^2 + errc01^2)
err2 = sqrt(errap2^2 + errc02^2)
err3 = sqrt(errap3^2 + errc03^2)
err4 = sqrt(errap4^2 + errc04^2)

;save files
save, x1, y1, mags1, errap1, mags2, errap2, file = 'VR_stack_NGC6940.sav'
save, x3, y3, mags3, errap3, mags4, errap4, file = 'VR_stack_NGC7160.sav'
save, x5, y5, mags5, errap5, mags6, errap6, file = 'VR_stack_a337.sav'
save, x7, y7, mags7, errap7, mags8, errap8, file = 'VR_stack_standard.sav'

save, x1, y1, mags1_cal, err1, mags2_cal, err2, file = 'VR_stack_NGC6940_cal.sav'
save, x3, y3, mags3_cal, err3, mags4_cal, err4, file = 'VR_stack_NGC7160_cal.sav'





end
