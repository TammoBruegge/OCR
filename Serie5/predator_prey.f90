program main
    use mod_precision
    implicit none
 

    
    real(kind = wp), allocatable :: DiffMat(:,:), values_pred(:), values_prey(:)
    real(kind = wp) :: alpha, beta, lambda, delta, gamma, mu, T, dt, kappa, h, t0, t1, t2
    integer :: i, j, steps, N


    !namelist-Gruppen definieren
    namelist /model_parameters/ alpha, beta, gamma, delta, lambda, mu
    namelist /spatial_parameters/ kappa, N 
    namelist /time_parameters/ t0, T, dt

    !namelist-Datei öffnen
    open(unit = 12, file = 'predatorprey.nml', action = 'read')

    !einzelne Gruppen auslesen
    read(unit = 12,nml = model_parameters)
    read(unit = 12,nml = spatial_parameters)
    read(unit = 12,nml = time_parameters)



    steps = (T - t0) / dt  ! = n

    !falls die Azahl der Schritte die gegebene Bedingung in Abhängigkeit von
    !Anzahl der Boxen, Diffusionskonstante und Endzeitpunkt nicht erfüllt, wird diese
    !manuell so gesetzt
    if(steps < int(2*N*N*kappa*T)) then
        steps = int(4*N*N*kappa*T)
        dt = (T-t0) / steps !Wenn Steps angepasst werden, müssen wir auch deltaT anpassen, da wir sonst über T hinaus laufen mit mehr Steps selber Größe
    endif

    h = 1 / dble(N) !Da wir das Intervall von 0 bis 1 Räumlich partitionieren hat eine Box die Breite h

    !Speicher allozieren
    allocate(DiffMat(N,N))
    allocate(values_prey(N))
    allocate(values_pred(N))

    !Diffusionsmatrix erstellen
    do j = 1, N
        do i = 1, N
            if((i == j) .and. (i == 1 .or. i == N)) then
                DiffMat(i,j) = -1
            else if (i == j) then
                DiffMat(i,j) = -2
            else if(i == j - 1 .or. i == j + 1) then
                DiffMat(i,j) = 1
            else
                DiffMat(i,j) = 0
            endif
        enddo
    enddo

    DiffMat = (kappa / (h * h))  * DiffMat !skalierte Diffusionsmatrix


    call random_number(values_prey) !random_number füllt das Array mit Zufälligen Zahlen zwischen 0 und 1
    call random_number(values_pred)


    !Timeloop
    call cpu_time(t1)
    do i = 2, steps + 1
        call euler_at_one_point(values_prey, values_pred, dt)
    enddo
    call cpu_time(t2)

    write(*,*) t2-t1 

    open(unit=12, file='values_prey.txt', status='replace', action='write')
    write(12, '(E20.6)') values_prey !E steht für Real Numbers(Exponent Notation), 
    close(unit=12)                   !die 20 für die Feldbreite und die 6 für die Anzahl der Nachkommastellen (fractional Part)

    open(unit=13, file='values_pred.txt', status='replace', action='write')
    write(13, '(E20.6)') values_pred
    close(unit=13)
    
    deallocate(values_prey)
    deallocate(values_pred)
    deallocate(DiffMat)


    
    contains
    subroutine euler_at_one_point(values_prey, values_pred, deltaT)
        real(kind=wp), intent(INOUT) :: values_prey(:), values_pred(:) !Beidseitiger Informationsfluss, Aufrufende Programmeinheit <->  Funktion
        real(kind=wp), intent(IN) :: deltaT  !Wert wird in der Funktion nicht verändert und es findet kein Rückfluss
                                             !der Informationen in die aufrufende Programmeinheit statt
        real(kind=wp), allocatable :: temp_array(:)  !Temp_array benutzen wir, damit die Änderung beider Bestände gleichzeitig in Kraft treten
                                                     !und sich nicht gegenseitig beeinflussen
        allocate(temp_array(N))
        temp_array = values_prey 

        values_prey = values_prey + deltaT * (MATMUL(DiffMat, values_prey) + values_prey * (alpha - beta * values_pred &
        & - lambda * values_prey))

        values_pred = values_pred + deltaT * (MATMUL(DiffMat, values_pred) + values_pred * (delta * temp_array - gamma &
        & - mu * values_pred))

        deallocate(temp_array)
    end subroutine

end program main

