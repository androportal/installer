function [xx,yy,zz,c]=slice3d(x,y,z,h,ii,jj,kk)

//  syntax: [xx,yy,zz,c]=slice3d([x,y,z,] h,ii,jj,kk)
//
// generates facelets for the slicing (sort of a la spyglass)
//  of 3d data in hypermat h
// Only cartesian plane slices for the moment
//
//  x,y,z: vectors, coordinates of the grid
//
//  ii, jj, kk : vectors or scalars, 
//    the slice is cut on cartesian planes at
//    constant value of the nonzero indices (if more than
//    one index is non null, more than one slice is produced)
//  index values can be negative: then the facelets are flipped
//   (this is for plot3d, which distinguishes the side of the faces);
//
// c is a vector of values of h, rescaled between 0 and 1
//  for use e.g. in plot3d1(xx,yy,list(zz,c*ncolors))
//  the resulting facelets extend over x,y,z: the center of
//   each facelet is in (x,y,z).
//

[lhs,rhs]=argn(0);
if rhs<=0 then
  write(%io(2),[
      '  s=hypermat([10,10,10]);'
      '  x=(-4.5:4.5)''*ones(1,10); y=x''; z=(-4.5:4.5);'
      '  for i=1:10; s(:,:,i)=1../((x-2).^2+y.^2+(z(i)-2)^2)+..'
      '     1../((x+2).^2+y.^2+(z(i)+2)^2); end'
      '  xbasc(); nc=xget(''lastpattern''); xset(''pixmap'',1);'
      '  for j=1:10;'
	'    [xx,yy,zz,c]=slice3d(-log(s),-1,[-1,-j],[1,j]); '
	'    xset(''wwpc'');plot3d(xx,yy,list(zz,c*(nc-1)+1));xset(''wshow'');'
      '  end;'
      '  xset (''pixmap'',0)'])
  
  
  
  s=hypermat([10,10,10]);
  x=(-4.5:4.5)'*ones(1,10); y=x'; z=(-4.5:4.5);
  for i=1:10; s(:,:,i)=1../((x-2).^2+y.^2+(z(i)-2)^2)+..
       1../((x+2).^2+y.^2+(z(i)+2)^2); end
  xbasc();   nc=xget('lastpattern'); xset('pixmap',1);
  for j=1:10;
    [xx,yy,zz,c]=slice3d(-log(s),-1,[-1,-j],[1,j]); 
    xset('wwpc');plot3d(xx,yy,list(zz,c*(nc-1)+1));xset('wshow');
  end;
  xset ('pixmap',0)
  return
end



if rhs==4 then 
  ii=y; jj=z; kk=h; h=x;
end

nx=size(h,1); ny=size(h,2); nz=size(h,3);

if rhs==4 then 
  x=1:nx;  y=1:ny;  z=1:nz; 
end

x=matrix(x,1,-1); y=matrix(y,1,-1); z=matrix(z,1,-1); 

//x1=[(3*x(1)-x(2))/2,(x(2:$)+x(1:$-1))/2,(3*x($)-x($-1))/2];
//y1=[(3*y(1)-y(2))/2,(y(2:$)+y(1:$-1))/2,(3*y($)-y($-1))/2];
//z1=[(3*z(1)-z(2))/2,(z(2:$)+z(1:$-1))/2,(3*z($)-z($-1))/2];
x1=[x(1),(x(2:$)+x(1:$-1))/2,x($)];
y1=[y(1),(y(2:$)+y(1:$-1))/2,y($)];
z1=[z(1),(z(2:$)+z(1:$-1))/2,z($)];
// facelets are centered on the gridpoint, except for edge facelets,
//  which are halved


//max and min are sought layer by layer, likely because scilab<2.6 didn't
// support max(hypermat); however, max(uint,uint) is still buggy in 2.6;
// therefore the double()s
maxh=max(double(h(:,:,1))); minh=min(double(h(:,:,1))); 
for l=2:nz
   minh=min(min(double(h(:,:,l))),minh); maxh=max(max(double(h(:,:,l))),maxh);
end

xx=[];yy=[];zz=[];c=[];

if or(abs(ii)>nx) then 
    write(%io(2),"yz slices "+strcat(string(ii(abs(ii)>nx)),' ')+..
          " nonexisting, ignored")
end 
if or(abs(jj)>ny) then 
    write(%io(2),"xz slices "+strcat(string(jj(abs(jj)>ny)),' ')+..
          " nonexisting, ignored")
end 
if or(abs(kk)>nz) then 
    write(%io(2),"xy slices "+strcat(string(kk(abs(kk)>nz)),' ')+..
          " nonexisting, ignored")
end 

for i=int(ii(find(ii<>0 & abs(ii)<=nx)))
  c0=matrix(h(abs(i),1:$,1:$),ny,nz); c0=c0(:,:);
  c0=matrix(c0',1,ny*nz); 
  [xx0,yy0,zz0]=genfac3d(x(abs(i))*ones(1,nz+1),y1,z1'*ones(1,ny+1))
  if i<0 then
     xx0=xx0([1,4,3,2],:);
     yy0=yy0([1,4,3,2],:);
     zz0=zz0([1,4,3,2],:);
  end
  xx=[xx,xx0]; yy=[yy,yy0], zz=[zz,zz0]; c=[c,c0];
end

for j=int(jj(find(jj<>0 & abs(jj)<=ny)))
  c0=matrix(h(1:$,abs(j),1:$),1,nx*nz); c0=c0(:,:);
  [xx0,yy0,zz0]=genfac3d(x1,y(abs(j))*ones(1,nz+1),(z1'*ones(1,nx+1))')
  if j<0 then
     xx0=xx0([1,4,3,2],:);
     yy0=yy0([1,4,3,2],:);
     zz0=zz0([1,4,3,2],:);
  end
  xx=[xx,xx0]; yy=[yy,yy0], zz=[zz,zz0]; c=[c,c0];
end

for k=int(kk(find(kk<>0 & abs(kk)<=nz))) 
  c0=matrix(h(1:$,1:$,abs(k)),1,nx*ny);  c0=c0(:,:);
  [xx0,yy0,zz0]=genfac3d(x1,y1,z(abs(k))*ones(nx+1,ny+1))
  if k<0 then
     xx0=xx0([1,4,3,2],:);
     yy0=yy0([1,4,3,2],:);
     zz0=zz0([1,4,3,2],:);
  end
  xx=[xx,xx0]; yy=[yy,yy0], zz=[zz,zz0]; c=[c,c0];
end

// I don't attempt any merging of adjacent rectangles of the same
//  color, as in pixmapl: I'm afraid that plot3d would be quite
//  confused with the visibility of partially blocked macrorectangles.
  
c=(double(c)-minh)/(maxh-minh);

endfunction

