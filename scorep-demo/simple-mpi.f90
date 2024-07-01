program simple
  use mpi

  implicit none

  ! define variables
  integer process_rank, size_of_cluster, ierror
  integer, parameter :: N = 2**11 ! 2048
  real :: r(N,N)
  real :: buffer(N*N)

  ierror = 0
  buffer = 0.

  ! MPI initialization (Boiler plate)
  call mpi_init(ierror)
  call mpi_comm_size(mpi_comm_world, size_of_cluster, ierror)
  call mpi_comm_rank(mpi_comm_world, process_rank, ierror)

  print *, 'internal process: ', process_rank, 'of ', size_of_cluster

  call random_number(r)
  if(process_rank == 1) then
    ! call again on rank 1 to get different random numbers
    call random_number(r)
  endif

  print *, 'r(1,1) = ',  r(1,1), ' on rank ', process_rank

  call computationally_intensive(r, N)
  call quick_routine()

  if(process_rank == 1) then
    ! send data using MPI from rank 1 to rank 0
    buffer = reshape(r, (/N*N/))
    call mpi_send(buffer, N*N, mpi_real, 0, 1, mpi_comm_world, ierror)
  endif

  if(process_rank == 0) then
    ! receive data using MPI on rank 0 from rank 1
    call mpi_recv(buffer, N*N, mpi_real, 1, 1, mpi_comm_world, mpi_status_ignore, ierror)
    r = reshape(buffer, (/N, N/))
  end if

  print *, 'r(1,1) = ',  r(1,1), ' on rank ', process_rank

  call mpi_finalize(ierror)

  contains

    subroutine computationally_intensive(r, N)
      implicit none
      integer, intent(in) :: N
      real, intent(inout) :: r(N,N)
      integer :: i

      print *, 'this function takes some time'
      do i = 1 , 1024
        r = r * r
        r = abs(r)
        r = sqrt(r)
      end do
    end subroutine computationally_intensive

    subroutine quick_routine()
      implicit none
      print *, 'this function is very quick and does nothing :)'
      call nested_quick_routine()
    end subroutine quick_routine

    subroutine nested_quick_routine()
      implicit none
      print *, 'this function is nested and quick'
    end subroutine nested_quick_routine

end program
