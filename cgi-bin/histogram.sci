function  [x,h]=histogram(a,l,u,n)
// manca....
// sintassi: histogram(a,l,u,n)  histogram(a,l,u)  histogram(a,n)
//
[lhs,rhs]=argn(0)
if rhs==0 then
  //write(%io(2),['[x,h]=histogram(rand(1,10000));';'plot(x,h)'])
  [x,h]=histogram(rand(1,10000));
  xbasc();plot(x,h) 
  x=[];h=x;
  return
end
mina=min(a); maxa=max(a);
if rhs==3 then n=50; end
if rhs==2 then n=l; l=min(a),u=max(a); end
if rhs==1 then l=mina; u=maxa; n=50; end

h=zeros(n,1); hh=zeros(n+1,1);

x=l+((1:n)'-0.5)*(u-l)/n;
dx=(u-l)/n;
xl=l+(0:n)*dx; xu=xl+dx;

for i=1:n+1;
// this is faster
   if xl(i)>=mina then a=a(a>=xl(i)); end
   hh(i)=length(a)
end  
h=hh(1:$-1)-hh(2:$);

if lhs==1 then x=h; end         // comodita' per calls veloci

endfunction
