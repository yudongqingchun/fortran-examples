program test_octree

  use octree_mod

  type(point_type), allocatable :: points(:)
  integer i, num_seed, num_ngb
  integer, allocatable :: seed(:), ngb_ids(:)
  real(8) x(3), dx(3)
  character(30) arg

  if (command_argument_count() == 1) then
    call get_command_argument(1, arg)
    read(arg, '(I8)') num_seed
    allocate(points(num_seed))
  else
    allocate(points(100))
  end if

  call octree_init()

  call random_seed(size=num_seed)
  allocate(seed(num_seed))
  seed(:) = 1
  call random_seed(put=seed)
  deallocate(seed)

  do i = 1, size(points)
    call random_number(x)
    points(i)%id = i
    points(i)%x = x
  end do

  call octree_build(points)

  allocate(ngb_ids(5000))

!$OMP PARALLEL DO
  do i = 1, size(points)
    !print *, 'Check neighbors of point ', i
    num_ngb = 0
    call octree_search(points(i)%x, 0.05d0, num_ngb, ngb_ids)
    !print *, 'Found ', num_ngb, ' neighbors'
  end do
!$OMP END PARALLEL DO

  call octree_final()

end program test_octree
