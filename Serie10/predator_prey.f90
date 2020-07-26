program predatorPrey
    implicit none

    real(8) :: alpha,beta,lambda,delta,gamma,mu,x0,y0, time, kappa, N, dt, T, t0
    integer :: i, steps
    real(8), allocatable :: result_pred(:), result_prey(:), timeArray(:)


    namelist /model_parameters/ alpha, beta, gamma, delta, lambda, mu
    namelist /spatial_parameters/ kappa, N 
    namelist /time_parameters/ t0, T, dt

    open(unit = 12, file = 'predatorprey.nml', action = 'read')

    read(unit = 12,nml = model_parameters)
    read(unit = 12,nml = spatial_parameters)
    read(unit = 12,nml = time_parameters)


    steps = (T - t0) / dt  ! = n

    allocate(result_prey(steps))
    allocate(result_pred(steps))
    allocate(timeArray(steps))
    x0 = 100
    y0 = 20



    time = t0
    result_prey(1) = x0
    result_pred(1) = y0
    timeArray(1) = time

    do i=2, steps
        time = time + dt
        timeArray(i) = time
        call euler_at_one_point(result_prey, result_pred, i, dt)
    enddo

    open(unit = 20, file = 'outfilePred.txt', status = 'replace', action = 'write')
    write(20, '(E20.6)') result_pred
    close(20)

    open(unit = 21, file = 'outfilePrey.txt', status = 'replace', action='write')
    write(21, '(E20.6)') result_prey
    close(21)

    open(unit = 22, file = 'outfileTime.txt', status = 'replace', action='write')
    write(22, '(E20.6)') timeArray
    close(22)


    deallocate(result_prey)
    deallocate(result_pred)
    deallocate(timeArray)

    contains   
        subroutine euler_at_one_point(result_prey, result_pred, i, deltaT)
            real(8), intent(INOUT) :: result_prey(:), result_pred(:) !Beidseitiger Informationsfluss, Aufrufende Programm Einheit <->  Funktion
            real(8), intent(IN) :: deltaT!Wert wird in der Funktion nicht verändert und es findet kein Rückfluss
            integer, intent(IN) :: i  !der Informationen in die aufrundende Programm Einheit statt 

            result_pred(i) = result_pred(i-1) + deltaT * (result_pred(i-1) + (deltaT/2) * result_pred(i-1) * & 
            & (delta * result_prey(i-1) - gamma - mu * result_pred(i-1))) * (delta * result_prey(i-1) - gamma - &
            & mu * (result_pred(i-1) + (deltaT/2) * result_pred(i-1) &
            & * (delta * result_prey(i-1) - gamma - mu * result_pred(i-1))))

            result_prey(i) = result_prey(i-1) + deltaT * (result_prey(i-1) + (deltaT/2) * result_prey(i-1) * &
            & (alpha - beta * result_pred(i-1) - lambda * result_prey(i-1))) * (alpha - beta * result_pred(i-1) &
            & - lambda  * (result_prey(i-1) + (deltaT/2) * result_prey(i-1) * (alpha - beta * result_pred(i-1) &
            & - lambda * result_prey(i-1))))     
        end subroutine

end program predatorPrey