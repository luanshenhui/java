import { call, takeEvery, put } from 'redux-saga/effects';
import moment from 'moment';

import pubNoteService from '../../services/preference/pubNoteService';
import hainsUserService from '../../services/preference/hainsUserService';
import consultService from '../../services/reserve/consultService';
import personService from '../../services/preference/personService';
import freeService from '../../services/preference/freeService';

import {
  openCommentDetailGuide,
  loadCommentDetailSuccess,
  loadCommentDetailFailure,
  registerPubNoteRequest,
  registerPubNoteSuccess,
  registerPubNoteFailure,
  deletePubNoteRequest,
  deletePubNoteSuccess,
  deletePubNoteFailure,
  loadCommentListFlameGuideRequest,
  loadCommentListFlameGuideSuccess,
  loadCommentListFlameGuideFailure,
  searchCommentListRequest,
  searchCommentListSuccess,
  searchCommentListFailure,
} from '../../modules/preference/pubNoteModule';

// 受診情報
const COMMENTLIST_SELINFO_CSL = 1;
// 個人
const COMMENTLIST_SELINFO_PER = 2;
// 団体
const COMMENTLIST_SELINFO_ORG = 3;
// 契約
const COMMENTLIST_SELINFO_CTR = 4;
// 個人＋受診
const COMMENTLIST_SELINFO_ALL = 0;
// 今回
const COMMENTLIST_HISTFLG_NOW = 0;
// 過去
const COMMENTLIST_HISTFLG_OLD = 1;
// 全件
const COMMENTLIST_HISTFLG_ALL = 2;

// コメント情報詳細初期化Action発生時に起動するメソッド
function* runRequestCommentDetail(action) {
  try {
    const { seq, rsvno, perid, cmtmode, pubnotedivcd } = action.payload.conditions;
    const arrCmtmode = cmtmode.split(',');
    let selinfo = '';
    for (let i = 0; i < 4; i += 1) {
      // 対象コメント
      if (arrCmtmode[i] === '1') {
        // 修正時ですでに対象コメントが決まっている
        if (selinfo !== '') {
          if (seq && seq > 0) {
            // コメント情報詳細失敗Actionを発生させる
            const error = [`パラメータ：対象コメントが不正です（CmtMode=${cmtmode})`];
            yield put(loadCommentDetailFailure({ errkbn: 1, error }));
            return;
          }
        } else {
          selinfo = (i + 1).toString();
        }
      }
    }

    // ユーザ情報処理実行
    // TODO
    const userid = 'HAINS$';
    const userdata = yield call(hainsUserService.getHainsUser, { userid });

    let consultdata = {};
    if (rsvno && rsvno !== null && Number.parseInt(rsvno, 10) > 0) {
      try {
        // 受診情報取得処理実行
        consultdata = yield call(consultService.getConsult, { rsvno });
      } catch (error) {
        // 受診情報取得失敗Actionを発生させる
        yield put(loadCommentDetailFailure({ errkbn: 2, error: error.response, rsvno }));
        return;
      }
    }

    let perdata = {};
    if (perid && perid !== '') {
      const params = { perid };
      try {
        // 個人ＩＤ情報取得処理実行
        perdata = yield call(personService.getPersonInf, { params });
      } catch (error) {
        // 個人ＩＤ情報取得失敗Actionを発生させる
        yield put(loadCommentDetailFailure({ errkbn: 3, error: error.response, perid }));
        return;
      }
    }

    let data = {};
    let notedivcd = {};
    if (seq && seq > 0) {
      // 更新モード
      try {
        const { conditions } = action.payload;
        // コメント情報取得処理実行
        const pubNotedata = yield call(pubNoteService.getPubNote, { ...conditions, selinfo, histflg: 0, incdelnote: '1' });
        if (pubNotedata && pubNotedata.length > 0) {
          data = { ...pubNotedata[0], selinfo, cmtmode };
        }
      } catch (error) {
        yield put(loadCommentDetailFailure({ errkbn: 4, error: error.response, seq }));
      }
    } else {
      // 新規モード
      let dispkbn = '';
      let onlyDispKbn = '';
      let wkPubnotedivcd = pubnotedivcd;
      const dispcolor = '';
      const { username } = userdata;
      if (pubnotedivcd && pubnotedivcd !== '') {
        // コメント情報取得処理実行
        notedivcd = yield call(pubNoteService.getPubNoteDiv, { pubnotedivcd });
        onlyDispKbn = notedivcd.onlydispkbn;
      } else {
        wkPubnotedivcd = '100';
      }
      dispkbn = dispkbn === '' ? userdata.defnotedispkbn : dispkbn;
      dispkbn = dispkbn === '' ? userdata.authnote : dispkbn;
      dispkbn = dispkbn === '' ? '3' : dispkbn;
      data = { ...data, dispkbn, pubnotedivcd: wkPubnotedivcd, username, dispcolor, selinfo, onlydispkbn: onlyDispKbn, cmtmode };
    }
    // コメント情報詳細成功Actionを発生させる
    yield put(loadCommentDetailSuccess({ userdata, consultdata, perdata: perdata.data, data }));
  } catch (error) {
    // コメント情報詳細失敗Actionを発生させる
    yield put(loadCommentDetailFailure(error.response));
  }
}

// コメント情報登録処理Action発生時に起動するメソッド
function* runRegisterPubNote(action) {
  try {
    const { data } = action.payload;
    const { boldflg, rsvno } = data;
    // コメント情報登録処理開始時の処理実行
    const payload = yield call(pubNoteService.registerPubNote, { data: { ...data, rsvno: rsvno === null ? 0 : rsvno, boldflg: boldflg === null ? 0 : boldflg } });
    // コメント情報登録処理成功Actionを発生させる
    yield put(registerPubNoteSuccess(payload));
  } catch (error) {
    // コメント情報登録処理失敗Actionを発生させる
    yield put(registerPubNoteFailure(error.response));
  }
}

// コメント情報削除処理Action発生時に起動するメソッド
function* runDeletePubNote(action) {
  try {
    // コメント情報削除処理開始時の処理実行
    const payload = yield call(pubNoteService.deletePubNote, action.payload);
    // コメント情報削除処理成功Actionを発生させる
    yield put(deletePubNoteSuccess(payload));
  } catch (error) {
    // コメント情報削除処理失敗Actionを発生させる
    yield put(deletePubNoteFailure(error.response));
  }
}

// コメント画面の初期処理Action発生時に起動するメソッド
function* runLoadCommentListFlameGuide(action) {
  try {
    const { params } = action.payload;
    // TODO
    params.userid = 'HAINS$';
    const hainsUserData = yield call(hainsUserService.getHainsUser, params);
    let consult = {};
    let free = {};
    const pubNoteData1 = {};
    const pubNoteData2 = {};
    const pubNoteData3 = {};
    const pubNoteData4 = {};
    const pubNoteData5 = {};
    const pubNoteData6 = {};
    // 予約番号、個人ID、団体コード、契約パターンコードのどれも指定されていない
    if (params.rsvno === null && params.perid === null && params.ctrptcd === null && params.orgcd1 === null && params.orgcd2 === null) {
      const error = { data: ['予約番号、個人ID、団体コード、契約パターンコードのいずれか一つを必ず指定してください'] };
      yield put(loadCommentListFlameGuideFailure(error));
      return;
    }


    if (params.rsvno && params.rsvno !== null && params.rsvno > 0) {
      consult = yield call(consultService.getConsult, params);
      params.orgcd1 = consult.orgcd1;
      params.orgcd2 = consult.orgcd2;
    }
    if (params.act === null || params.act === undefined) {
      params.freecd = 'CMTPERIOD';
      params.mode = 0;
      free = yield call(freeService.getFree, params);
      if (free.length > 0) {
        if (free[0].freefield2 !== '') {
          if (Number(free[0].freefield2) < 0) {
            if (params.startdate === null || params.startdate === undefined) {
              if (params.dispmode === '4' || params.dispmode === '5') {
                params.startdate = moment().format('YYYY/MM/DD');
              } else {
                let formmat = free[0].freefield1.toLowerCase();
                if (formmat === 'yyyy') {
                  formmat = 'years';
                } else if (formmat === 'mm') {
                  formmat = 'months';
                } else if (formmat === 'dd') {
                  formmat = 'days';
                }
                params.startdate = moment().add(Number(free[0].freefield2), formmat).format('YYYY/MM/DD');
              }
            }
            if (params.enddate === null || params.enddate === undefined) {
              params.enddate = moment().format('YYYY/MM/DD');
            }
          } else {
            if (params.startdate === null || params.startdate === undefined) {
              params.strdate = moment().format('YYYY/MM/DD');
            }
            if (params.enddate === null || params.enddate === undefined) {
              if (params.dispmode === '4' || params.dispmode === '5') {
                params.enddate = moment().format('YYYY/MM/DD');
              } else {
                params.enddate = new Date().setDate(new Date().getDate() + Number(free[0].freefield2));
              }
            }
          }
        }
      }
      params.act = 'search';
    }
    if (hainsUserData.authnote === 1) {
      // 医療のみ
      params.dispkbn = hainsUserData.authnote;
    } else if (hainsUserData.authnote === 2) {
      // 事務のみ
      params.dispkbn = hainsUserData.authnote;
    }

    const type = [];
    // 個人＋今回受診＋過去受診
    if (params.dispmode === '0') {
      type.push(1);
      type.push(2);
      type.push(3);
    // 個人・受診＋団体＋契約
    } else if (params.dispmode === '1') {
      type.push(4);
      type.push(5);
      type.push(6);
      params.Chk = 1;
      // 個人・受診（面接支援のチャート情報、注意事項専用）
    } else if (params.dispmode === '2') {
      type.push(4);
      // 個人
    } else if (params.dispmode === '3') {
      type.push(1);
      // 団体
    } else if (params.dispmode === '4') {
      type.push(5);
      // 請求
    } else if (params.dispmode === '5') {
      type.push(6);
    }

    for (let i = 0; i < type.length; i += 1) {
      let selInfo;
      let histFlg;
      let title;
      const arrDataName = [];
      // 個人
      if (type[i] === 1) {
        selInfo = COMMENTLIST_SELINFO_PER;
        histFlg = COMMENTLIST_HISTFLG_NOW;
        title = '個人に対するコメント一覧';
        arrDataName.push('コメント種類');
        arrDataName.push('内容');
        arrDataName.push('オペレータ名');
        arrDataName.push('更新日時');
        // 今回受診情報
      } else if (type[i] === 2) {
        selInfo = COMMENTLIST_SELINFO_CSL;
        histFlg = COMMENTLIST_HISTFLG_NOW;
        title = '今回受診情報に対するコメント一覧';
        arrDataName.push('コメント種類');
        arrDataName.push('内容');
        arrDataName.push('オペレータ名');
        arrDataName.push('更新日時');
        // 過去受診情報
      } else if (type[i] === 3) {
        selInfo = COMMENTLIST_SELINFO_CSL;
        histFlg = COMMENTLIST_HISTFLG_OLD;
        title = '過去受診情報に対するコメント一覧';
        arrDataName.push('コメント種類');
        arrDataName.push('受診日');
        arrDataName.push('内容');
        arrDataName.push('コース');
        arrDataName.push('オペレータ名');
        arrDataName.push('更新日時');
        // 個人＋受診情報
      } else if (type[i] === 4) {
        selInfo = COMMENTLIST_SELINFO_ALL;
        histFlg = COMMENTLIST_HISTFLG_ALL;
        title = '';
        arrDataName.push('コメント種類');
        arrDataName.push('対象コメント');
        arrDataName.push('受診日');
        arrDataName.push('内容');
        arrDataName.push('オペレータ名');
        arrDataName.push('更新日時');
        // 契約
      } else if (type[i] === 5) {
        selInfo = COMMENTLIST_SELINFO_CTR;
        histFlg = COMMENTLIST_HISTFLG_ALL;
        title = '契約に対するコメント一覧';
        arrDataName.push('コメント種類');
        arrDataName.push('内容');
        arrDataName.push('オペレータ名');
        arrDataName.push('更新日時');
        // 団体
      } else if (type[i] === 6) {
        selInfo = COMMENTLIST_SELINFO_ORG;
        histFlg = COMMENTLIST_HISTFLG_NOW;
        title = '団体に対するコメント一覧';
        arrDataName.push('コメント種類');
        arrDataName.push('内容');
        arrDataName.push('オペレータ名');
        arrDataName.push('更新日時');
      }

      params.selinfo = selInfo;
      params.histflg = histFlg;
      const pubNotedata = yield call(pubNoteService.getPubNote, params);
      for (let j = 0; j < pubNotedata.length; j += 1) {
        pubNotedata[j].key = j;
      }
      // 個人
      if (type[i] === 1) {
        pubNoteData1.title = title;
        pubNoteData1.dataNames = arrDataName;
        pubNoteData1.dataContent = pubNotedata;
        // 今回受診情報
      } else if (type[i] === 2) {
        pubNoteData2.title = title;
        pubNoteData2.dataNames = arrDataName;
        pubNoteData2.dataContent = pubNotedata;
        // 過去受診情報
      } else if (type[i] === 3) {
        pubNoteData3.title = title;
        pubNoteData3.dataNames = arrDataName;
        pubNoteData3.dataContent = pubNotedata;
        // 個人＋受診情報
      } else if (type[i] === 4) {
        pubNoteData4.title = title;
        pubNoteData4.dataNames = arrDataName;
        pubNoteData4.dataContent = pubNotedata;
        // 契約
      } else if (type[i] === 5) {
        pubNoteData5.title = title;
        pubNoteData5.dataNames = arrDataName;
        pubNoteData5.dataContent = pubNotedata;
        // 団体
      } else if (type[i] === 6) {
        pubNoteData6.title = title;
        pubNoteData6.dataNames = arrDataName;
        pubNoteData6.dataContent = pubNotedata;
      }
    }
    const payload = { consult, free, hainsUserData, params, pubNoteData1, pubNoteData2, pubNoteData3, pubNoteData4, pubNoteData5, pubNoteData6 };
    // コメント情報削除処理成功Actionを発生させる
    yield put(loadCommentListFlameGuideSuccess(payload));
  } catch (error) {
    // コメント情報削除処理失敗Actionを発生させる
    yield put(loadCommentListFlameGuideFailure(error.response));
  }
}

// コメント検索処理Action発生時に起動するメソッド
function* runSearchCommentList(action) {
  try {
    const { params } = action.payload;
    const pubNoteData1 = {};
    const pubNoteData2 = {};
    const pubNoteData3 = {};
    const pubNoteData4 = {};
    const pubNoteData5 = {};
    const pubNoteData6 = {};
    // 表示期間(開始)
    let dtmStrDate;
    // 表示期間(終了)
    let dtmEndDate;
    // 日付
    let dtmDate;

    if (params.act !== null) {
      if (params.startdate !== null && params.startdate !== undefined) {
        dtmStrDate = params.startdate;
      } else {
        dtmStrDate = 0;
      }

      if (params.enddate !== null && params.enddate !== undefined) {
        dtmEndDate = params.enddate;
      } else {
        dtmEndDate = 0;
      }

      // 終了日未設定時は何もしない
      if (dtmEndDate !== 0) {
        if (dtmStrDate === 0 || (moment(dtmStrDate) > moment(dtmEndDate))) {
          // 値を交換
          dtmDate = dtmStrDate;
          dtmStrDate = dtmEndDate;
          dtmEndDate = dtmDate;
        }
      }

      // 後の処理のために年月日を再編集
      if (dtmStrDate !== 0) {
        params.startdate = dtmStrDate;
      } else {
        params.startdate = null;
      }

      if (dtmEndDate !== 0) {
        params.enddate = dtmEndDate;
      } else {
        params.enddate = null;
      }
    }

    const type = [];
    // 個人＋今回受診＋過去受診
    if (params.dispmode === '0') {
      type.push(1);
      type.push(2);
      type.push(3);
      // 個人・受診＋団体＋契約
    } else if (params.dispmode === '1') {
      type.push(4);
      type.push(5);
      type.push(6);
      // 個人・受診（面接支援のチャート情報、注意事項専用）
    } else if (params.dispmode === '2') {
      type.push(4);
      // 個人
    } else if (params.dispmode === '3') {
      type.push(1);
      // 団体
    } else if (params.dispmode === '4') {
      type.push(5);
      // 請求
    } else if (params.dispmode === '5') {
      type.push(6);
    }

    for (let i = 0; i < type.length; i += 1) {
      let selInfo;
      let histFlg;
      let title;
      const arrDataName = [];
      // 個人
      if (type[i] === 1) {
        selInfo = COMMENTLIST_SELINFO_PER;
        histFlg = COMMENTLIST_HISTFLG_NOW;
        title = '個人に対するコメント一覧';
        arrDataName.push('コメント種類');
        arrDataName.push('内容');
        arrDataName.push('オペレータ名');
        arrDataName.push('更新日時');
        // 今回受診情報
      } else if (type[i] === 2) {
        selInfo = COMMENTLIST_SELINFO_CSL;
        histFlg = COMMENTLIST_HISTFLG_NOW;
        title = '今回受診情報に対するコメント一覧';
        arrDataName.push('コメント種類');
        arrDataName.push('内容');
        arrDataName.push('オペレータ名');
        arrDataName.push('更新日時');
        // 過去受診情報
      } else if (type[i] === 3) {
        selInfo = COMMENTLIST_SELINFO_CSL;
        histFlg = COMMENTLIST_HISTFLG_OLD;
        title = '過去受診情報に対するコメント一覧';
        arrDataName.push('コメント種類');
        arrDataName.push('受診日');
        arrDataName.push('内容');
        arrDataName.push('コース');
        arrDataName.push('オペレータ名');
        arrDataName.push('更新日時');
        // 個人＋受診情報
      } else if (type[i] === 4) {
        selInfo = COMMENTLIST_SELINFO_ALL;
        histFlg = COMMENTLIST_HISTFLG_ALL;
        title = '';
        arrDataName.push('コメント種類');
        arrDataName.push('対象コメント');
        arrDataName.push('受診日');
        arrDataName.push('内容');
        arrDataName.push('オペレータ名');
        arrDataName.push('更新日時');
        // 契約
      } else if (type[i] === 5) {
        selInfo = COMMENTLIST_SELINFO_CTR;
        histFlg = COMMENTLIST_HISTFLG_ALL;
        title = '契約に対するコメント一覧';
        arrDataName.push('コメント種類');
        arrDataName.push('内容');
        arrDataName.push('オペレータ名');
        arrDataName.push('更新日時');
        // 団体
      } else if (type[i] === 6) {
        selInfo = COMMENTLIST_SELINFO_ORG;
        histFlg = COMMENTLIST_HISTFLG_NOW;
        title = '団体に対するコメント一覧';
        arrDataName.push('コメント種類');
        arrDataName.push('内容');
        arrDataName.push('オペレータ名');
        arrDataName.push('更新日時');
      }

      params.selinfo = selInfo;
      params.histflg = histFlg;
      const pubNotedata = yield call(pubNoteService.getPubNote, params);
      for (let j = 0; j < pubNotedata.length; j += 1) {
        pubNotedata[j].key = j;
      }
      // 個人
      if (type[i] === 1) {
        pubNoteData1.title = title;
        pubNoteData1.dataNames = arrDataName;
        pubNoteData1.dataContent = pubNotedata;
        // 今回受診情報
      } else if (type[i] === 2) {
        pubNoteData2.title = title;
        pubNoteData2.dataNames = arrDataName;
        pubNoteData2.dataContent = pubNotedata;
        // 過去受診情報
      } else if (type[i] === 3) {
        pubNoteData3.title = title;
        pubNoteData3.dataNames = arrDataName;
        pubNoteData3.dataContent = pubNotedata;
        // 個人＋受診情報
      } else if (type[i] === 4) {
        pubNoteData4.title = title;
        pubNoteData4.dataNames = arrDataName;
        pubNoteData4.dataContent = pubNotedata;
        // 契約
      } else if (type[i] === 5) {
        pubNoteData5.title = title;
        pubNoteData5.dataNames = arrDataName;
        pubNoteData5.dataContent = pubNotedata;
        // 団体
      } else if (type[i] === 6) {
        pubNoteData6.title = title;
        pubNoteData6.dataNames = arrDataName;
        pubNoteData6.dataContent = pubNotedata;
      }
    }
    const payload = { params, pubNoteData1, pubNoteData2, pubNoteData3, pubNoteData4, pubNoteData5, pubNoteData6 };
    // コメント情報削除処理成功Actionを発生させる
    yield put(searchCommentListSuccess(payload));
  } catch (error) {
    // コメント情報削除処理失敗Actionを発生させる
    yield put(searchCommentListFailure(error.response));
  }
}

// Actionとその発生時に実行するメソッドをリンクさせる
const pubNoteSagas = [
  takeEvery(openCommentDetailGuide.toString(), runRequestCommentDetail),
  takeEvery(registerPubNoteRequest.toString(), runRegisterPubNote),
  takeEvery(deletePubNoteRequest.toString(), runDeletePubNote),
  takeEvery(loadCommentListFlameGuideRequest.toString(), runLoadCommentListFlameGuide),
  takeEvery(searchCommentListRequest.toString(), runSearchCommentList),
];

export default pubNoteSagas;
