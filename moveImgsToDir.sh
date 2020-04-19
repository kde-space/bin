#!/bin/sh

CURRENT_WORK_DIR=$1
BACKUP_DIR=$2

if [ ! -d $CURRENT_WORK_DIR ]
  then 
    echo "${CURRENT_WORK_DIR}はディレクトリではありません"
    exit 1
fi

# 直下の画像を取得
images=`find ${CURRENT_WORK_DIR} -maxdepth 1 -type f -name *.jpg -or -name *.png -or -name *.gif`

if [ -z $images ]
  then
    echo "ファイルが存在しません"
    exit 1
fi

if [ -n $BACKUP_DIR ]
  then
    # backup ディレクトリ作成
    backupDirFullPath="${CURRENT_WORK_DIR}/${BACKUP_DIR}"
    mkdir -p $backupDirFullPath
fi

for originImagePath in $images
do
  if [ -n $BACKUP_DIR ]
    then
      # バックアップ作成
      cp $originImagePath $backupDirFullPath
  fi

  # 画像名だけ取得
  fileName=${originImagePath##*/} 
  # hoge:fuga.jpg -> hoge/fuga.jpg
  changedImageName=`echo $fileName | sed -e 's/:/\//g'`
  # 移動先となるディレクトリ作成
  targetDir="${CURRENT_WORK_DIR}/${changedImageName%/*}"
  mkdir -p $targetDir
  # 移動
  mv -v $originImagePath "${CURRENT_WORK_DIR}/${changedImageName}"
done

echo "DONE!!"
exit 0