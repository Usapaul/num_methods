program diffur
use funs

implicit none
integer :: n, i
real(mp) :: h, kap1, nu1, kap2, nu2, r, z
real(mp), allocatable :: Y(:), X(:), P(:), Q(:), F(:)
real(mp), allocatable :: kf(:,:), U(:), V(:)
character(10) :: nchar
!---------------------------------------
call getarg(1,nchar)
read(nchar,'(i8)') n
h=(b-a)/n
allocate (Y(0:n), X(0:n), P(0:n), Q(0:n), F(0:n))
forall (i=0:n) X(i)=a+i*h
forall (i=0:n)
    P(i)=Pfun(X(i))
    Q(i)=Qfun(X(i))
    F(i)=Ffun(X(i))
end forall
!---------------------------------------
r=(4.0_mp-2.0_mp*(2.0_mp-Q(1)*h**2)/(2.0_mp+P(1)*h))*alp2
z=2.0_mp*alp1*h-3.0_mp*alp2-alp2*(P(1)*h-2.0_mp)/(2.0_mp+P(1)*h)
kap1=-r/z
nu1=(2.0_mp*h*Abig+2.0_mp*alp2*F(1)*h**2/(2.0_mp+P(1)*h))/z

r=(-4.0_mp+2.0_mp*(2.0_mp-Q(n-1)*h**2)/(2.0_mp-P(n-1)*h))*bet2
z=2.0_mp*bet1*h+3.0_mp*bet2-bet2*(2.0_mp+P(n-1)*h)/(2.0_mp-P(n-1)*h)
kap2=-r/z
nu2=(2.0_mp*h*Bbig-2.0_mp*bet2*F(n-1)*h**2/(2.0_mp-P(n-1)*h))/z
!---------------------------------------
allocate (kf(4,1:n-1), U(0:n-1), V(0:n-1))
forall (i=1:n-1)
    kf(1,i)=1.0_mp+h/2.0_mp*P(i)
    kf(2,i)=2.0_mp-h**2*Q(i)
    kf(3,i)=1.0_mp-h/2.0_mp*P(i)
    kf(4,i)=h**2*F(i)
end forall
!---------------------------------------
U(0)=kap1; V(0)=nu1
do i=1,n-1
    U(i)=kf(1,i)/(kf(2,i)-kf(3,i)*U(i-1))
    V(i)=(kf(3,i)*V(i-1)-kf(4,i))/(kf(2,i)-kf(3,i)*U(i-1))
enddo
!---------------------------------------
Y(n)=(-kap2*V(n-1)-nu2)/(kap2*U(n-1)-1.0_mp)
do i=n-1,0,-1
    Y(i)=U(i)*Y(i+1)+V(i)
enddo
!---------------------------------------
open(777,file='yyy.dat')
    do i=0,n
        write(777,*) X(i), Y(i)
    enddo
close(777)

end program diffur

