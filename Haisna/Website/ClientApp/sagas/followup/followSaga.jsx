import { call, takeEvery, put } from 'redux-saga/effects';
import { initialize } from 'redux-form';
import * as contants from '../../constants/common';
import followService from '../../services/followup/followService';
import consultService from '../../services/reserve/consultService';
import pubNoteService from '../../services/preference/pubNoteService';
import judService from '../../services/preference/judService';
import freeService from '../../services/preference/freeService';
import hainsUserService from '../../services/preference/hainsUserService';
import {
  getFollowBeforeRequest,
  getFollowBeforeSuccess,
  getFollowBeforeFailure,
  getFollowItemRequest,
  getFollowItemSuccess,
  getFollowItemFailure,
  getConsultInfoRequest,
  getConsultInfoSuccess,
  getConsultInfoFailure,
  getTargetFollowInfoRequest,
  getTargetFollowInfoSuccess,
  getTargetFollowInfoFailure,
  registerFollowInfoRequest,
  registerFollowInfoSuccess,
  registerFollowInfoFailure,
  getPubNoteSuccess,
  getPubNoteFailure,
  // フォローアップ検索
  getFollowItemInfoRequest,
  getFollowItemInfoSuccess,
  getFollowItemInfoFailure,
  getTargetFollowListRequest,
  getTargetFollowListSuccess,
  getTargetFollowListFailure,
  registerFollowInfoListRequest,
  registerFollowInfoListSuccess,
  registerFollowInfoListFailure,
  // フォローアップの変更履歴
  getFollowLogListRequest,
  getFollowLogListSuccess,
  getFollowLogListFailure,
  // フォローアップの印刷履歴
  getFolReqHistoryRequest,
  getFolReqHistorySuccess,
  getFolReqHistoryFailure,
  // フォローアップの二次検診情報登録
  openFollowInfoEditGuideRequest,
  openFollowInfoEditGuideSuccess,
  openFollowInfoEditGuideFailure,
  updateFollowInfoRequest,
  updateFollowInfoSuccess,
  updateFollowInfoFailure,
  deleteFollowInfoRequest,
  deleteFollowInfoSuccess,
  deleteFollowInfoFailure,
  updateFollowInfoConfirmRequest,
  updateFollowInfoConfirmSuccess,
  updateFollowInfoConfirmFailure,
  // フォローアップの二次検診結果登録
  openFollowRslEditGuideRequest,
  openFollowRslEditGuideSuccess,
  openFollowRslEditGuideFailure,
  deleteFollowRslRequest,
  deleteFollowRslSuccess,
  deleteFollowRslFailure,
  updateFollowRslRequest,
  updateFollowRslSuccess,
  updateFollowRslFailure,
  // フォローアップの依頼状作成
  openFollowReqEditGuideRequest,
  openFollowReqEditGuideSuccess,
  openFollowReqEditGuideFailure,
} from '../../modules/followup/followModule';

// フォローアップの依頼状作成ガイドを開くアクション時の処理
function* runRequestOpenFollowReqEditGuide(action) {
  const { rsvno, judclasscd } = action.payload;
  try {
    // 指定予約番号のフォロー状況管理情報を取得処理実行
    const followInfo = yield call(followService.getFollowInfo, action.payload);
    // 受診情報を取得処理実行
    const consult = yield call(consultService.getConsult, action.payload);

    let realAge = null;
    const params = { birth: consult.birth, cslDate: consult.csldate };
    if (consult.birth !== null) {
      // 実年齢の計算
      realAge = yield call(freeService.calcAge, params);
      consult.age = parseInt(realAge.realAge, 10);
    }
    if (consult.lastname !== null && consult.firstname !== null) {
      consult.lastname = `${consult.lastname}`;
      consult.lastname += '　';
      consult.lastname += `${consult.firstname}`;
    } else {
      consult.lastname = null;
    }
    if (consult.lastkname !== null && consult.firstkname !== null) {
      consult.lastkname = `${consult.lastkname}`;
      consult.lastkname += '　';
      consult.lastkname += `${consult.firstkname}`;
    } else {
      consult.lastkname = null;
    }
    // ユーザ名取得
    const userid = 'HAINS$';
    const hainsUser = yield call(hainsUserService.getHainsUser, { userid });

    // 所見情報取得
    let folNote = '';
    let secEquipCourse = followInfo.secequipcourse;
    if (followInfo.judclasscd === 31) {
      folNote += '■ 子宮頸部細胞診 ベセスダ分類　：　';
      folNote += yield call(followService.getResult, { rsvno, itemcd: contants.ITEM_BETHESDA });
      folNote += '\n';
      folNote += '■ ＨＰＶ　：　';
      folNote += yield call(followService.getResult, { rsvno, itemcd: contants.ITEM_HPV });
      folNote += '\n';
    } else if (followInfo.judclasscd === 24) {
      folNote += '■ 乳房Ｘ線　：　';
      folNote += yield call(followService.getResult, { rsvno, itemcd: contants.ITEM_MMG_CATE });
      folNote += '\n';
      folNote += '■ 乳房超音波：　';
      folNote += yield call(followService.getResult, { rsvno, itemcd: contants.ITEM_BECHO_CATE });
      folNote += yield call(followService.getResult, { rsvno, itemcd: contants.ITEM_BECHO_OBS });
      folNote += '\n';
      if (followInfo.secequipcourse === null) {
        secEquipCourse = '乳腺外科';
      }
    }
    // 指定検索条件の依頼状作成を取得成功処理実行
    yield put(openFollowReqEditGuideSuccess({ consult, followInfo, rsvno, judclasscd, userid, username: hainsUser.username, folNote, secEquipCourse }));
  } catch (error) {
    // 指定検索条件の依頼状作成を取得失敗Actionを発生させる
    yield put(openFollowReqEditGuideFailure({ rsvno }));
  }
}

// 判定分類別フォローアップ情報保存処理
function* runRequestUpdateFollowRsl(action) {
  try {
    // フォローアップ情報承認（又は承認解除）処理実行
    yield call(followService.updateFollowRsl, action.payload);
    // 二次検診情報登録ガイドまた開く
    yield put(openFollowInfoEditGuideRequest(action.payload));
    // フォローアップ情報更新処理成功時を実行
    yield put(updateFollowRslSuccess());
  } catch (error) {
    // フォローアップ情報更新処理を更新失敗Actionを発生させる
    yield put(updateFollowRslFailure(error.response));
  }
}

// 判定分類別フォローアップ情報削除の処理
function* runRequestDeleteFollowRsl(action) {
  try {
    // 判定分類別フォローアップ情報削除処理実行
    yield call(followService.deleteFollowRsl, action.payload);
    // 二次検診情報登録ガイドまた開く
    yield put(openFollowInfoEditGuideRequest(action.payload));
    // 判定分類別フォローアップ情報削除成功時を実行
    yield put(deleteFollowRslSuccess());
  } catch (error) {
    // フォローアップ情報削除処理を更新失敗Actionを発生させる
    yield put(deleteFollowRslFailure(error.response));
  }
}

// フォローアップの二次検診結果登録ガイドを開くアクション時の処理
function* runRequestOpenFollowRslEditGuide(action) {
  const { rsvno, judclasscd, seq } = action.payload;
  let followRsl = {};
  try {
    // 指定予約番号のフォロー状況管理情報を取得処理実行
    const followInfo = yield call(followService.getFollowInfo, action.payload);
    // 結果情報の診断名を取得処理実行
    const disFollowRsl = yield call(followService.getFollowRsl, action.payload);
    if (disFollowRsl !== '') {
      followRsl = disFollowRsl;
    }
    // 対象全部位（臓器）別診断名（疾患）を基に疾患情報を取得）実行
    const rslItemList = yield call(followService.getFollowRslItemList, action.payload);
    const followRslItemList = [];
    let beforeGrpName = null;
    let t = 0;
    for (let j = 0; j < rslItemList.length; j += 1) {
      followRslItemList.push({
        key: t,
        grpname: null,
        itemcd: null,
        itemname: null,
        result: null,
        shortstc: null,
        suffix: null,
      });
      if (beforeGrpName !== rslItemList[j].grpname) {
        followRslItemList[t].grpname = rslItemList[j].grpname;
      }
      followRslItemList[t].itemcd = rslItemList[j].itemcd;
      followRslItemList[t].itemname = rslItemList[j].itemname;
      followRslItemList[t].result = rslItemList[j].result;
      followRslItemList[t].shortstc = rslItemList[j].shortstc;
      followRslItemList[t].suffix = rslItemList[j].suffix;
      beforeGrpName = rslItemList[j].grpname;
      t += 1;
    }
    // 指定検索条件の二次検診結果登録を取得成功処理実行
    yield put(openFollowRslEditGuideSuccess({ followInfo, followRsl, followRslItemList, rsvno, judclasscd, seq }));
  } catch (error) {
    // 指定検索条件の二次検診結果登録を取得失敗Actionを発生させる
    yield put(openFollowRslEditGuideFailure(error.response));
  }
}

// フォローアップ情報承認（又は承認解除）処理
function* runRequestUpdateFollowInfoConfirm(action) {
  const { rsvNo, judClassCd, conditions } = action.payload;
  try {
    // フォローアップ情報承認（又は承認解除）処理実行
    yield call(followService.updatefollowInfoConfirm, action.payload);
    // 二次検診情報登録ガイドまた開く
    yield put(openFollowInfoEditGuideRequest({ rsvno: rsvNo, judclasscd: judClassCd }));
    // フォローアップ検索取得
    yield put(getTargetFollowListRequest(conditions));
    // フォローアップ情報更新処理成功時を実行
    yield put(updateFollowInfoConfirmSuccess());
  } catch (error) {
    // フォローアップ情報更新処理を更新失敗Actionを発生させる
    yield put(updateFollowInfoConfirmFailure(error.response));
  }
}

// フォローアップ情報削除処理処理
function* runRequestDeleteFollowInfo(action) {
  const { conditions } = action.payload;
  try {
    // フォローアップ情報削除処理実行
    yield call(followService.deleteFollowInfo, action.payload);
    // フォローアップ検索取得
    yield put(getTargetFollowListRequest(conditions));
    // フォローアップ情報削除処理成功時を実行
    yield put(deleteFollowInfoSuccess());
  } catch (error) {
    // フォローアップ情報削除処理を更新失敗Actionを発生させる
    yield put(deleteFollowInfoFailure(error.response));
  }
}

// 判定分類別フォローアップ情報保存処理
function* runRequestUpdateFollowInfo(action) {
  const { rsvNo, judClassCd, conditions } = action.payload;
  try {
    // 判定分類別フォローアップ情報保存実行
    yield call(followService.updateFollowInfo, action.payload);
    // 二次検診情報登録ガイドまた開く
    yield put(openFollowInfoEditGuideRequest({ rsvno: rsvNo, judclasscd: judClassCd }));
    // フォローアップ検索取得
    yield put(getTargetFollowListRequest(conditions));
    // フォローアップ情報更新処理成功時を実行
    yield put(updateFollowInfoSuccess());
  } catch (error) {
    // フォローアップ情報更新処理を更新失敗Actionを発生させる
    yield put(updateFollowInfoFailure(error.response));
  }
}

// フォローアップの二次検診情報登録ガイドを開くアクション時の処理
function* runRequestOpenFollowInfoEditGuide(action) {
  const { rsvno, judclasscd } = action.payload;
  const disRslItemList = [];
  let followRslList = [];
  // 判定の一覧を取得処理実行
  const judList = yield call(judService.getJudList);
  // 指定予約番号のフォロー状況管理情報を取得処理実行
  const followInfo = yield call(followService.getFollowInfo, action.payload);
  try {
    // 結果情報の診断名を取得処理実行
    followRslList = yield call(followService.getFollowRslList, action.payload);
  } catch (error) {
    yield put(openFollowInfoEditGuideFailure());
  }
  for (let i = 0; i < followRslList.length; i += 1) {
    const params = { rsvno: followRslList[i].rsvno, judclasscd: followRslList[i].judclasscd, seq: followRslList[i].seq, rslFlg: true };
    let rslItemList = [];
    try {
      // 二次検査結果情報別疾患（診断名）情報取得処理実行
      rslItemList = yield call(followService.getFollowRslItemList, params);
    } catch (error) {
      yield put(openFollowInfoEditGuideFailure());
    }
    const followRslItemList = [];
    let beforeGrpName = null;
    let t = 0;
    for (let j = 0; j < rslItemList.length; j += 1) {
      followRslItemList.push({
        key: t,
        grpname: null,
        itemcd: null,
        itemname: null,
        result: null,
        shortstc: null,
        suffix: null,
      });
      if (beforeGrpName !== rslItemList[j].grpname) {
        followRslItemList[t].grpname = rslItemList[j].grpname;
      }
      followRslItemList[t].itemcd = rslItemList[j].itemcd;
      followRslItemList[t].itemname = rslItemList[j].itemname;
      followRslItemList[t].result = rslItemList[j].result;
      followRslItemList[t].shortstc = rslItemList[j].shortstc;
      followRslItemList[t].suffix = rslItemList[j].suffix;
      beforeGrpName = rslItemList[j].grpname;
      t += 1;
    }
    disRslItemList.push(followRslItemList);
  }
  // 指定検索条件の二次検診情報登録を取得成功処理実行
  yield put(openFollowInfoEditGuideSuccess({ judList, followInfo, followRslList, disRslItemList, rsvno, judclasscd }));
}

// 指定検索条件の印刷履歴歴取得する
function* runRequestFolReqHistory(action) {
  const { rsvno } = action.payload;
  try {
    // フォロー対象検査情報取得処理実行
    const followItem = yield call(followService.getFollowItem, action.payload);
    // 指定検索条件の印刷履歴を取得処理実行
    const folReqHistory = yield call(followService.getFolReqHistory, action.payload);
    // 指定検索条件の印刷履歴を取得成功処理実行
    yield put(getFolReqHistorySuccess({ followItem, folReqHistory, rsvno }));
  } catch (error) {
    // 指定検索条件の印刷履歴を取得失敗Actionを発生させる
    yield put(getFolReqHistoryFailure(error.response));
  }
}

// 指定検索条件の変更履歴を取得する
function* runRequestFollowLogList(action) {
  const { conditions } = action.payload;
  try {
    // 指定検索条件の変更履歴を取得処理実行
    const payload = yield call(followService.getFollowLogList, conditions);
    // 指定検索条件の変更履歴を取得成功処理実行
    yield put(getFollowLogListSuccess(payload));
  } catch (error) {
    // 指定検索条件の変更履歴を取得失敗Actionを発生させる
    yield put(getFollowLogListFailure(error.response));
  }
}

// 受診者・検査項目毎に二次検査実施区分（医療施設区分）、判定結果を一括で登録Action発生時に起動するメソッド
function* runRegisterFollowInfoList(action) {
  const { formValues } = action.payload;
  try {
    // フォロー対象検査情報取得
    yield put(getFollowItemInfoRequest());
    // 受診者・検査項目毎に二次検査実施区分（医療施設区分）、判定結果を一括で登録処理実行
    yield call(followService.insertFollowInfo, action.payload);
    // フォローアップ検索取得
    yield put(getTargetFollowListRequest(formValues));
    // 受診者・検査項目毎に二次検査実施区分（医療施設区分）、判定結果を一括で登録成功処理実行
    yield put(registerFollowInfoListSuccess());
  } catch (error) {
    // 受診者・検査項目毎に二次検査実施区分（医療施設区分）、判定結果を一括で登録失敗Actionを発生させる
    yield put(registerFollowInfoListFailure(error.response));
  }
}

// フォローアップ検索取得Action発生時に起動するメソッド
function* runRequestTargetFollowList(action) {
  const conditions = action.payload;
  const message = [];
  const { startCslDate, endCslDate, pageMaxLine, judClassCd, equipDiv, confirmDiv, addUser, perId } = action.payload;

  if (startCslDate === null) {
    message.push('受診日の指定に誤りがあります。');
  }

  if (startCslDate !== null && endCslDate !== null) {
    if ((new Date(endCslDate) - new Date(startCslDate)) / 86400000 > 120) {
      message.push('受診日範囲は120日以内で指定して下さい。');
    }
  }
  if (message.length > 0) {
    yield put(getTargetFollowListFailure({ message }));
    return;
  }
  try {
    // フォローアップ検索取得処理実行
    const payload = yield call(followService.getTargetFollowList, action.payload);
    const { data, totalcount } = payload;
    const targetFollowList = [];
    let t = 0;
    const values = { startCslDate, endCslDate, pageMaxLine, judClassCd, equipDiv, confirmDiv, addUser, perId };
    if (totalcount > 0) {
      let beforeRsvNo = '';
      for (let i = 0; i < data.length; i += 1) {
        let webCslDate = '';
        let webDayId = '';
        let webPerId = '';
        let webPerKName = '';
        let webPerName = '';
        let webAge = '';
        let webGender = '';
        let webBirth = '';
        const webJudClassName = data[i].judclassname;
        const webJudCd = data[i].judcd;
        const webRslJudCd = data[i].rsljudcd;
        const webEquipDiv = data[i].equipdiv;
        const webEquipDivName = '';
        const webStatusCd = data[i].statuscd;
        const webStatusName = '';
        const webPrtSeq = data[i].prtseq;
        const webFileName = data[i].filename;
        const webPrtDate = data[i].prtdate;
        const webPrtUser = data[i].prtuser;
        let webRsvNo = data[i].rsvno;
        const webAddUser = data[i].adduser;
        let webDocJud = '';
        let webDocGf = '';
        let webDocCf = '';
        let webDocGyne = '';
        let webDocGyneJud = '';
        if (beforeRsvNo !== data[i].rsvno) {
          webCslDate = data[i].csldate;
          webDayId = `000${data[i].dayid}`.slice(-4);
          webPerId = data[i].perid;
          webPerKName = data[i].perkname;
          webPerName = data[i].pername;
          webAge = `${data[i].age}歳`;
          webGender = data[i].gender;
          webBirth = data[i].birth;
          webRsvNo = data[i].rsvno;
          webDocJud = data[i].doc_jud;
          webDocGf = data[i].doc_gf;
          webDocCf = data[i].doc_cf;
          webDocGyne = data[i].doc_gyne;
          webDocGyneJud = data[i].doc_gynejud;
        }
        beforeRsvNo = data[i].rsvno;
        targetFollowList.push({
          key: t,
          webCslDate: null,
          webDayId: null,
          webPerId: null,
          webAge: null,
          webPerKName: null,
          webPerName: null,
          webGender: null,
          webBirth: null,
          webJudClassName: null,
          csCD: null,
          webJudCd: null,
          judCd: null,
          rslJudCd: null,
          webRslJudCd: null,
          webEquipDiv: null,
          equipDiv: null,
          statusCd: null,
          prtSeq: null,
          reqConfirmDate: null,
          reqConfirmUser: null,
          addUser: null,
          docJud: null,
          docGf: null,
          docCf: null,
          docGyne: null,
          docGyneJud: null,
          judClassCd: null,
          webEquipDivName: null,
          webStatusCd: null,
          webStatusName: null,
          webPrtSeq: null,
          webFileName: null,
          webPrtDate: null,
          webPrtUser: null,
          webRsvNo: null,
          webAddUser: null,
          webDocJud: null,
          webDocGf: null,
          webDocCf: null,
          webDocGyne: null,
          webDocGyneJud: null,
        });

        targetFollowList[t].webCslDate = webCslDate;
        targetFollowList[t].webDayId = webDayId;
        targetFollowList[t].webPerId = webPerId;
        targetFollowList[t].webPerKName = webPerKName;
        targetFollowList[t].webPerName = webPerName;
        targetFollowList[t].webAge = webAge;
        targetFollowList[t].webGender = webGender;
        targetFollowList[t].webBirth = webBirth;
        targetFollowList[t].webJudClassName = webJudClassName;
        targetFollowList[t].csCd = data[i].cscd;
        targetFollowList[t].webJudCd = webJudCd;
        targetFollowList[t].judCd = data[i].judcd;
        targetFollowList[t].rslJudCd = data[i].rsljudcd;
        targetFollowList[t].webRslJudCd = webRslJudCd;
        targetFollowList[t].webEquipDiv = webEquipDiv;
        targetFollowList[t].equipDiv = data[i].equipdiv;
        targetFollowList[t].statusCd = data[i].statuscd;
        targetFollowList[t].prtSeq = data[i].prtseq;
        targetFollowList[t].reqConfirmDate = data[i].reqconfirmdate;
        targetFollowList[t].reqConfirmUser = data[i].reqconfirmuser;
        targetFollowList[t].addUser = data[i].adduser;
        targetFollowList[t].docJud = data[i].doc_jud;
        targetFollowList[t].docGf = data[i].doc_gf;
        targetFollowList[t].docCf = data[i].doc_cf;
        targetFollowList[t].docGyne = data[i].doc_gyne;
        targetFollowList[t].docGyneJud = data[i].doc_gynejud;
        targetFollowList[t].judClassCd = data[i].judclasscd;
        targetFollowList[t].webEquipDivName = webEquipDivName;
        targetFollowList[t].webStatusCd = webStatusCd;
        targetFollowList[t].webStatusName = webStatusName;
        targetFollowList[t].webPrtSeq = webPrtSeq;
        targetFollowList[t].webFileName = webFileName;
        targetFollowList[t].webPrtDate = webPrtDate;
        targetFollowList[t].webPrtUser = webPrtUser;
        targetFollowList[t].webRsvNo = webRsvNo;
        targetFollowList[t].webAddUser = webAddUser;
        targetFollowList[t].webDocJud = webDocJud;
        targetFollowList[t].webDocGf = webDocGf;
        targetFollowList[t].webDocCf = webDocCf;
        targetFollowList[t].webDocGyne = webDocGyne;
        targetFollowList[t].webDocGyneJud = webDocGyneJud;
        t += 1;
      }
    }
    // フォローアップ検索取得成功Actionを発生させる
    yield put(getTargetFollowListSuccess({ targetFollowList, totalcount, conditions }));
    yield put(initialize('FollowInfoList', values));
  } catch (error) {
    // フォローアップ検索取得失敗Actionを発生させる
    yield put(getTargetFollowListFailure(error.response));
  }
}

// フォロー対象検査情報取得Action発生時に起動するメソッド
function* runRequestFollowItemInfo(action) {
  try {
    // フォロー対象検査情報取得処理実行
    const followItem = yield call(followService.getFollowItem, action.payload);
    // フォロー対象検査情報取得成功Actionを発生させる
    yield put(getFollowItemInfoSuccess(followItem));
  } catch (error) {
    // フォロー対象検査情報取得失敗Actionを発生させる
    yield put(getFollowItemInfoFailure(error.response));
  }
}

// 指定予約番号の直前のフォロー情報を取得
function* rungetFollowBefore(action) {
  try {
    // 指定予約番号の直前のフォロー情報を取得処理実行
    const payload = yield call(followService.getFollowBefore, action.payload);
    yield put(getFollowBeforeSuccess(payload));
  } catch (error) {
    // 指定予約番号の直前のフォロー情報を取得失敗Actionを発生させる
    yield put(getFollowBeforeFailure(error.response));
  }
}

// フォロー対象検査情報取得Action発生時に起動するメソッド
function* runRequestFollowItem(action) {
  try {
    // フォロー対象検査情報取得処理実行
    const payload = yield call(followService.getFollowItem, action.payload);
    // フォロー対象検査情報取得成功Actionを発生させる
    yield put(getFollowItemSuccess(payload));
  } catch (error) {
    // フォロー対象検査情報取得失敗Actionを発生させる
    yield put(getFollowItemFailure(error.response));
  }
}

// 受診情報と受診歴情報取得Action発生時に起動するメソッド
function* runRequestConsultInfo(action) {
  try {
    const params = action.payload;
    const { motorsvno } = params;
    let { rsvno } = params;
    // 一度も表示していない場合は予約番号を退避する
    if (motorsvno !== undefined && motorsvno !== null) {
      rsvno = motorsvno;
    }
    // 受診情報取得処理実行
    const consultData = yield call(consultService.getConsult, action.payload);
    // 個人ID情報取得
    const { perid } = consultData;
    // 受診歴情報取得処理実行
    const followHistoryData = yield call(followService.getFollowHistory, { perid, rsvno });
    // 受診情報と受診歴情報取得成功Actionを発生させる
    yield put(getConsultInfoSuccess({ consultData, followHistoryData }));
  } catch (error) {
    // 受診情報と受診歴情報取得失敗Actionを発生させる
    yield put(getConsultInfoFailure(error.response));
  }

  try {
    // チャート情報を取得する処理実行
    const params = { ...action.payload, selInfo: 0, histFlg: 0, seq: 0, pubNoteDivCd: 500, dispKbn: 1 };
    let payload = yield call(pubNoteService.getPubNote, params);
    // チャート情報を取得する成功Actionを発生させる
    if (payload === '') {
      payload = { data: [] };
      yield put(getPubNoteSuccess(payload));
    }
    yield put(getPubNoteSuccess(payload));
  } catch (error) {
    // チャート情報を取得する失敗Actionを発生させる
    yield put(getPubNoteFailure(error.response));
  }
}

// 指定予約番号の基準値以上判定情報（フォロー対象情報）取得Action発生時に起動するメソッド
function* runRequesttargetFollow(action) {
  try {
    const { formName, rsvno, judFlg } = action.payload;
    // 指定予約番号の基準値以上判定情報（フォロー対象情報）取得処理実行
    const targetFollowData = yield call(followService.getTargetFollow, { formName, rsvno, judFlg });
    let parajudFlg = 0;
    if (judFlg === false) {
      parajudFlg = 0;
    } else {
      parajudFlg = 1;
    }
    yield put(initialize(formName, { targetFollowData, csldate: rsvno, judFlg: parajudFlg }));
    // 指定予約番号の基準値以上判定情報（フォロー対象情報）取得成功処理実行
    yield put(getTargetFollowInfoSuccess(targetFollowData));
  } catch (error) {
    // 指定予約番号の基準値以上判定情報（フォロー対象情報）取得失敗処理実行
    yield put(getTargetFollowInfoFailure(error.response));
  }
}
// 受診者・検査項目毎に二次検査実施区分（医療施設区分）、判定結果を一括で登録Action発生時に起動するメソッド
function* runRegisterFollowInfo(action) {
  try {
    // 受診者・検査項目毎に二次検査実施区分（医療施設区分）、判定結果を一括で登録処理実行
    yield call(followService.insertFollowInfo, action.payload);
    // 受診者・検査項目毎に二次検査実施区分（医療施設区分）、判定結果を一括で登録成功処理実行
    yield put(registerFollowInfoSuccess());
    const { formName, rsvno, judFlg } = action.payload;
    // 指定予約番号の基準値以上判定情報（フォロー対象情報）取得処理実行
    const targetFollowData = yield call(followService.getTargetFollow, { formName, rsvno, judFlg });
    let parajudFlg = 0;
    if (judFlg === false) {
      parajudFlg = 0;
    } else {
      parajudFlg = 1;
    }
    yield put(initialize(formName, { targetFollowData, csldate: rsvno, judFlg: parajudFlg }));
    // 指定予約番号の基準値以上判定情報（フォロー対象情報）取得成功処理実行
    yield put(getTargetFollowInfoSuccess(targetFollowData));
  } catch (error) {
    // 受診者・検査項目毎に二次検査実施区分（医療施設区分）、判定結果を一括で登録失敗Actionを発生させる
    yield put(registerFollowInfoFailure(error.response));
  }
}

// Actionとその発生時に実行するメソッドをリンクさせる
const followSagas = [
  takeEvery(getFollowBeforeRequest.toString(), rungetFollowBefore),
  takeEvery(getFollowItemRequest.toString(), runRequestFollowItem),
  takeEvery(getConsultInfoRequest.toString(), runRequestConsultInfo),
  takeEvery(getTargetFollowInfoRequest.toString(), runRequesttargetFollow),
  takeEvery(registerFollowInfoRequest.toString(), runRegisterFollowInfo),
  takeEvery(getFollowItemInfoRequest.toString(), runRequestFollowItemInfo),
  takeEvery(getTargetFollowListRequest.toString(), runRequestTargetFollowList),
  takeEvery(registerFollowInfoListRequest.toString(), runRegisterFollowInfoList),
  takeEvery(getFollowLogListRequest.toString(), runRequestFollowLogList),
  takeEvery(getFolReqHistoryRequest.toString(), runRequestFolReqHistory),
  takeEvery(openFollowInfoEditGuideRequest.toString(), runRequestOpenFollowInfoEditGuide),
  takeEvery(updateFollowInfoRequest.toString(), runRequestUpdateFollowInfo),
  takeEvery(deleteFollowInfoRequest.toString(), runRequestDeleteFollowInfo),
  takeEvery(updateFollowInfoConfirmRequest.toString(), runRequestUpdateFollowInfoConfirm),
  takeEvery(openFollowRslEditGuideRequest.toString(), runRequestOpenFollowRslEditGuide),
  takeEvery(deleteFollowRslRequest.toString(), runRequestDeleteFollowRsl),
  takeEvery(updateFollowRslRequest.toString(), runRequestUpdateFollowRsl),
  takeEvery(openFollowReqEditGuideRequest.toString(), runRequestOpenFollowReqEditGuide),
];

export default followSagas;
