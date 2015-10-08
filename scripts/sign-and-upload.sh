#!/bin/sh
#if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
#echo "This is a pull request. No deployment will be done."
#exit 0
#fi
#if [[ "$TRAVIS_BRANCH" != "master" ]]; then
#echo "Testing on a branch other than master. No deployment will be done."
#exit 0
#fi

PROVISIONING_PROFILE="$HOME/Library/MobileDevice/Provisioning Profiles/$PROFILE_NAME.mobileprovision"
OUTPUTDIR="$PWD/build/Release-iphoneos"

#xcrun -log -sdk iphoneos PackageApplication "$OUTPUTDIR/$APP_NAME.app" -o "$OUTPUTDIR/$APP_NAME.ipa" -sign "$DEVELOPER_NAME" -embed "$PROVISIONING_PROFILE"
#xcrun -sdk iphoneos PackageApplication -v "$PWD/build/Release-iphoneos/Hello-World.app" -o "$PWD/build/Release-iphoneos/Hello-World.ipa" --sign "iPhone Distribution: Datacom (3W2D35BGJW)"
xcrun -sdk iphoneos PackageApplication -v "$OUTPUTDIR/$APP_NAME.app" -o "$OUTPUTDIR/$APP_NAME.ipa" --sign "$PROVISIONING_PROFILE"


RELEASE_DATE=`date '+%Y-%m-%d %H:%M:%S'`
RELEASE_NOTES="Build: $TRAVIS_BUILD_NUMBER\nUploaded: $RELEASE_DATE"

#curl https://rink.hockeyapp.net/api/2/apps/$HOCKEY_APP_ID/app_versions \
#-F status="2" \
#-F notify="0" \
#-F notes="$RELEASE_NOTES" \
#-F notes_type="0" \
#-F ipa="@$OUTPUTDIR/$APP_NAME.ipa" \
#-F dsym="@$OUTPUTDIR/$APP_NAME.app.dSYM" \
#-H "X-HockeyAppToken: $HOCKEY_APP_TOKEN"

curl \
-F "status=2" \
-F "notify=0" \
-F "notes=$RELEASE_NOTES" \
-F "notes_type=0" \
-F "ipa=@$OUTPUTDIR/$APP_NAME.ipa" \
-F "dsym=@$OUTPUTDIR/$APP_NAME.app.dSYM" \
-H "X-HockeyAppToken: $HOCKEY_APP_TOKEN" \
https://rink.hockeyapp.net/api/2/apps/$HOCKEY_APP_ID/app_versions/upload