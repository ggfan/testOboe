# Configurations:
#  temp file name to hold build result
BUILD_RESULT_FILE=build_result.txt

# Repo root directory
REPO_ROOT_DIR=.


declare projects=(
    samples
)

for d in "${projects[@]}"; do 
    pushd ${REPO_ROOT_DIR}/${d}
    ./gradlew  -q clean
    ./gradlew -q assembleDebug
    popd
done


# Check the apks that all get built fine
# TBD: add echo after it is merged
#        samples/echo/build/outputs/apk/debug/echo-debug.apk
declare apks=(
    samples/hello-oboe/build/outputs/apk/debug/hello-oboe-debug.apk
    samples/MegaDrone/build/outputs/apk/debug/MegaDrone-debug.apk
    samples/RhythmGame/build/outputs/apk/debug/RhythmGame-debug.apk
)

rm -fr ${BUILD_RESULT_FILE}
for apk in "${apks[@]}"; do
  if [ ! -f ${REPO_ROOT_DIR}/${apk} ]; then
    export SAMPLE_CI_RESULT=1
    echo ${apk} does not build >> ${BUILD_RESULT_FILE}
  fi
done

if [ -f ${BUILD_RESULT_FILE} ]; then
   echo  "******* Failed Builds ********:"
   cat  ${BUILD_RESULT_FILE}
else
  echo "======= BUILD SUCCESS ======="
fi

rm -fr ${BUILD_RESULT_FILE}
