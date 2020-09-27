import { call, takeEvery, put, all, select } from 'redux-saga/effects';
import { initialize } from 'redux-form';
import moment from 'moment';
import consultService from '../../services/reserve/consultService';
import organizationService from '../../services/preference/organizationService';
import personService from '../../services/preference/personService';
import freeService from '../../services/preference/freeService';
import courseService from '../../services/preference/courseService';
import contractService from '../../services/preference/contractService';
import scheduleService from '../../services/preference/scheduleService';
import perResultService from '../../services/preference/perResultService';
import interviewService from '../../services/judgement/interviewService';
import pubNoteService from '../../services/preference/pubNoteService';
import rslCmtService from '../../services/preference/rslCmtService';
import resultService from '../../services/result/resultService';
import { hankana2zenkana } from '../../containers/reserve/DailyList';

import * as consultModules from '../../modules/reserve/consultModule';
import { FreeCd, CONSULT_USED } from '../../constants/common';

// 変更履歴一覧取得Action発生時に起動するメソッド
function* runRequestConsultLogList(action) {
  const message = [];
  const { startDate, endDate, rsvNo } = action.payload;
  const reg = new RegExp('^[0-9]+$');

  if (startDate === null || endDate === null) {
    message.push('更新日の指定に誤りがあります。');
  }
  if (rsvNo !== undefined && !reg.test(rsvNo)) {
    message.push('予約番号の指定に誤りがあります。');
  }
  if (message.length > 0) {
    yield put(consultModules.getConsultLogListFailure({ message }));
    return;
  }
  try {
    // 変更履歴一覧取得処理実行
    const consultLogList = yield call(consultService.getConsultLogList, action.payload);
    // 変更履歴一覧取得成功Actionを発生させる
    yield put(consultModules.getConsultLogListSuccess(consultLogList));
  } catch (error) {
    message.push('検索条件を満たす履歴は存在しませんでした。 ');
    // 変更履歴一覧取得失敗Actionを発生させる
    yield put(consultModules.getConsultLogListFailure({ message }));
  }
}

// 受診者ガイド一覧取得Action発生時に起動するメソッド
function* runRequestConsultListGuide(action) {
  try {
    const { conditions } = action.payload;
    // 受診情報一覧取得処理実行
    const payload = yield call(consultService.getConsultList, conditions);
    // 受診情報一覧取得成功Actionを発生させる
    yield put(consultModules.getConsultListGuideSuccess(payload));
  } catch (error) {
    // 受診情報一覧取得失敗Actionを発生させる
    yield put(consultModules.getConsultListGuideFailure(error.response));
  }
}

// 受診者ガイド受診情報取得Action発生時に起動するメソッド
function* runRequestConsultGuide(action) {
  try {
    // 受診情報取得処理実行
    const payload = yield call(consultService.getConsult, action.payload);
    // 受診情報取得成功Actionを発生させる
    yield put(consultModules.getConsultGuideSuccess(payload));
  } catch (error) {
    // 受診情報取得失敗Actionを発生させる
    yield put(consultModules.getConsultGuideFailure(error.response));
  }
}

function* runRequestConsult(action) {
  try {
    // 受診情報取得処理実行
    const payload = yield call(consultService.getConsult, action.payload);
    // 受診情報取得成功Actionを発生させる
    yield put(consultModules.getConsultSuccess(payload));
  } catch (error) {
    // 受診情報取得失敗Actionを発生させる
    yield put(consultModules.getConsultFailure(error.response));
  }
}

// 受診者検索ガイドの受診オープンAction発生時に起動するメソッド
function* runOpenConsultationListGuide(action) {
  const { csldate, keyword } = action.payload.conditions;
  // 受診日かキーワードが設定されていたら受診情報取得Actionを発生させる
  if (csldate || keyword) {
    yield put(consultModules.getConsultationListGuideRequest(action.payload.conditions));
  }
}

// 受診者検索ガイドの受診情報取得Action発生時に起動するメソッド
function* runRequestConsultationListGuide(action) {
  try {
    const printFields = [2, 4, 5, 6, 10, 17, 39];
    const params = {
      startcsldate: action.payload.csldate,
      endcsldate: action.payload.csldate,
      key: action.payload.keyword,
      sortkey: printFields[0],
      printFields,
      sorttype: 0,
      startpos: 0,
      getcount: 0,
    };
    // 受診情報取得処理実行
    const payload = yield call(consultService.getDailyList, { params });
    // 受診情報取得成功Actionを発生させる
    yield put(consultModules.getConsultationListGuideSuccess(payload));
  } catch (error) {
    // 受診情報取得失敗Actionを発生させる
    yield put(consultModules.getConsultationListGuideFailure(error.response));
  }
}

// 受診者情報取得Action発生時に起動するメソッド
function* runOpenReserveMain(action) {
  try {
    const { formName, params } = yield select((state) => state.app.reserve.consult.edit);
    // 受診情報取得処理実行
    const consult = yield call(consultService.getConsult, params);

    // 検査オプション取得処理実行
    const consultoptionspayload = yield call(consultService.getConsultOptions, params);
    // 検査オプションのキーをオプションコード、値をオプション枝番とセットクラスコードをカンマ区切りにしたものとして連想配列で保持する
    const consultoptions = consultoptionspayload.reduce && consultoptionspayload.reduce(
      (result, rec) => (
        { ...result, [rec.optcd]: rec.optbranchno }
      ),
      {},
    );

    // キャンセル理由名取得
    yield put(consultModules.getCancelReasonNameRequest(consult));

    // 受診付属情報取得処理実行
    const consultdetail = yield call(consultService.getConsultDetail, params);

    // 受診付属情報から紹介者を取得
    const { introductor } = consultdetail;
    // 受診情報から団体コードを取得
    const payloadconsult = consult || {};
    const { orgcd1, orgcd2 } = payloadconsult;

    // 団体コードが存在すれば団体情報を取得
    let payloadorg = {};
    if (orgcd1 && orgcd2) {
      payloadorg = yield call(organizationService.getOrg, { orgcd1, orgcd2 });
    }

    // 住所情報取得
    const { perid } = payloadconsult;
    const peraddr = yield call(personService.getPersonAddr, { params: { perid } });

    // 個人付属情報取得
    const persondetail = yield call(personService.getPersonDetail, { params: { perid } });

    // 紹介者情報取得
    let payloadintroductor = {};
    if (introductor) {
      payloadintroductor = yield call(personService.getPerson, { params: { perid: introductor } });
    }

    const payload = {
      consult,
      consultoptions,
      consultdetail,
      org: payloadorg,
      peraddr,
      introductor: payloadintroductor,
      persondetail,
    };

    // 受診情報をredux-formへセットするActionを発生させる
    yield put(initialize(formName, payload));
    // 受診情報取得成功Actionを発生させる
    yield put(consultModules.openReserveMainSuccess(payload));
  } catch (error) {
    // 受診情報取得失敗Actionを発生させる
    yield put(consultModules.openReserveMainFailure(error.response));
  }
}

// 年齢計算Action発生時に起動するメソッド
function* runCalcAge(action) {
  try {
    // 年齢計算処理実行
    const payload = yield call(freeService.calcAge, action.payload.conditions);
    // コールバック処理
    action.payload.callback(payload);
    // 年齢計算成功Actionを発生させる
    yield put(consultModules.calcAgeSuccess(payload));
  } catch (error) {
    // コールバック
    action.payload.callback();
    // 年齢計算失敗Actionを発生させる
    yield put(consultModules.calcAgeFailure(error.response));
  }
}

// 受診情報詳細画面受診者選択開始Action発生時に起動するメソッド
function* runSelectReserveMainPerson(action) {
  try {
    // APIアクセス用パラメータ定義
    const params = {
      perid: action.payload.params.perid,
    };
    // 住所情報と個人付属情報を取得
    const payload = yield all({
      peraddr: call(personService.getPersonAddr, { params }),
      persondetail: call(personService.getPersonDetail, { params }),
    });
    // コールバック
    action.payload.callback(payload);
    // 受診情報詳細画面受診者選択成功Actionを発生させる
    yield put(consultModules.selectReserveMainPersonSuccess(payload));
  } catch (error) {
    // 受診情報詳細画面受診者選択失敗Actionを発生させる
    yield put(consultModules.selectReserveMainPersonFailure(error.response));
  }
}

// 受診者情報詳細画面コースの選択肢取得Action発生時に起動するメソッド
function* runRequestReserveMainCourceItems(action) {
  try {
    // コース一覧取得処理実行
    const payload = yield call(contractService.getAllCtrMng, action.payload);
    // コースの選択肢取得処理成功Actionを発生させる
    yield put(consultModules.getReserveMainCourceItemsSuccess(payload.data));
  } catch (error) {
    // コースの選択肢取得処理失敗Actionを発生させる
    yield put(consultModules.getReserveMainCourceItemsFailure(error.response));
  }
}

// 受診者情報詳細画面受診区分の選択肢取得Action発生に起動するメソッド
function* runRequestReserveMainCslDivItems(action) {
  try {
    // 受診区分一覧取得処理実行
    const payload = yield call(contractService.getContractCslDivList, action.payload);
    // 受診区分の選択肢取得処理成功Actionを発生させる
    yield put(consultModules.getReserveMainCslDivItemsSuccess(payload));
  } catch (error) {
    // 受診区分の選択肢取得処理失敗Actionを発生させる
    yield put(consultModules.getReserveMainCslDivItemsFailure(error.response));
  }
}

// 受診者情報詳細画面検査セット取得Action発生時に起動するメソッド
function* runRequestReserveMainOptions(action) {
  try {
    // 検査セット取得処理実行
    const payload = yield call(contractService.getCtrPtOptFromConsult, action.payload);
    // 検査セット取得処理成功Actionを発生させる
    yield put(consultModules.getReserveMainOptionsSuccess(payload));
  } catch (error) {
    // 検査セット取得処理失敗Actionを発生させる
    yield put(consultModules.getReserveMainOptionsFailure(error.response));
  }
}

// 受診者情報詳細画面予約群取得Action発生時に起動するメソッド
function* runRequestReserveMainRsvGrpItems(action) {
  try {
    const payload = yield call(scheduleService.getCscdRsvGrpList, action.payload);
    yield put(consultModules.getReserveMainRsvGrpItemsSuccess(payload));
  } catch (error) {
    yield put(consultModules.getReserveMainRsvGrpItemsFailure(error.response));
  }
}

// 受診者情報詳細画面全予約群取得Action発生時に起動するメソッド
function* runRequestReserveMainRsvGrpItemsAll(action) {
  try {
    const payload = yield call(scheduleService.getRsvGrpList, { params: action.payload });
    yield put(consultModules.getReserveMainRsvGrpItemsAllSuccess(payload.data));
  } catch (error) {
    yield put(consultModules.getReserveMainRsvGrpItemsAllFailure(error.response));
  }
}

// キャンセル理由名取得Action発生時に起動するメソッド
function* runGetCancelReasonName(action) {
  try {
    const mode = 0;
    const { cancelflg } = action.payload;
    // 汎用コード
    const freecd = `${FreeCd.Cancel}${cancelflg}`;
    // キャンセル理由取得処理実行
    const payload = yield call(freeService.getFree, { freecd, mode });
    // キャンセル理由取得成功Actionを発生させる
    yield put(consultModules.getCancelReasonNameSuccess(payload[0]));
  } catch (error) {
    // キャンセル理由取得失敗Actionを発生させる
    yield put(consultModules.getCancelReasonNameFailure(error.response));
  }
}

// 受診情報登録Action発生時に起動するメソッド
function* runRegisterConsult(action) {
  try {
    // 受診情報取得処理実行
    const payload = yield call(consultService.registerConsult, action.payload);
    // リダイレクト
    action.payload.redirect(payload);
    // 受診情報取得成功Actionを発生させる
    yield put(consultModules.registerConsultSuccess(payload));
  } catch (error) {
    // 受診情報取得失敗Actionを発生させる
    yield put(consultModules.registerConsultFailure(error.response));
  }
}

// 受付ガイドオープン開始Action発生時に起動するメソッド
function* runOpenEntryFromDetailGuide(action) {
  try {
    const { params, data } = action.payload;
    // 受診情報バリデーション処理実行
    const payload = yield call(consultService.validateConsult, { params, data });
    // コース情報取得
    yield put(consultModules.getCourseEntryFromDetailGuideRequest(data.consult));
    // 個人情報取得
    yield put(consultModules.getPersonEntryFromDetailGuideRequest(data.consult));
    // 受付ガイドオープン成功Actionを発生させる
    yield put(consultModules.openEntryFromDetailGuideSuccess(payload));
  } catch (error) {
    // 受付ガイドオープン失敗Actionを発生させる
    yield put(consultModules.openEntryFromDetailGuideFailure(error.response));
  }
}

// 受付ガイドコース情報取得Action発生時に起動するメソッド
function* runRequestCourseEntryFromDetailGuide(action) {
  try {
    // コース情報取得処理実行
    const payload = yield call(courseService.getCourse, action.payload);
    // コース情報取得成功Actionを発生させる
    yield put(consultModules.getCourseEntryFromDetailGuideSuccess(payload));
  } catch (error) {
    // コース情報取得失敗Actionを発生させる
    yield put(consultModules.getCourseEntryFromDetailGuideFailure(error.response));
  }
}

// 受付ガイド個人情報取得Action発生時に起動するメソッド
function* runRequestPersonEntryFromDetailGuide(action) {
  try {
    const { perid } = action.payload;
    // 個人情報取得処理実行
    const payload = yield call(personService.getPerson, { params: { perid } });
    // 個人情報取得成功Actionを発生させる
    yield put(consultModules.getPersonEntryFromDetailGuideSuccess(payload));
  } catch (error) {
    // 個人情報取得失敗Actionを発生させる
    yield put(consultModules.getPersonEntryFromDetailGuideFailure(error.response));
  }
}

// 受付ガイド確定時の当日ID確認Action発生時に起動するメソッド
function* runValidateEntryFromDetailGuide(action) {
  try {
    const { data, callback } = action.payload;
    // 当日ID確認処理実行
    const payload = yield call(consultService.validateDayId, data);
    // コールバック
    callback();
    // 当日ID確認処理成功Actionを発生させる
    yield put(consultModules.validateConsultEntryFromDetailSuccess(payload));
  } catch (error) {
    // 当日ID確認処理失敗Actionを発生させる
    yield put(consultModules.validateConsultEntryFromDetailFailure(error.response));
  }
}

// 印刷状況オープンAction発生時に起動するメソッド
function* runOpenPrintStatuGuide(action) {
  // 印刷状態取得Actionを発生させる
  yield put(consultModules.getPrintStatusRequest(action.payload));
}

// 印刷状況取得Action発生時に起動するメソッド
function* runRequestPrintStatusGuide(action) {
  try {
    // 印刷状況取得処理実行
    const payload = yield call(consultService.getPrintStatus, action.payload);
    const { rsvno } = action.payload;
    // 印刷状況取得成功Actionを発生させる
    yield put(consultModules.getPrintStatusSuccess({ rsvno, ...payload }));
  } catch (error) {
    // 印刷状況取得失敗Actionを発生させる
    yield put(consultModules.getPrintStatusFailure(error.response));
  }
}

// 印刷状況登録Action発生時に起動するメソッド
function* runRegisterPrintStatusGuide(action) {
  const { data, callback } = action.payload;
  try {
    // 印刷状況登録処理
    const payload = yield call(consultService.registerPrintStatus, data);
    // コールバック
    if (callback) {
      callback();
    }
    // 印刷状況登録成功Actionを発生させる
    yield put(consultModules.registerPrintStatusSuccess(payload));
  } catch (error) {
    // 印刷状況登録失敗Actionを発生させる
    yield put(consultModules.registerPrintStatusFailure(error.response));
  }
}

// 受付取り消しガイドオープンAction発生時処理
function* rundOpenCancelReceptionGuide(action) {
  // 受付取り消しガイド受診情報取得Actionを発生させる
  yield put(consultModules.getConsultCancelReceptionGuideRequest(action.payload.data));
}

// 受付取り消しガイド受診情報取得Action発生時処理
function* runGetConsultCancelReceptionGuide(action) {
  try {
    // 受診情報取得処理実行
    const payload = yield call(consultService.getConsult, action.payload);
    // 受信情報取得成功時Actionを発生させる
    yield put(consultModules.getConsultCancelReceptionGuideSuccess(payload));
  } catch (error) {
    // 受信情報取得失敗時Actionを発生させる
    yield put(consultModules.getConsultCancelReceptionGuideFailure(error.response));
  }
}

// 受付取り消しガイド受付取り消し実行Action発生時処理
function* runExecuteCancelReceptionGuide(action) {
  const { data, callback } = action.payload;
  try {
    // 受付取り消し処理実行
    const payload = yield call(consultService.cancelReception, data);
    // コールバック
    callback(['保存が完了しました。']);
    // 受付取り消し成功Actionを発生させる
    yield put(consultModules.executeCancelReceptionGuideSuccess(payload));
  } catch (error) {
    // 受付取り消し失敗Actionを発生させる
    yield put(consultModules.executeCancelReceptionGuideFailure(error.response));
    // コールバック
    callback(error.response.data.errors);
  }
}

// 予約キャンセルガイドオープンAction時に起動するメソッド
function* runOpenCancelConsultGuide() {
  // 予約キャンセル理由取得一覧取得Actionを発生させる
  yield put(consultModules.getCancelReasonsRequest());
}

// 予約キャンセル理由一覧取得Action時に起動するメソッド
function* runRequestReasonsCancelGuide() {
  try {
    const freecd = FreeCd.Cancel;
    const mode = 3;
    // 予約キャンセル理由一覧処理実行
    const payload = yield call(freeService.getFree, { freecd, mode });
    // 予約キャンセル理由一覧をドロップダウン用に整形
    const items = Array.isArray(payload) &&
      payload.map((rec) => ({
        value: rec.freecd.substr(freecd.length),
        name: rec.freefield1,
      }));
    // 予約キャンセル理由一覧取得成功Actionを発生させる
    yield put(consultModules.getCancelReasonsSuccess(items));
  } catch (error) {
    // 予約キャンセル理由一覧取得失敗Actionを発生させる
    yield put(consultModules.getCancelReasonsFailure(error.response));
  }
}

// 予約キャンセルAction時に起動するメソッド
function* runRegisterCancelConsult(action) {
  try {
    // 予約キャンセル処理実行
    const payload = yield call(consultService.registerCancelConsult, action.payload);
    // リダイレクト
    action.payload.redirect();
    // 予約キャンセル成功Actionを発生させる
    yield put(consultModules.registerCancelConsultSuccess(payload));
  } catch (error) {
    // 予約キャンセル失敗Actionを発生させる
    yield put(consultModules.registerCancelConsultFailure(error.response));
  }
}

// セット内項目削除ガイドオープンAction時に起動するメソッド
function* runOpenConsultDeleteItemGuide(action) {
  // オプション情報取得Actionを発生させる
  yield put(consultModules.getContractOptionDeleteItemGuideRequest(action.payload));
  // オプション内アイテム取得Actionを発生させる
  yield put(consultModules.getContractOptionItemsDeleteItemGuideRequest(action.payload));
}

// セット内項目削除ガイドオプション情報取得Action時に起動するメソッド
function* runRequestContractOptionDeleteItemGuide(action) {
  try {
    // オプション情報取得処理実行
    const payload = yield call(contractService.getCtrPtOpt, action.payload);
    // セット内項目削除ガイド項目情報取得成功Actionを発生させる
    yield put(consultModules.getContractOptionDeleteItemGuideSuccess(payload));
  } catch (error) {
    // セット内項目削除ガイド項目情報取得失敗Actionを発生させる
    yield put(consultModules.getContractOptionDeleteItemGuideFailure(error.response));
  }
}

// セット内項目削除ガイドオプションの項目一覧取得Action時に起動するメソッド
function* runRequestContractOptionItemsDeleteItemGuide(action) {
  try {
    // オプションの項目一覧取得実行
    const payload = yield call(contractService.getContractOptionItems, action.payload);
    // セット内項目削除ガイド項目一覧取得成功Actionを発生させる
    yield put(consultModules.getContractOptionItemsDeleteItemGuideSuccess(payload));
  } catch (error) {
    // セット内項目削除ガイド項目一覧取得失敗Actionを発生させる
    yield put(consultModules.getContractOptionItemsDeleteItemGuideFailure(error.response));
  }
}

function* runRegisterContractOptionsItemsDeleteItemGuide(action) {
  const { data, callback } = action.payload;
  try {
    const payload = yield call(consultService.registerConsultItems, data);
    callback();
    yield put(consultModules.registerContractOptionItemsDeleteItemGuideSuccess(payload));
  } catch (error) {
    yield put(consultModules.registerContractOptionItemsDeleteItemGuideFailure(error.response));
  }
}

// カレンダー検索ガイド（予約番号）オープン開始Action発生時に実行するメソッド
function* runOpenRsvCalendarFromRsvNoGuide(action) {
  try {
    const guideParams = yield select((state) => state.app.reserve.consult.rsvCalendarFromRsvNoGuide.params);

    const recentConsults = [];

    // 受診情報読み込み
    for (let i = 0; i < guideParams.rsvno.length; i += 1) {
      const consult = yield call(consultService.getConsult, { rsvno: guideParams.rsvno[i] });
      recentConsults.push({ consult });
    }

    const { consult } = recentConsults[0];
    // 各情報読み込み
    const payload = yield all({
      // 団体情報
      organization: call(organizationService.getOrg, { orgcd1: consult.orgcd1, orgcd2: consult.orgcd2 }),
      // コースオプション情報
      options: call(consultService.getConsultOptions, { rsvno: consult.rsvno }),
      // コース情報
      contract: call(contractService.getCtrPt, { ctrptcd: consult.ctrptcd }),
      // カレンダー情報
      schedule: call(scheduleService.getEmptyCalendarFromRsvNo, {
        mode: guideParams.mode,
        cslyear: guideParams.cslyear,
        cslmonth: guideParams.cslmonth,
        rsvno: guideParams.rsvno,
        rsvgrpcd: guideParams.rsvgrpcd,
      }),
    });

    // 読み込んだ受診情報数の受診履歴を取得する
    for (let i = 0; i < recentConsults.length; i += 1) {
      const params = {
        year: guideParams.cslyear,
        month: guideParams.cslmonth,
        perid: recentConsults[i].consult.perid,
        currsvno: recentConsults[i].consult.rsvno,
      };

      const data = yield call(consultService.getResentConsultHistory, params);
      recentConsults[i] = { ...recentConsults[i], data };
    }

    // カレンダー検索ガイド（予約番号）オープン成功Actionを発生させる。
    yield put(consultModules.openRsvCalendarFromRsvNoGuideSuccess({ consult, recentConsults, ...payload }));
  } catch (error) {
    // カレンダー検索ガイド（予約番号）オープン失敗Actionを発生させる。
    yield put(consultModules.openRsvCalendarFromRsvNoGuideFailure(error.response));
  }
}

// カレンダー検索ガイド（予約番号）年月変更開始Action発生時に実行するメソッド
function* runChangeDateRsvCalendarFromRsvNoGuide(action) {
  try {
    const guideParams = yield select((state) => state.app.reserve.consult.rsvCalendarFromRsvNoGuide.params);
    // 指定年月の予約空き状況取得実行
    const payload = yield call(scheduleService.getEmptyCalendarFromRsvNo, {
      mode: guideParams.mode,
      cslyear: guideParams.cslyear,
      cslmonth: guideParams.cslmonth,
      rsvno: guideParams.rsvno,
      rsvgrpcd: guideParams.rsvgrpcd,
    });
    // カレンダー検索ガイド（予約番号）年月変更成功Actionを発生させる
    yield put(consultModules.changeDateRsvCalendarFromRsvNoGuideSuccess(payload));
  } catch (error) {
    // カレンダー検索ガイド（予約番号）年月変更失敗Actionを発生させる
    yield put(consultModules.changeDateRsvCalendarFromRsvNoGuideFailure(error.response));
  }
}

// カレンダー検索ガイド（予約番号）受診年月日登録開始Action発生時に実行するメソッド
function* runRegisterDateRsvCalendarFromRsvNoGuide(action) {
  try {
    const guideParams = yield select((state) => state.app.reserve.consult.rsvCalendarFromRsvNoGuide.params);
    const params = {
      csldate: action.payload.csldate,
      ignoreflg: action.payload.ignoreFlg || 0,
      mode: guideParams.mode,
      rsvno: guideParams.rsvno,
      rsvgrpcd: guideParams.rsvgrpcd,
    };
    // 受診年月日登録処理
    const payload = yield call(consultService.registerDate, params);
    // 登録後処理があれば実行
    if (guideParams.onSelected) {
      guideParams.onSelected();
    }
    // カレンダー検索ガイド（予約番号）受診年月日登録成功Actionを発生させる
    yield put(consultModules.registerDateRsvCalendarFromRsvNoGuideSuccess(payload));
    // 受診日一括変更(変更完了)ガイドオープン開始Actionを発生させる
    yield put(consultModules.openRsvCslListChangedDateGuideRequest({ csldate: params.csldate, rsvno: params.rsvno }));
  } catch (error) {
    // カレンダー検索ガイド（予約番号）受診年月日登録失敗Actionを発生させる
    yield put(consultModules.registerDateRsvCalendarFromRsvNoGuideFailure(error.response));
  }
}

// 受診日一括変更(変更完了)ガイドオープン開始Action発生時処理
function* runOpenRsvCslListChangedDateGuide(action) {
  try {
    const { rsvno = [] } = action.payload;
    const payload = [];
    // 受診番号ごとに受診情報を取得
    for (let i = 0; i < rsvno.length; i += 1) {
      const result = yield call(consultService.getConsultListForFraRsv, { startrsvno: rsvno[i], endrsvno: rsvno[i] });
      if (!result || result.length <= 0) {
        return yield put(consultModules.openRsvCslListChangedDateGuideSuccess({
          data: { errors: ['受診情報が存在しません。'] },
        }));
      }
      payload.push(result[0]);
    }
    // 受診日一括変更(変更完了)ガイドオープン成功Actionを発生させる
    return yield put(consultModules.openRsvCslListChangedDateGuideSuccess(payload));
  } catch (error) {
    // 受診日一括変更(変更完了)ガイドオープン失敗Actionを発生させる
    return yield put(consultModules.openRsvCslListChangedDateGuideSuccess(error.response));
  }
}

// お連れ様情報登録ガイドオープン開始Action発生時処理
function* runOpenEditGuide(action) {
  try {
    // 受診情報取得処理
    const consult = yield call(consultService.getConsult, action.payload);
    // データ取得処理
    const result = yield all({
      // 個人情報
      person: call(personService.getPerson, { params: { perid: consult.perid } }),
      // お連れ様情報
      friends: call(consultService.getFriends, { rsvno: action.payload.rsvno, csldate: consult.csldate }),
    });

    // 変更前の同伴者の個人IDを別変数で保持
    // 名前を結合して別名で保持
    const friends = result.friends.map((rec) => ({
      ...rec,
      compperidorg: rec.compperid,
      name: `${rec.lastname}${'　'}${rec.firstname}`.trim(),
      kananame: `${rec.lastkname}${'　'}${rec.firstkname}`.trim(),
    }));

    // お連れ様情報登録ガイドオープン成功Actionを発生させる
    yield put(consultModules.openEditFriendsGuideSuccess({ ...result, friends, consult }));
  } catch (error) {
    // お連れ様情報登録ガイドオープン失敗Actionを発生させる
    yield put(consultModules.openEditFriendsGuideFailure(error.resposne));
  }
}

// お連れ様情報登録ガイド情報削除開始Action発生時処理
function* runDeleteEditFriendsGuide(action) {
  try {
    // 何もせずに終了した場合のメッセージをセット
    let payload = { messages: [] };
    // お連れ様単位が0出ない場合はお連れ様情報削除
    if (action.payload.seq > 0) {
      payload = yield call(consultService.deleteFriends, action.payload);
    }
    // お連れ様情報登録ガイド情報削除成功Actionを発生させる
    yield put(consultModules.deleteEditFriendsGuideSuccess(payload));
    // お連れ様情報登録ガイドを取得し直す
    const params = yield select((state) => state.app.reserve.consult.editFriendsGuide.params);
    yield put(consultModules.openEditFriendsGuideRequest(params));
  } catch (error) {
    // お連れ様情報登録ガイド情報削除失敗Actionを発生させる
    yield put(consultModules.deleteEditFriendsGuideFailure(error.response));
  }
}

// お連れ様情報登録ガイド登録開始Action発生時処理
function* runRegisterEditFriendsGuide(action) {
  try {
    const readParams = yield select((state) => state.app.reserve.consult.editFriendsGuide.params);
    const values = action.payload.filter((rec) => rec && rec.rsvno);

    // お連れ様情報がない場合、お連れ様が初めから登録されていない場合は警告文を表示し
    // お連れ様を削除した場合は削除処理を行う
    if (values.length === 1) {
      // お連れ様単位が0以下であれば初登録と判定
      if (values[0].seq <= 0) {
        return yield put(consultModules.registerEditFriendsGuideFailure({
          data: { errors: ['お連れ様が一人もいない場合は保存できません。'] },
        }));
      }

      // 削除処理
      const payload = yield call(consultService.deleteFriends, {
        csldate: values[0].csldate,
        seq: values[0].seq,
      });
      yield put(consultModules.registerEditFriendsGuideSuccess(payload));
      // お連れ様情報登録ガイドを読み直す
      return yield put(consultModules.openEditFriendsGuideRequest(readParams));
    }

    // 登録用にデータを整形
    const data = {
      csldate: values[0].csldate,
      seq: values[0].seq,
      rsvno: values.filter((rec) => rec).map((rec) => rec.rsvno),
      samegrp1: values.filter((rec) => rec).map((rec) => rec.samegrp1),
      samegrp2: values.filter((rec) => rec).map((rec) => rec.samegrp2),
      samegrp3: values.filter((rec) => rec).map((rec) => rec.samegrp3),
      perid: values.filter((rec) => rec && rec.compperid !== rec.compperidorg).map((rec) => rec.perid),
      compperid: values.filter((rec) => rec && rec.compperid !== rec.compperidorg).map((rec) => rec.compperid),
    };
    // お連れ様情報登録処理
    const payload = yield call(consultService.registerFriends, data);
    // お連れ様情報登録成功Actionを発生させる
    yield put(consultModules.registerEditFriendsGuideSuccess(payload));
    // お連れ様情報登録ガイドを読み直す
    return yield put(consultModules.openEditFriendsGuideRequest(readParams));
  } catch (error) {
    // お連れ様情報登録失敗Actionを発生させる
    return yield put(consultModules.registerEditFriendsGuideFailure(error.response));
  }
}

// 受診日一括変換ガイドオープン開始Action発生時に実行する処理
function* runOpenRsvChangeDateAllGuide(action) {
  try {
    const { rsvno } = action.payload;

    // 受診情報を読み、現在の受診日を取得
    let consult = [];
    try {
      consult = yield call(consultService.getConsult, { rsvno });
    } catch (error) {
      const response = { ...error.response,
        data: { errors: ['受診情報が存在しません。'] } };
      const newError = { ...error, response };
      throw newError;
    }

    // お連れ様情報読み込み
    let friendsOrigin = [];
    try {
      friendsOrigin = yield call(consultService.getFriends, { rsvno, csldate: consult.csldate });
    } catch (error) {
      const response = { ...error.response,
        data: { errors: ['受診情報が存在しません。'] } };
      const newError = { ...error, response };
      throw newError;
    }

    // 受診日がシステム日付より前の日付であればドロップダウンの選択肢として全予約群を取得する
    let allRsvGrpItems = null;
    if (moment(consult.csldate).isBefore(moment(), 'day')) {
      const list = yield call(scheduleService.getRsvGrpList, {});
      if (list && Array.isArray(list.data)) {
        allRsvGrpItems = list.data.map((rec) => ({ name: rec.rsvgrpname, value: rec.rsvgrpcd }));
      }
    }

    const friends = [];

    for (let i = 0; i < friendsOrigin.length; i += 1) {
      // 受診日変更可否の情報を作成
      // 受付番号がなく（受付されていない状態）キャンセルされていない場合は受診日変更可能
      let changeTarget = { isTarget: false };
      if (!friendsOrigin[i].dayid && friendsOrigin[i].cancelflg === CONSULT_USED) {
        changeTarget = { isTarget: true, isChange: true };
      }

      // 全予約群を取得していればそれを予約群ドロップダウンの選択肢としてセットする
      // そうでなければお連れ様のコースコードをもとにそれぞれの予約群ドロップダウンの選択肢を取得する
      if (allRsvGrpItems) {
        friends.push({ friend: friendsOrigin[i], rsvGrpItems: allRsvGrpItems, ...changeTarget });
      } else {
        const list = yield call(scheduleService.getCscdRsvGrpList, { cscd: friendsOrigin[i].cscd, csldate: consult.csldate });

        let rsvGrpItems = [];
        if (Array.isArray(list)) {
          rsvGrpItems = list.map((rec) => ({ name: rec.rsvgrpname, value: rec.rsvgrpcd }));
        }

        friends.push({ friend: friendsOrigin[i], rsvGrpItems, ...changeTarget });
      }
    }
    // 受診日一括変更ガイドオープン成功Actionを発生させる
    yield put(consultModules.openRsvChangeDateAllGuideSuccess({ consult, friends }));
  } catch (error) {
    // 受診日一括変更ガイドオープン成功Actionを失敗させる
    yield put(consultModules.openRsvChangeDateAllGuideFailure(error.response));
  }
}

// 受診情報一覧取得Action発生時に起動するメソッド
function* runRequestDailyList(action) {
  try {
    const params = action.payload;

    // 引数値の取得
    let { key = '', strDate = '', endDate = '', prtField = '',
      sortKey = 0, sortType = 0, startPos = 0, getCount = '' } = params;
    const { csCd = '', orgCd1 = '', orgCd2 = '',
      itemCd = '', grpCd = '', entry = '',
      rsvStat = '', rptStat = '', cslDivCd = '' } = params;
    // 検索キー中の半角カナを全角カナに変換する
    key = hankana2zenkana(key);

    // 検索キー中の小文字を大文字に変換する
    key = key.toUpperCase();
    // 全角空白を半角空白に置換する
    key = key.trim().replace('　', ' ');

    // 2バイト以上の半角空白文字が存在しなくなるまで置換を繰り返す
    while (key.includes('  ')) {
      key = key.replace('  ', ' ');
    }
    // 出力項目のデフォルト値設定
    prtField = (prtField === '' ? 'RSVLIST1' : prtField);

    // 出力開始位置のデフォルト値として１を設定
    startPos = (startPos === 0 ? 1 : startPos);
    // １ページ表示行数のデフォルト値設定
    getCount = (getCount === '' ? '20' : getCount);

    // 表示項目の取得処理実行
    let payload = yield call(freeService.getFree, { mode: '0', freecd: prtField.toUpperCase() });

    let lngArrPrtField = [];
    // 表示項目の配列
    let strArrPrtField = [];
    const strPrtFieldName = payload[0].freename == null ? '' : payload[0].freename;
    let strPrtFields = payload[0].freefield1 == null ? '' : payload[0].freefield1; // 表示項目制御フラグ
    const vntFreeField2 = payload[0].freefield2 == null ? '' : payload[0].freefield2;
    if (vntFreeField2 !== '') {
      strPrtFields = strPrtFields + (strPrtFields !== '' ? ',' : '') + vntFreeField2;
    }

    if (strPrtFields !== '') {
      strArrPrtField = strPrtFields.split(',');
      if (strArrPrtField.length > 0) {
        lngArrPrtField = strArrPrtField.map((value) => (parseInt(value, 10)));
      }
    }

    if (lngArrPrtField.length === 0) {
      yield put(consultModules.getDailyListSuccess({ message: ['表示すべき項目が指定されていません。'], prtFieldName: '', arrPrtField: [], totalcount: 0, data: [] }));
    } else {
      // ソートキー未指定時は表示項目の先頭項目を適用する
      if (sortKey === 0) {
        sortKey = parseInt(lngArrPrtField[0], 10);
        sortType = 0;
      }

      // 終了日未設定時は何もしない
      if (endDate !== '') {
        // 開始日未設定、または開始日より終了日が過去であれば
        if (strDate === '' || moment(strDate, 'YYYY/MM/DD').isAfter(moment(endDate, 'YYYY/MM/DD'))) {
          // 値を交換
          let dtmDate = '';
          dtmDate = strDate;
          strDate = endDate;
          endDate = dtmDate;
        }
        // 更に同値の場合、終了日はクリア
        if (strDate === endDate) {
          // 値を交換
          endDate = '';
        }
      }

      // 検索キー、受診日のいずれかが指定されていない場合は検索を行わない
      if (strDate === '' && endDate === '' && key === '') {
        yield put(consultModules.getDailyListSuccess({ message: ['検索条件を満たす受診情報は存在しません。'], prtFieldName: strPrtFieldName, arrPrtField: lngArrPrtField, totalcount: 0, data: [] }));
      } else {
        // 受診情報の読み込み
        const dailyListParams = {
          key,
          startCslDate: strDate,
          endCslDate: endDate,
          csCd,
          orgCd1,
          orgCd2,
          grpCd,
          itemCd,
          entry,
          sortKey: parseInt(sortKey, 10),
          sortType: parseInt(sortType, 10),
          startPos: (startPos - 1) * parseInt(getCount, 10),
          getCount,
          printFields: lngArrPrtField,
          rsvStat,
          rptStat,
          cslDivCd,
        };
        payload = yield call(consultService.getDailyList, { params: dailyListParams });
        if (payload.totalcount === 0) {
          yield put(consultModules.getDailyListSuccess({ message: ['検索条件を満たす受診情報は存在しません。'], prtFieldName: strPrtFieldName, arrPrtField: lngArrPrtField, totalcount: 0, data: [] }));
        } else {
          // 受診情報一覧取得成功Actionを発生させる
          yield put(consultModules.getDailyListSuccess({ message: [], prtFieldName: strPrtFieldName, arrPrtField: lngArrPrtField, ...payload }));
        }
      }
    }

    yield put(consultModules.setDailyListParams({
      newParams: {
        key,
        strDate,
        endDate,
        csCd,
        prtField,
        orgCd1,
        orgCd2,
        grpCd,
        itemCd,
        sortKey: parseInt(sortKey, 10),
        sortType: parseInt(sortType, 10),
        startPos: parseInt(startPos, 10),
        getCount,
        rsvStat,
        rptStat,
        cslDivCd,
        isSearching: false,
      },
    }));
  } catch (error) {
    // 受診情報一覧取得失敗Actionを発生させる
    yield put(consultModules.getDailyListFailure(error.response));
  }
}

function* runloadPreparationInfo(action) {
  try {
    // 受診情報検索
    const consult = yield call(consultService.getConsult, action.payload);

    // 団体テーブルレコード読み込み
    const org = yield call(organizationService.getOrg, consult);
    let perResult = {};
    let disease = {};
    let cmntHis = {};

    try {
      consult.grpCd = 'X039';
      consult.allDataMode = 1;
      // 個人検査結果情報取得
      perResult = yield call(perResultService.getPerResultList, consult);
    } catch (error) {
      // 受診情報を取得する失敗Actionを発生させる
      yield put(consultModules.loadPreparationInfoFailure(error.response));
    }

    try {
      consult.grpCd = 'X028';
      consult.getSeqMode = 1;
      consult.allDataMode = 0;

      // 既往歴結果情報取得
      disease = yield call(perResultService.getPerResultList, consult);
    } catch (error) {
      // 受診情報を取得する失敗Actionを発生させる
      yield put(consultModules.loadPreparationInfoFailure(error.response));
    }

    try {
      consult.dispMode = 1;
      consult.hisCount = '*';
      consult.rsvNo = action.payload.rsvno;
      consult.selectMode = 1;

      // 総合コメント取得
      cmntHis = yield call(interviewService.getTotalJudCmt, consult);
    } catch (error) {
      // 受診情報を取得する失敗Actionを発生させる
      yield put(consultModules.loadPreparationInfoFailure(error.response));
    }
    const payload = { consult, org, perResult, disease, cmntHis };
    // 受診情報を取得する成功Actionを発生させる
    yield put(consultModules.loadPreparationInfoSuccess(payload));
  } catch (error) {
    // 受診情報を取得する失敗Actionを発生させる
    yield put(consultModules.loadPreparationInfoFailure(error.response));
  }
}

// グループ一覧取得Action発生時に起動するメソッド
function* runReceiptAll(action) {
  try {
    // グループ一覧取得処理実行
    const payload = yield call(consultService.runReceiptAll, action.payload);
    // グループ一覧取得成功Actionを発生させる
    yield put(consultModules.receiptAllSuccess(payload));
  } catch (error) {
    // グループ一覧取得失敗Actionを発生させる
    yield put(consultModules.receiptAllFailure(error.response));
  }
}

// グループ情報取得Action発生時に起動するメソッド
function* runCancelReceiptAll(action) {
  try {
    // グループ情報取得処理実行
    const payload = yield call(consultService.runCancelReceiptAll, action.payload);
    // グループ情報取得成功Actionを発生させる
    yield put(consultModules.cancelReceiptAllSuccess(payload));
  } catch (error) {
    // グループ情報取得失敗Actionを発生させる
    yield put(consultModules.cancelReceiptAllFailure(error.response));
  }
}

// 個人検査結果テーブルを更新取得Action発生時に起動するメソッド
function* runMergePerResult(action) {
  try {
    // グループ情報取得処理実行
    const payload = yield call(perResultService.mergePerResult, action.payload);
    // グループ情報取得成功Actionを発生させる
    yield put(consultModules.mergePerResultSuccess(payload));
  } catch (error) {
    // グループ情報取得失敗Actionを発生させる
    yield put(consultModules.mergePerResultFailure(error.response));
  }
}

// 個人検査結果テーブルを削除取得Action発生時に起動するメソッド
function* runDeletePerResult(action) {
  try {
    // グループ情報取得処理実行
    const payload = yield call(perResultService.deletePerResult, action.payload);
    // グループ情報取得成功Actionを発生させる
    yield put(consultModules.deletePerResultSuccess(payload));
  } catch (error) {
    // グループ情報取得失敗Actionを発生させる
    yield put(consultModules.deletePerResultFailure(error.response));
  }
}

// 来院情報の更新Action発生時に起動するメソッド
function* runUpdateWelComeInfo(action) {
  try {
    // 来院情報の更新処理実行
    const { data } = action.payload;
    yield call(consultService.checkWelComeInfo, data);
    yield call(consultService.updateWelComeInfo, data);

    const { visible } = false;
    yield put(consultModules.updateWelComeInfoSuccess({ visible }));
  } catch (error) {
    // 来院制御エラー時はフラグ成立
    const visitstatus = -1;
    let visiterror = false;
    if (visitstatus != null) {
      if (visitstatus <= 0) {
        visiterror = true;
      }
    }

    // 来院情報の更新失敗Actionを発生させる
    yield put(consultModules.updateWelComeInfoFailure({ error: error.response, visitstatus, visiterror }));
  }
}

// 来院情報検索Action発生時に起動するメソッド
function* runRequestWelComeInfo(action) {
  try {
    // 来院情報検索処理実行
    const payload = yield call(consultService.getWelComeInfo, action.payload);
    yield put(consultModules.getWelComeInfoSuccess(payload));
  } catch (error) {
    // 来院情報検索失敗Actionを発生させる
    const { rsvno } = action.payload;
    yield put(consultModules.getWelComeInfoFailure({ error: error.response, rsvno }));
  }
}

// 来院処理受付確定後Action発生時に起動するメソッド
function* runRegisterWelComeInfo(action) {
  let realagetxt = '';
  try {
    let message = [];
    // 来院確認の入力チェック
    const { values } = action.payload.data;
    yield call(consultService.checkRegisterWelComeInfo, values);

    // 来院確定、検索処理実行
    const { data } = action.payload;
    const getdata = yield call(consultService.getWelComeInfo, data);

    if (getdata != null) {
      if (getdata.birth != null) {
        try {
          // 実年齢を取得
          const agedata = { birth: getdata.birth };
          const payload = yield call(freeService.calcAge, agedata);
          const realage = payload.realAge;
          if (realage != null) {
            realagetxt = Math.floor(realage.toString());
          }
        } catch (error) {
          message = ['実年齢取得エラー。'];
          yield put(consultModules.loadPeceiptMainFailure(message));
          return;
        }
      }
    }

    // 来院確定、更新処理実行
    const updatedata = { rsvno: data.rsvno, mode: 0, welcome: 1, ocrno: data.values.ocrno };
    yield call(consultService.updateWelComeInfo, updatedata);

    // 受付確認検索あるの場合
    if (getdata != null) {
      let errstauts = null;
      let date = null;

      const checkdata = moment(getdata.csldate).format('YYYY/MM/DD');
      const nowdate = moment(new Date()).format('YYYY/MM/DD');

      if (getdata.dayid === null) {
        message = ['受付されていません。'];
      } else if (checkdata !== null && checkdata !== nowdate) {
        message = [`受診日(${checkdata})は本日ではありません。`];
      } else if (getdata.comedate !== null) {
        message = ['すでに来院済みです。'];
      }

      if (message.length > 0) {
        errstauts = 'checkerr';
        date = { errstauts, message, getdata, realagetxt };
        yield put(consultModules.registerWelComeInfoFailure(date));
      }
    }
    // 受付確認処理エラーなしの場合
    const { jumpsource, rsvno } = data;
    const nextparms = { rsvno };
    if (jumpsource === 'ReserveMain' || jumpsource === 'ReceiptMain') {
      if (message.length === 0) {
        yield put(consultModules.openReceiptMainGuide(nextparms));
      }
    }
  } catch (error) {
    // 来院処理受付確定失敗Actionを発生させる
    const message = ['予約されていません。'];
    yield put(consultModules.registerWelComeInfoFailure({ error: error.response, message, realagetxt }));
  }
}


// 来院情報検索Action発生時に起動するメソッド
function* runLoadPeceiptMainInfo(action) {
  // 来院情報
  let getwelcomedata = null;
  // 受診オプション管理情報
  let getoptdata = null;
  // お連れ様情報を取得
  let getfriendsdata = null;
  // ノート情報
  let getpubnotedata = null;
  // ノート情報の取得(団体)
  let getpubnoteteamdata = null;
  // ノート情報の取得(契約)
  let getpubnotecontractdata = null;
  // 指定された予約番号の受診歴一覧情報
  let gethisdata = null;
  // 個人検査結果情報
  let getperrsldata = null;
  // エラーメッセージ
  let message = [];
  // 使用予約番号
  const { rsvno } = action.payload;
  // 実年齢
  let realagetxt = '';

  // 来院情報検索
  try {
    getwelcomedata = yield call(consultService.getWelComeInfo, action.payload);
    if (getwelcomedata != null) {
      if (getwelcomedata.birth != null) {
        try {
          // 実年齢を取得
          const data = { birth: getwelcomedata.birth };
          const payload = yield call(freeService.calcAge, data);
          const realage = payload.realAge;
          if (realage != null) {
            realagetxt = Math.floor(realage.toString());
          }
        } catch (error) {
          const data = { getwelcomedata };
          message = ['実年齢取得エラー。'];
          yield put(consultModules.loadPeceiptMainFailure(message, data));
          return;
        }
      }
    }
  } catch (error) {
    const data = { getwelcomedata };
    message = [`来院情報が存在しません。（予約番号 = ${rsvno})`];
    yield put(consultModules.loadPeceiptMainFailure(message, data));
    return;
  }

  // 受診オプション管理情報検索
  try {
    const optparms = { hidekbn: 3, rsvno };
    getoptdata = yield call(consultService.getConsultO, optparms);
  } catch (error) {
    const data = { getwelcomedata };
    message = [`受診オプション管理情報が取得できません。（予約番号 = ${rsvno})`];
    yield put(consultModules.loadPeceiptMainFailure({ message, data, realagetxt }));
    return;
  }

  // お連れ様情報を取得（お連れ様がいない場合も自分自身の情報は返ってくるので注意）
  try {
    const { csldate } = getwelcomedata;
    const friendparms = { csldate, rsvno };
    getfriendsdata = yield call(consultService.getFriends, friendparms);
  } catch (error) {
    if (error.visitstatus !== 404) {
      const { csldate } = getwelcomedata;
      const data = { getwelcomedata, getoptdata };
      message = [`お連れ様情報が存在しません。（受診日= ${csldate} 予約番号=${rsvno} )`];
      yield put(consultModules.loadPeceiptMainFailure({ message, data, realagetxt }));
      return;
    }
  }

  // ノート情報の取得
  try {
    // 検索情報
    let selInfo = '';
    // ノート情報の取得
    selInfo = 0;
    const pubnoteparms = { selInfo, histflg: 0, startdate: '', enddate: '', rsvno, perid: '', orgcd1: '', orgcd2: '', ctrptcd: '', seq: 0, pubnotedivcd: '', dispkbn: 0 };
    getpubnotedata = yield call(pubNoteService.getPubNote, pubnoteparms);
    // ノート情報の取得(団体)
    selInfo = 3;
    const pubnoteteamparms = { selInfo, histflg: 0, startdate: '', enddate: '', rsvno, perid: '', orgcd1: '', orgcd2: '', ctrptcd: '', seq: 0, pubnotedivcd: '', dispkbn: 0 };
    getpubnoteteamdata = yield call(pubNoteService.getPubNote, pubnoteteamparms);
    // ノート情報の取得(契約)
    selInfo = 4;
    const pubnotecontractparms = { selInfo, histflg: 0, startdate: '', enddate: '', rsvno, perid: '', orgcd1: '', orgcd2: '', ctrptcd: '', seq: 0, pubnotedivcd: '', dispkbn: 0 };
    getpubnotecontractdata = yield call(pubNoteService.getPubNote, pubnotecontractparms);

    if (getpubnotedata === null && getpubnoteteamdata === null && getpubnotecontractdata === null) {
      message = ['ノート情報が存在しません。'];
      const data = { getwelcomedata, getoptdata, getfriendsdata, getpubnotedata, getpubnoteteamdata, getpubnotecontractdata };
      yield put(consultModules.loadPeceiptMainFailure({ message, data, realagetxt }));
      return;
    }
  } catch (error) {
    message = ['ノート情報が存在しません。'];
    const data = { getwelcomedata, getoptdata, getfriendsdata, getpubnotedata, getpubnoteteamdata, getpubnotecontractdata };
    yield put(consultModules.loadPeceiptMainFailure({ message, data, realagetxt }));
  }

  // 指定された予約番号の受診歴一覧を取得する
  try {
    const gethisparms = { rsvNo: rsvno, receptonly: false, lastdspmode: 0, csgrp: '', getrowcount: 2, selectmode: 0, datesort: '' };
    gethisdata = yield call(interviewService.GetConsultHistory, gethisparms);
  } catch (error) {
    message = [`受診歴が取得できません。（予約番号 = ${rsvno})`];
    const data = { getwelcomedata, getoptdata, getfriendsdata, getpubnotedata, getpubnoteteamdata, getpubnotecontractdata };
    yield put(consultModules.loadPeceiptMainFailure({ message, data, realagetxt }));
    return;
  }

  // 個人検査結果情報取得
  try {
    const { perid } = getwelcomedata;
    const parms = { perid, grpcd: 'X039', getseqmode: 2, alldatamode: 0 };
    getperrsldata = yield call(perResultService.getPerResultList, parms);
  } catch (error) {
    if (error.response.status !== 404 && error.response.status >= 500) {
      const { perid } = getwelcomedata;
      message = [`個人検査結果情報が存在しません。（個人ID= ${perid})`];
      const data = { getwelcomedata, getoptdata, getfriendsdata, getpubnotedata, getpubnoteteamdata, getpubnotecontractdata, gethisdata };
      yield put(consultModules.loadPeceiptMainFailure({ message, data, realagetxt }));
      return;
    }
  }
  const data = { getwelcomedata, getoptdata, getfriendsdata, getpubnotedata, getpubnoteteamdata, getpubnotecontractdata, gethisdata, getperrsldata };
  yield put(consultModules.loadPeceiptMainSuccess({ data, realagetxt, message }));
}
// 受診者情報取得Action発生時に起動するメソッド
function* runOpenChangeOptionGuide(action) {
  try {
    const { params } = action.payload;
    const { rsvno } = params;
    let consultdata = null;
    let optiondata = null;
    let realage = null;
    // 受診情報取得処理実行
    consultdata = yield call(consultService.getConsult, params);
    // 現在の受診オプション検査情報取得処理実行
    optiondata = yield call(consultService.getConsultOptions, { rsvno });
    const { csldate, csldivcd, ctrptcd, perid, birth } = consultdata;

    try {
      let optfromconsultdata = null;
      // 実年齢の計算
      if (birth !== null && birth !== '') {
        const calcage = yield call(freeService.calcAge, { birth });
        const { realAge } = calcage;
        if (realAge !== null) {
          realage = Number.parseInt(realAge, 10);
        }
      }
      // 指定契約パターンの全オプション検査を取得
      optfromconsultdata = yield call(contractService.getCtrPtOptFromConsult, {
        csldate,
        csldivcd,
        ctrptcd,
        perid,
        exceptnomatch: true,
        includetax: false });
      // 指定契約パターンの全オプション検査を取得成功Actionを発生させる
      yield put(consultModules.getCtrPtOptFromConsultSuccess({ optfromconsultdata, optiondata }));
    } catch (error) {
      yield put(consultModules.getConsultFailure(error.response));
    }

    try {
      let changesetdata = null;
      const freecd = FreeCd.Chgsetgrp;
      // 結果コメント情報読を取得
      changesetdata = yield call(rslCmtService.getRslCmtListForChangeSet, {
        rsvno,
        freecd,
      });
      // 結果コメント情報を取得成功Actionを発生させる
      yield put(consultModules.getRslCmtListForChangeSetSuccess({ changesetdata, rsvno }));
    } catch (error) {
      yield put(consultModules.getConsultFailure(error.response));
    }
    // 受診情報取得成功Actionを発生させる
    yield put(consultModules.getConsultSuccess({ consultdata, realage }));
  } catch (error) {
    // 受診情報取得失敗Actionを発生させる
    yield put(consultModules.getConsultFailure(error.response));
  }
}
// 来院済み受診者のみ対象
function* runConsultListRequest(action) {
  const { cntlNo, cscd, grpcd, cslDate, dayIdF, dayIdT } = action.payload;
  const checkparam = {};
  if (action.payload.allResultClear && action.payload.allResultClear === 1) {
    checkparam.allResultClear = 1;
  }
  try {
    checkparam.cntlNo = cntlNo;
    checkparam.cscd = cscd;
    checkparam.grpcd = grpcd;
    checkparam.cslDate = cslDate;
    if (dayIdF) {
      if (dayIdF.length === 1) {
        checkparam.dayIdF = `000${dayIdF}`;
      } else if (dayIdF.length === 2) {
        checkparam.dayIdF = `00${dayIdF}`;
      } else if (dayIdF.length === 3) {
        checkparam.dayIdF = `0${dayIdF}`;
      } else {
        checkparam.dayIdF = dayIdF;
      }
    }
    if (dayIdT) {
      if (dayIdF.length === 1) {
        checkparam.dayIdT = `000${dayIdT}`;
      } else if (dayIdT.length === 2) {
        checkparam.dayIdT = `00${dayIdT}`;
      } else if (dayIdT.length === 3) {
        checkparam.dayIdT = `0${dayIdT}`;
      } else {
        checkparam.dayIdT = dayIdT;
      }
    }
    checkparam.comeOnly = true;
    checkparam.startDayId = checkparam.dayIdF;
    checkparam.endDayId = checkparam.dayIdT;
    if (action.payload.step && action.payload.step === 'step1') {
      const year = action.payload.cslDate.split('/')[0];
      const month = action.payload.cslDate.split('/')[1];
      const day = action.payload.cslDate.split('/')[2];
      const fromBody = {};
      fromBody.year = year;
      fromBody.month = month;
      fromBody.day = day;
      fromBody.dayIdF = dayIdF;
      fromBody.dayIdT = dayIdT;
      const payload = yield call(consultService.getConsultList, checkparam);
      payload.checkParam = checkparam;
      yield put(consultModules.getConsultListItemSuccess(payload));
      if (payload && payload.totalCount && payload.totalCount > 0) {
        action.payload.props.onNext();
      } else {
        yield put(consultModules.getConsultListItemFailure(checkparam));
      }
    } else if (action.payload.step && action.payload.step === 'step2') {
      const payload2 = yield call(consultService.getConsultList, checkparam);
      payload2.checkParam = checkparam;
      yield put(consultModules.getConsultListItemSuccess(payload2));
      if (payload2 && payload2.totalCount && payload2.totalCount > 0) {
        action.payload.props.onNext();
      } else {
        yield put(consultModules.getConsultListItemFailure(checkparam));
      }
    } else if (action.payload.step && action.payload.step === 'step3') {
      const payloadThree = yield call(consultService.getConsultList, checkparam);
      payloadThree.checkParam = checkparam;
      yield put(consultModules.getConsultListItemSuccess(payloadThree));
    }
  } catch (error) {
    yield put(consultModules.getConsultListItemFailure(checkparam));
  }
}


// 検査結果テーブルのコメントと中止フラグを更新Action発生時に起動するメソッド
function* runUpdateResultForChangeSet(action) {
  try {
    // 検査結果テーブルのコメントと中止フラグを更新する処理
    const payload = yield call(resultService.updateResultForChangeSet, action.payload);
    // 検査結果テーブルのコメントと中止フラグを更新する成功Actionを発生させる
    yield put(consultModules.updateResultForChangeSetSuccess(payload));
  } catch (error) {
    // 検査結果テーブルのコメントと中止フラグを更新する失敗Actionを発生させる
    yield put(consultModules.updateResultForChangeSetFailure(error.response));
  }
}


// Actionとその発生時に実行するメソッドをリンクさせる
const consultSagas = [
  takeEvery(consultModules.getConsultListGuideRequest.toString(), runRequestConsultListGuide),
  takeEvery(consultModules.getConsultGuideRequest.toString(), runRequestConsultGuide),
  takeEvery(consultModules.getConsultRequest.toString(), runRequestConsult),
  takeEvery(consultModules.openConsultationListGuide.toString(), runOpenConsultationListGuide),
  takeEvery(consultModules.getConsultationListGuideRequest.toString(), runRequestConsultationListGuide),
  takeEvery(consultModules.openReserveMainRequest.toString(), runOpenReserveMain),
  takeEvery(consultModules.calcAgeRequest.toString(), runCalcAge),
  takeEvery(consultModules.selectReserveMainPersonRequest.toString(), runSelectReserveMainPerson),
  takeEvery(consultModules.getReserveMainCourceItemsRequest.toString(), runRequestReserveMainCourceItems),
  takeEvery(consultModules.getReserveMainCslDivItemsRequest.toString(), runRequestReserveMainCslDivItems),
  takeEvery(consultModules.getReserveMainOptionsRequest.toString(), runRequestReserveMainOptions),
  takeEvery(consultModules.getReserveMainRsvGrpItemsRequest.toString(), runRequestReserveMainRsvGrpItems),
  takeEvery(consultModules.getReserveMainRsvGrpItemsAllRequest.toString(), runRequestReserveMainRsvGrpItemsAll),
  takeEvery(consultModules.registerConsultRequest.toString(), runRegisterConsult),
  takeEvery(consultModules.openEntryFromDetailGuideRequest.toString(), runOpenEntryFromDetailGuide),
  takeEvery(consultModules.getCourseEntryFromDetailGuideRequest.toString(), runRequestCourseEntryFromDetailGuide),
  takeEvery(consultModules.getPersonEntryFromDetailGuideRequest.toString(), runRequestPersonEntryFromDetailGuide),
  takeEvery(consultModules.validateConsultEntryFromDetailRequest.toString(), runValidateEntryFromDetailGuide),
  takeEvery(consultModules.openPrintStatusGuide.toString(), runOpenPrintStatuGuide),
  takeEvery(consultModules.getPrintStatusRequest.toString(), runRequestPrintStatusGuide),
  takeEvery(consultModules.registerPrintStatusRequest.toString(), runRegisterPrintStatusGuide),
  takeEvery(consultModules.openCancelReceptionGuide.toString(), rundOpenCancelReceptionGuide),
  takeEvery(consultModules.getConsultCancelReceptionGuideRequest.toString(), runGetConsultCancelReceptionGuide),
  takeEvery(consultModules.executeCancelReceptionGuideRequest.toString(), runExecuteCancelReceptionGuide),
  takeEvery(consultModules.openCancelConsultGuide.toString(), runOpenCancelConsultGuide),
  takeEvery(consultModules.getCancelReasonsRequest.toString(), runRequestReasonsCancelGuide),
  takeEvery(consultModules.registerCancelConsultRequest.toString(), runRegisterCancelConsult),
  takeEvery(consultModules.getCancelReasonNameRequest.toString(), runGetCancelReasonName),
  takeEvery(consultModules.openConsultDeleteItemGuide.toString(), runOpenConsultDeleteItemGuide),
  takeEvery(consultModules.getContractOptionDeleteItemGuideRequest.toString(), runRequestContractOptionDeleteItemGuide),
  takeEvery(consultModules.getContractOptionItemsDeleteItemGuideRequest.toString(), runRequestContractOptionItemsDeleteItemGuide),
  takeEvery(consultModules.registerContractOptionItemsDeleteItemGuideRequest.toString(), runRegisterContractOptionsItemsDeleteItemGuide),
  takeEvery(consultModules.openRsvCalendarFromRsvNoGuideRequest.toString(), runOpenRsvCalendarFromRsvNoGuide),
  takeEvery(consultModules.changeDateRsvCalendarFromRsvNoGuideRequest.toString(), runChangeDateRsvCalendarFromRsvNoGuide),
  takeEvery(consultModules.registerDateRsvCalendarFromRsvNoGuideRequest.toString(), runRegisterDateRsvCalendarFromRsvNoGuide),
  takeEvery(consultModules.openRsvCslListChangedDateGuideRequest.toString(), runOpenRsvCslListChangedDateGuide),
  takeEvery(consultModules.openEditFriendsGuideRequest.toString(), runOpenEditGuide),
  takeEvery(consultModules.deleteEditFriendsGuideRequest.toString(), runDeleteEditFriendsGuide),
  takeEvery(consultModules.registerEditFriendsGuideRequest.toString(), runRegisterEditFriendsGuide),
  takeEvery(consultModules.openRsvChangeDateAllGuideRequest.toString(), runOpenRsvChangeDateAllGuide),
  takeEvery(consultModules.getDailyListRequest.toString(), runRequestDailyList),
  takeEvery(consultModules.receiptAllRequest.toString(), runReceiptAll),
  takeEvery(consultModules.cancelReceiptAllRequest.toString(), runCancelReceiptAll),
  takeEvery(consultModules.loadPreparationInfoRequest.toString(), runloadPreparationInfo),
  takeEvery(consultModules.mergePerResultRequest.toString(), runMergePerResult),
  takeEvery(consultModules.deletePerResultRequest.toString(), runDeletePerResult),
  takeEvery(consultModules.updateWelComeInfoRequest.toString(), runUpdateWelComeInfo),
  takeEvery(consultModules.openEditWelComeInfoGuide.toString(), runRequestWelComeInfo),
  takeEvery(consultModules.registerWelComeInfoRequest.toString(), runRegisterWelComeInfo),
  takeEvery(consultModules.loadPeceiptMainInfo.toString(), runLoadPeceiptMainInfo),
  takeEvery(consultModules.openChangeOptionGuide.toString(), runOpenChangeOptionGuide),
  takeEvery(consultModules.updateResultForChangeSetRequest.toString(), runUpdateResultForChangeSet),
  takeEvery(consultModules.getConsultLogListRequest.toString(), runRequestConsultLogList),
  takeEvery(consultModules.getConsultListItemRequest.toString(), runConsultListRequest),
];

export default consultSagas;
