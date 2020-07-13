#注意：脚本目录和xxxx.xcodeproj要在同一个目录，如果放到其他目录，请自行修改脚本。
#工程名字(Target名字)
Project_Name="xcodeBuild"
#配置环境，Release或者Debug
Configuration="Release"

#AdHoc版本的Bundle ID
AdHocBundleID="com.foxitofd.xcodebuild"
#AppStore版本的Bundle ID
AppStoreBundleID="com.xxxxx"
#enterprise的Bundle ID
EnterpriseBundleID="com.xxxxx"

#配置蒲公英
#蒲公英账号的 uKey
U_key=bdd89cde74e915c367181ed7d0df5815
#蒲公英账号的APPKEY
APP_KEY=d3f48359390750a4dc933f766e3c7ed8
#ipa包的路径文件夹
filePath=~/Desktop/$Project_Name-adhoc.ipa

#ipa包的路径文件
filePath1=~/Desktop/$Project_Name-adhoc.ipa/$Project_Name.ipa

# ADHOC
#证书名#描述文件
ADHOCCODE_SIGN_IDENTITY="Apple Distribution: Aerospace Foxit Software (Beijing) Co.,Ltd. (Y44M6Q4F7W)"
ADHOCPROVISIONING_PROFILE_NAME="83625a37-da8a-4b9d-a752-909eaa684ac8"

#AppStore证书名#描述文件
APPSTORECODE_SIGN_IDENTITY="iPhone Distribution: xxxx"
APPSTOREROVISIONING_PROFILE_NAME="xxxx-xxxx-xxxx-xxxx-xxxx"

#企业(enterprise)证书名#描述文件
ENTERPRISECODE_SIGN_IDENTITY="iPhone Distribution: xxxx"
ENTERPRISEROVISIONING_PROFILE_NAME="xxxx-xxxx-xxxx-xxxx-xxxx"

#加载各个版本的plist文件
ADHOCExportOptionsPlist=./ADHOCExportOptionsPlist.plist
AppStoreExportOptionsPlist=./AppStoreExportOptionsPlist.plist
EnterpriseExportOptionsPlist=./EnterpriseExportOptionsPlist.plist

ADHOCExportOptionsPlist=${ADHOCExportOptionsPlist}
AppStoreExportOptionsPlist=${AppStoreExportOptionsPlist}
EnterpriseExportOptionsPlist=${EnterpriseExportOptionsPlist}

echo "~~~~~~~~~~~~选择打包方式(输入序号)~~~~~~~~~~~~~~~"
echo "		1 appstore"
echo "		2 adhoc"
echo "		3 enterprise"

# 读取用户输入并存到变量里
read parameter
sleep 0.5
method="$parameter"

# 判读用户是否有输入
if [ -n "$method" ]
then

#clean下
xcodebuild clean -xcodeproj ./$Project_Name/$Project_Name.xcodeproj -configuration $Configuration -alltargets

    if [ "$method" = "1" ]
    then

#appstore脚本
xcodebuild -project $Project_Name.xcodeproj -scheme $Project_Name -configuration $Configuration -archivePath build/$Project_Name-appstore.xcarchive clean archive build  CODE_SIGN_IDENTITY="${APPSTORECODE_SIGN_IDENTITY}" PROVISIONING_PROFILE="${APPSTOREROVISIONING_PROFILE_NAME}" PRODUCT_BUNDLE_IDENTIFIER="${AppStoreBundleID}"
xcodebuild -exportArchive -archivePath build/$Project_Name-appstore.xcarchive -exportOptionsPlist $AppStoreExportOptionsPlist -exportPath ~/Desktop/$Project_Name-appstore.ipa
    elif [ "$method" = "2" ]
    then
#adhoc脚本
xcodebuild -project $Project_Name.xcodeproj -scheme $Project_Name -configuration $Configuration -archivePath build/$Project_Name-adhoc.xcarchive clean archive build CODE_SIGN_IDENTITY="${ADHOCCODE_SIGN_IDENTITY}" PROVISIONING_PROFILE="${ADHOCPROVISIONING_PROFILE_NAME}" PRODUCT_BUNDLE_IDENTIFIER="${AdHocBundleID}"
xcodebuild -exportArchive -archivePath build/$Project_Name-adhoc.xcarchive -exportOptionsPlist $ADHOCExportOptionsPlist -exportPath ${filePath}
#上传api至蒲公英
echo "****** 开始上传IPA包到蒲公英 ******"
    if [ -e "${filePath}" ]; then
    echo "进入上传"
curl -F "file=@${filePath1}" \
-F "uKey=${U_key}" \
-F "_api_key=${APP_KEY}" \
"http://www.pgyer.com/apiv1/app/upload"
    echo "****** IPA包上传到蒲公英成功 ******"
else
echo "IPA包不存在 上传蒲公英失败"
fi
    elif [ "$method" = "3" ]
    then
#企业打包脚本
xcodebuild -project $Project_Name.xcodeproj -scheme $Project_Name -configuration $Configuration -archivePath build/$Project_Name-enterprise.xcarchive clean archive build CODE_SIGN_IDENTITY="${ENTERPRISECODE_SIGN_IDENTITY}" PROVISIONING_PROFILE="${ENTERPRISEROVISIONING_PROFILE_NAME}" PRODUCT_BUNDLE_IDENTIFIER="${EnterpriseBundleID}"
xcodebuild -exportArchive -archivePath build/$Project_Name-enterprise.xcarchive -exportOptionsPlist $EnterpriseExportOptionsPlist -exportPath ~/Desktop/$Project_Name-enterprise.ipa
else
    echo "参数无效...."
    exit 1
    fi
fi
