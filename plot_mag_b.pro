pro plot_mag_b                    ; Tim Costa and Daniel Rono.

  restore,'VR_stack_NGC6940_cal.sav'

  restore,'VR_stack_NGC7160_cal.sav'

  readcol, 'iso_7160_2.dat', z, age7160, mini, mact, Lo, te, g, mbol, U, B, V7160, R7160, format = 'f,f,f,f,f,f,f,f,f,f,f,f'

  readcol, 'iso_6940.dat', z, age6940, mini, mact, Lo, te, g, mbol, U, B, V6940, R6940, format = 'f,f,f,f,f,f,f,f,f,f,f,f'

  color_6940 = mags2_cal-mags1_cal

  color_7160 = mags4_cal-mags3_cal

  
  V7160 = V7160[where(age7160 gt 7.90)]
  R7160 = R7160[where(age7160 gt 7.90)]


  V6940 = V6940[where(age6940 gt 9.0 and age6940 lt 9.2)]
  R6940 = R6940[where(age6940 gt 9.0 and age6940 lt 9.2)]

  color_iso_7160 = V7160-R7160
  color_iso_6940 = V6940-R6940
  
  mederr6940 = median(err1)
  mederr7160 = median(err3)

  V6940 = V6940 + 10.10
  V7160 = V7160+10.65
  
  ;mederr = make_array(1, 1, value = mederr)
  ;print, mederr

 plot, color_6940, mags2_cal, xrange=[-2.0, 3.0],yrange=[20.0,min(mags1_cal)], psym=1

 oplot, color_iso_6940-.9, V6940

 ;plot, color_7160, mags4_cal, xrange=[-1.0, max(color_7160)], yrange=[22.0, min(mags4_cal)], psym=1
  
 ;oplot, color_iso_7160-.1, V7160

 errplot, mags1_cal-mederr6940, mags1_cal+mederr6940, color = 160
 
 ;errplot, mags4_cal-mederr7160, mags4_cal+mederr7160, color = 160


end
