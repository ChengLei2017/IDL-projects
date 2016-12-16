pro homework4                 ; Daniel Rono. CCD Data Reduction

  atv,'cal-001_bias.fit'
  
  fits_read,'cal-001_bias.fit', arr, hdr ; reads the bias frame 

  mfr = mean(arr[998:1641,998:1641]); calculates the mean bias level of the whole frame

  print, "Mean bias of the whole frame is",mfr 

  msp = mean(arr[1054:1134,1054:1134]); calculates the mean value of the small patch

  print, "Mean value of small patch is",msp

  arr=float(arr)

  plothist, arr[1054:1134,1054:1134] ; plots the histogram of pixel values in the patch  

  st=stdev(arr[1054:1134,1054:1134]); calculates the standard deviation in the small patch of a bias frame

  print, "Standard deviation in the small patch is",st

  fits_read, 'cal-002_bias.fit', arrb1, hdr

  fits_read, 'cal-003_bias.fit', arrb2, hdr

  diff_bias = float(arrb1) - float(arrb2) ; creates the difference frame as an array

  st_diff=stdev(diff_bias); calculates standard deviation of the difference frame 

  print, "Standard deviation in the difference frame is",st_diff

  rd_noise = st_diff/sqrt(2); calculates the read noise of the difference frame in ADU

  print, "The read noise in ADU of the difference frame is",rd_noise

  fits_write,'diff_bias.fit',diff_bias, hdr 

  atv,'diff_bias.fit'

  blist = file_search('*bias*.fit',count=nfiles); selects all FITS files with "bias" in the filename

  fits_read, blist[0], b0, hdr ; reads first image to get size

  xsz = sxpar(hdr,'NAXIS1') ; get X size of image

  ysz = sxpar(hdr,'NAXIS2') ; get Y size of image

  barray = fltarr(xsz,ysz,nfiles) ; set up 3D array of images

  for i=0, nfiles-1 do begin  ; loop through input images, stuff data into single array

	fits_read, blist[i], bias, hdr

	barray[*,*,i] = bias

  endfor

  sxaddpar, hdr, 'BZERO', 0.0 ; update BZERO keyword in header in case image gets saved with fits_write

  medarr, barray, masterbias ; use ASTROLIB routine to make masterbias as median stack of input images

  fits_write, 'masterbias.fit', masterbias

  flist = file_search('*flat*.fit',count=nfiles) ; selects all files with "flat" in the filename

  fbasefiles = file_basename (flist, '.fit')

  fits_read, flist[0], f0, hdr ; reads the first flat image to get size

  xsz = sxpar(hdr,'NAXIS1') ; gets X size of the image

  ysz = sxpar(hdr,'NAXIS2') ; gets Y size of the image

  for i=0, nfiles-1 do begin    ; loop through flats and subtract master bias frame from each

	fits_read, flist[i], flat, hdr

	fits_read, 'masterbias.fit', arr, hdr ; reads the master bias frame

        flat = float(flat) - float(arr) ; subtracts the master bias frame from the flats

        directory = "F:\Obsv_Astro\DRonoHW\hw4\m27_proc_masterbias\"

        fits_write, directory + fbasefiles[i] + '.procmb.fit', flat, hdr ; output processed results with "procmb" in filename, mb referring to "masterbias"

  endfor

  dlist = file_search('*dark*.fit',count=nfiles) ; selects all files with "dark" in the filename

  dbasefiles = file_basename (dlist, '.fit')

  fits_read, dlist[0], d0, hdr ; reads the first dark image to get size

  xsz = sxpar(hdr,'NAXIS1') ; gets X size of the image

  ysz = sxpar(hdr,'NAXIS2') ; gets Y size of the image

  for i=0, nfiles-1 do begin    ; loop through darks and subtract master bias frame from each

	fits_read, dlist[i], dark, hdr

	fits_read, 'masterbias.fit', arr, hdr ; reads the master bias frame

        dark = float(dark) - float(arr) ; subtracts the master bias frame from the darks

        directory = "F:\Obsv_Astro\DRonoHW\hw4\m27_proc_masterbias\"

        fits_write, directory + dbasefiles[i] + '.procmb.fit', dark, hdr ; output processed results with "procmb" in filename, mb referring to "masterbias" 

  endfor
  
  slist = file_search('*M27*.fit',count=nfiles) ; selects all files with "M27" in the filename

  sbasefiles = file_basename (slist, '.fit')

  fits_read, slist[0], s0, hdr ; reads the first science image to get size

  xsz = sxpar(hdr,'NAXIS1') ; gets X size of the image

  ysz = sxpar(hdr,'NAXIS2') ; gets Y size of the image

  for i=0, nfiles-1 do begin    ; loop through science images and subtract master bias frame from each

	fits_read, slist[i], science, hdr

        fits_read, 'masterbias.fit', arr, hdr ; reads the master bias frame

        science = float(science) - float(arr) ; subtracts the master bias frame from the science images

        directory = "F:\Obsv_Astro\DRonoHW\hw4\m27_proc_masterbias\"

        fits_write, directory + sbasefiles[i] + '.procmb.fit', science, hdr ; output processed results with "procmb" in filename, mb referring to "masterbias"

  endfor

  dlist = file_search('*dark*.fit',count=nfiles) ; searches for all dark images

  fits_read, dlist[0], d0, hdr ; read first image to get size

  exptime = sxpar(hdr,'EXPTIME')

  xsz = sxpar(hdr, 'NAXIS1') ; get X size of image

  ysz = sxpar(hdr, 'NAXIS2') ; get Y size of image

  darray = fltarr(xsz, ysz, nfiles) ; set up 3D array of images

  for i=0, nfiles-1 do begin ; loop through input images, stuff data into a single array

	   fits_read, dlist[i], dark, hdr

	   darray[*,*,i] = (dark-masterbias)/exptime

  endfor

  sxaddpar, hdr, 'BZERO', 0.0

  medarr, darray, masterdark_persec ; use ASTROLIB to make masterdark as median of input images

  fits_write, 'masterdark_persec.fit', masterdark_persec

  for i=0, nfiles-1 do begin    ; loop through flats and subtract scaled master dark frame from each

	fits_read, flist[i], flat, hdr

	exptime = sxpar(hdr,'EXPTIME')

        flat = float(flat) - (masterdark_persec*exptime) ; subtracts the scaled master dark frame from the flats

        directory = "F:\Obsv_Astro\DRonoHW\hw4\m27_proc_masterdark\"

        fits_write, directory + fbasefiles[i] + '.procmd.fit', flat, hdr ; output processed results with "procmd" in filename, md referring to "masterdark" 

  endfor

  for i=0, nfiles-1 do begin    ; loop through science images and substract scaled master dark frame from each

	fits_read, slist[i], science, hdr

	exptime = sxpar(hdr,'EXPTIME')

        science = float(science) - (masterdark_persec*exptime) ; subtracts the scaled master dark frame from the science images 

        directory = "F:\Obsv_Astro\DRonoHW\hw4\m27_proc_masterdark\"

        fits_write, directory + sbasefiles[i] + '.procmd.fit', science, hdr ; output processed results with "procmd" in filename, md referring to "masterdark"

  endfor

  filters = ['V', 'R', 'I']     ; list of filters used in the observing run

  for j=0, n_elements(filters) - 1 do begin ; loop through the list of filters

     files = file_search('cal*'+filters[j] +'*flat*'+'.fit',count=nfiles) ; selects all [j]-band flatfield frame FITS files

     print,'Found flat files:',nfiles ; This needs to be > 0

     masterflat = masterbias*0

     for i=0, nfiles-1 do begin

        fits_read, files[i], im, hdr

        exptime = sxpar(hdr,'EXPTIME')

        masterflat = masterflat + ((float(im) - masterbias) - masterdark_persec*exptime)/nfiles

     endfor

     masterflat = masterflat/median(masterflat) ; normalize so that masterflat now has mean=1.0

     sxaddpar, hdr, 'BZERO', 0.0

     fits_write, 'masterflat'+filters[j]+'.fit', masterflat, hdr ; output one masterflat FITS file per filter

  endfor

  print,'masterflat parameters',mean(masterflat),median(masterflat),stddev(masterflat)

  print,'dark parameters',mean(masterdark_persec),median(masterdark_persec),stddev(masterdark_persec)

  print,'bias parameters',mean(masterbias),median(masterbias),stddev(masterbias)

  for j=0, n_elements(filters) - 1 do begin

     print, 'Processing ', filters[j], 'science frames'

     files = file_search('M27'+'*'+filters[j]+'.fit', count=nfiles) ; selects all [j]-band science frame FITS files matching "M27"

     basefiles = file_basename(files, '.fit')

     for i=0, nfiles-1 do begin

        fits_read, files[i], im, hdr

	print,size(im)

	help,im

        exptime = sxpar(hdr,'EXPTIME')

        im = ((float(im) - masterbias) - masterdark_persec*exptime)/masterflat ; from each science image, subtract bias and dark, then divide by flat

        sxaddpar, hdr, 'BZERO', 0.0

        directory = "F:\Obsv_Astro\DRonoHW\hw4\m27_proc_masterflat\"
        
        fits_write, directory + basefiles[i] + '.procmf.fit', im, hdr ; output processed results with "procmf" in filename, mf referring to "masterflat"

     endfor

  endfor
     
end
  

