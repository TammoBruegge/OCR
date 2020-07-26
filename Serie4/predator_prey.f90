program main
    
    implicit none
    
    real(8), allocatable :: D(:,:), x0(:), y0(:), DiffMat(:,:)
    real(8) :: a,b,l,delta,g,m, maxT, deltaT, kappa, h, partitions1
    integer :: i,j,t0, steps, partitions

    real(8), allocatable :: values_pred(:), values_prey(:)

    a = 0.6 
    b = 0.03 
    l = 0
    delta = 0.02 !Reproduktionsrate der Räuber
    g = 0.8 ! Sterberate der Räuber
    m = 0

    kappa = 0.001



    maxT = 45
    steps = 450000

    partitions = 5 !Anzahl Räumliche Dimensionen
    partitions1 = partitions
    t0 = 0

    deltaT = maxT / steps
    h = 1 / partitions1

    !Diffusions Matrix
    allocate(DiffMat(partitions,partitions))
    allocate(D(partitions,partitions))

    allocate(x0(partitions))
    allocate(y0(partitions))

    allocate(values_prey(partitions))
    allocate(values_pred(partitions))


    do i = 1, partitions
        do j = 1, partitions
            if((i == j) .and. (i == 1 .or. i == partitions)) then
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

    D = (kappa / (h*h)) * DiffMat

  !  write(*,*) D(1,:)
  !  write(*,*) D(2,:)
  !  write(*,*) D(3,:)
  !  write(*,*) D(4,:)
  !  write(*,*) D(5,:)





   ! x0 = 100 !preys
   ! y0 = 20 ! predators

    x0 = (/100, 90, 110, 80, 103/)
    y0 = (/20, 10, 15, 25, 22/)

    
    values_prey = x0
    values_pred = y0


    do i = 2, steps
        call euler_at_one_point(values_prey, values_pred, deltaT)
    enddo

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
    subroutine euler_at_one_point(values_prey, values_pred,deltaT)
        real(8), intent(INOUT) :: values_prey(:), values_pred(:) !Beidseitiger Informationsfluss, Aufrufende Programm Einheit <->  Funktion
        real(8), intent(IN) :: deltaT!Wert wird in der Funktion nicht verändert und es findet kein Rückfluss
        !der Informationen in die aufrundende Programm Einheit statt
        real(8), allocatable :: temp_array(:)
        allocate(temp_array(steps))

        temp_array = values_prey

        values_prey = values_prey + deltaT * (MATMUL(D, values_prey) + values_prey * a - values_prey * b * &
        & values_pred - values_prey * l * values_prey)

        values_pred = values_pred + deltaT * (MATMUL(D, values_pred) + values_pred * delta *  temp_array - values_pred * g - &
        & values_pred * m * values_pred)

        deallocate(temp_array)
    end subroutine

end program main