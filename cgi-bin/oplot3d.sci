function oplot3d(data,nc,theta,alpha,leg,flag,ebox)

// data=list(xx1,yy1,zz1,c1,icontext1,xx2,yy2,zz2,c2,icontext2,...)
// nc vector of number of colors in the stack
// to make things easier to begin with, let's suppose that all
// the objects have facelets with the same number of sides

[lhs,rhs]=argn(0);

if ~exists('nc','local') then nc=xget('lastpattern'); end
// usually one wants to provide nc, this is a last resource escape
if ~exists('theta','local') then theta=45; end
if ~exists('alpha','local') then alpha=35; end
if ~exists('leg','local') then leg='X@Y@Z'; end
if ~exists('flag','local') then flag=[-1 2 4]'; end
if ~exists('ebox','local') then ebox=[0 0 0 1 1 1]'; end

if rhs==0 | type(data)<>15 then
 write(%io(2),..
  ' The first argument of oplot3d has to be a list of xx,yy,zz,c'+..
  ',icontext  tuples!')
 return
end

// scanning the argument "data" for valid entries
lobj=[]; nobj=0; nfj=[]; ncj=[]; ndata=length(data); j=1;
while j<=ndata
   if type(data(j))==15 then
      if length(data(j))==4 then data(j)(5)=1; end
      if length(data(j))<>5 then
         write(%io(2),..
            'graphic object #'+string(nobj+1)+' is a list, but not a 5-tuple!')
         return
      end
      nobj=nobj+1;
      lobj=[lobj,%t]
      nfj=[nfj,size(data(j)(1),1)]
      ncj=[ncj,size(data(j)(4),1)]
      j=j+1
   else
      if ndata < j+4 then
        write(%io(2),..
            'last graphic object is not a 5-tuple!')
        return
      end    
      if ~(type(data(j))==1 & type(data(j+1))==1 &..
           type(data(j+2))==1 & type(data(j+3))==1 &..
           type(data(j+4))==1) then
         write(%io(2),..
            'graphic object #'+string(nobj+1)+' is not a 5-tuple of reals!')
         return
      else          
        nobj=nobj+1;
        lobj=[lobj,%f]
        nfj=[nfj,size(data(j),1)]
        ncj=[ncj,size(data(j+3),1)]
        j=j+5
      end
   end
end

// find the maximum number of sides of all the faceted objects 
nf=max(nfj)
ncv=max(ncj)

a=or(ncj<>1 & ncj<>nfj) //workaround: if bug in CVS 22/11/04
if a then
 write(%io(2),..
  '  something wrong with the color arrays dimensions:')
  for k=1:nobj
    if ncj(k)<>1 & ncj(k)<>nfj(k) then
       write(%io(2),'object '+string(k)+' has facelets with '+..
            string(nfj(k))+' sides, but the color array has '+..
            string(ncj(k))+' corresponding entries')
    end
  end
 return
end

// Now we construct a single set xx,yy,zz,cc for all the objects.
// the number of vertices is augmented to nf if nf(j)<nf. This
// allows concatenation of xx,yy,zz; a little memory consuming,
// but easier to code than calling plot3d separately for each object
// Besides, a single call presents no visibility issues.
// One object with vertex colors will force all to have vertex colors.
xx=[];yy=xx;zz=xx;cc=xx;
j=1;
for k=1:nobj
  if lobj(k) then
    xx=[xx,data(j)(1)([1:nfj(k),nfj(k)*ones(1,nf-nfj(k))],:)]
    yy=[yy,data(j)(2)([1:nfj(k),nfj(k)*ones(1,nf-nfj(k))],:)]
    zz=[zz,data(j)(3)([1:nfj(k),nfj(k)*ones(1,nf-nfj(k))],:)]
    ic=min(max(data(j)(5),1),length(nc))
    cc=[cc,data(j)(4)([1:ncj(k),ncj(k)*ones(1,nf-ncj(k))],:)..
       *(nc(ic)-1)+sum(nc(1:(ic-1)))+1]
    j=j+1
  else
    xx=[xx,data(j)([1:nfj(k),nfj(k)*ones(1,nf-nfj(k))],:)]
    yy=[yy,data(j+1)([1:nfj(k),nfj(k)*ones(1,nf-nfj(k))],:)]
    zz=[zz,data(j+2)([1:nfj(k),nfj(k)*ones(1,nf-nfj(k))],:)]
    ic=min(max(data(j+4),1),length(nc))
    cc=[cc,data(j+3)([1:ncj(k),ncj(k)*ones(1,nf-ncj(k))],:)..
        *(nc(ic)-1)+sum(nc(1:(ic-1)))+1]
    j=j+5
  end
end

clear data  // it still occupies memory, not needed any more

plot3d1(xx,yy,list(zz,cc),theta,alpha,leg,flag,ebox)

endfunction
