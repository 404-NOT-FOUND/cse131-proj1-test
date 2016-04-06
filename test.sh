#!/bin/bash

# PLACE THIS FILE TOGETHER WITH YOUR `glc`
# PLACE YOUR TEST FILES UNDER `<PATH TO THIS FILE>/tests/`
# PLACE THE EXPECTED RESULTS UNDER `<PATH TO THIS FILE>/tests/expects`
# MAKE SURE THE NAMES OF EACH PAIR OF TEST FILE AND EXPECT FILE MATCHE
# e.g., `./tests/int.glsl` and `./tests/expects/int.out`

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

OUTPUT_DIR="${DIR}/my_test_temp_hope_there_is_no_conflicting_names"
EXPECT_DIR="${DIR}/tests/expects"
TEST_DIR="${DIR}/tests"

OUTPUT_EXT="out"
EXPECT_EXT="out"
TEST_EXT="glsl"

numTest=0
numErr=0

# make temporary test folder
mkdir -p ${OUTPUT_DIR}

# for each test files
for f in ${TEST_DIR}/*.${TEST_EXT}; do

    numTest=`expr ${numTest} + 1`
    filename=$(basename "$f")
    extension="${filename##*.}"
    filename="${filename%.*}"

    # run test program
    ./glc < ${f} &> ${OUTPUT_DIR}/${filename}.${EXPECT_EXT}

    diffOutput="$(diff ${OUTPUT_DIR}/${filename}.${OUTPUT_EXT} ${EXPECT_DIR}/${filename}.${EXPECT_EXT})"
    if [ "${diffOutput}" != "" ]; then
        # print test title
        printf "\n"
        echo `basename ${f}`
        printf "==============================\n"
        printf "\n\033[33mYOURS:\033[m\n"
        cat ${OUTPUT_DIR}/${filename}.${OUTPUT_EXT}
        printf "\n\033[33mEXPECTED:\033[m\n"
        cat ${EXPECT_DIR}/${filename}.${EXPECT_EXT}
        printf "\n"
        numErr=`expr ${numErr} + 1`
    fi
done

if [ ${numErr} == 0 ]; then
    printf "\n\033[32mPASSED\033[m\n"
else
    printf "\n\033[31m${numErr}/${numTest} FAILED\033[m\n"
fi

# remove temporary test folder
rm -rf ${OUTPUT_DIR}

