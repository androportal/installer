function polarplot(a,i)
//
// draws a polar plot of the lines of a
//  orientation is that of the rose-of-winds: first element
//  is N, angles increase clockwise to NNO-N.
//
// sintax: polarplot(a[,i])
// i can be a scalar or a vector of styles
//
// seems to crash scilab if a contains a %nan
//
[lhs,rhs]=argn(0)
if rhs==1 then i=-1;end
if rhs==0 then
   write(%io(2),'Demo of polarplot')
   a=ones(8,1)*sin((0:63)*6*%pi/64+%pi/2)+0.3*(8:-1:1)'*ones(1,64); 
   i=2:9;
end

[xi,m,np]=graduate(0,max(a));
n=size(a,2);
if length(i)==1 then i=i*ones(1,n);end 

plot2d([-m,m],[-m,m],0,'040')

angolo=-(0:n-1)*2*%pi/n +%pi/2
r=[cos(angolo);sin(angolo)];

for k=1:size(a,1)
  xset("pattern",i(k));
  if i(k)>0 then xfpoly(a(k,:).*r(1,:),a(k,:).*r(2,:),1); end
  xset("pattern",1);
  if i(k)>0 then t=1; else t=-i(k); end
  xset("thickness",2)
  xpolys([a(k,:).*r(1,:),a(k,1)*r(1,1)]',...
     [a(k,:).*r(2,:),a(k,1)*r(2,1)]',t);
  xset("thickness",1)
end

// grid & legends

xsegs([-m,0;m,0],[0,-m;0,m])
arc=zeros(6,np);arc(1,:)=-(m/np:m/np:m); arc(2,:)=-arc(1,:);
arc(3,:)=-2*arc(1,:);arc(4,:)=arc(3,:); arc(6,:)=64*360*ones(1,np);
xarcs(arc,ones(1,np))
for i=1:np;
  xstring(i*m/(sqrt(2)*np),i*m/(sqrt(2)*np),string(i*m/np));
end
xstring(m+m/np,0,'E');xstring(-m-m/np,0,'O');
xstring(0,m,'N');xstring(0,-m-m/np,'S');

endfunction



