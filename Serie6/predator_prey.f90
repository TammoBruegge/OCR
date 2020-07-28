program main
    use mod_precision
    use omp_lib

    implicit none

    
    real(kind=wp), allocatable :: DiffMat(:,:), values_pred(:), values_prey(:)
    real(kind=wp) :: alpha, beta, lambda, delta, gamma, mu, T, dt, kappa, h, t0
    real(4) :: t1, t2
    integer :: i, j, steps, N, k

    logical :: diff !logical sind .true. oder .false.
    

    !namelist Gruppen definieren
    namelist /model_parameters/ alpha, beta, gamma, delta, lambda, mu
    namelist /spatial_parameters/ kappa, N 
    namelist /time_parameters/ t0, T, dt

    !namelist Datei öffnen
    open(unit = 12, file = 'predatorprey.nml', action = 'read')

    !einzelne Gruppen auslesen
    read(unit = 12,nml = model_parameters)
    read(unit = 12,nml = spatial_parameters)
    read(unit = 12,nml = time_parameters)


    diff = .true.


    steps = (T - t0) / dt  ! = n

    !falls die Azahl der Schritte die gegebene Bedingung in Abhängigkeit von
    !Anzahl der Boxen, Diffusionskonstante und Endzeitpunkt nicht erfüllt, wird diese
    !manuell so gesetzt
    if(steps < int(2*N*N*kappa*T)) then
        steps = int(4*N*N*kappa*T)
        dt = (T-t0) / steps !Wenn Steps angepasst werden, müssen wir auch deltaT anpassen, da wir sonst über T hinaus laufen
    endif

    h = 1 / dble(N) !Da wir das Intervall von 0 bis 1 Räumlich partitionieren


    !Speicher allozieren
    allocate(DiffMat(N,N))
    allocate(values_prey(N))
    allocate(values_pred(N))


    !Überprüfung ob wir Diffusion haben wollen oder nicht
    if(diff .eqv. .true.) then

        !Diffusionsmatrix erstellen
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

        DiffMat = (kappa / (h * h))  * DiffMat !skalierte Diffusionsmatrix


        call random_number(values_prey) !random_number füllt das Array mit Zufälligen Zahlen zwischen 0 und 1
        call random_number(values_pred)
    
        t1 = omp_get_wtime()
        !timeloop mit verschiedenen Eulervarianten
        do i = 2, steps + 1
            !call euler_at_one_point_diff_matmul(values_prey, values_pred, dt)       !Laufzeit: 0 Sekunden bei 250 Boxen
                                                                                    !Laufzeit: 36,5 Sekunden bei 1024 Boxen
            call euler_at_one_point_diff_matmul_loop(values_prey, values_pred, dt) !Laufzeit: 0 Sekunden bei 250 Boxen (26,5 wenn MatMUL immer neuberechnet wird in Loop)
                                                                                    !Laufzeit: 38,5 Sekunden bei 1024 Boxen
            !call euler_at_one_point_diff_selfmade(values_prey, values_pred, dt) !Laufzeit: 1219 Sekunden ca. 20 Min bei 1024 Boxen
                                                                                 !Laufzeit: 1.5 Sekunden bei 250 Boxen
            write(*,*) i
        enddo
        t2 = omp_get_wtime()
        

        write(*,*) t2-t1
    else
        call random_number(values_prey) !random_number füllt das Array mit Zufälligen Zahlen zwischen 0 und 1
        call random_number(values_pred)

        t1 = omp_get_wtime()

        !timeloop
        do i = 2, steps + 1
          call euler_at_one_point(values_prey, values_pred, dt) !Laufzeit: 0.5 Sekunden bei 1024 Boxen
                                                                !Laufzeit: 0 Sekunden bei 250 Boxen
        enddo
        t2 = omp_get_wtime()

        write(*,*) t2-t1 

     end if

    open(unit=12, file='values_prey.txt', status='replace', action='write')
    write(12, '(E20.6)') values_prey !E steht für Real Numbers(Exponent Notation), 
    close(unit=12)                   !die 20 für die Feldbreite und die 6 für die Anzahl der Nachkommastellen (fractional Part)

    open(unit=13, file='values_pred.txt', status='replace', action='write')
    write(13, '(E20.6)') values_pred
    close(unit=13)
    
    !Speicher wieder freigeben
    deallocate(values_prey)
    deallocate(values_pred)
    deallocate(DiffMat)

    
    contains
    !In dieser Subroutine wird die Matrix Vektor Multiplikation händisch erledigt
    subroutine euler_at_one_point_diff_selfmade(values_prey, values_pred,deltaT)
        real(kind=wp), intent(INOUT) :: values_prey(:), values_pred(:) !Beidseitiger Informationsfluss, Aufrufende Programmeinheit <->  Funktion
        real(kind=wp), intent(IN) :: deltaT !Wert wird in der Funktion nicht verändert und es findet kein Rückfluss
                                            !der Informationen in die aufrundende Programmeinheit statt
        real(kind=wp), allocatable :: temp_array(:), result_prey(:), result_pred(:)
        !Temp_array benutzen wir, damit die Änderung beider Bestände gleichzeitig in Kraft treten und sich nicht gegenseitig beeinflussen
        allocate(temp_array(N))
        allocate(result_prey(N))
        allocate(result_pred(N))

        result_prey = 0
        result_pred = 0

        temp_array = values_prey
        
        call omp_set_num_threads(8) !hiermit sagen wir, dass wir 8 Threads benutzen wollen
        !$omp parallel private(k)
            !$omp do
                do k=1,N
                    do j=1, N
                        result_prey(k) = result_prey(k) + (DiffMat(k,j) * values_prey(j)) !result_prey = D * values_prey
                    enddo
                enddo
            !$omp end do
        !$omp end parallel            
                
        values_prey = values_prey + deltaT * (result_prey + values_prey * (alpha - beta * values_pred - lambda * values_prey))
        
       call omp_set_num_threads(8) !hiermit sagen wir, dass wir 8 Threads benutzen wollen
        !$omp parallel private(k)
            !$omp do
                do k=1,N
                    do j=1, N
                        result_pred(k) = result_pred(k) + (DiffMat(k,j) * values_pred(j)) !result_pred = D * values_pred
                    enddo
                enddo
            !$omp end do
        !$omp end parallel
                
        values_pred = values_pred + deltaT * (result_pred + values_pred * (delta *  temp_array - gamma - mu * values_pred))

        deallocate(temp_array)
        deallocate(result_prey)
        deallocate(result_pred)
    end subroutine

    !Hier wird die Matrix Vektor Multiplikation durch die vordefinierte MATMUL Funktion erledigt
    !Außerdem nutzen wir die Vektor Multiplikation von Fortran, welche elementweise geschieht
    subroutine euler_at_one_point_diff_matmul(values_prey, values_pred,deltaT)
        real(kind=wp), intent(INOUT) :: values_prey(:), values_pred(:) !Beidseitiger Informationsfluss, Aufrufende Programmeinheit <->  Funktion
        real(kind=wp), intent(IN) :: deltaT !Wert wird in der Funktion nicht verändert und es findet kein Rückfluss
                                            !der Informationen in die aufrundende Programmeinheit statt
        real(kind=wp), allocatable :: temp_array(:) !Temp_array benutzen wir, damit die Änderung beider Bestände gleichzeitig in Kraft treten
                                                    !und sich nicht gegenseitig beeinflussen
        allocate(temp_array(N))

        temp_array = values_prey

        values_prey = values_prey + deltaT * (MATMUL(DiffMat, values_prey) + values_prey * (alpha - beta * values_pred &
        & - lambda * values_prey))

        values_pred = values_pred + deltaT * (MATMUL(DiffMat, values_pred) + values_pred * (delta * temp_array - gamma &
        & - mu * values_pred))

        deallocate(temp_array)
    end subroutine

    !Hier machen wir die Vektor Multiplikation in einer Schleife händisch, also Komponentenweise und nicht über die vordefinierte Fotran Funktion
    !Aber wir benutzen die MATMUL Funktion, welche uns Fortran bereitstellt
    subroutine euler_at_one_point_diff_matmul_loop(values_prey, values_pred,deltaT)
        real(kind=wp), intent(INOUT) :: values_prey(:), values_pred(:) !Beidseitiger Informationsfluss, Aufrufende Programmeinheit <->  Funktion
        real(kind=wp), intent(IN) :: deltaT !Wert wird in der Funktion nicht verändert und es findet kein Rückfluss
                                            !der Informationen in die aufrundende Programm Einheit statt
        real(kind=wp), allocatable :: temp_array(:), mat_prey(:), mat_pred(:)
        allocate(temp_array(N))
        allocate(mat_prey(N))
        allocate(mat_pred(N))

        temp_array = values_prey

        mat_prey = MATMUL(DiffMat, values_prey) !mat_prey = D * values_prey
        mat_pred = MATMUL(DiffMat, values_pred) !mat_pred = D * values_pred


        call omp_set_num_threads(8)
        !$omp parallel private(k)
            !$omp do
                do k=1,N 
                    values_prey(k) = values_prey(k) + deltaT * (mat_prey(k) + values_prey(k) * (alpha &
                    & - beta * values_pred(k) - lambda * values_prey(k)))

                    values_pred(k) = values_pred(k) + deltaT * (mat_pred(k) + values_pred(k) * (delta & 
                    & * temp_array(k) - gamma - mu * values_pred(k)))
                enddo
            !$omp end do
        !$omp end parallel

        deallocate(temp_array)
    end subroutine

    !Eulermethode ohne Diffusion
    subroutine euler_at_one_point(values_prey, values_pred,deltaT)
        real(kind=wp), intent(INOUT) :: values_prey(:), values_pred(:) !Beidseitiger Informationsfluss, Aufrufende Programmeinheit <->  Funktion
        real(kind=wp), intent(IN) :: deltaT !Wert wird in der Funktion nicht verändert und es findet kein Rückfluss
                                            !der Informationen in die aufrundende Programmeinheit statt
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

