function shadesurf(x,y,z,a,b,theta,alpha,leg,flag,ebox)

//  plot of a surface with lighting due to an infinitely
//    distant light source (the sun), no shading
//
// usage: shadesurf(x,y,z,[a,b,theta,alpha,leg,flag,ebox])
//
//     all arguments like those of plot3d1 (in fact, that's
//     a little more than a wrapper), except for:
//     a,b:  director cosines of the sun direction
//   


[lhs,rhs]=argn(0);

if rhs==0 then
//demo
  //disp "Demo of shadesurf:"
  //disp "  x=linspace(-2.5,2.5,50);"
  //disp "  a=exp(-(x''*x).^2);"
  //disp "  xbasc(); shadesurf(x,x,a,-1,1,65,60);"
  x=linspace(-2.5,2.5,35); 
  a=exp(-(x'*x).^2);
  xbasc(); shadesurf(x,x,a,-1,1,65,60); 
  return
end
if rhs<4 then a=0; end
if rhs<5 then b=.2; end
if rhs<6 then theta=45; end
if rhs<7 then alpha=35; end
if rhs<8 then leg='X@Y@Z'; end
if rhs<9 then flag=[-1 2 4]'; end
if rhs<10 then ebox=[0 0 0 1 1 1]'; end


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
  nn1=-((yy(1,:)-yy(2,:)).*(zz(2,:)-zz(3,:))-...
      (yy(2,:)-yy(3,:)).*(zz(1,:)-zz(2,:)));
  nn2=((xx(1,:)-xx(2,:)).*(zz(2,:)-zz(3,:))-...
      (xx(2,:)-xx(3,:)).*(zz(1,:)-zz(2,:)));
  nn3=-((xx(1,:)-xx(2,:)).*(yy(2,:)-yy(3,:))-...
      (xx(2,:)-xx(3,:)).*(yy(1,:)-yy(2,:)));
  if size(xx,1)==3 then
// so far scilab (up to 2.5) has the bug of the extra line of the
// 3d triangle
    xx=[xx;xx(1,:)]; yy=[yy;yy(1,:)]; zz=[zz;zz(1,:)]; 
  end
end

degfac=find(abs(nn1)+abs(nn2)+abs(nn3)<10*%eps);
// this can happen for instance if there are coincident vertices;
// it shouldn't, if xx, yy, zz are constructed properly, but
// I want shadesurf to get through it anyway
nn3(degfac)=1

//cc=sqrt(nn1.^2+nn2.^2+nn3.^2);
// color proportional to the slope

//cc=1../max(a*nn1+b*nn2,1);
// color inversely proportional to the lightened side

cc=(a*nn1+b*nn2+nn3)./sqrt(nn1.^2+nn2.^2+nn3.^2) ./sqrt(a^2+b^2+1);
// color proportional to the sine of the angle (local normal)^(sun)
// the direction of the sun is [a, b, 1]

if max(cc)~=min(cc) then
   cc=(-min(cc)+cc)/(max(cc)-min(cc))*(nc-1)+1;
else
// this can happen if the surface is a plane, and I want this to
//  be handled
   cc=ones(size(cc,1),size(cc,2))*nc;
end

plot3d1(xx,yy,list(zz,cc),theta,alpha,leg,flag,ebox)

// to draw also the external contour of the surface would be
//  nice, but requires more tracking of the external edges

endfunction

//an additional animated demo:
//x=linspace(-2.5,2.5,35); 
//a=cos((x'*x)).*((x'*x)+1);
////a=exp(-(x'*x).^2);
//xbasc();xset("pixmap",1);xset("wwpc");
//for i=-1.5:.15:1.5; shadesurf(x,x,a,-i,i,145);  xset("wshow"); end; 
//xset("pixmap",0)

