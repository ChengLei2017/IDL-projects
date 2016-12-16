pro homework1  ; Daniel Rono.  HW1: Distance Modulus and Standard Candles.

	readcol, 'messiercatalog.txt', Object, RA_hrs, RA_min, RA_sec, DEC_sign, DEC_deg, DEC_min, DEC_sec, Epoch, V_Mag, Type, format='a,i,i,d,a,i,i,d,i,d,a' ; reads columns in the Messier catalog into arrays

	RA_decimal = [RA_hrs + (RA_min/60) + (RA_sec/3600)]; convert RA to decimal
	
	DEC_deg1 = DEC_deg[where(DEC_sign.Contains('+'))] ;find degrees with positive declination

	DEC_deg2 = DEC_deg[where(DEC_sign.Contains('-'))] ;find degrees with negative declination

	DEC_min1 = DEC_min[where(DEC_sign.Contains('+'))] ;find minutes with positive declination

	DEC_min2 = DEC_min[where(DEC_sign.Contains('-'))] ;find minutes with negative declination

	DEC_sec1 = DEC_sec[where(DEC_sign.Contains('+'))] ;find seconds with positive declination

	DEC_sec2 = DEC_sec[where(DEC_sign.Contains('-'))] ;find seconds with negative declination

	DEC_1 = [DEC_deg1 + (DEC_min1/60) + (DEC_sec1/3600)] ; convert positive declination to decimal

        DEC_2 = [0 - DEC_deg2 - (DEC_min2/60) - (DEC_sec2/3600)] ; convert negative declination to decimal

	open_clust = Object[where(Type EQ 'OC')] ;finds open clusters

	nopen_clust = n_elements(open_clust) ;finds number of open clusters

	print, 'Number of open clusters is',nopen_clust

	glob_clust = Object[where(Type EQ 'GC')] ; finds globular clusters

	nglob_clust = n_elements(glob_clust) ;finds number of globular clusters

	print, 'Number of globular clusters is',nglob_clust

	clusters = Object[where((Type EQ 'OC') or(Type EQ 'GC'))] ;finds all clusters

	nclusters = n_elements(clusters) ; finds total number of clusters

	print, 'The total number of clusters is',nclusters

	target_clust = clusters[where((DEC_1 ge 47.7) or (((DEC_2 gt -7.7) or (DEC_1 lt 47.7)) and ((RA_decimal ge 17) and (RA_decimal le 21))))] ; finds clusters that match our criteria for observation, given parameters in parts a,b and c

	print, 'Target clusters matching our criteria are',target_clust

	V_Mag2 = min(V_Mag[where((Type EQ 'OC') or(Type EQ 'GC'))]) ; finds magnitude of brightest cluster
 
	bright_clust = Object[where((V_Mag EQ V_Mag2) and ((Type EQ 'OC') or(Type EQ 'GC')))] ;finds the brightest cluster

	print, 'The brightest cluster in the catalog is',bright_clust,'with a V band magnitude of',V_Mag2

	V_Mag3 = max(V_Mag[where((Type EQ 'OC') or(Type EQ 'GC'))]) ; finds magnitude of dimmest cluster

	dim_clust = Object[where((V_Mag EQ V_Mag3) and ((Type EQ 'OC') or(Type EQ 'GC')))] ;finds the dimmest cluster

	print, 'The dimmest cluster in the catalog is',dim_clust,'with a V band magnitude of',V_Mag3

end