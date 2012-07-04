function [xt,yt,zt,ct]=trisplit(xx,yy,zz,cc)
[lhs,rhs]=argn(0);

//list input form, a la oplot3d
if rhs==1 then
  cc=xx(4); zz=xx(3); yy=xx(2), xx=xx(1);
  rhs=4;
end

if size(xx)~=size(yy) | size(xx)~=size(zz) | size(yy)~=size(zz) then
    write(%io(2),'arguments have wrong sizes!')
    return
end

nf=size(xx,2); ns=size(xx,1);

//if ns==3 then return; end    //nothing to do!

if rhs==4 then
   if (size(cc)~=[1,nf] & size(cc)~=[ns,nf])
     write(%io(2),'cc has wrong sizes!')
     return
   end
end

//find suitable internal centroids of the given polygons
// try first middle points (would be ok for plane convex polygons)
xc=mean(xx,1);
yc=mean(yy,1);
zc=mean(zz,1);

// check if they fall inside the polygon (3d?)

//if cc is given and vertex-bound:
//compute an interpolated value of cc at the centroid
if rhs==4 then if size(cc,1)==ns then
   ccc=mean(cc,1)
end; end

//compose triangles
xt=zeros(3,ns*nf); yt=xt; zt=xt;
for i=1:ns-1
  xt(:,(0:nf-1)*ns+i)=[xx(i,:);xx(i+1,:);xc];
  yt(:,(0:nf-1)*ns+i)=[yy(i,:);yy(i+1,:);yc];
  zt(:,(0:nf-1)*ns+i)=[zz(i,:);zz(i+1,:);zc];
end
xt(:,(1:nf)*ns)=[xx(ns,:);xx(1,:);xc];
yt(:,(1:nf)*ns)=[yy(ns,:);yy(1,:);yc];
zt(:,(1:nf)*ns)=[zz(ns,:);zz(1,:);zc];
zt(:,(1:nf)*ns)=[zz(ns,:);zz(1,:);zc];

if (lhs==4 | lhs==1) & rhs==4 then 
  if size(cc,1)==1 then
    ct=zeros(1,ns*nf);
    for i=1:ns
      ct((0:nf-1)*ns+i)=cc;
    end
  end
  if size(cc,1)==ns then
    ct=xt;
    for i=1:ns-1
      ct(:,(0:nf-1)*ns+i)=[cc(i,:);cc(i+1,:);ccc]; 
    end
    ct(:,(1:nf)*ns)=[cc(ns,:);cc(1,:);ccc];
  end
end

//elimination of null triangles (typical occurrences: from the
// splitting of quadrangles with two coincident points, e.g. poles
// of spheres, tips of arrows)
q=find(~(..
       (abs(xt(1,:)-xt(2,:))<%eps & abs(yt(1,:)-yt(2,:))<%eps..
                                  & abs(zt(1,:)-zt(2,:))<%eps) | ..
       (abs(xt(1,:)-xt(3,:))<%eps & abs(yt(1,:)-yt(3,:))<%eps..
                                  & abs(zt(1,:)-zt(3,:))<%eps) | ..
       (abs(xt(3,:)-xt(2,:))<%eps & abs(yt(3,:)-yt(2,:))<%eps..
                                  & abs(zt(3,:)-zt(2,:))<%eps) ) ..
        );
xt=xt(:,q); yt=yt(:,q); zt=zt(:,q);
if isdef('ct') then ct=ct(:,q); end

//list output form for oplot3d
if lhs==1 then
  if ~isdef('ct') then ct=ones(1,ns*nf); end
  xt=list(xt,yt,zt,ct,1)
end

endfunction
