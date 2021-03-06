program predatorPrey
    implicit none

    real(8) :: alpha, beta, lambda, delta, gamma, mu, kappa, N, dt, T, t0, halfstep_prey, halfstep_pred
    integer :: i, steps
    real(8), allocatable :: result_prey(:), result_pred(:), timeArray(:)

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

    allocate(result_prey(steps + 1))
    allocate(result_pred(steps + 1))
    allocate(timeArray(steps + 1))

    !Initiale Werte setzen
    result_prey(1) = 100
    result_pred(1) = 20
    timeArray(1) = t0

    !timeloop
    do i = 2, steps + 1
        timeArray(i) = timeArray(i - 1) + dt
        call euler_at_one_point(result_prey, result_pred, i, dt)
    enddo

    !Ergebnisse zurückschreiben, wir brauchen hier jedoch nur das outfilePrey
    open(unit = 21, file = 'outfilePrey.txt', status = 'replace', action='write') ! 21 ist Idenfitifier
    write(21, '(E20.6)') result_prey!E steht für Real Numbers(Exponent Notation), 
    close(21)                       !die 20 für die Feldbreite und die 6 für die Anzahl der Nachkommastellen (fractional Part)


    deallocate(result_prey)
    deallocate(result_pred)
    deallocate(timeArray)

    contains   
        subroutine euler_at_one_point(result_prey, result_pred, i, deltaT)
            real(8), intent(INOUT) :: result_prey(:), result_pred(:) ! Beidseitiger Informationsfluss, Aufrufende Programmeinheit <->  Funktion
            real(8), intent(IN) :: deltaT ! Wert wird in der Funktion nicht verändert und es findet kein Rückfluss
            integer, intent(IN) :: i      ! der Informationen in die aufrundende Programmeinheit statt 
            
            halfstep_prey = result_prey(i-1) + (deltaT/2) * result_prey(i-1) * (alpha - beta * result_pred(i-1) &
            & - lambda * result_prey(i-1)) ! Halber Eulerstep 

            halfstep_pred = result_pred(i-1) + (deltaT/2) * result_pred(i-1) * (delta * result_prey(i-1) &
            & - gamma - mu * result_pred(i-1)) ! Halber Eulerstep

            
            result_prey(i) = result_prey(i-1) + deltaT * halfstep_prey * (alpha - beta * halfstep_pred &
            & - lambda  * halfstep_prey)  !Eulerstep mit Ableitung an halbem Schritt ausführen

            result_pred(i) = result_pred(i-1) + deltaT * halfstep_pred * (delta * halfstep_prey - gamma - &
            & mu * halfstep_pred)  !Eulerstep mit Ableitung an halbem Schritt ausführen

        end subroutine

end program predatorPrey
