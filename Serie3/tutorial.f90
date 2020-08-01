program tutorial
    implicit none
    real(8), allocatable :: A(:,:), x(:), result(:), result2(:)
    integer :: n, i, j
    real(8) :: t1, t2, t3, t4, sum

    n = 1000

    allocate(A(n,n))
    allocate(x(n))
    allocate(result(n))

    call random_number(A)
    call random_number(x)

    result = 0

    call cpu_time(t1)
    do j = 1, n
        do i = 1, n
            result(i) = result(i) + (A(i,j) * x(j))
        enddo
    enddo
    call cpu_time(t2)

    ! write(*,*) result(1001) ! -fbounds-check schmeißt Fehler beim Ausführen der .exe
    !At line 26 of file tutorial.f90
    !Fortran runtime error: Index '1001' of dimension 1 of array 'result' above upper bound of 1000


    call cpu_time(t3)
        result2 = matmul(A,x)
    call cpu_time(t4)
    
    sum = 0
    

    write(*,*) 'cputime selfmade matMul= ', t2-t1 !4.6689E-003
    write(*,*) 'cputime predefined matMul= ', t4-t3 !1.1590E-003

    deallocate(A)
    deallocate(x)
    deallocate(result)

end program tutorial
