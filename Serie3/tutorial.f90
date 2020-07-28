program tutorial
    implicit none
    real(8), allocatable :: A(:,:), x(:), result(:), result2(:)
    integer :: n, i, j
    real(8) :: t1, t2, t3, t4

    n = 1000

    allocate(A(n,n))
    allocate(x(n))
    allocate(result(n))

    call random_number(A)
    call random_number(x)

    result = 0

    call cpu_time(t1)
    do i=1, n
        do j=1, n
            result(i) = result(i) + (A(i,j) * x(j))
        enddo
    enddo
    call cpu_time(t2)


    call cpu_time(t3)
        result2 = matmul(A,x)
    call cpu_time(t4)


    write(*,*) 'cputime selfmade matMul= ', t2-t1 !4.6689E-003
    write(*,*) 'cputime predefined matMul= ', t4-t3 !1.1590E-003

    deallocate(A)
    deallocate(x)
    deallocate(result)

end program tutorial
