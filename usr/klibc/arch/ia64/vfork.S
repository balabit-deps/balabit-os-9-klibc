/*
 * ia64 specific vfork syscall
 *
 * Written By:	 Martin Hicks <mort@wildopensource.com>
 *
 */

/* This syscall is a special case of the clone syscall */
#include <asm/unistd.h>
#include <asm/signal.h>

/* These are redefined here because linux/sched.h isn't safe for
 * inclusion in asm.
 */
#define CLONE_VM    0x00000100 /* set if VM shared between processes */
#define CLONE_VFORK 0x00004000 /* set if parent wants the child to wake it up on exit */

/* pid_t vfork(void) */
/* Implemented as clone(CLONE_VFORK | CLONE_VM | SIGCHLD, 0) */

	.align 32
	.proc vfork
	.global vfork
vfork:
	alloc r2=ar.pfs,0,0,2,0
	mov	r15=__NR_clone
	mov	out0=CLONE_VM|CLONE_VFORK|SIGCHLD
	mov     out1=0
	break 0x100000      // Do the syscall
	cmp.eq  p7,p6 = -1,r10
	;;
(p7)	movl r14 = errno
	;;
(p7)	st4	[r14]=r8
(p7)	mov	r8=-1
	br.ret.sptk.many b0
	.endp vfork
