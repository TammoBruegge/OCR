program main
    use mod_precision
    use omp_lib

    implicit none

    
    real(kind=wp), allocatable :: D(:,:), x0(:), y0(:), DiffMat(:,:)
    real(kind=wp) :: alpha,beta,lambda,delta,gamma,mu, T, dt, kappa, h, t0
    real(4) :: t1, t2
    integer :: i,j,steps, N, k
    real(kind=wp), allocatable :: values_pred(:), values_prey(:)
    logical :: diff
    


    namelist /model_parameters/ alpha, beta, gamma, delta, lambda, mu
    namelist /spatial_parameters/ kappa, N 
    namelist /time_parameters/ t0, T, dt

    open(unit = 12, file = 'predatorprey.nml', action = 'read')

    read(unit = 12,nml = model_parameters)
    read(unit = 12,nml = spatial_parameters)
    read(unit = 12,nml = time_parameters)


    diff = .true.!1 für Diffusion, andere Zahl für keine Diffusion


    steps = (T - t0) / dt  ! = n

    if(steps < int(2*N*N*kappa*T)) then
        steps = int(2*N*N*kappa*T)
    endif

    h = 1 / dble(N)


    !Diffusions Matrix
    allocate(DiffMat(N,N))
    allocate(D(N,N))

    allocate(x0(N))
    allocate(y0(N))

    allocate(values_prey(N))
    allocate(values_pred(N))


    if(diff .eqv. .true.) then

        do j = 1, N
            do i = 1, N
                if((i == j) .and. (i == 1 .or. i == N)) then
                    DiffMat(i,j) = -1
                else if (i == j) then
                    DiffMat(i,j) = -2
                else if(i == j-1 .or. i == j+1) then
                    DiffMat(i,j) = 1
                else
                    DiffMat(i,j) = 0
                endif
            enddo
        enddo

        D = (kappa / (h * h))  * DiffMat


        call random_number(x0)
        call random_number(y0)
        values_prey = x0
        values_pred = y0


    
        t1 = omp_get_wtime()

        do i = 2, steps
            !call euler_at_one_point_diff_matmul(values_prey, values_pred, dt)
                   !call euler_at_one_point_diff_matmul_loop(values_prey, values_pred, dt)
            call euler_at_one_point_diff_selfmade(values_prey, values_pred, dt)
        enddo
        t2 = omp_get_wtime()

        write(*,*) t2-t1

        open(unit=12, file='values_prey.txt', status='replace', action='write')
        write(12, '(E20.6)') values_prey
        close(unit=12)

        open(unit=13, file='values_pred.txt', status='replace', action='write')
        write(13, '(E20.6)') values_pred
        close(unit=13)

    else
        call random_number(x0)
        call random_number(y0)
        values_prey = x0
        values_pred = y0

        t1 = omp_get_wtime()

        do i = 2, steps
          call euler_at_one_point(values_prey, values_pred, dt)
        enddo
        t2 = omp_get_wtime()

        write(*,*) t2-t1 

     end if

    open(unit=12, file='values_prey.txt', status='replace', action='write')
    write(12, '(E20.6)') values_prey
    close(unit=12)

    open(unit=13, file='values_pred.txt', status='replace', action='write')
    write(13, '(E20.6)') values_pred
    close(unit=13)
    
    deallocate(values_prey)
    deallocate(values_pred)
    deallocate(D)
    deallocate(DiffMat)
    deallocate(x0)
    deallocate(y0)

    
    contains
    subroutine euler_at_one_point_diff_selfmade(values_prey, values_pred,deltaT)
        real(kind=wp), intent(INOUT) :: values_prey(:), values_pred(:) !Beidseitiger Informationsfluss, Aufrufende Programm Einheit <->  Funktion
        real(kind=wp), intent(IN) :: deltaT!Wert wird in der Funktion nicht verändert und es findet kein Rückfluss
        !der Informationen in die aufrundende Programm Einheit statt
        real(kind=wp), allocatable :: temp_array(:), result_prey(:), result_pred(:)
        allocate(temp_array(N))
        allocate(result_prey(N))
        allocate(result_pred(N))

        result_prey = 0
        result_pred = 0

        temp_array = values_prey

        call omp_set_num_threads(8)
        !$omp parallel private(k)
            !$omp do
                do j=1,N
                    do i=1, N
                        result_prey(i) = result_prey(i) + (D(i,j) * values_prey(j))
                    enddo
                enddo
            !$omp end do
        !$omp end parallel            

        values_prey = values_prey + deltaT * (result_prey + values_prey * alpha - values_prey * beta * &
        & values_pred - values_prey * lambda * values_prey)

        call omp_set_num_threads(8)
        !$omp parallel private(k)
            !$omp do
                do j=1,N
                    do i=1, N
                        result_pred(i) = result_pred(i) + (D(i,j) * values_pred(j))
                    enddo
                enddo
            !$omp end do
        !$omp end parallel

        values_pred = values_pred + deltaT * (result_pred + values_pred * delta *  temp_array - values_pred * gamma - &
        & values_pred * mu * values_pred)

        deallocate(temp_array)
        deallocate(result_prey)
        deallocate(result_pred)
    end subroutine

    subroutine euler_at_one_point_diff_matmul(values_prey, values_pred,deltaT)
        real(kind=wp), intent(INOUT) :: values_prey(:), values_pred(:) !Beidseitiger Informationsfluss, Aufrufende Programm Einheit <->  Funktion
        real(kind=wp), intent(IN) :: deltaT!Wert wird in der Funktion nicht verändert und es findet kein Rückfluss
        !der Informationen in die aufrundende Programm Einheit statt
        real(kind=wp), allocatable :: temp_array(:)
        allocate(temp_array(N))

        temp_array = values_prey

        values_prey = values_prey + deltaT * ((MATMUL(D, values_prey) + values_prey * alpha - values_prey * beta * &
        & values_pred - values_prey * lambda * values_prey))

        values_pred = values_pred + deltaT * ((MATMUL(D, values_pred) + values_pred * delta *  temp_array - values_pred * gamma - &
        & values_pred * mu * values_pred))

        deallocate(temp_array)
    end subroutine

    subroutine euler_at_one_point_diff_matmul_loop(values_prey, values_pred,deltaT)
        real(kind=wp), intent(INOUT) :: values_prey(:), values_pred(:) !Beidseitiger Informationsfluss, Aufrufende Programm Einheit <->  Funktion
        real(kind=wp), intent(IN) :: deltaT!Wert wird in der Funktion nicht verändert und es findet kein Rückfluss
        !der Informationen in die aufrundende Programm Einheit statt
        real(kind=wp), allocatable :: temp_array(:), mat_prey(:), mat_pred(:)
        allocate(temp_array(N))
        allocate(mat_prey(N))
        allocate(mat_pred(N))

        temp_array = values_prey
        call omp_set_num_threads(8)
        !$omp parallel private(k)
            !$omp do
                do i=1,N 
                    mat_prey = MATMUL(D, values_prey)
                    values_prey(i) = values_prey(i) + deltaT * (mat_prey(i) + values_prey(i) * alpha &
                    & - values_prey(i) * beta * values_pred(i) - values_prey(i) * lambda * values_prey(i))

                    mat_pred = MATMUL(D, values_pred)
                    values_pred = values_pred(i) + deltaT * (mat_pred(i) + values_pred * delta & 
                    & * temp_array - values_pred(i) * gamma - values_pred(i) * mu * values_pred(i))
                enddo
            !$omp end do
        !$omp end parallel

        deallocate(temp_array)
    end subroutine

    subroutine euler_at_one_point(values_prey, values_pred,deltaT)
        real(kind=wp), intent(INOUT) :: values_prey(:), values_pred(:) !Beidseitiger Informationsfluss, Aufrufende Programm Einheit <->  Funktion
        real(kind=wp), intent(IN) :: deltaT!Wert wird in der Funktion nicht verändert und es findet kein Rückfluss
        !der Informationen in die aufrundende Programm Einheit statt
        real(kind=wp), allocatable :: temp_array(:)
        allocate(temp_array(N))

        temp_array = values_prey

        values_prey = values_prey + deltaT * (values_prey * alpha - values_prey * beta * &
        & values_pred - values_prey * lambda * values_prey)

        values_pred = values_pred + deltaT * (values_pred * delta *  temp_array - values_pred * gamma - &
        & values_pred * mu * values_pred)

        deallocate(temp_array)
    end subroutine

end program main
