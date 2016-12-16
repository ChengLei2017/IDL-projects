FUNCTION xyoff, a,b,bx,by,hx,hy,fna,wdow=wdow,mask=mask,sobel=sobel,ccf=ccf,quiet=quiet

;+
; NAME:
;	xyoff
; PURPOSE:
;	Calculates the correlation function between two images using a box of
;	size (bx,by) surrounding a point in the image. By default this point
;	is the center of the image, (nx/2,ny/2). The routine calculates the
;	offsets by finding the maximum of the correlation function.
; CATEGORY:
;	Image processing
; CALLING SEQUENCE:
;	s = xyoff(a,b,bx,by, hx,hy,fna,wdow=wdow,mask=mask,/sobel,ccf=ccf,/quiet)
; INPUTS:
;	a	2D reference image.
;	b	2D image that you want to track with respect to a
;	bx	size of the box in the x-dimension that you wish
;		to use to generate the cross correlation function
;	by	size of the box in the y-dimension that you wish
;		to use to generate the cross correlation function.
;	hx	x position in the image that corresponds to the center
;		of the box. (Optional)
;	hy	y position in the image that corresponds to the center
;		of the box. (Optional)
;	fna	fourier transform of the 256x256  (Optional)
;		subtended image from the center of a.
; OPTIONAL INPUTS:
;	wdow=wdow	2-d apodization window.  (Optional; default=1)
;	mask=mask	2-d mask to be applied in fourier space. (Optional;default=1)
;	/sobel		If specified, then SOBEL keyword causes this routine
;			to track on the gradient of the image instead of the
;			image itself.  (It uses a Sobel edge enhancement operator)
;	/quiet		if set, suppress printing of results on screen
; OUTPUTS:
;	s =	A vector containing the x and y offsets that should be applied
;		to an image to maximize the cross correlation.
;	s[0] = The x offset.
;	s[1] = The y offset.
;	s[2] = max value of the correlation
;	s[3] = cross correlation at 0 shift
;	s[4] = maximum of the real part of absolute value of cross correlation
; INCLUDE:
	;@compile_opt.pro	; On error, return to caller
; CALLS:
;	max_pos
; PROCEDURE:
;	The executing program is xyoff.pro.  It performs a 2D
;	cross-correlation, yielding the lag of maximum correlation, the
;	coefficient of maximum correlation and the coefficient at lag 0.  In
;	practice, I usually used lag 0.  Within the limits of floating point
;	computation, the cross correlation at 0 shift of an image and itself is
;	1.0 and the shifts are 0.0 and 0.0 as would be expected.  xyoff.pro
;	calls max_pos.pro to find the maximum position within an array...the
;	cross-correlation function in this case.
; MODIFICATION HISTORY:
;	H. Cohl,   7 Jun, 1991 --- Initial programming.
;	H. Cohl,  13 Dec, 1991 --- Added SOBEL keyword.
;	H. Cohl,  13 Feb, 1992 --- Made it so that you can enter in hx or hy.
;	H. Cohl,  25 Mar, 1992 --- Made documentation more understandable.
;	T. Henry   December, 1993 ---  some changes made to size
;-

InitVar, sobel, /key
InitVar, quiet, /key

ssz = size(a)				; Size of first image
IF ssz[0] NE 2 THEN message, 'Main image must be 2D array'

nx = ssz[1]
ny = ssz[2]
message, /info, 'Main image is A('+strcompress(nx,/rem)+','+strcompress(ny,/rem)+')'

ssz = size(b)
IF ssz[0] NE 2 THEN message, 'Secondary image must be 2D array'

IF nx NE ssz[1] OR ny NE ssz[2] THEN BEGIN
    message, /info, 'Second image is A('+strcompress(ssz[1],/rem)+','+strcompress(ssz[2],/rem)+')'
    message, 'Both images must have same array dimensions'
ENDIF

InitVar, hx, nx/2	; Check center of image
InitVar, hy, ny/2

InitVar, bx, nx-1	; Check box size
InitVar, by, ny-1

mx = bx/2
my = by/2			; Set correlation box size

InitVar, wdow, 1.0	; Check presence of window
InitVar, mask, 1.0	; Check for presence of mask

xlo = hx-mx
xhi = hx+mx

ylo = hy-my
yhi = hy+my

; In the original XYOFF program the values of xhi and yhi were one less
; than in the current version. Activate the next line to go back to the
; original version

; xhi = xhi-1
; yhi = yhi-1

message, /info, 'Center of correlation window: ('+	$
	strcompress(hx,/rem)+','+strcompress(hy,/rem)+')'
message, /info, 'Window used for correlation: ' +	$
	'A('+strcompress(xlo,/rem)+':'+strcompress(xhi,/rem)+','+	$
	     strcompress(ylo,/rem)+':'+strcompress(yhi,/rem)+')'

IF xlo LT 0 OR xhi GT nx-1 OR 	$
   ylo LT 0 OR yhi GT ny-1 THEN message, 'Invalid subarray index range'

na = a[xlo:xhi,ylo:yhi]
nb = b[xlo:xhi,ylo:yhi]

IF min(na) EQ max(na) THEN message, 'First image is flat'
IF min(nb) EQ max(nb) THEN message, 'Second image is flat'

na = na-mean(na)						; Subtract average
nb = nb-mean(nb)

IF sobel THEN na = 1.*sobel(na) ELSE na = na*wdow
IF sobel THEN nb = 1.*sobel(nb) ELSE nb = nb*wdow

fna = fft(na*mask,-1)					; Forward Fourier transform
fnb = fft(nb*mask,-1)

rms_na = sqrt(mean(na*na))
rms_nb = sqrt(mean(nb*nb))

ccf = fft(fna*conj(fnb),1)				; Correlation fnc between na and nb (reverse Fourier transform)
ccf = float(ccf)						; Get real part (imaginary part should be zero)
ccf = ccf/(rms_na*rms_nb)				; Normalize cross correlation fnc

ccf = shift(ccf,mx,my)					; Shift correlation function.
ps  = max_pos(ccf)						; Find maximum of ccf

s = [ps[0]-mx, ps[1]-my, max(ccf), ccf[bx/2,by/2], max(abs(ccf))]

IF NOT quiet THEN BEGIN
	help, ccf
	print, 'RMS of images A and B : ', rms_na, rms_nb

	print, 'Position of Maximum(CCF)= ', [mx,my]+s[0:1]
	print, 'Shift in X   - ', s[0]
	print, 'Shift in Y   - ', s[1]
	print, 'Maximum(CCF) - ', s[2]
	print, 'Center CCF   - ', s[3]
	print, 'Maximum( abs(CCF) )= ', s[4]
	print, 'Position of Maximum( abs(CCF) )= ',max_pos(abs(ccf))
ENDIF

RETURN, s  &  END
