pro project_stack_stacked

;authors: Tim Costa and Daniel Rono

;measure offset and place in arrays
xshift_a337 = make_array(3,1)
yshift_a337 = make_array(3,1)
xshift_standard = make_array(3,1)
yshift_standard = make_array(3,1)
xshift_ngc6940 = make_array(3,1)
yshift_ngc6940 = make_array(3,1)
xshift_ngc7160 = make_array(3,1)
yshift_ngc7160 = make_array(3,1)
 
files_a337 = file_search('*a337*.fits', count = nfilesb)

for i = 1, nfilesb-1 do begin
	fits_read, files_a337[0], imb1, hdrb
	fits_read, files_a337[i], im, hdr
	shifts = xyoff(imb1, im, 1000, 1000)
	xshift_out = -shifts[0]
	yshift_out = -shifts[1]
	xshift_a337[i] = xshift_out
	yshift_a337[i] = yshift_out
endfor

files_standard = file_search('*standard*.fits', count = nfilesr)

for i = 1, nfilesr-1 do begin
	fits_read, files_standard[0], imr1, hdrr
	fits_read, files_standard[i], im, hdr
	shifts = xyoff(imr1, im, 1000, 1000)
	xshift_out = -shifts[0]
	yshift_out = -shifts[1]
	xshift_standard[i] = xshift_out
	yshift_standard[i] = yshift_out
endfor

files_ngc6940 = file_search('*NGC6940*.fits', count = nfilesv)

for i = 1, nfilesv-1 do begin
	fits_read, files_ngc6940[0], imv1, hdrv
	fits_read, files_ngc6940[i], im, hdr
	shifts = xyoff(imv1, im, 1000, 1000)
	xshift_out = -shifts[0]
	yshift_out = -shifts[1]
	xshift_ngc6940[i] = xshift_out
	yshift_ngc6940[i] = yshift_out
endfor

files_ngc7160 = file_search('*NGC7160*.fits', count = nfilesv)

for i = 1, nfilesv-1 do begin
	fits_read, files_ngc7160[0], imv1, hdrv
	fits_read, files_ngc7160[i], im, hdr
	shifts = xyoff(imv1, im, 1000, 1000)
	xshift_out = -shifts[0]
	yshift_out = -shifts[1]
	xshift_ngc7160[i] = xshift_out
	yshift_ngc7160[i] = yshift_out
endfor

print, 'The offsets for', files_ngc7160, 'are:'
print, 'in the x coordinate:', xshift_ngc7160 
print, 'in the y coordinate:', yshift_ngc7160

print, 'The offsets for', files_ngc6940, 'are:'
print, 'in the x coordinate:', xshift_ngc6940 
print, 'in the y coordinate:', yshift_ngc6940

print, 'The offsets for', files_standard, 'are:'
print, 'in the x coordinate:', xshift_standard 
print, 'in the y coordinate:', yshift_standard

print, 'The offsets for', files_a337, 'are:'
print, 'in the x coordinate:', xshift_a337 
print, 'in the y coordinate:', yshift_a337


end