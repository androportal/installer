function shadesurf2(x,y,z,l,shine,m,theta,alpha,leg,flag,ebox)

//  plot of a surface with lighting due to an infinitely
//    distant light source (the sun), shading
//
// usage: shadesurf2(x,y,z [,l,shine,m,theta,alpha,leg,flag,ebox])
//    or: shadesurf(x,y,z, opt_arg=value, ...)    
//
//     all arguments like those of plot3d1 and shadecomp
//  

[lhs,rhs]=argn(0);

if rhs==0 then
//demo
  disp "Demo of shadesurf2():"
  disp "  x=linspace(-2.5,2.5,50);"
  disp "  a=exp(-(x''*x).^2);"
  disp "  xbasc(); shadesurf2(x,x,a);"
  x=linspace(-2.5,2.5,35); 
  a=exp(-(x'*x).^2);
  xbasc(); shadesurf2(x,x,a); 
  return
end

if ~exists('l','local') then l=[-1 1 2]; end
if ~exists('shine','local')  then shine=3; end
if ~exists('m','local')  then m=2; end
if ~exists('theta','local')  then theta=45; end
if ~exists('alpha','local')  then alpha=35; end
if ~exists('leg','local')  then leg='X@Y@Z'; end
if ~exists('flag','local')  then flag=[-1 6 4]'; end
if ~exists('ebox','local') then ebox=[0 0 0 1 1 1]'; end

nc=xget("lastpattern");
// beware - drivers other than 'REC' have their bugs about colormaps

if size(x,1)==1 | size(x,2)==1 then
// style like plot3d(x,y,z): x(1:nx), y(1:ny), z(1:nx,1:ny)
   [xx,yy,zz]=genfac3d(x,y,z);
   nn1=(zz(1,:)+zz(2,:)-zz(3,:)-zz(4,:))./(xx(4,:)-xx(1,:));
   nn2=(zz(1,:)-zz(2,:)-zz(3,:)+zz(4,:))./(yy(2,:)-yy(1,:));
   nn3=1
else
// style like plot3d(xx,yy,zz): facelets (thought primarily for
// triangles)
  xx=x; yy=y; zz=z;
end

cc=shadecomp(xx,yy,zz,l,shine,m)*(nc-1)+1;
plot3d1(xx,yy,list(zz,cc),theta,alpha,leg,flag,ebox)

// to draw also the external contour of the surface would be
//  nice, but requires more tracking of the external edges

endfunction

//an additional animated demo:
//x=linspace(-2.5,2.5,35); 
//a=cos((x'*x)).*((x'*x)+1);
//xbasc();xset("pixmap",1);xset("wwpc");
//for i=-1.5:.15:1.5; shadesurf2(x,x,a,l=[-i,i,2],theta=145); xset("wshow"); end; 
//xset("pixmap",0)

