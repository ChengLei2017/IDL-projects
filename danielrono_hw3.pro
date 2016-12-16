pro homework3  ; Daniel Rono.

        atv, 'dss_search'   ; opening the downloaded image of M33 from DSS using ATV

        catalog=queryvizier('GSC2.3','M33',15,constraint='Vmag<14') ; searching for the 10 brightest objects in the Hubble GSC according to Vmag

        help, catalog,/struct

	print, "The stars with V<14, unsorted according to magnitude are:",catalog.vmag

        sortedarray=catalog[sort(catalog.vmag)].vmag ; sorting the array of Vmags 

        print, "The sorted array is:",sortedarray

        plothist, catalog.vmag, xrange = [5,13] ; plotting a histogram of magnitudes

	ra = catalog.raj2000  ; creating IDL vectors for RA, Declination and Visual Magnitude
	
	dec = catalog.dej2000

	vmag = catalog.vmag     

        print, "The RA for these objects is", ra

	print, "The Declination for these objects is", dec

        for i=0, 12 do begin

        	print, sixty(ra[i]/15.),sixty(dec[i]) ; converting RA and Declination from decimal to sexigesimal

	endfor

        atv, 'M33_clear_stacked.fits' ; opening the image of M33 taken with the Smith 16' telescope

end
