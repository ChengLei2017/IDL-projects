pro homework6 ; Daniel Rono. Homework 6: The CCD Equation.

	c_star = 682.47 ; star count rate in electrons per second.

	c_bkg = 8.14 ; background count rate in electrons per second.

	c_d = 0.0014; dark count rate in electrons per second [=(5 electrons/hr/pixel)/3600 sec/hr].

	n_pix = 5 ; number of pixels for the star.

	rn = 7.3 ; read noise in electrons per pixel.

	sn_rat = 10 ; signal-to-noise ratio.

	t_exp1 = (((sn_rat^2)*(c_star+n_pix*(c_bkg + c_d))) + (((sn_rat^4)*(c_star+(n_pix*(c_bkg + c_d)))^2) - (4*(c_star^2)*n_pix*(rn^2)))^0.5)/(2*(c_star^2)) ; exposure time from the root of the quadratic formula

        t_exp2 = t_exp1*(sqrt(3))

        print, 'The exposure time in seconds that is needed is', t_exp1

        print, 'The exposure time in seconds needed for one of three exposures is', t_exp2        

	sn_hour = (3600/t_exp1)*((((c_star*t_exp1)^2)/((c_star*t_exp1) + n_pix*((C_bkg*t_exp1) + (c_d*t_exp1) + (rn^2))))^0.5) ; signal-to-noise ratio for a one-hour (3600 sec) exposure.

        sn_hourb = (3600/t_exp2)*((((c_star*t_exp2)^2)/((c_star*t_exp2) + n_pix*((C_bkg*t_exp2) + (c_d*t_exp2) + (rn^2))))^0.5) ; signal-to-noise ratio for three twenty-minute exposures.
        
        print, 'The SNR for one-hour is', sn_hour

        print, 'The SNR for three 20-minute exposures is', sn_hourb

end
