program test_memory

  implicit none
  integer, dimension(:), allocatable :: array

  allocate(array(5))

  array(6) = 0         ! problem 1: heap block overrun (Invalid write)
  ! array(5) = 0       ! solution 1: set 5th element instead of 6th

  ! deallocate(array)  ! solution 2: deallocate memory before end of program

end program            ! problem 2: memory leak -- array not deallocated
