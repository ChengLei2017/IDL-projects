pro project_masterdark_sep24
;author: Tim Costa, Daniel Rono

;initialize list to hold the dark fits files
dlist = file_search('*dark*.fit',count = nfiles)

;read in master bias fits file
fits_read, 'project_masterbias_sep22.fits', bias, hdrb

;read header of first dark fits file to obtain exposure time, x size and y size parameters
fits_read, dlist[0], d0, hdr
exptime = sxpar(hdr,'EXPTIME')
xsz = sxpar(hdr,'NAXIS1')
ysz = sxpar(hdr,'NAXIS2')

;initialize an array to hold the dark fits files
darray = fltarr(xsz, ysz, nfiles)

;fill array with bias subtracted, exposuretime normalized dark fits files
for i = 0, nfiles-1 do begin
	fits_read, dlist[i], dark, hdr
	darray[*,*,i] = (float(dark) - float(bias))/float(exptime)
endfor
sxaddpar, hdr, 'BZERO', 0.0

;take median of array of bias subtracted dark fits files and save it to masterdark_persec variable
medarr, darray, masterdark_persec

;write masterdark_persec variable to masterdark fits file
fits_write, 'project_masterdark_sep24.fits', masterdark_persec



end