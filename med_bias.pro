pro med_bias
;author: Tim Costa

;get bias files
blist = file_search('*bias*.fit', count = nfiles)

;read parameters from the header of one of the bias files
fits_read, blist[0], b0, hdr
xsz = sxpar(hdr, 'NAXIS1')
ysz = sxpar(hdr, 'NAXIS2')

;set up array to hold the bias images
barray = fltarr(xsz, ysz, nfiles)

;fill the array
for i = 0, nfiles - 1 do begin
	fits_read, blist[i], bias, hdr
	barray[*,*,i] = bias
endfor
sxaddpar, hdr, 'BZERO', 0.0

;take the median of the array and save it as masterbias variable
medarr, barray, masterbias

;write fits with the masterbias data
fits_write, 'project_masterbias_oct06.fits', masterbias





end