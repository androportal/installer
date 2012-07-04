function zi=grid2Ddata(xyzp,xg,yg,nb)
//xg -> 1*nx
//yg -> 1*ny
//xyp-> np*3
//zi -> nx*ny

[lhs,rhs]=argn(0);
if rhs==3 then nb=3; end
if rhs==0 then
  xg=linspace(0,1,30); yg=linspace(0,1,30); xyzp=rand(12,3);
  zi=grid2Ddata(xyzp,xg,yg,3);
  xbasc(); shadesurf2(xg,yg,zi);
  xset("mark size",3)
  param3d1(xyzp(:,1),xyzp(:,2),list(xyzp(:,3),-3),flag=[0 0])
  zi=[];
  return
end


xp=xyzp(:,1); yp=xyzp(:,2); zp=xyzp(:,3); np=size(xyzp,1);
if np<nb then error("not enough points to find neighbors!"); end

nx=length(xg); ny=length(yg); zi=zeros(nx,ny);

//size of a square where I have probability of finding nb
// datapoint, if datapoints are uniformly distributed over
//  the rectangle xg*yg:
dx=sqrt(nb*(xg($)-xg(1))*(yg($)-yg(1))/np);
//even if the grid is nonuniformly spaced, the points are non evenly
//distributed, etc, this is a starting size for the shell search

for i=1:nx
   ix=(xp-xg(i))/dx; nmx=max(abs(ix))
   for j=1:ny
      iy=(yp-yg(j))/dx;  nmy=max(abs(iy))
//search for nb neighbors of (xg(i),yg(j)) by looking in
//  larger and larger cell neighborhoods
      nnb=0;ns=0; nls=0; //(=> first macrocell -> 1x probability)
      while nnb<nb & nls<max(nmx,nmy)
        ns=ns+1; nls=sqrt(ns/4);
        inb=find(abs(ix)<nls & abs(iy)<nls)
        nnb=length(inb)
      end
//compute the distances between the gridpoint and all the
// candidate neighbors found in the macrocell
      d2=(xp(inb)-xg(i)).^2 + (yp(inb)-yg(j)).^2 
      zb=zp(inb);
//select the nb closest data points
      [ds,k]=gsort(-d2); ds=-ds;
      zb=zb(k(1:nb)); ds=ds(1:nb)
//the grid value is computed as a weighted mean of the values
// at the neighbor datapoints, with inverse square distance weights
      if or(ds==0) then
//one or more datapoints could fall exactly on a gridpoint
         zi(i,j)=mean(zb(ds==0))
      else
         zi(i,j)=sum(zb./ds)./sum(1../ds)
      end
   end
end
endfunction
