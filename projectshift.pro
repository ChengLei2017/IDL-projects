pro projectshift;       ;Daniel  Rono and Tim Costa . ; Project: shift stacked images

	fits_read, 'stacked_NGC6940R.fits', arr1, hdr

        fits_read, 'stacked_NGC6940B.fits', arr1b, hdr

        s = xyoff (arr1b,arr1,500,500)
        
        shift_stacked_NGC6940R = shift(arr1, s[0], s[1])

        fits_write, 'shift_stacked_NGC6940R.fits', shift_stacked_NGC6940R, hdr

        fits_read, 'stacked_NGC6940V.fits', arr2, hdr

        t = xyoff (arr1b,arr2,500,500)

	shift_stacked_NGC6940V = shift(arr2, t[0],t[1])

        fits_write, 'shift_stacked_NGC6940V.fits', shift_stacked_NGC6940V, hdr

        fits_read, 'stacked_NGC7160V.fits', arr3, hdr

        fits_read, 'stacked_NGC7160B.fits', arr2b, hdr

        u = xyoff (arr2b,arr3,500,500)

	shift_stacked_NGC7160V = shift(arr3, u[0], u[1])

        fits_write, 'shift_stacked_NGC7160V.fits', shift_stacked_NGC7160V, hdr

        fits_read, 'stacked_NGC7160R.fits', arr4, hdr

        w = xyoff (arr2b,arr4,500,500)

	shift_stacked_NGC7160R = shift(arr4, w[0],  w[1])

        fits_write, 'shift_stacked_NGC7160R.fits', shift_stacked_NGC7160R, hdr

        fits_read, 'stacked_a337_0915R.fits', arr5, hdr

        fits_read, 'stacked_a337_0915B.fits', arr5b, hdr

        n = xyoff (arr5b,arr5,500,500)

	shift_stacked_a337_0915R = shift(arr5, n[0], n[1])

        fits_write, 'shift_stacked_a337_0915R.fits', shift_stacked_a337_0915R, hdr

        fits_read, 'stacked_a337_0915V.fits', arr6, hdr

        m = xyoff (arr5b,arr6,500,500)

	shift_stacked_a337_0915V = shift(arr6, m[0], m[1])

        fits_write, 'shift_stacked_a337_0915V.fits', shift_stacked_a337_0915V, hdr

        fits_read, 'stacked_standard_R.fits', arr7, hdr

        fits_read, 'stacked_standard_B.fits', arr7b, hdr

        q = xyoff (arr7b,arr7,500,500)

	shift_stacked_standard_R = shift(arr7, q[0], q[1])

        fits_write, 'shift_stacked_standard_R.fits', shift_stacked_standard_R, hdr

        fits_read, 'stacked_standard_V.fits', arr8, hdr

        k = xyoff (arr7b,arr8,500,500)

	shift_stacked_standard_V = shift(arr8, k[0], k[1])

	fits_write, 'shift_stacked_standard_V.fits', shift_stacked_standard_V, hdr

end
