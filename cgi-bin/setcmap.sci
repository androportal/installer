function nc=setcmap(i,nc,r)
//
// syntax:  setcmap(i,nc,r),  setcmap(i,nc),  setcmap(i)
//
//  i : index of my predefined colormaps
//      the list is printed if i is out of range
//      Negative i gives the complementar colormap
//  nc: number of colors - useful for limited monitors
//      or private colormaps - 32 gives good results
//  r:  the window is redrawn afterwards if r<>0
//      The results are poor if nc has been changed
//
[rhs,lhs]=argn(0);
if lhs==0 then r=0; nc=xget("lastpattern"); i=9999; end
if lhs==1 then r=0; nc=int(xget("lastpattern")/length(i)); end
if lhs==2 then r=0; end
if nc<0 then nc=32; end

i=matrix(i,length(i),1)
//nc=[matrix(nc,length(nc),1);nc($)*ones(length(i)-length(nc),1)]
//would be nice, but as the function is written now, nc has to be a
// scalar

// Here are some colormaps: (crooked way to define them indeed -
//  but it was the first one I figured out long ago -
k=1;
cname(k)='BlackWhite';
     execstr(cname(k)+"=linspace(0,1,nc)''*[1,1,1];") 
k=k+1;
cname(k)='Fluorescine'; 
    execstr(cname(k)+"=[((1:nc).^2)/nc;1:nc;((1:nc).^2)/nc]''/nc;") 
k=k+1;
cname(k)='Caramel'; 
     execstr(cname(k)+"=[(0:nc-1).^0.67*nc^0.33;1:nc;...
    ((1:nc).^3)/nc^2]''/nc;") 
k=k+1;
cname(k)='Cappuccino'; execstr(cname(k)+"=...
   [(0:nc-1).^0.8*nc^0.2;(1:nc).^2/nc;((1:nc).^3)/nc^2]''/nc;") 
k=k+1;
cname(k)='Chocolate'; execstr(cname(k)+"=...
   [(0:nc-1).^0.8*nc^0.2;(1:nc).^2/nc;sin(3*%pi*(1:nc)/nc)/2+1]''/nc;") 
k=k+1;
cname(k)='Hot'; execstr(cname(k)+"=...
  [min(1,max((2*(1:nc)/nc),0));...
   min(1,max((2.5*(1:nc)/nc)-1,0));...
   min(1,max((3*(1:nc)/nc)-2,0))]'';") 
k=k+1;
cname(k)='Hot2';
// this is copied from hotcolormap of scilab 2.4.1
 execstr(cname(k)+"=...
   [(1:fix(3/8*nc))''/fix(3/8*nc)  zeros(fix(3/8*nc),1) ...
                                         zeros(fix(3/8*nc),1); ...
    ones(fix(3/8*nc),1)  (1:fix(3/8*nc))''/fix(3/8*nc)  ...
                                         zeros(fix(3/8*nc),1); ...
    ones((nc-2*fix(3/8*nc)),1)  ones((nc-2*fix(3/8*nc)),1)  ...
           (1:(nc-2*fix(3/8*nc)))''/(nc-2*fix(3/8*nc))];")
k=k+1;
cname(k)='BluRed'; execstr(cname(k)+"=[1:nc;0*(1:nc);nc:-1:1]''/nc") 
k=k+1;
cname(k)='LightBlueRed';execstr(cname(k)+"=[1:nc;nc:-1:1;nc:-1:1]''/nc;") 
k=k+1;
cname(k)='Sunrise'; execstr(cname(k)+..    
    "=[[zeros(1,nc-floor(nc/4)-floor(nc/2)),...
      linspace(1,nc,floor(nc/4))./nc,ones(1,floor(nc/2))]'',..
       [linspace(0,1,ceil(nc/2)),linspace(1,0,floor(nc/2))]'',..
       [ones(1,floor(nc/2)),linspace(nc,1,floor(nc/4))./nc,...
         zeros(1,nc-floor(nc/2)-floor(nc/4))]''];;")
k=k+1;
cname(k)='BluBlackRed'; 
  execstr(cname(k)+"=[zeros(1,ceil(nc/2)),linspace(1,nc,floor(nc/2));...
  zeros(1,nc);linspace(nc,1,floor(nc/2)),zeros(1,ceil(nc/2))]''/nc;") 
k=k+1;
cname(k)='BluBlackRed_II';execstr(cname(k)+"=sqrt(BluBlackRed);")
k=k+1;
cname(k)='BluGreenRed'; 
  execstr(cname(k)+"=[zeros(1,ceil(nc/2)),linspace(1,nc,floor(nc/2));..
        zeros(1,floor(nc/4)),linspace(1,nc,floor(nc/4)),...
        linspace(nc,0,nc-3*floor(nc/4)),zeros(1,floor(nc/4));...
        linspace(nc,1,floor(nc/2)),zeros(1,ceil(nc/2))]''/nc;") 
k=k+1;
cname(k)='BluGreenRed_II'; 
  
execstr(cname(k)+"=[zeros(1,floor(nc/2)),..
                    linspace(1,nc,ceil(nc/2));...
      linspace(0,nc,ceil(nc/2)),linspace(nc,0,floor(nc/2));...
      linspace(nc,0,ceil(nc/2)),zeros(1,floor(nc/2))]''/nc;") 
k=k+1;
cname(k)='BluGreenRed_III'; execstr(cname(k)+"=[1:nc;...
        linspace(0,nc,floor(nc/2)),linspace(nc,0,ceil(nc/2))...
        ;nc:-1:1]''/nc;") 
k=k+1;
cname(k)='Prism'; execstr(cname(k)+"=...
  [ sin((linspace(2,2*nc,nc)+2.*nc/3)*%pi/nc);...
    sin((linspace(2,2*nc,nc)-2.*nc/3)*%pi/nc);...
    sin((linspace(2,2*nc,nc))*%pi/nc)]''/2+1./2;") 
k=k+1;
cname(k)='Prism_II'; execstr(cname(k)+"=Prism.^(1/2)'';")
k=k+1;
cname(k)='Bands'; execstr(cname(k)+"=...
   [1:nc;nc:-1:1;nc*((-sin(15*%pi*(1:nc)/nc)+1)/2)]''/nc;") 
k=k+1;
cname(k)='BlackBands'; execstr(cname(k)+"=...
   ([sin((linspace(2,2*nc,nc)+2.*nc/3)*%pi/nc);...
     sin((linspace(2,2*nc,nc)-2.*nc/3)*%pi/nc);...
     sin((linspace(2,2*nc,nc))*%pi/nc)]''/2+1./2)...
    .*modulo([1:nc;1:nc;1:nc]''-1,nc/8)*7/nc;") 

if lhs==0 then
// demo - interactive choice of colormaps
  currwin=xget('window')
  a=winsid(); xset('window',a($)+1); // note that if a=[], a+1=1
  xset("default")
  c0=xget("colormap");
  setcmap(-k:-1,nc); cmap=[xget("colormap");c0]
  setcmap(1:k,nc); cmap=[cmap;xget("colormap")]
  xset("colormap",cmap)
  drawlater
  for j=-k:k;
    subwind(j+k+1,2*k+1,1);
    select [j<0 j>0]
    case [%t %f]
      Matplot([(nc:-1:1);(nc:-1:1)]'+(j+k)*nc,'011',...
        [1,1,2,nc],[0,0,0,0])
      xstring(1,-0.04*nc,string(j))
    case [%f %f]
      Matplot([(32:-1:1);(32:-1:1)]'+k*nc,'011',...
        [1,1,2,32],[0,0,0,0])
      xstring(1,-1.6,"0")
    case [%f %t]
      Matplot([(nc:-1:1);(nc:-1:1)]'+(j+k-1)*nc+32,'011',...
        [1,1,2,nc],[0,0,0,0])
      xstring(1,-0.04*nc,string(j))
    end
  end
  subwind(1,1,1)
  xtitle("All the colormaps at the current color depth ("+string(nc)+..
         " colors)")
  drawnow
  disp " "
  i=x_choose(string((-k:k)')+' '+..
   [cname(k:-1:1);'Scilab''s default';cname],..
           'Choose one colormap!','Forget!')-k-1
  xdel(a($)+1); xset('window',currwin); setcmap(i,nc,1)
  return
end


if i==0 then xset("default"); end
if abs(i)>k then 
  write(%io(2)," ")
  write(%io(2),"0 default graphic context")
  for j=1:k
   write(%io(2),string(j)+" "+cname(j));
  end
end  
if abs(i)>=1 & abs(i)<=k then 
  write(%io(2),string(i)+" "+cname(abs(i)))
  ccol=[];
  for j=1:length(i)
//    nc=ncv(j);    //for the future version
    execstr("ccol=[ccol;(sign(-i(j))+1)/2-sign(-i(j))*"+..
             cname(abs(i(j)))+"]"); 
  end
  xset('colormap',ccol)
  if r<>0 then write(%io(2),'redrawing...'); xbasr(xget("window")); end
end

nc=xget("lastpattern")
// reset and returned, just for consistency check

endfunction

