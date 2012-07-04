function  [x,y,h]=histogram2(a,b,lx,ux,ly,uy,nx,ny)
//
// joint histogram in 2d
//  syntax:   [x,y,h]=histogram2(a,b)
//            [x,y,h]=histogram2(a,b,nx,ny)
//            [x,y,h]=histogram2(a,b,lx,ux,ly,uy)
//            [x,y,h]=histogram2(a,b,lx,ux,ly,uy,nx,ny)
//
[lhs,rhs]=argn(0)

if rhs==0 then
  write(%io(2),[
      '[x,y,h]=histogram2(rand(1,1000).^2,rand(1,1000).^3,20,20);'
      'plot3d1(x,y,h)'])
  [x,y,h]=histogram2(rand(1,1000).^2,rand(1,1000).^3,20,20);
  xbasc();plot3d1(x,y,h)
  return
end

if ~(rhs==2 | rhs==4 | rhs==6 ) then 
   write(%io(2),'histogram2: wrong number of arguments'); return; end

if rhs==6 then nx=50; ny=50; end
if rhs==4 then  nx=lx; ny=ux; lx=min(a);ux=max(a); 
        ly=min(b); uy=max(b);
end
if rhs==2 then lx=min(a),ux=max(a); ly=min(b),uy=max(b); 
       nx=50; ny=50; end

h=zeros(nx,ny);

x=lx+((1:nx)'-0.5)*(ux-lx)/nx;
dx=(ux-lx)/nx; xp=[x'-0.5*dx,ux+dx];
y=ly+((1:ny)'-0.5)*(uy-ly)/ny;
dy=(uy-ly)/ny; yp=[y'-0.5*dy,uy+dy];

for i=1:nx; 
 for j=1:ny;
  h(i,j)=length( find( a>=xp(i) &  a<xp(i+1) & b>=yp(j) &  b<yp(j+1) ) )
 end; 
end


if lhs==1 then x=h; end         // comodita' per calls veloci

endfunction

