#include <stdio.h>
#include <sbl.h>

int main() {
	int major ;
	int minor ;
	int patch ;
	sbl_get_lib_version( &major, &minor, &patch) ;

	printf( "Found libsbl version %d.%d.%d\n", major,minor,patch ) ;
	
	return 0 ;
}
