#!/bin/bash

PlistBuddy="/usr/libexec/PlistBuddy"

#工程路径
prjc_path=${SRCROOT}
prjc_name=${PRODUCT_NAME}

prjcInfoPlist_path=$prjc_path/$prjc_name/Info.plist
prjcAsset_path=$prjc_path/$prjc_name/Vices.xcassets

#副包根目录
viceResource_path=$prjc_path/ViceResource
#副包资源索引文件
viceResourcePlist_path=$viceResource_path/ViceResourceIndex.plist
#vice items
viceItem_path=$viceResource_path/ViceItems

#bundle_id
bundle_id=${PRODUCT_BUNDLE_IDENTIFIER}

#cntStructureBundleId
cntBundleId_key="cntStructureBundleId"
cntBundle_id=$($PlistBuddy -c "Print :$cntBundleId_key" $viceResourcePlist_path)

if [[ $bundle_id == $cntBundle_id ]]; then
	#statements
	echo "两次构建target相同，忽略此次构建"
	exit
else
	$PlistBuddy -c "Set :$cntBundleId_key $bundle_id" $viceResourcePlist_path
fi

#具体资源路径
resourceRootFileName=$($PlistBuddy -c "Print :$bundle_id" $viceResourcePlist_path)

#具体资源plist 与 assets
resourcePlistPath=$viceResource_path/$resourceRootFileName/$resourceRootFileName.plist
resourceAssetsPath=$viceResource_path/$resourceRootFileName/$resourceRootFileName.xcassets


echo "$($PlistBuddy -c "Print " $resourcePlistPath)"

list=`cat $viceItem_path`

for one in $list
do
    echo $one
    $PlistBuddy -c "Delete :$one" $prjcInfoPlist_path
done

$PlistBuddy -c "Merge $resourcePlistPath" $prjcInfoPlist_path


rm -rf $prjcAsset_path
cp -r $resourceAssetsPath $prjcAsset_path







