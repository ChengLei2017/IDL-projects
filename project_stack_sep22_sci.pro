pro project_stack_sep22_sci

;authors: Tim Costa and Daniel Rono

;initiate filter list
filters = ['V', 'R', 'B']

;measure offset and place in arrays
xshiftb = make_array(3,1)
yshiftb = make_array(3,1)
xshiftr = make_array(3,1)
yshiftr = make_array(3,1)
xshiftv = make_array(3,1)
yshiftv = make_array(3,1)


filesb = file_search('*NGC*'+filters[2]+'.proc.fits', count = nfilesb)

for i = 1, nfilesb-1 do begin
	fits_read, filesb[0], imb1, hdrb
	fits_read, filesb[i], im, hdr
	shifts = xyoff(imb1, im, 3071, 2046)
	xshift_out = -shifts[0]
	yshift_out = -shifts[1]
	xshiftb[i] = xshift_out
	yshiftb[i] = yshift_out
endfor

filesr = file_search('*NGC*'+filters[1]+'.proc.fits', count = nfilesr)

for i = 1, nfilesr-1 do begin
	fits_read, filesr[0], imr1, hdrr
	fits_read, filesr[i], im, hdr
	shifts = xyoff(imr1, im, 3071, 2046)
	xshift_out = -shifts[0]
	yshift_out = -shifts[1]
	xshiftr[i] = xshift_out
	yshiftr[i] = yshift_out
endfor

filesv = file_search('*NGC*'+filters[0]+'.proc.fits', count = nfilesv)

for i = 1, nfilesv-1 do begin
	fits_read, filesv[0], imv1, hdrv
	fits_read, filesv[i], im, hdr
	shifts = xyoff(imv1, im, 3071, 2046)
	xshift_out = -shifts[0]
	yshift_out = -shifts[1]
	xshiftv[i] = xshift_out
	yshiftv[i] = yshift_out
endfor



filelistb = file_search('*NGC*'+filters[2]+'.proc.fits')
stacker, filelistb, xshiftb, yshiftb, NGC6940_stacked_b, /robust

filelistr = file_search('*NGC*'+filters[1]+'.proc.fits')
stacker, filelistr, xshiftr, yshiftr, NGC6940_stacked_r, /robust

filelistv = file_search('*NGC*'+filters[0]+'.proc.fits')
stacker, filelistv, xshiftv, yshiftv, NGC6940_stacked_v, /robust







end