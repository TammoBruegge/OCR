program main
    
    implicit none
    
    real(8), allocatable :: DiffMat(:,:), values_pred(:), values_prey(:)
    real(8) :: a, b, l, d, g, m, maxT, deltaT, kappa, h, partitions1
    integer :: i, j, t0, steps, partitions

    a = 0.6 !Reproduktionsrate der Beute
    b = 0.03 !Fressrate der Räuber im Bezug auf die Beute
    l = 0 !negative soziale Interaktion der Beute
    d = 0.02 !Reproduktionsrate der Räuber im Bezug auf Beute
    g = 0.8 ! Sterberate der Räuber
    m = 0 !negative soziale Interaktion der Räuber


    kappa = 0.001 !Diffusionskonstante



    t0 = 0
    maxT = 45
    steps = 450000
    deltaT = (maxT - t0) / steps

    partitions = 5 !Anzahl Räumliche Dimensionen
    partitions1 = partitions !Wir brauchen partitions1, weil partitions ein Integer sein muss aber bei der Berechnung von h
                             !wir ein Real benötigen, da sonst Rundungsfehler enstehen

    h = 1 / partitions1  !Da wir das Intervall von 0 bis 1 Räumlich partitionieren

    !Speicher allozieren
    allocate(DiffMat(partitions,partitions))

    allocate(values_prey(partitions))
    allocate(values_pred(partitions))


    !Diffusionsmatrix erstellen
    do j = 1, partitions
        do i = 1, partitions
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

    DiffMat = (kappa / (h*h)) * DiffMat !skalierte Diffusionsmatrix


    !Vektoren mit den Anfangsvektoren
    values_prey = (/100, 90, 110, 80, 103/)
    values_pred = (/20, 10, 15, 25, 22/)


    !timeloop
    do i = 2, steps + 1
        call euler(values_prey, values_pred, deltaT)
    enddo

    open(unit=12, file='values_prey.txt', status='replace', action='write')
    write(12, '(E20.6)') values_prey
    close(unit=12)

    open(unit=13, file='values_pred.txt', status='replace', action='write')
    write(13, '(E20.6)') values_pred
    close(unit=13)
    
    deallocate(values_prey)
    deallocate(values_pred)
    deallocate(DiffMat)


    
    contains
    subroutine euler(values_prey, values_pred,deltaT)
        real(8), intent(INOUT) :: values_prey(:), values_pred(:) !Beidseitiger Informationsfluss, Aufrufende Programmeinheit <->  Funktion
        real(8), intent(IN) :: deltaT  !Wert wird in der Funktion nicht verändert und es findet kein Rückfluss
                                       !der Informationen in die aufrufende Programmeinheit statt
        real(8), allocatable :: temp_array(:)  !Temp_array benutzen wir, damit die Änderung beider Bestände gleichzeitig in Kraft treten
                                               !und sich nicht gegenseitig beeinflussen
        allocate(temp_array(steps))

        temp_array = values_prey 

        values_prey = values_prey + deltaT * (MATMUL(DiffMat, values_prey) + values_prey * (a - b * values_pred - l * values_prey))

        values_pred = values_pred + deltaT * (MATMUL(DiffMat, values_pred) + values_pred * (d * temp_array - g - m * values_pred))

        deallocate(temp_array)
    end subroutine

end program main