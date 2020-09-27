import { call, takeEvery, put } from 'redux-saga/effects';
import moment from 'moment';

import scheduleService from '../../services/preference/scheduleService';

import {
  getScheduleHRequest,
  getScheduleHSuccess,
  getScheduleHFailure,
  getRsvFraListRequest,
  getRsvFraListSuccess,
  getRsvFraListFailure,
  getCourseListRequest,
  getCourseListSuccess,
  getCourseListFailure,
  getMntCapacityListRequest,
  getMntCapacityListSuccess,
  getMntCapacityListFailure,
  openRsvFraGuide,
  openRsvFraGuideSuccess,
  openRsvFraGuideFailure,
  insertRsvFraRequest,
  insertRsvFraSuccess,
  insertRsvFraFailure,
  updateRsvFraRequest,
  updateRsvFraSuccess,
  updateRsvFraFailure,
  deleteRsvFraRequest,
  deleteRsvFraSuccess,
  deleteRsvFraFailure,
  rsvFraInputCheck,
  getMntCapacityRequest,
  getMntCapacitySuccess,
  getMntCapacityFailure,
  updateMntCapacityRequest,
  updateMntCapacitySuccess,
  updateMntCapacityFailure,
  checkRsvFraCopyInput,
  checkRsvFraCopyInputSuccess,
  checkRsvFraCopyInputFailure,
  rsvFraCopyBack,
  rsvFraCopyRegister,
  rsvFraCopyRegisterSuccess,
  rsvFraCopyRegisterFailure,
  rsvFraCopyInputCheck,
} from '../../modules/preference/scheduleModule';

// 病院スケジュール一覧取得Action発生時に起動するメソッド
function* runRequestScheduleH(action) {
  try {
    // 病院スケジュール一覧取得処理実行
    const payload = yield call(scheduleService.getScheduleh, action.payload);
    // 病院スケジュール一覧取得成功Actionを発生させる
    yield put(getScheduleHSuccess(payload));
  } catch (error) {
    // 病院スケジュール一覧取得失敗Actionを発生させる
    yield put(getScheduleHFailure(error.response));
  }
}

// 予約枠の検索取得Action発生時に起動するメソッド
function* runRequestRsvFraList(action) {
  try {
    // 予約枠の検索取得処理実行
    const payload = yield call(scheduleService.getRsvFraMngList, action.payload);
    // 予約枠の検索取得成功Actionを発生させる
    yield put(getRsvFraListSuccess(payload));
  } catch (error) {
    // 予約枠の検索取得失敗Actionを発生させる
    yield put(getRsvFraListFailure(error.response));
  }
}

// 予約枠の検索取得Action発生時に起動するメソッド
function* runOpenRsvFraGuide(action) {
  try {
    let rsvFraData = null;
    // 予約枠の検索取得処理実行
    const payload = yield call(scheduleService.getRsvFraMngList, action.payload);
    const { data } = payload;
    if (data.length > 0) {
      ([rsvFraData] = data);
    }
    // 予約枠の検索取得成功Actionを発生させる
    yield put(openRsvFraGuideSuccess({ rsvFraData }));
  } catch (error) {
    // 予約枠の検索取得失敗Actionを発生させる
    yield put(openRsvFraGuideFailure(error.response));
  }
}

function* runRequestCourseList(action) {
  try {
    // コース情報の読取得処理実行
    const payload = yield call(scheduleService.getCourseListRsvGrpManaged, action.payload.startDate);
    const conditions = {};
    const { data } = payload;
    for (let i = 0; i < data.length; i += 1) {
      conditions[data[i].cscd] = '1';
    }
    // コース情報の読取得成功Actionを発生させる
    yield put(getCourseListSuccess({ data, conditions }));
    if (action.payload.isRetrieval) {
      yield put(getMntCapacityListRequest({ startDate: action.payload.startDate, gender: '0', conditions }));
    }
  } catch (error) {
    // コース情報の読取得失敗Actionを発生させる
    yield put(getCourseListFailure(error.response));
  }
}
function manageGender(MngGender, MaxCnt, MaxCntM, MaxCntF) {
  if (MngGender !== null) {
    return parseInt(MngGender, 10);
  }
  if (MaxCnt === null) {
    return '';
  }
  if (parseInt(MaxCntM, 10) !== 0 || parseInt(MaxCntF, 10) !== 0) {
    return 1;
  }
  return 0;
}

function rsvgrpnameData(MngGender, MaxCnt, MaxCntM, MaxCntF, CsCd, OverCnt, OverCntM, OverCntF, RsvCntM, RsvCntF) {
  let strRsvCount = '';
  let strColor = '';
  let strRsvCountM = '';
  let strColorM = '';
  let strRsvCountF = '';
  let strColorF = '';
  const manageGenderResult = manageGender(MngGender, MaxCnt, MaxCntM, MaxCntF);
  let result = {};
  if (manageGenderResult === 0) {
    if (MaxCnt !== null) {
      // 予約人数を計算
      const lngRsvCount = parseInt(MaxCntM, 10) + parseInt(MaxCntF, 10);
      // 最大人数を計算
      const lngMaxCount = parseInt(MaxCnt, 10) + (CsCd === 'W001' ? 0 : parseInt(OverCnt, 10));
      // 編集用の予約人数編集
      if (lngRsvCount !== 0 || lngMaxCount !== 0) {
        strRsvCount = `${lngRsvCount}/${MaxCnt}`;
        strColor = lngRsvCount >= lngMaxCount ? 'cccccc' : 'ffffff';
        if (parseInt(OverCnt, 10) !== 0) {
          strRsvCount = `${strRsvCount}(${OverCnt})`;
        }
      } else {
        strRsvCount = ' ';
        strColor = 'ffffff';
      }
    } else {
      strRsvCount = ' ';
      strColor = 'ffffff';
    }
    result = { manageGenderResult, strRsvCount, strColor, CsCd };
  } else if (manageGenderResult === 1) {
    if (MaxCnt !== null) {
      // 予約人数を計算
      const lngRsvCountM = parseInt(RsvCntM, 10);
      // 最大人数を計算
      const lngMaxCountM = parseInt(MaxCntM, 10) + (CsCd === 'W001' ? 0 : parseInt(OverCntM, 10));
      // 編集用の予約人数編集
      if (lngRsvCountM !== 0 || lngMaxCountM !== 0) {
        strRsvCountM = `${lngRsvCountM}/${MaxCntM}`;
        strColorM = lngRsvCountM >= lngMaxCountM ? 'cccccc' : 'ffffff';
        if (parseInt(OverCntM, 10) !== 0) {
          strRsvCountM = `${strRsvCountM}(${OverCntM})`;
        }
      } else {
        strRsvCountM = ' ';
        strColorM = 'ffffff';
      }
      // 予約人数を計算
      const lngRsvCountF = parseInt(RsvCntF, 10);
      // 最大人数を計算
      const lngMaxCountF = parseInt(MaxCntF, 10) + (CsCd === 'W001' ? 0 : parseInt(OverCntF, 10));
      // 編集用の予約人数編集
      if (lngRsvCountF !== 0 || lngMaxCountF !== 0) {
        strRsvCountF = `${lngRsvCountF}/${MaxCntF}`;
        strColorF = lngRsvCountF >= lngMaxCountF ? 'cccccc' : 'ffffff';
        if (parseInt(OverCntF, 10) !== 0) {
          strRsvCountF = `${strRsvCountF}(${OverCntF})`;
        }
      } else {
        strRsvCountF = ' ';
        strColorF = 'ffffff';
      }
    } else {
      strRsvCountF = ' ';
      strColorF = 'ffffff';
      strRsvCountM = ' ';
      strColorM = 'ffffff';
    }
    result = { manageGenderResult, strRsvCountM, strColorM, strRsvCountF, strColorF, CsCd };
  } else {
    result = { manageGenderResult, CsCd };
  }
  return result;
}
function* runRequestMntCapacityList(action) {
  try {
    const conditions = {};
    if (!action.payload.conditions) {
      // コース情報の読取得処理実行
      const payload = yield call(scheduleService.getCourseListRsvGrpManaged, action.payload.startDate);
      const { data } = payload;
      for (let i = 0; i < data.length; i += 1) {
        conditions[data[i].cscd] = '1';
      }
    }
    // 予約人数情報読取得処理実行
    const payload = yield call(scheduleService.getRsvFraMngListCapacity, { conditions, ...action.payload });
    // 最初の日付の最初の予約群のレコードのみを検索し、コース名を編集する
    let lngCourseCount = 0;
    for (let i = 0; i < payload.length - 1; i += 1) {
      if (payload[i].rsvgrpcd !== payload[i + 1].rsvgrpcd || payload[i].csldate !== payload[i + 1].csldate) {
        lngCourseCount = i + 1;
        break;
      }
    }
    // 最初の日付のみを検索し、予約群数をカウント
    const lngRsvGrpCountArray = [];
    let lngRsvGrpCount = 0;
    for (let i = 0; i < payload.length - 1; i += 1) {
      if (payload[i].rsvgrpcd !== payload[i + 1].rsvgrpcd) {
        lngRsvGrpCount += 1;
      }
      if (i === payload.length - 2) {
        lngRsvGrpCount += 1;
      }
      if (payload[i].csldate !== payload[i + 1].csldate || i === payload.length - 2) {
        lngRsvGrpCountArray.push(lngRsvGrpCount);
        lngRsvGrpCount = 0;
      }
    }
    // 先頭の場合のみ日付を編集
    const lngRsvGrp = [];
    lngRsvGrp.push({ date: moment(payload[0].csldate).format('M/D/YYYY'), blnExists: false, holiday: payload[0].holiday, rsvgrpnameArray: null, data: null });
    for (let i = 0; i < payload.length - 1; i += 1) {
      if (payload[i].csldate !== payload[i + 1].csldate) {
        lngRsvGrp.push({ date: moment(payload[i + 1].csldate).format('M/D/YYYY'), blnExists: false, holiday: payload[i + 1].holiday, rsvgrpnameArray: null, data: null });
      }
    }
    let j = 0;
    // 予約人数情報の有無を検索
    for (let i = 0; i < payload.length; i += 1) {
      if (payload[i].maxcnt !== null) {
        lngRsvGrp[j].blnExists = true;
      }
      if (i !== payload.length - 1) {
        if (payload[i].csldate !== payload[i + 1].csldate) {
          j += 1;
        }
      }
    }

    for (let i = 0; i < lngRsvGrp.length; i += 1) {
      if (lngRsvGrp[i].blnExists) {
        const rsvgrpnameArray = [];
        const data = [];
        let rsvgrpnameDataArray = [];
        for (let k = 0; k < payload.length; k += 1) {
          if (moment(payload[k].csldate).format('M/D/YYYY') === lngRsvGrp[i].date) {
            // eslint-disable-next-line camelcase
            const { mnggender, maxcnt, maxcnt_m, maxcnt_f, cscd, overcnt, overcnt_m, overcnt_f, rsvcnt_m, rsvcnt_f } = payload[k];
            const rsvgrpnameDataResult = rsvgrpnameData(mnggender, maxcnt, maxcnt_m, maxcnt_f, cscd, overcnt, overcnt_m, overcnt_f, rsvcnt_m, rsvcnt_f);
            if (rsvgrpnameArray.indexOf(payload[k].rsvgrpname) === -1) {
              rsvgrpnameArray.push(payload[k].rsvgrpname);
            }
            if (!payload[k + 1]) {
              rsvgrpnameDataArray.push(rsvgrpnameDataResult);
              data.push(rsvgrpnameDataArray);
              break;
            }
            if (payload[k].rsvgrpname === payload[k + 1].rsvgrpname) {
              rsvgrpnameDataArray.push(rsvgrpnameDataResult);
            } else {
              rsvgrpnameDataArray.push(rsvgrpnameDataResult);
              data.push(rsvgrpnameDataArray);
              rsvgrpnameDataArray = [];
            }
          }
        }
        lngRsvGrp[i] = { ...lngRsvGrp[i], rsvgrpnameArray, data };
      }
    }
    const { gender } = action.payload;
    // 予約人数情報読取得成功Actionを発生させる
    yield put(getMntCapacityListSuccess({ data: payload, lngCourseCount, lngRsvGrpCountArray, lngRsvGrp, gender }));
  } catch (error) {
    // 予約人数情報読取得失敗Actionを発生させる
    yield put(getMntCapacityListFailure(error.response));
  }
}

// 予約枠登録Action発生時に起動するメソッド
function* runInsertRsvFraRequest(action) {
  try {
    const message = [];
    const { rsvFraData } = action.payload;
    // コースチェック
    if (!rsvFraData.cscd || rsvFraData.cscd === '' || rsvFraData.cscd === undefined) {
      message.push('コースは必須です。');
    }
    // 予約群チェック
    if (!rsvFraData.rsvgrpcd || rsvFraData.rsvgrpcd === '' || rsvFraData.rsvgrpcd === undefined) {
      message.push('予約群は必須です。');
    }
    // 予約可能人数（共通）チェック
    if (rsvFraData.maxcnt !== null && `${rsvFraData.maxcnt}` !== '0' && rsvFraData.maxcnt !== '' && rsvFraData.maxcnt !== undefined) {
      if (`${rsvFraData.maxcnt}`.match(/^\d{0,3}$/) === null) {
        message.push('予約可能人数（共通）は3文字以内の半角数字で入力して下さい。');
      }
    }
    // 予約可能人数（男性）チェック
    if (rsvFraData.maxcnt_m !== null && `${rsvFraData.maxcnt_m}` !== '0' && rsvFraData.maxcnt_m !== '' && rsvFraData.maxcnt_m !== undefined) {
      if (`${rsvFraData.maxcnt_m}`.match(/^\d{0,3}$/) === null) {
        message.push('予約可能人数（男性）は3文字以内の半角数字で入力して下さい。');
      }
    }
    // 予約可能人数（女性）チェック
    if (rsvFraData.maxcnt_f !== null && `${rsvFraData.maxcnt_f}` !== '0' && rsvFraData.maxcnt_f !== '' && rsvFraData.maxcnt_f !== undefined) {
      if (`${rsvFraData.maxcnt_f}`.match(/^\d{0,3}$/) === null) {
        message.push('予約可能人数（女性）は3文字以内の半角数字で入力して下さい。');
      }
    }
    // オーバ可能人数（共通）チェック
    if (rsvFraData.overcnt !== null && `${rsvFraData.overcnt}` !== '0' && rsvFraData.overcnt !== '' && rsvFraData.overcnt !== undefined) {
      if (`${rsvFraData.overcnt}`.match(/^\d{0,3}$/) === null) {
        message.push('オーバ可能人数（共通）は3文字以内の半角数字で入力して下さい。');
      }
    }
    // オーバ可能人数（男性）チェック
    if (rsvFraData.overcnt_m !== null && `${rsvFraData.overcnt_m}` !== '0' && rsvFraData.overcnt_m !== '' && rsvFraData.overcnt_m !== undefined) {
      if (`${rsvFraData.overcnt_m}`.match(/^\d{0,3}$/) === null) {
        message.push('オーバ可能人数（男性）は3文字以内の半角数字で入力して下さい。');
      }
    }
    // オーバ可能人数（女性）チェック
    if (rsvFraData.overcnt_f !== null && `${rsvFraData.overcnt_f}` !== '0' && rsvFraData.overcnt_f !== '' && rsvFraData.overcnt_f !== undefined) {
      if (`${rsvFraData.overcnt_f}`.match(/^\d{0,3}$/) === null) {
        message.push('オーバ可能人数（女性）は3文字以内の半角数字で入力して下さい。');
      }
    }
    if (message.length > 0) {
      yield put(rsvFraInputCheck(message));
      return;
    }
    // 予約枠の登録処理実行
    const payload = yield call(scheduleService.insertRsvFra, action.payload);
    // 予約枠の登録成功Actionを発生させる
    yield put(insertRsvFraSuccess(payload));
    // 予約枠の再読込Actionを発生させる
    const { conditions } = action.payload;
    yield put(getRsvFraListRequest(conditions));
  } catch (error) {
    // 予約枠の登録失敗Actionを発生させる
    yield put(insertRsvFraFailure(error.response));
  }
}

// 予約枠更新Action発生時に起動するメソッド
function* runUpdateRsvFraRequest(action) {
  try {
    const message = [];
    const { rsvFraData } = action.payload;
    // 予約可能人数（共通）チェック
    if (rsvFraData.maxcnt !== null && `${rsvFraData.maxcnt}` !== '0' && rsvFraData.maxcnt !== '' && rsvFraData.maxcnt !== undefined) {
      if (`${rsvFraData.maxcnt}`.match(/^\d{0,3}$/) === null) {
        message.push('予約可能人数（共通）は3文字以内の半角数字で入力して下さい。');
      }
    }
    // 予約可能人数（男性）チェック
    if (rsvFraData.maxcnt_m !== null && `${rsvFraData.maxcnt_m}` !== '0' && rsvFraData.maxcnt_m !== '' && rsvFraData.maxcnt_m !== undefined) {
      if (`${rsvFraData.maxcnt_m}`.match(/^\d{0,3}$/) === null) {
        message.push('予約可能人数（男性）は3文字以内の半角数字で入力して下さい。');
      }
    }
    // 予約可能人数（女性）チェック
    if (rsvFraData.maxcnt_f !== null && `${rsvFraData.maxcnt_f}` !== '0' && rsvFraData.maxcnt_f !== '' && rsvFraData.maxcnt_f !== undefined) {
      if (`${rsvFraData.maxcnt_f}`.match(/^\d{0,3}$/) === null) {
        message.push('予約可能人数（女性）は3文字以内の半角数字で入力して下さい。');
      }
    }
    // オーバ可能人数（共通）チェック
    if (rsvFraData.overcnt !== null && `${rsvFraData.overcnt}` !== '0' && rsvFraData.overcnt !== '' && rsvFraData.overcnt !== undefined) {
      if (`${rsvFraData.overcnt}`.match(/^\d{0,3}$/) === null) {
        message.push('オーバ可能人数（共通）は3文字以内の半角数字で入力して下さい。');
      }
    }
    // オーバ可能人数（男性）チェック
    if (rsvFraData.overcnt_m !== null && `${rsvFraData.overcnt_m}` !== '0' && rsvFraData.overcnt_m !== '' && rsvFraData.overcnt_m !== undefined) {
      if (`${rsvFraData.overcnt_m}`.match(/^\d{0,3}$/) === null) {
        message.push('オーバ可能人数（男性）は3文字以内の半角数字で入力して下さい。');
      }
    }
    // オーバ可能人数（女性）チェック
    if (rsvFraData.overcnt_f !== null && `${rsvFraData.overcnt_f}` !== '0' && rsvFraData.overcnt_f !== '' && rsvFraData.overcnt_f !== undefined) {
      if (`${rsvFraData.overcnt_f}`.match(/^\d{0,3}$/) === null) {
        message.push('オーバ可能人数（女性）は3文字以内の半角数字で入力して下さい。');
      }
    }
    if (message.length > 0) {
      yield put(rsvFraInputCheck(message));
      return;
    }

    // 予約枠の更新処理実行
    const payload = yield call(scheduleService.updateRsvFra, action.payload);
    // 予約枠の更新成功Actionを発生させる
    yield put(updateRsvFraSuccess(payload));
    // 予約枠の再読込Actionを発生させる
    const { conditions } = action.payload;
    yield put(getRsvFraListRequest(conditions));
  } catch (error) {
    // 予約枠の更新失敗Actionを発生させる
    yield put(updateRsvFraFailure(error.response));
  }
}

// 予約枠削除Action発生時に起動するメソッド
function* runDeleteRsvFraRequest(action) {
  try {
    // 予約枠の削除処理実行
    const payload = yield call(scheduleService.deleteRsvFra, action.payload);
    // 予約枠の削除成功Actionを発生させる
    yield put(deleteRsvFraSuccess(payload));
    // 予約枠の再読込Actionを発生させる
    const { conditions } = action.payload;
    yield put(getRsvFraListRequest(conditions));
  } catch (error) {
    // 予約枠の更新失敗Actionを発生させる
    yield put(deleteRsvFraFailure(error.response));
  }
}

// 病院スケジュール一覧取得Action発生時に起動するメソッド
function* runGetMntCapacityRequest(action) {
  try {
    // 病院スケジュール一覧取得処理実行
    const payload = yield call(scheduleService.getScheduleh, action.payload);
    const { data } = payload;
    const { year, month } = action.payload;
    const calendarItem = {};
    for (let i = 0; i < data.length; i += 1) {
      const fieldName = moment(data[i].csldate).format('YYYYMMDD');
      const fieldValue = data[i].holiday;
      calendarItem[`day${fieldName}`] = fieldValue;
    }

    // 病院スケジュール一覧取得成功Actionを発生させる
    yield put(getMntCapacitySuccess({ calendarItem, year, month }));
  } catch (error) {
    // 病院スケジュール一覧取得失敗Actionを発生させる
    yield put(getMntCapacityFailure(error.response));
  }
}

// 休診日設定更新Action発生時に起動するメソッド
function* runUpdateMntCapacityRequest(action) {
  try {
    // 休診日設定更新処理実行
    const payload = yield call(scheduleService.updateHospitalSchedule, action.payload);
    // 休診日設定の更新成功Actionを発生させる
    yield put(updateMntCapacitySuccess(payload));
  } catch (error) {
    // 休診日設定の更新失敗Actionを発生させる
    yield put(updateMntCapacityFailure(error.response));
  }
}

// 予約枠コピーチェックAction発生時に起動するメソッド
function* runCheckRsvFraCopyInput(action) {
  try {
    // 受診日チェック
    let message = [];
    const { startcsldate, rsvFraCopyNextPage } = action.payload;
    if (!startcsldate || startcsldate === '' || startcsldate === undefined) {
      message = ['コピー元受診日の入力形式が正しくありません。'];
      // 予約枠コピーチェック成功Actionを発生させる
      yield put(checkRsvFraCopyInputSuccess({ message }));
      return;
    }
    // 予約枠コピーチェック処理実行
    const payload = yield call(scheduleService.getRsvFraMngList, action.payload);
    const { data } = payload;
    if (!data || data.length === 0) {
      message = ['この条件を満たす予約人数情報は登録されていません。'];
      // 予約枠コピーチェック成功Actionを発生させる
      yield put(checkRsvFraCopyInputSuccess({ message }));
      return;
    }
    // コピー先情報を設定する画面へ遷移
    yield call(rsvFraCopyNextPage);
  } catch (error) {
    // 休予約枠コピーチェック失敗Actionを発生させる
    yield put(checkRsvFraCopyInputFailure(error.response));
  }
}

// 予約枠コピー先情報から予約枠コピー画面へ戻る発生時に起動するメソッド
function* runRsvFraCopyBack(action) {
  const { backFun } = action.payload;
  // コピー先情報を設定する画面へ遷移
  yield call(backFun);
}

// 予約枠コピーをコピーするAction発生時に起動するメソッド
function* runRsvFraCopyRegister(action) {
  try {
    // コピー先範囲開始受診日チェック
    const message = [];
    const { csldate, cscd, rsvgrpcd, startcsldate, endcsldate, mon, tue, wed, thu, fri, sat, sun, upd } = action.payload;
    if (!startcsldate || startcsldate === '' || startcsldate === undefined) {
      message.push('コピー元開始受診日の入力形式が正しくありません。');
    }
    // コピー先範囲終了受診日チェック
    if (!endcsldate || endcsldate === '' || endcsldate === undefined) {
      message.push('コピー元終了受診日の入力形式が正しくありません。');
    }
    // 対象曜日チェック
    if (mon === '' && tue === '' && wed === '' && thu === '' && fri === '' && sat === '' && sun === '') {
      message.push('対象曜日を選択してください。');
    }
    if (message.length > 0) {
      yield put(rsvFraCopyInputCheck(message));
      return;
    }
    // コピー先受診日範囲
    const weekdays = [];
    weekdays.push(mon);
    weekdays.push(tue);
    weekdays.push(wed);
    weekdays.push(thu);
    weekdays.push(fri);
    weekdays.push(sat);
    weekdays.push(sun);
    const inputItem = { csldate, cscd, rsvgrpcd, strcsldate: startcsldate, endcsldate, weekdays, update: upd !== '' };
    // 予約枠コピーの処理実行
    const payload = yield call(scheduleService.copyRsvFraMng, inputItem);
    // 予約枠コピーをコピーする成功Actionを発生させる
    yield put(rsvFraCopyRegisterSuccess(payload));
  } catch (error) {
    // 予約枠コピーをコピーするActionを発生させる
    yield put(rsvFraCopyRegisterFailure(error.response));
  }
}
// Actionとその発生時に実行するメソッドをリンクさせる
const scheduleSagas = [
  takeEvery(getScheduleHRequest.toString(), runRequestScheduleH),
  takeEvery(getRsvFraListRequest.toString(), runRequestRsvFraList),
  takeEvery(getCourseListRequest.toString(), runRequestCourseList),
  takeEvery(getMntCapacityListRequest.toString(), runRequestMntCapacityList),
  takeEvery(openRsvFraGuide.toString(), runOpenRsvFraGuide),
  takeEvery(insertRsvFraRequest.toString(), runInsertRsvFraRequest),
  takeEvery(updateRsvFraRequest.toString(), runUpdateRsvFraRequest),
  takeEvery(deleteRsvFraRequest.toString(), runDeleteRsvFraRequest),
  takeEvery(getMntCapacityRequest.toString(), runGetMntCapacityRequest),
  takeEvery(updateMntCapacityRequest.toString(), runUpdateMntCapacityRequest),
  takeEvery(checkRsvFraCopyInput.toString(), runCheckRsvFraCopyInput),
  takeEvery(rsvFraCopyBack.toString(), runRsvFraCopyBack),
  takeEvery(rsvFraCopyRegister.toString(), runRsvFraCopyRegister),

];

export default scheduleSagas;
