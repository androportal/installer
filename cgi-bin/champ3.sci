function champ3(x,y,z,sx,sy,sz)

//argument parsing
x=matrix(x,1,-1); y=matrix(y,1,-1); z=matrix(z,1,-1); 
nx=length(x); ny=length(y); nz=length(z); 

if size(sx)<>[nx,ny,nz] &  size(sx)<>[nx,ny,nz]'  then 
  write(%io(2), "sx size "+strcat(string(size(sx)),'x')+" found, "+..
        strcat(string([nx,ny,nz]),'x')+" expected")
  return
end
if size(sy)<>[nx,ny,nz] &  size(sy)<>[nx,ny,nz]' then 
  write(%io(2), "sy size "+strcat(string(size(sy)),'x')+" found, "+..
        strcat(string([nx,ny,nz]),'x')+" expected")
  return
end
if size(sz)<>[nx,ny,nz] & size(sz)<>[nx,ny,nz]'  then 
  write(%io(2), "sz size "+strcat(string(size(sz)),'x')+" found, "+..
        strcat(string([nx,ny,nz]),'x')+" expected")
  return
end

//scale factors
ds=mean([x(2:$)-x(1:$-1), y(2:$)-y(1:$-1), z(2:$)-z(1:$-1)])
su=sx.^2+sy.^2+sz.^2;
sf=ds/max(su(:));
q=su(:)>0
clear su;

//generate the arrows
zp=   z   .*.ones(y).*.ones(x)
yp=ones(z).*.  y    .*.ones(x)
xp=ones(z).*.ones(y).*.   x

xp=xp(q); yp=yp(q); zp=zp(q)
 
xp1=xp+sf*sx(q)'; yp1=yp+sf*sy(q)'; zp1=zp+sf*sz(q)'; 
clear q
                                                      
[xx,yy,zz]=spaghetti([xp;xp1],[yp;yp1],[zp;zp1],ds/15)
clear xp xp1 yp yp1 zp zp1
shadesurf2(xx,yy,zz,m=1)
endfunction
