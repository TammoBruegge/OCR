program predatorPrey
    implicit none
    real(8) :: a, b, l, d, g, m, x0, y0, deltaT, maxT
    integer :: i, t0, steps
    real(8), allocatable :: result_pred(:), result_prey(:), timeArray(:)

    a = 0.6 !Reproduktionsrate der Beute
    b = 0.03 !Fressrate der Räuber im Bezug auf die Beute
    l = 0 !negative soziale Interaktion der Beute
    d = 0.02 !Reproduktionsrate der Räuber im Bezug auf Beute
    g = 0.8 ! Sterberate der Räuber
    m = 0 !negative soziale Interaktion der Räuber
    x0 = 100 !preys
    y0 = 20 ! predators
    
    t0 = 0
    maxT = 45
    steps = 4500
    deltaT = (maxT - t0) / steps


    allocate(result_prey(steps + 1))
    allocate(result_pred(steps + 1))
    allocate(timeArray(steps + 1))

    result_prey(1) = x0
    result_pred(1) = y0
    timeArray(1) = t0

    !Time-Loop
    do i = 2, steps + 1
        timeArray(i) = timeArray(i-1) + deltaT
        call euler(result_prey, result_pred, i, deltaT)
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
        subroutine euler(result_prey, result_pred, i, deltaT) !subroutine ist eine Funktion ohne Return Type (Void Funktion) Hier benötigt, da wir 2
                                                              !Arrays zurückgeben wollen (sonst als Matrix möglich)
            real(8), intent(INOUT) :: result_prey(:), result_pred(:) !Beidseitiger Informationsfluss, Aufrufende Programmeinheit <->  Funktion
            real(8), intent(IN) :: deltaT !Wert wird in der Funktion nicht verändert und es findet kein Rückfluss
            integer, intent(IN) :: i      !der Informationen in die aufrufende Programmeinheit statt 
            result_prey(i) = result_prey(i-1) + deltaT * (result_prey(i-1) * (a-b * result_pred(i-1) - l * result_prey(i-1)))
            result_pred(i) = result_pred(i-1) + deltaT * (result_pred(i-1) * (d * result_prey(i-1) - g - m * result_pred(i-1)))
        end subroutine


end program predatorPrey