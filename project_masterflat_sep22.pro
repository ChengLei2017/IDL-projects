pro project_masterflat_sep22
;author: Tim Costa, Daniel Rono

;create list to hold filters
filters = ['V', 'R', 'B']

;read in the bias and dark master files
fits_read, 'project_masterbias_sep22.fits', masterbias, hdrb
fits_read, 'project_masterdark_sep24.fits', masterdark, hdrd

;first for loop loops through the three filters
for j = 0, n_elements(filters) - 1 do begin

	;get flat fits files for each filter as the loop progresses
	files = file_search('*'+filters[j]+'*flat*.fit',count=nfiles)
	
	;initiate masterflat variable for calculations
	masterflat = float(masterbias) * 0

	;calculations for the master flat
	for i = 0, nfiles - 1 do begin
		fits_read, files[i], im, hdr
		;set exposure time variable for normalization purposes of dark
		exptime = sxpar(hdr, 'EXPTIME')
		masterflat = float(masterflat) + ((float(im) - float(masterbias)) - float(masterdark) * float(exptime))/float(nfiles)
	endfor


	;normalize masterflat to about 1 using the median	
	masterflat = float(masterflat) / median(float(masterflat))
	sxaddpar, hdr, 'BZERO', 0.0

	;write the master flat for each filter to a fits file
	fits_write, 'project_masterflat_sep22'+filters[j]+'.fits', masterflat, hdr
endfor



end