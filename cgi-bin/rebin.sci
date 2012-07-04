function an=rebin(xn,yn,x,y,a,sedge)
//
// Given the matrix a(x,y), it rebins it on the new grid as an(xn,yn).
//  the function interp2, which treats the matrix as doubly periodic,
//  is used.
[lhs,rhs]=argn(0)
if rhs==0 then
  write(%io(2),['xn=1:.1:8; yn=-1:.1:3;'
      'an=rebin(xn,yn,1:3,1:3,5*rand(3,3));'
      'plot3d1(xn,yn,an)'])
   xn=1:.1:8; yn=-1:.1:3;
   an=rebin(xn,yn,1:3,1:3,5*rand(3,3))
   xbasc();plot3d1(xn,yn,an)
  return
end

if rhs<6 then sedge='per'; end                                                   

nxn=length(xn);nyn=length(yn);
xy= [ matrix(ones(nyn,1)*matrix(xn,1,nxn),nxn*nyn,1), ...
     matrix(matrix(yn,nyn,1)*ones(1,nxn),nxn*nyn,1)];
an=interp2(xy,x,y,a,sedge)';
an=matrix(an,nyn,nxn)';

endfunction
