subroutine hi
write(*,*) 'hi'
end subroutine
program hello
use ESMF
write(*,*) 'hello'
call hi
end program
