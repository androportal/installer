function [xx,yy,zz]=spaghetti(x,y,z,w,nf)

[lhs,rhs]=argn(0);

if rhs==0 then
  disp('demo of spaghetti(x,y,z,w)');disp('');
  comm=[..
     'h=(-25:25)''/20; s=(tanh(h.^2/2)+1)/2; alpha=(-%pi:0.8:%pi);';..
     'nl=length(s); na=length(alpha);';..
     'x=zeros(nl,na); y=x; z=x; w=zeros(nl,3*na);';..
     'for i=1:na;';..
     '   phi=alpha(i);';..
     '   x(:,i)=s*cos(phi); y(:,i)=h; z(:,i)=s*sin(phi);';..
     'end';..
  'xbasc(); [xx,yy,zz]=spaghetti(x,y,z,0.08); shadesurf(xx,yy,zz,10);']
  write(%io(2),comm)
  execstr(comm)
  xtitle('demo for spaghetti()')
  xx=[];yy=[];zz=[];
  return
end

xx=[];

if rhs<5 then nf=11; end

if rhs<3 then 
    disp('spaghetti() wants one or more trajectories x,y,z !')
    return
end

if rhs==3 then w=(max(y)-min(y))/20; end  //just a given value

if size(x)~=size(y) | size(z)~=size(y) | size(x)~=size(z) then
   disp('inconsistency in x,y,z lengths')
   return
end

np=size(x,1); nv=size(x,2);
if np==1 then 
   disp('cannot make spaghetti of single points!')
   return
end

if size(w)==[1,np] then
  w=w'
end
if size(w)==[np,1] then
  w=w*ones(1,nv)
end

if size(w,1)<>np | size(w,2)<>nv then 
   w=w(1)*ones(np,nv);
end

if np==2 then
// "arrows3d" mode: I invent a middle point, so the following
//  assignments work
  x=[x(1,:); (x(1,:)+x(2,:))/2; x(2,:)];
  y=[y(1,:); (y(1,:)+y(2,:))/2; y(2,:)];
  z=[z(1,:); (z(1,:)+z(2,:))/2; z(2,:)];
  np=3
  w=[w(1,:);w]
end

fd=[cos(2*%pi*(1:nf)/nf);sin(2*%pi*(1:nf)/nf)]

xx=zeros(4,nf*np*nv); yy=xx; zz=yy;  // only (np-1)*nv tubelets, but
                                     // the last arrowhead requires
                                     // more facelets


for j=1:nv
//array of versors of the segments
   un=zeros(np-1,3);
   un=[x(2:np,j)-x(1:(np-1),j),y(2:np,j)-y(1:(np-1),j),..
       z(2:np,j)-z(1:(np-1),j)];
   nn=sqrt(sum(un.^2,'c')); 
// take care of possible coincident points: assign an un<>0
// even to those coincident
   isep=find(nn>10*%eps);
   if isep<>[] then   
// if all the points coincide, don't even try to mend anything
// (a division by 0 will result soon)
     un(1:(isep(1)-1),1)=un(isep(1),1);
     un(1:(isep(1)-1),2)=un(isep(1),2);
     un(1:(isep(1)-1),3)=un(isep(1),3);
     nn(1:(isep(1)-1))=nn(isep(1))
//so if the first points were coincident, they take the un of their
//  followers
   else
     write(%io(2),"all the points of line "+string(j)+" coincide!")
     break
   end
// now each nn=0 has for sure a predecessor <>0
   for i=find(nn<=10*%eps); 
     un(i,:)=un(i-1,:); nn(i)=nn(i-1);
   end
// the loop above is not vectorizable! Feedback! 
   nn=[nn,nn,nn];
   un=un./nn;
//compute 2 local normals to each point of the trail
 //intermediate points: first normal=bisectrix of the vertex
   N1=zeros(np,3);
   N1(2:(np-1),:)=un(1:(np-2),:)-un(2:(np-1),:); 
 //extremes: equal that at the next (previous) point
   N1(1,:)=-N1(2,:); N1(np,:)=N1(np-1,:);
//really no idea of why N1(1,:)=-N1(2,:) with minus, but solves a bug.
 //now, we could have N1(:,i)=[0;0;0] either for coincident
 // points or for colinear segments. Let's take care of it.
 // We cannot just set N1 to an arbitrary direction, because
 //  that could be too different from its neighbor.
   nN1=sqrt(sum(N1.^2,'c'));
   if find(abs(nN1)>10*%eps)==[] then
 //if _all_ the points are colinear (this can happen in arrow mode)
      if find(abs(un(:,1))>10*%eps | abs(un(:,2))>10*%eps)==[] then
   //if the whole trail is parallel to the z axis
         N1=[ones(np,1),zeros(np,2)]
      else
         N1(2:np,:)=[un(:,2),-un(:,1),zeros(np-1,1)]       
   //this is for sure perpendicular to un 
         N1(1,:)=N1(2,:); N1(np,:)=N1(np-1,:);
      end
      nN1=sqrt(sum(N1.^2,'c')); // recalculate for the points which
                               // have been taken care of
   else
  //now, if not all points are colinear, lets put the missing N1s
  // (for those which are still colinear). Let's start from the
  // beginning of the trail:
     ibent=find(nN1>10*%eps);
     N1(1:(ibent(1)-1),1)=N1(ibent(1),1);
     N1(1:(ibent(1)-1),2)=N1(ibent(1),2);
     N1(1:(ibent(1)-1),3)=N1(ibent(1),3);
     nN1(1:(ibent(1)-1))=nN1(ibent(1))
  // now each N1=0 has for sure a predecessor <>0
     for i=find(nN1<=10*%eps);
       N1(i,:)=N1(i-1,:); nN1(i)=nN1(i-1);
     end
 // still one thing to do - if the trail is even a little zigzag,
 //  neighboring points can have almost opposite N1. Let's flip
 //  those which have a negative projection on their predecessor
     P1=sign(N1(1:(np-1),1).*N1(2:np,1)+N1(1:(np-1),2).*N1(2:np,2)+..
              N1(1:(np-1),3).*N1(2:np,3))
     iflip=find(cumprod(P1)<0)+1    // I'm really clever!
     N1(iflip,:)=-N1(iflip,:)
   end
//normalization
   N1=N1./[nN1,nN1,nN1];
 //intermediate points: second normal=binormal to the previous
   N2=zeros(np,3);
   N2(2:(np-1),1)=un(1:(np-2),2).*N1(2:(np-1),3)-..
                   un(1:(np-2),3).*N1(2:(np-1),2);
   N2(2:(np-1),2)=un(1:(np-2),3).*N1(2:(np-1),1)-..
                   un(1:(np-2),1).*N1(2:(np-1),3);
   N2(2:(np-1),3)=un(1:(np-2),1).*N1(2:(np-1),2)-..
                   un(1:(np-2),2).*N1(2:(np-1),1);   
 //extremes: equal that at the next (previous) point
   N2(1,:)=N2(2,:); N2(np,:)=N2(np-1,:);
 //normalization
   nN1=sqrt(sum(N2.^2,'c'));
   nN1(find(abs(nN1)<%eps))=1;
   N2=N2./[nN1,nN1,nN1];
//Sometimes the intrinsic twist of the line is such, that it is better
// to further rotate N1 and N2 of an integer number of quarter of turns
// around their commom normal, i.e. send (N1,N2) --> (+-N2,+-N1)
// in order to minimize the angles between corresponding normals of
// neighboring points. This should be done here.

// TO DO

//generate a vector of vertices of the facelet, still to sort
   xt=zeros(np,nf); yt=xt; zt=yt; 
   for k=1:nf  // could I vectorize this?
     xt(:,k)=x(:,j)+(N1(:,1)*fd(1,k)+N2(:,1)*fd(2,k)).*w(:,j)
     yt(:,k)=y(:,j)+(N1(:,2)*fd(1,k)+N2(:,2)*fd(2,k)).*w(:,j)
     zt(:,k)=z(:,j)+(N1(:,3)*fd(1,k)+N2(:,3)*fd(2,k)).*w(:,j)
   end
// generate the faces of the tube
   k1=1:nf; k2=[2:nf,1]; np2=1:(np-2); np2f=(np-2)*nf;
   xx(:,(j-1)*np*nf+(1:(np-2)*nf))=..
      [matrix(xt(np2,k1),1,np2f);matrix(xt(np2+1,k1),1,np2f);..
       matrix(xt(np2+1,k2),1,np2f);matrix(xt(np2,k2),1,np2f)] 
   yy(:,(j-1)*np*nf+(1:(np-2)*nf))=..
      [matrix(yt(np2,k1),1,np2f);matrix(yt(np2+1,k1),1,np2f);..
       matrix(yt(np2+1,k2),1,np2f);matrix(yt(np2,k2),1,np2f)] 
   zz(:,(j-1)*np*nf+(1:(np-2)*nf))=..
      [matrix(zt(np2,k1),1,np2f);matrix(zt(np2+1,k1),1,np2f);..
       matrix(zt(np2+1,k2),1,np2f);matrix(zt(np2,k2),1,np2f)] 
// last segment: arrowhead
   np1=np-1; xc=zeros(1,nf); yc=xc; zc=yc; xp=yc; yp=yc; zp=yc;
   xc(k1)=-x(np1,j)+2*xt(np1,k1)
   yc(k1)=-y(np1,j)+2*yt(np1,k1)
   zc(k1)=-z(np1,j)+2*zt(np1,k1)
   xp(k1)=x(np,j)
   yp(k1)=y(np,j)
   zp(k1)=z(np,j)
   xx(:,(j-1)*np*nf+(((np-2)*nf+1):(np-1)*nf))=..
      [xt(np1,k1);xc(k1);xc(k2);xt(np1,k2)] 
   yy(:,(j-1)*np*nf+(((np-2)*nf+1):(np-1)*nf))=..
      [yt(np1,k1);yc(k1);yc(k2);yt(np1,k2)] 
   zz(:,(j-1)*np*nf+(((np-2)*nf+1):(np-1)*nf))=..
      [zt(np1,k1);zc(k1);zc(k2);zt(np1,k2)] 
   xx(:,(j-1)*np*nf+((np1*nf+1):np*nf))=..
      [xc(k2);xc(k1);xp(k1);xp(k2)] 
   yy(:,(j-1)*np*nf+((np1*nf+1):np*nf))=..
      [yc(k2);yc(k1);yp(k1);yp(k2)] 
   zz(:,(j-1)*np*nf+((np1*nf+1):np*nf))=..
      [zc(k2);zc(k1);zp(k1);zp(k2)] 
//note that only putting equal the 3rd and 4th point, my
// shadesurf works (trick)     
end
endfunction
