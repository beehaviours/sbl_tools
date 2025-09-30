#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <sbl.h>

int main( int argc, char** argv ) {

	int module;
	int cam ;
	int year;
	int month;
	int day;
	int hour;
	int minute;
	int ret ;
	char* filename = NULL;

	if (argc != 5)
		goto erreur ;

	if ( sscanf( argv[1], "%d", &module ) != 1 )
		goto erreur ;

	if ( sscanf( argv[2], "%d", &cam ) != 1 )
		goto erreur ;

	if ( sscanf( argv[3], "%4d%2d%2d", &year, &month, &day ) != 3 )
		goto erreur ;

	if ( sscanf( argv[4], "%2d:%2d", &hour, &minute ) != 2 )
		goto erreur ;

	ret = sbl_find_video(filename, module, cam, \
			year, month, day, hour, minute);

	if (ret) {
		fprintf(stderr, "File not found.\n") ;
		return -1 ;
	}
	
	printf("%s\n",filename);
	free(filename);

	return 0 ;

erreur:
	fprintf(stderr, "Error: Wrong args.\n");
	fprintf(stderr, "Usage:\n");
	fprintf(stderr, "\t%s MODULE CAM YYYYMMDD HH:MM\n", argv[0]);
	fprintf(stderr,"\n");

	return -1 ;
}
