# FLAGS
REBUILD=false
OBFUSCATE=false


# USEFUL VARIABLES
ABORT="\033[31mAbort:\033[00m"
SUCCESS="\033[32mSuccess:\033[00m"
INFO="\033[33mInfo:\033[00m"

ORIGINAL_PATH_TO_SCRIPT="${0}"
CLEANED_PATH_TO_SCRIPT="${ORIGINAL_PATH_TO_SCRIPT//\\//}"
BASE_DIR=`dirname "$CLEANED_PATH_TO_SCRIPT"`


cd $BASE_DIR/..

if [ $REBUILD = false ]; then
	echo -e "$INFO REBUILD flag is set to false. Do you want to proceed?"
	read -p "Press [Enter] key to continue"
fi

if [ $OBFUSCATE = false ]; then
	echo -e "$INFO OBFUSCATE flag is set to false. Do you want to proceed?"
	read -p "Press [Enter] key to continue"
fi

echo -e "$INFO Did you set the correct version number for the installers?"
read -p "Press [Enter] key to continue"

echo -e "$INFO Did you set the correct version number for the Visual Studio plugins?"
read -p "Press [Enter] key to continue"

echo -e "$INFO Are the Visual Studio plugins up to date?"
read -p "Press [Enter] key to continue"

# SETTING THE DEPLOY FLAG
rm -rf src/lib_gui/platform_includes/deploy.h
echo "#define DEPLOY" >src/lib_gui/platform_includes/deploy.h


# CLEANING THE PROJECT
if [ $REBUILD = true ]; then
	echo -e "$INFO cleaning the project"
	"D:/programme/Microsoft Visual Studio14/Common7/IDE/devenv.com" build/Coati.sln //clean Release
fi


# BUILDING THE EXECUTABLES
echo -e "$INFO building the executable (app)"
"D:/programme/Microsoft Visual Studio14/Common7/IDE/devenv.com" build/Coati.sln //build Release //project build/Coati.vcxproj

echo -e "$INFO building the executable (trail)"
"D:/programme/Microsoft Visual Studio14/Common7/IDE/devenv.com" build/Coati.sln //build Release //project build/Coati_trial.vcxproj


# CREATING TRAIL DATABASES´
echo -e "$INFO creating databases for trail"

rm bin/app/data/projects/tictactoe/tictactoe.coatidb
rm bin/app/data/projects/tutorial/tutorial.coatidb
rm -rf temp
mkdir -p temp
cd temp
echo -e "$INFO Please wait until Coati created the database for tictactoe. Close Coati to continue"
../bin/app/Release/Coati.exe -p ../bin/app/data/projects/tictactoe/tictactoe.coatiproject

echo -e "$INFO Please wait until Coati created the database for tutorial. Close Coati to continue"
../bin/app/Release/Coati.exe -p ../bin/app/data/projects/tutorial/tutorial.coatiproject

cd ..
rm -rf temp


# OBFUSCATING THE EXECUTABLES
if [ $OBFUSCATE = true ]; then
	echo -e "$INFO obfuscating the executables"
	rm bin/app/Release/Coati_obfuscated.exe
	rm bin/app/Release/Coati_trial_obfuscated.exe
	upx --brute -o bin/app/Release/Coati_obfuscated.exe bin/app/Release/Coati.exe
	upx --brute -o bin/app/Release/Coati_trial_obfuscated.exe bin/app/Release/Coati_trial.exe
else
	cp bin/app/Release/Coati.exe bin/app/Release/Coati_obfuscated.exe
	cp bin/app/Release/Coati_trial.exe bin/app/Release/Coati_trial_obfuscated.exe
fi


# BUILDING THE INSTALLERS
echo -e "$INFO building the installer (app)"
"D:/programme/Microsoft Visual Studio 12/Common7/IDE/devenv.com" deployment/windows/CoatiAppSetup/CoatiAppSetup.sln //build Release //project deployment/windows/CoatiAppSetup/CoatiSetup/CoatiSetup.vdproj

echo -e "$INFO building the installer (trail)"
"D:/programme/Microsoft Visual Studio 12/Common7/IDE/devenv.com" deployment/windows/CoatiTrialSetup/CoatiTrialSetup.sln //build Release //project deployment/windows/CoatiTrialSetup/CoatiSetup/CoatiSetup.vdproj


# EDIT THE INSTALLERS
"C:/Program Files (x86)/Microsoft SDKs/Windows/v7.1A/Bin/MsiTran.Exe" -a "deployment/windows/transform.mst" "deployment/windows/CoatiAppSetup/CoatiSetup/Release/Coati.msi"
"C:/Program Files (x86)/Microsoft SDKs/Windows/v7.1A/Bin/MsiTran.Exe" -a "deployment/windows/transform.mst" "deployment/windows/CoatiTrialSetup/CoatiSetup/Release/CoatiTrial.msi"


# CREATING PACKAGE FOLDERS (APP)
VERSION_STRING=$(git describe)
VERSION_STRING="${VERSION_STRING//-/_}"
VERSION_STRING="${VERSION_STRING//./_}"
VERSION_STRING="${VERSION_STRING%_*}"

APP_PACKAGE_NAME=Coati_${VERSION_STRING}

APP_PACKAGE_DIR=release/$APP_PACKAGE_NAME

echo -e "$INFO creating package folders for app"
rm -rf $APP_PACKAGE_DIR
mkdir -p $APP_PACKAGE_DIR

cp -u -r deployment/windows/CoatiAppSetup/CoatiSetup/Release/Coati.msi $APP_PACKAGE_DIR/
cp -u -r deployment/windows/CoatiAppSetup/CoatiSetup/Release/setup.exe $APP_PACKAGE_DIR/

mkdir -p $APP_PACKAGE_DIR/plugins/visual_studio/
cp -u -r ide_plugins/vs/coati_plugin_vs_2012.vsix $APP_PACKAGE_DIR/plugins/visual_studio/
cp -u -r ide_plugins/vs/coati_plugin_vs_2013.vsix $APP_PACKAGE_DIR/plugins/visual_studio/
cp -u -r ide_plugins/vs/coati_plugin_vs_2015.vsix $APP_PACKAGE_DIR/plugins/visual_studio/
mkdir -p $APP_PACKAGE_DIR/plugins/sublime_text/
cp -u -r ide_plugins/sublime_text/* $APP_PACKAGE_DIR/plugins/sublime_text/


# PACKAGING COATI (APP)
echo -e "$INFO packaging coati app"
cd ./release/
winrar a -afzip ${APP_PACKAGE_NAME}_Windows.zip $APP_PACKAGE_NAME
cd ../


# CLEANING UP (APP)
echo -e "$INFO Cleaning up app"
rm -rf $APP_PACKAGE_DIR


# CREATING PACKAGE FOLDERS (TRIAL)
TRIAL_PACKAGE_NAME=Coati_Trail_${VERSION_STRING}

TRIAL_PACKAGE_DIR=release/$TRIAL_PACKAGE_NAME

echo -e "$INFO creating package folders for trail"
rm -rf $TRIAL_PACKAGE_DIR
mkdir -p $TRIAL_PACKAGE_DIR

cp -u -r deployment/windows/CoatiTrialSetup/CoatiSetup/Release/CoatiTrial.msi $TRIAL_PACKAGE_DIR/
cp -u -r deployment/windows/CoatiTrialSetup/CoatiSetup/Release/setup.exe $TRIAL_PACKAGE_DIR/

mkdir -p $TRIAL_PACKAGE_DIR/plugins/visual_studio/
cp -u -r ide_plugins/vs/coati_plugin_vs_2012.vsix $TRIAL_PACKAGE_DIR/plugins/visual_studio/
cp -u -r ide_plugins/vs/coati_plugin_vs_2013.vsix $TRIAL_PACKAGE_DIR/plugins/visual_studio/
cp -u -r ide_plugins/vs/coati_plugin_vs_2015.vsix $TRIAL_PACKAGE_DIR/plugins/visual_studio/
mkdir -p $TRIAL_PACKAGE_DIR/plugins/sublime_text/
cp -u -r ide_plugins/sublime_text/* $TRIAL_PACKAGE_DIR/plugins/sublime_text/


# PACKAGING COATI (TRIAL)
echo -e "$INFO packaging coati trail"
cd ./release/
winrar a -afzip ${TRIAL_PACKAGE_NAME}_Windows.zip $TRIAL_PACKAGE_NAME
cd ../


# CLEANING UP (TRIAL)
echo -e "$INFO Cleaning up trail"
rm -rf $TRIAL_PACKAGE_DIR


# UNSETTING THE DEPLOY FLAG
rm -rf src/lib_gui/platform_includes/deploy.h
echo "// #define DEPLOY" >src/lib_gui/platform_includes/deploy.h


echo -e "$SUCCESS packaging complete!"



















