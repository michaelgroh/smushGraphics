#!/bin/sh

#Set the Internal Field Separator that won't screw up directory names that have spaces.
IFS=$'\n'

BASE_FOLDER="/var/www/"
LOG_FILE="/var/log/smushGraphics.log"
ERR_FILE="/var/log/smushGraphics.err"
SAVINGS=0

echo -e "File\tSize Before\tSize After\tDifference" > ${LOG_FILE}
echo -e "Error" > ${ERR_FILE}

ORIG_FILES=$(find ${BASE_FOLDER} -type f -daystart -mtime -30 -name "*.jpg")

for ORIG_FILE in $ORIG_FILES
do
        if [ -f "$ORIG_FILE" ]
        then
                NEW_FILE=${ORIG_FILE/.jpg/.opt.jpg}
                jpegtran -copy none -optimize "${ORIG_FILE}" > "${NEW_FILE}"

                if [ $? != 0 ]
                then
                        echo -e "jpegtran returned $? after processing $ORIG_FILE." >> ${ERR_FILE}
                fi

                ORIG_FILE_SIZE=$(stat -c%s "$ORIG_FILE")

                if [ -f "$NEW_FILE" ]
                then
                        NEW_FILE_SIZE=$(stat -c%s "$NEW_FILE")
                        FILE_SIZE_DIFF=$(($ORIG_FILE_SIZE - $NEW_FILE_SIZE))
  		if (( $NEW_FILE_SIZE < $ORIG_FILE_SIZE ))
			then
				cp -f "${NEW_FILE}" "${ORIG_FILE}"
				let "SAVINGS+=$FILE_SIZE_DIFF"
			fi
			rm -f "${NEW_FILE}"                        
			echo -e "$ORIG_FILE\t$ORIG_FILE_SIZE\t$NEW_FILE_SIZE\t$FILE_SIZE_DIFF" >> ${LOG_FILE}
                else
                        echo -e "$ORIG_FILE not optimized. New file was not found." >> ${ERR_FILE}
                fi
        fi
done

if [ "$SAVINGS" -gt "0" ]
then
	echo Reduced file sizes by $SAVINGS bytes.
fi
exit 0
