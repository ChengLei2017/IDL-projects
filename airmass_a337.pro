pro airmass_a337


filters = ['B', 'V', 'R']

for i = 0, n_elements(filters) -1  do begin
	list = file_search('*a337*'+filters[i]+'.fits', count = nfiles)
	airmass = fltarr(n_elements(list))
	for j = 0, n_elements(list) -1 do begin
		fits_read, list[j], im, hdr
		airmass[j] = sxpar(hdr, 'AIRMASS')
	endfor
	av_air = mean(airmass)
	print, 'the mean airmass for the'+filters[i]+' filter is', av_air
endfor






end