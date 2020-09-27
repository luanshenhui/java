#. $HOME/.profile

####数据库链接 /home/admin/local/mysql/bin/mysql -u${mysqlUser} -p${mysqlPassword} -h${mysqlIP} -P${mysqlPort} -vv ${mysqlDB} -e
#need set start
#mysqlUser=
#mysqlPassword=
#mysqlIP=
#mysqlPort=
#mysqlDB=
mysqlUser=mysqlbatch
mysqlPassword=mysqldba123
mysqlIP=mysql-1.shop.cgbchina.com.cn
mysqlPort=3306
mysqlDB=cgbmall
#need set end
#有环境变量的情况下mysql 没有的情况下/home/admin/local/mysql/bin/mysql
#need set
mysqlCmd=/ebank/apps/mysql-client
#mysqlCmd=

#生产路径
#HOME_PATH=/db2/db2inst1/db2backup
#need set
#HOME_PATH=
HOME_PATH=/ebank/ODS
#SIT路径
#HOME_PATH=/home/db2inst1/db2backup

#### date of system ####
sysdate=`date +%Y%m%d`
systime=`date +%H%M%S`
#生产上设定 停止接受调度时间
stopTime=230000
#SIT上设定 停止接受调度时间
#stopTime=190000
#数据文件齐全标志配置
#passSign=true

####记录日志的目录####
logPath=${HOME_PATH}/logs
####记录日志的文件####
logFile=${logPath}/dataImport_${sysdate}.log

##取T-2的日期
#need set
if [[ $1 =~ ^[0-9]{8}$ ]]
then
WANTEDDAY=$1
else 
WANTEDDAY=`date +%Y%m%d -d -2day`
fi

##T-2日期目录
DAYPath=${HOME_PATH}/ODS_data/$WANTEDDAY

#取数路径(数据仓库)，生产环境
#sjckHome=/CDMETL/user/cdm_ems/cdm/$WANTEDDAY
sjckHome=/CDMETL/user/cdm_ems/cdm/$WANTEDDAY
#取数路径(数据仓库)，SIT和UAT环境
#sjckHome=/CDM_ETL/user/cdm_mall/cdm/$WANTEDDAY

#生产环境CDM的服务
#CDM_IP=10.2.112.80
#CDM_USER=cdm_ems
#need set start
CDM_IP=10.2.112.80
CDM_USER=cdm_ems
#need set end
#SIT环境CDM的服务器IP
#CDM_IP=10.2.36.94
#UAT环境CDM的服务
#CDM_IP=10.2.36.175

#### data files name ####
dataFileCust=A_CUST_TOELECTRONBANK
dataFileCard=A_CARD_CUST_TOELECTRONBANK
dataFileDesc=A_CARD_LEVEL_TOELECTRONBANK

#### table name ####
tblCust=A_CUST_TOELECTRONBANK
tblCard=A_CARD_CUST_TOELECTRONBANK
tblDesc=A_CARD_LEVEL_TOELECTRONBANK

#### temp table name ####
tblCustTemp=A_CUST_TOELECTRONBANK_TEMP
tblCardTemp=A_CARD_CUST_TOELECTRONBANK_TEMP
tblDescTemp=A_CARD_LEVEL_TOELECTRONBANK_TEMP

#### table column ###
tblCustCol=\`data_dt\`,\`cert_nbr\`,\`card_level_cd\`,\`vip_tp_cd\`,\`birth_day\`,\`cust_addr\`,\`etl_sys_dttime\`,\`eng_name\`,\`incr_ind\`,\`his_add_ind\`,\`cust_name\`
tblCardCol=\`data_dt\`,\`card_nbr\`,\`cust_nbr\`,\`bank_nbr\`,\`card_tp_cd\`,\`card_format_nbr\`,\`card_level_cd\`,\`birth_day\`,\`cert_nbr\`,\`etl_sys_dttime\`,\`incr_ind\`
tblDescCol=\`data_dt\`,\`card_level_nbr\`,\`card_level_desc\`,\`etl_sys_dttime\`

##远程变量关系
rDataFileCust=CDM_A_OUT_EMS_CUST_D_F_
rDataFileCard=CDM_A_OUT_EMS_CARD_CUST_D_F_
rDataFileDesc=CDM_A_OUT_EMS_CARD_LEVEL_D_F_

#### print logs function 定义打印日志函数####


shlog()
{
    if [ ! -z "$1" ]
    then
        LOGTIME=`date +"%Y-%m-%d %H:%M:%S"`
        echo "[$LOGTIME] $1" >> $logFile
    fi
}
#### mkdir function ####
shmkpath()
{
if [ ! -d $1 ]
    then
shlog "create directory $1"
mkdir -p $1
fi
}
#### mkfile function ####
shmkfile()
{
if [ ! -f $1 ]
    then   
shlog "create file $1 "
touch $1
fi
}

copyfileandconvent(){
FILEPATH=$1
ORGINFILENAME=$2
orginCatalog=orgin
tmpFile=tmp
mkdir -p ${orginCatalog}
cp ${FILEPATH}/${ORGINFILENAME} ${FILEPATH}/${orginCatalog}
iconv -f 'gb18030' -t 'utf-8' ${FILEPATH}/${ORGINFILENAME} -o ${FILEPATH}/${tmpFile}
mv -f ${FILEPATH}/${tmpFile} ${FILEPATH}/${ORGINFILENAME}
}

#### load data function 定义导数函数####
loaddata()
{
FILEPATH=$1
TABLENAME=$2
TABLECOL=$3
shlog "import data $FILEPATH begin..."
#db2 "load from $FILEPATH of del replace into ${TABLENAME} COPY NO without prompting" >> $logFile
#db2 "load from $FILEPATH of del modified by usedefaults coldel0x1b nochardel keepblanks replace into ${TABLENAME} nonrecoverable" >> $logFile
##COMMITCOUNT n：n条记录提交一次 ##
#db2 "import from $FILEPATH of del modified by usedefaults coldel0x1b nochardel keepblanks COMMITCOUNT 100000 replace into ${TABLENAME}" >> $logFile
${mysqlCmd} -u${mysqlUser} -p${mysqlPassword} -h${mysqlIP} -P${mysqlPort} -vv ${mysqlDB} -e "truncate table ${TABLENAME}" >> $logFile
${mysqlCmd} --local-infile -u${mysqlUser} -p${mysqlPassword} -h${mysqlIP} -P${mysqlPort} -vv ${mysqlDB} -e "load data local infile '$FILEPATH' 
replace into table ${TABLENAME} fields terminated by 0x1b enclosed by ''  (${TABLECOL}) "  >> $logFile


callrst=$?

if [ $callrst -ne 0 ]
then
    shlog "import data $FILEPATH error!!"
    return -1
  else
    shlog "import data $FILEPATH success!!"
fi
}

#### update table status function 定义更新表状态函数####
updatestate()
{
TABLENAME=$1
shlog "update table ${TABLENAME} state begin..."
shlog "update A_ODS_DATA_STATUS set DATA_STATUS='1', MODIFY_DATE='${sysdate}', MODIFY_TIME='${systime}' where TBL_NAME='${TABLENAME}'"
#db2 "update A_ODS_DATA_STATUS set DATA_STATUS='1', MODIFY_DATE='${sysdate}', MODIFY_TIME='${systime}' where TBL_NAME='${TABLENAME}'" >> $logFile

${mysqlCmd} -u${mysqlUser} -p${mysqlPassword} -h${mysqlIP} -P${mysqlPort} -vv ${mysqlDB} -e "update A_ODS_DATA_STATUS set DATA_STATUS='1', MODIFY_time=now() where TBL_NAME='${TABLENAME}'" >> $logFile

callrst=$?

if [ $callrst -ne 0 ]
then
    shlog "update table ${TABLENAME} state error!!"
    return -1
  else
    shlog "update table ${TABLENAME} state success!!"
fi
}

####定义增量更新A_CARD_CUST_TOELECTRONBANK函数####
mergecardcustdata()
{
TABLENAME=$1
TABLENAMETEMP=$2
TABLECOL=$3
shlog "merge table ${TABLENAME} state begin..."
#db2 "merge into ${TABLENAME} card using ${TABLENAMETEMP} tmp on (tmp.CARD_NBR=card.CARD_NBR) when matched then update set card.DATA_DT=tmp.DATA_DT,card.CUST_NBR=tmp.CUST_NBR,card.BANK_NBR=tmp.BANK_NBR,card.CARD_TP_CD=tmp.CARD_TP_CD,card.CARD_FORMAT_NBR=tmp.CARD_FORMAT_NBR,card.CARD_LEVEL_CD=tmp.CARD_LEVEL_CD,card.BIRTH_DAY=tmp.BIRTH_DAY,card.CERT_NBR=tmp.CERT_NBR,card.ETL_SYS_DTTIME=tmp.ETL_SYS_DTTIME,card.INCR_IND=tmp.INCR_IND,card.HIS_ADD_IND=tmp.HIS_ADD_IND,card.HIS_UPDATE_IND=tmp.HIS_UPDATE_IND,card.TX_DATE=tmp.TX_DATE when not matched then insert (DATA_DT,CARD_NBR,CUST_NBR,BANK_NBR,CARD_TP_CD,CARD_FORMAT_NBR,CARD_LEVEL_CD,BIRTH_DAY,CERT_NBR,ETL_SYS_DTTIME,INCR_IND,HIS_ADD_IND,HIS_UPDATE_IND,TX_DATE) values (tmp.DATA_DT,tmp.CARD_NBR,tmp.CUST_NBR,tmp.BANK_NBR,tmp.CARD_TP_CD,tmp.CARD_FORMAT_NBR,tmp.CARD_LEVEL_CD,tmp.BIRTH_DAY,tmp.CERT_NBR,tmp.ETL_SYS_DTTIME,tmp.INCR_IND,tmp.HIS_ADD_IND,tmp.HIS_UPDATE_IND,tmp.TX_DATE)" >> $logFile
${mysqlCmd} -u${mysqlUser} -p${mysqlPassword} -h${mysqlIP} -P${mysqlPort} -vv ${mysqlDB} -e "replace into ${TABLENAME} (${TABLECOL}) select ${TABLECOL} from ${TABLENAMETEMP}"  >> $logFile
callrst=$?

#merge没有数据
if [ $callrst -eq 1 ]
then
shlog "merge table ${TABLENAME} no data!!"
else
if [ $callrst -ne 0 ]
then
    shlog "merge table ${TABLENAME} data error!!"
    return -1
  else
    shlog "merge table ${TABLENAME} data success!!"
fi
fi

}
####定义增量更新A_CUST_TOELECTRONBANK函数####
mergecustdata()
{
TABLENAME=$1
TABLENAMETEMP=$2
TABLECOL=$3
shlog "merge table ${TABLENAME} data begin..."
#db2 "merge into ${TABLENAME} cust using ${TABLENAMETEMP} tmp on (tmp.CERT_NBR=cust.CERT_NBR) when matched then update set cust.DATA_DT=tmp.DATA_DT,cust.CARD_LEVEL_CD=tmp.CARD_LEVEL_CD,cust.VIP_TP_CD=tmp.VIP_TP_CD,cust.BIRTH_DAY=tmp.BIRTH_DAY,cust.CUST_ADDR=tmp.CUST_ADDR,cust.ETL_SYS_DTTIME=tmp.ETL_SYS_DTTIME,cust.ENG_NAME=tmp.ENG_NAME,cust.INCR_IND=tmp.INCR_IND,cust.HIS_ADD_IND=tmp.HIS_ADD_IND,cust.HIS_UPDATE_IND=tmp.HIS_UPDATE_IND,cust.TX_DATE=tmp.TX_DATE when not matched then insert (DATA_DT,CERT_NBR,CARD_LEVEL_CD,VIP_TP_CD,BIRTH_DAY,CUST_ADDR,ETL_SYS_DTTIME,ENG_NAME,INCR_IND,HIS_ADD_IND,HIS_UPDATE_IND,TX_DATE) values (tmp.DATA_DT,tmp.CERT_NBR,tmp.CARD_LEVEL_CD,tmp.VIP_TP_CD,tmp.BIRTH_DAY,tmp.CUST_ADDR,tmp.ETL_SYS_DTTIME,tmp.ENG_NAME,tmp.INCR_IND,tmp.HIS_ADD_IND,tmp.HIS_UPDATE_IND,tmp.TX_DATE)" >> $logFile
${mysqlCmd} -u${mysqlUser} -p${mysqlPassword} -h${mysqlIP} -P${mysqlPort} -vv ${mysqlDB} -e "replace into ${TABLENAME} (${TABLECOL}) select ${TABLECOL} from ${TABLENAMETEMP}" >> $logFile
callrst=$?

#merge没有数据
if [ $callrst -eq 1 ]
then
shlog "merge table ${TABLENAME} no data!!"
else
if [ $callrst -ne 0 ]
then
    shlog "merge table ${TABLENAME} data error!!"
    return -1
  else
    shlog "merge table ${TABLENAME} data success!!"
fi
fi
}
####定义增量更新A_CUST_TOELECTRONBANK函数####
mergecardleveldata()
{
TABLENAME=$1
TABLENAMETEMP=$2
TABLECOL=$3
shlog "merge table ${TABLENAME} data begin..."
#db2 "merge into ${TABLENAME} lev using ${TABLENAMETEMP} tmp on (tmp.CARD_LEVEL_NBR=lev.CARD_LEVEL_NBR) when matched then update set lev.DATA_DT=tmp.DATA_DT,lev.CARD_LEVEL_DESC=tmp.CARD_LEVEL_DESC,lev.ETL_SYS_DTTIME=tmp.ETL_SYS_DTTIME,lev.HIS_UPDATE_IND=tmp.HIS_UPDATE_IND,lev.TX_DATE=tmp.TX_DATE when not matched then insert (DATA_DT,CARD_LEVEL_NBR,CARD_LEVEL_DESC,ETL_SYS_DTTIME,HIS_UPDATE_IND,TX_DATE) values (tmp.DATA_DT,tmp.CARD_LEVEL_NBR,tmp.CARD_LEVEL_DESC,tmp.ETL_SYS_DTTIME,tmp.HIS_UPDATE_IND,tmp.TX_DATE)" >> $logFile
${mysqlCmd} -u${mysqlUser} -p${mysqlPassword} -h${mysqlIP} -P${mysqlPort} -vv ${mysqlDB} -e "replace into ${TABLENAME} (${TABLECOL}) select ${TABLECOL} from ${TABLENAMETEMP}" >> $logFile
callrst=$?

#merge没有数据
if [ $callrst -eq 1 ]
then
shlog "merge table ${TABLENAME} no data!!"
else
if [ $callrst -ne 0 ]
then
    shlog "merge table ${TABLENAME} data error!!"
    return -1
  else
    shlog "merge table ${TABLENAME} data success!!"
fi
fi
}
####定义全量导入数据函数(临时表到目标表) ####
importdata()
{
FILEPATH=$1
TABLENAME=$2
shmkfile ${dataHome}/null.del
shlog "delete table ${TABLENAME} data begin..."
#db2 "import from ${dataHome}/null.del of del replace into ${TABLENAME}" >> $logFile
callrst=$?
if [ $callrst -ne 0 ]
then
shlog "delete table ${TABLENAME} data error!!"
return -1
else
shlog "delete table ${TABLENAME} data success!!"
fi
shlog "import table ${TABLENAME} data begin..."
## allow WRITE ACCESS：允许并发应用程序访问表数据，COMMITCOUNT n：n条记录提交一次 ##
#db2 "import from $FILEPATH of del modified by usedefaults coldel0x1b nochardel keepblanks allow WRITE ACCESS COMMITCOUNT 100000 insert into ${TABLENAME}" >> $logFile
callrst=$?
if [ $callrst -ne 0 ]
then
shlog "import table ${TABLENAME} data error!!"
return -1
else
shlog "import table ${TABLENAME} data success!!"
fi
}

####定义重命名表名函数####
renametable()
{
TABLENAME=$1
TABLENAMETEMP=$2
shlog "rename table ${TABLENAME} begin..."
#db2 "rename table ${TABLENAME} to ${TABLENAMETEMP}_A" >> $logFile

${mysqlCmd} -u${mysqlUser} -p${mysqlPassword} -h${mysqlIP} -P${mysqlPort} -vv ${mysqlDB} -e "rename table ${TABLENAME} to ${TABLENAMETEMP}_A" >> $logFile

callrst=$?
if [ $callrst -ne 0 ]
then
    shlog "rename table ${TABLENAME} to ${TABLENAMETEMP}_A error!!"
    return -1
  else
    shlog "rename table ${TABLENAME} to ${TABLENAMETEMP}_A success!!"
fi

#db2 "rename table ${TABLENAMETEMP} to ${TABLENAME}" >> $logFile
${mysqlCmd} -u${mysqlUser} -p${mysqlPassword} -h${mysqlIP} -P${mysqlPort} -vv ${mysqlDB} -e "rename table ${TABLENAMETEMP} to ${TABLENAME}" >> $logFile
callrst=$?
if [ $callrst -ne 0 ]
then
    shlog "rename table ${TABLENAMETEMP} to ${TABLENAME} error!!"
    return -1
  else
    shlog "rename table ${TABLENAMETEMP} to ${TABLENAME} success!!"
fi

#db2 "rename table ${TABLENAMETEMP}_A to ${TABLENAMETEMP}" >> $logFile
${mysqlCmd} -u${mysqlUser} -p${mysqlPassword} -h${mysqlIP} -P${mysqlPort} -vv ${mysqlDB} -e "rename table ${TABLENAMETEMP}_A to ${TABLENAMETEMP}" >> $logFile
callrst=$?
if [ $callrst -ne 0 ]
then
    shlog "rename table ${TABLENAMETEMP}_A to ${TABLENAMETEMP} error!!"
    return -1
  else
    shlog "rename table ${TABLENAMETEMP}_A to ${TABLENAMETEMP} success!!"
fi
}

#### logs path 创建记录日志的目录####
shmkpath ${logPath}
#### create logs file 创建记录日志的文件####
shmkfile ${logFile}

##创建T-2日期目录
shmkpath ${DAYPath}/CDM

##进入T-2日期目录
cd ${DAYPath}/CDM

if [ $systime -le $stopTime ]
then
#如果${DAYPath}/CDM目录下的数据还没有导入成功，则需要获取数据
if [ ! -r ${DAYPath}/CDM/importData.ok ]
then 
shlog "get ${WANTEDDAY} data begin..."
sftp ${CDM_USER}@${CDM_IP}<<!
   get ${sjckHome}/${rDataFileCust}$WANTEDDAY.dat     ${dataFileCust}.dat  
   get ${sjckHome}/${rDataFileCust}$WANTEDDAY.ok      ${dataFileCust}.ok
   get ${sjckHome}/${rDataFileCard}$WANTEDDAY.dat     ${dataFileCard}.dat
   get ${sjckHome}/${rDataFileCard}$WANTEDDAY.ok      ${dataFileCard}.ok
   get ${sjckHome}/${rDataFileDesc}$WANTEDDAY.dat     ${dataFileDesc}.dat
   get ${sjckHome}/${rDataFileDesc}$WANTEDDAY.ok      ${dataFileDesc}.ok
!
shlog "get ${WANTEDDAY} data end "
fi

#如果获取的数据不全，则返回2，等30分钟后集中调度重新调起
if [ ! -r ${DAYPath}/CDM/${dataFileCust}.ok -o ! -r ${DAYPath}/CDM/${dataFileCust}.dat -o ! -r ${DAYPath}/CDM/${dataFileCard}.ok -o ! -r ${DAYPath}/CDM/${dataFileCard}.dat -o ! -r ${DAYPath}/CDM/${dataFileDesc}.ok -o ! -r ${DAYPath}/CDM/${dataFileDesc}.dat ]
then
shlog "get ${WANTEDDAY} data failed, exit!"
echo 2
exit 0 
fi

#检查数据文件大小，小于10M 不倒入。
if [ `du ${DAYPath}/CDM/${dataFileCust}.dat -m | awk '{print $1}'` -lt 1 -o `du ${DAYPath}/CDM/${dataFileCard}.dat -m | awk '{print $1}'` -lt 10 ]
then
shlog "get ${WANTEDDAY} data less 10M , exit!"
echo 2
exit 0 
fi

#####get file count #######
batchcount=`ls -l $HOME_PATH/ODS_data |grep "^d"|wc -l`
if [ ! $batchcount -eq 0 ]
then
#loop datefile
#只检查最近5天的数据是否有导入
if [ $batchcount -gt 5 ]
then
d=`expr $batchcount - 4 `
else
  d=1
fi

while [ $d -le $batchcount ]
do
batchdate1=`ls  $HOME_PATH/ODS_data |sed -n "$d p" `
#batchdate1=`ls -tr  $HOME_PATH/ODS_data |sed -n "1p" `
dataHome=${HOME_PATH}/ODS_data/$batchdate1/CDM

shlog "dataHome=${dataHome}"

#### Is the newest data already loaded ####
if [ ! -r ${dataHome}/importData.ok ]
then
#### Are the ok files all ready ####
if [ -r ${dataHome}/${dataFileCust}.ok -a -r ${dataHome}/${dataFileCust}.dat -a -r ${dataHome}/${dataFileCard}.ok -a -r ${dataHome}/${dataFileCard}.dat -a -r ${dataHome}/${dataFileDesc}.ok -a -r ${dataHome}/${dataFileDesc}.dat ]
then
#shlog "connect to database..."
#db2 connect to $DBName >> $logFile
#callrst=$?
#if [ $callrst -ne 0 ];
#then
#shlog "connect error!!!"
#echo 1
#return -1
#fi
#shlog "connect success!"

shlog "start import data..."

#导入到临时表A_CUST_TOELECTRONBANK_TEMP
copyfileandconvent ${dataHome} ${dataFileCust}.dat
loaddata ${dataHome}/${dataFileCust}.dat ${tblCustTemp} ${tblCustCol}
 callrst=$?
if [ $callrst -ne 0 ];
then
echo 1
return -1
else
updatestate ${tblCustTemp}
fi

#导入到临时表A_CARD_CUST_TOELECTRONBANK_TEMP
copyfileandconvent ${dataHome} ${dataFileCard}.dat
loaddata ${dataHome}/${dataFileCard}.dat ${tblCardTemp} ${tblCardCol}
callrst=$?
if [ $callrst -ne 0 ];
then
echo 1
return -1
else
updatestate ${tblCardTemp}
fi
   
#导入到临时表A_CARD_LEVEL_TOELECTRONBANK_TEMP
copyfileandconvent ${dataHome} ${dataFileDesc}.dat
loaddata ${dataHome}/${dataFileDesc}.dat ${tblDescTemp} ${tblDescCol}
 callrst=$?
if [ $callrst -ne 0 ];
then
echo 1
return -1
else
updatestate ${tblDescTemp}
fi

## 判断全量、增量 start ##
importFlag=`head -1 ${dataHome}/${dataFileCust}.dat|awk -F "" '{print $9}'`
shlog "importFlag=${importFlag}"

#文件增全量标志为空，需要判断导入的是否是旧数据
if [ "${importFlag}" = "" ]
then
cnt=`awk '{print NR}' ${dataHome}/${dataFileCust}.dat|tail -n1`
certnbr=`head -1 ${dataHome}/${dataFileCust}.dat|awk -F "" '{print $2}'`
shlog "cnt=$cnt , certnbr=$certnbr"
#数据文件内容行数大于0并且 证件号不为空，为全量旧数据
if [ ${cnt} -gt 0 -a "${certnbr}" != "" ]
then
#为全量旧数据
importFlag="F"
else
#为增量空数据
importFlag="I"
fi
fi

if [ "${importFlag}" = "F" ]
then
##全量导数，改表名
shlog "full import data..."
renametable ${tblCust} ${tblCustTemp}
 callrst=$?
if [ $callrst -ne 0 ];
then
echo 1
return -1
else
updatestate ${tblCust}
fi
   
renametable ${tblCard} ${tblCardTemp}
callrst=$?
if [ $callrst -ne 0 ];
then
echo 1
return -1
else
updatestate ${tblCard}
fi 
else
##增量导数，合并数据
shlog "increase import data..."
         
mergecustdata ${tblCust} ${tblCustTemp} ${tblCustCol}
callrst=$?
 if [ $callrst -ne 0 ];
then
  echo 1
return -1
else
updatestate ${tblCust}
fi
   
mergecardcustdata ${tblCard} ${tblCardTemp} ${tblCardCol}
callrst=$?
 if [ $callrst -ne 0 ];
then
  echo 1
return -1
else
updatestate ${tblCard}
fi
fi
## 判断全量、增量 end ##

#loaddata ${dataHome}/${dataFileDesc}.dat ${tblDesc}
mergecardleveldata ${tblDesc} ${tblDescTemp} ${tblDescCol}
callrst=$?
if [ $callrst -ne 0 ];
then
echo 1
return -1
else
updatestate ${tblDesc}
fi

shlog "data import complete!"

shmkfile ${dataHome}/importData.ok

else
shlog "missing OK files or dat files!"
fi
else
shlog "data of ${dataHome} was already loaded!"
fi
d=`expr $d + 1 `
done

####cleanup Data####
#保留最近30天的数据
cd ${HOME_PATH}/ODS_data
ls -t | tail -n +31 | xargs rm -rf
echo 0

fi
else
#超过时间段的话直接返回0，等待第二天跑批
shlog "over time!"
  echo 0
fi
