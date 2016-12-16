pro project_reduction_oct06
;author: Tim Costa, Daniel Rono

;read in the master calibration fits files

fits_read, 'project_masterdark_oct06.fits', masterdark, hdrd 
fits_read, 'project_masterbias_oct06.fits', masterbias, hdrb
;fits_read, 'masterflatI.fits', masterflatI, hdri
;fits_read, 'masterflatR.fits', masterflatR, hdrr
;fits_read, 'masterflatV.fits', masterflatV, hdrv
;The masterflats were better served being read in the for loop than individually

;initiate filter list
filters = ['V', 'R', 'B']

;begin reduction
for j = 0, n_elements(filters) - 1 do begin
	files = file_search('*standard*'+filters[j]+'.fit', count = nfiles)
	basefiles = file_basename(files, '.fit')
	fits_read, 'project_masterflat_oct06'+filters[j]+'.fits', masterflat, hdrf
	for i = 0, nfiles-1 do begin
		fits_read, files[i], im, hdr
		exptime = sxpar(hdr, 'EXPTIME')
		im = ((float(im)-float(masterbias))-float(masterdark)*float(exptime))/float(masterflat)
		sxaddpar, hdr, 'BZERO', 0.0
		fits_write, basefiles[i]+'.proc.fits', im, hdr
	endfor
endfor	



end