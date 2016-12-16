pro homework2                   ; Daniel Rono.         HW2: Star Clusters and Galactic Coordinates and Structure.

  readcol, 'galactic.open.dat', Gallong, Gallat, Name, format = 'd,d,a' ; reads columns in the open cluster data into arrays

  readcol, 'galactic.glob.dat', Lat, Long, Dist, Name, format = 'd,d,d,a' ; reads columns in the globular cluster data into arrays

  Gallong_open = Gallong-180 ; converts open cluster longitudes to a [-180, 180] scale

  Gallong_glob = Long-180 ; converts globular cluster longitudes to a [-180, 180] scale

  plot,Gallong_open, Gallat, psym=5, xtitle='Galactic longitude, open cluster', ytitle='Galactic latitude, open cluster', title='Open cluster galactic latitude against galactic longitude', xrange=[min(Gallong_open), max(Gallong_open)], yrange=[min(Gallat), max(Gallat)] ; plots 2D graph of open cluster

  plot,Gallong_glob, Lat, psym=6, xtitle='Galactic longitude, globular cluster', ytitle='Galactic latitude, globular cluster', title='Globular cluster galactic latitude against galactic longitude', xrange=[min(Gallong_glob), max(Gallong_glob)], yrange=[min(Lat), max(Lat)] ; plots 2D graph of globular cluster

  Gallong_glob_rad = Gallong_glob/57.2958  ; converts globular cluster longitude into radians

  Lat_rad = Lat/57.2958 ; converts globular cluster latitude into radians

  X = Dist*cos(Lat_rad)*cos(Gallong_glob_rad) ; these three lines do the conversion from spherical coordinates to rectangular coordinates

  Y = Dist*cos(Lat_rad)*sin(Gallong_glob_rad)

  Z = Dist*sin(Lat_rad)

  plot,X, Z, psym=4, xtitle='X in kpc', ytitle='Z in kpc', title='Globular cluster plot of Z vs X', xrange=[-20, 20], yrange=[-20, 20] ; plots Z vs X in 3D rectangular coordinates

  plot,X, Y, psym=5, xtitle='X in kpc', ytitle='Y in kpc', title='Globular cluster plot of Y vs X', xrange=[-20, 20], yrange=[-20, 20] ; plots Y vs X in 3D rectangular coordinates

  plot,Y, Z, psym=2, xtitle='Y in kpc', ytitle='Z in kpc', title='Globular cluster plot of Z vs Y', xrange=[-20, 20], yrange=[-20, 20] ; plots Z vs Y in 3D rectangular coordinates

  Sun_dist = mean(((X^2) + (Y^2) + (Z^2))^0.5) ; estimate of distance from the sun to the centre of the Galaxy, given (0,0,0) as the sun's location.

  print, 'Estimated distance from the sun to the centre of the Milky Way in kpc is ',Sun_dist

end
