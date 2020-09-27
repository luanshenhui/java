import { call, takeEvery, put } from 'redux-saga/effects';
import { initialize } from 'redux-form';
import moment from 'moment';
import personService from '../../services/preference/personService';
import perResultService from '../../services/preference/perResultService';
import freeService from '../../services/preference/freeService';
import prefService from '../../services/preference/prefService';

import {
  getPersonGuideListRequest,
  getPersonGuideListSuccess,
  getPersonGuideListFailure,
  getPersonGuideRequest,
  getPersonGuideSuccess,
  getPersonGuideFailure,
  getPersonListRequest,
  getPersonListSuccess,
  getPersonListFailure,
  getPersonRequest,
  getPersonFailure,
  deletePersonRequest,
  deletePersonSuccess,
  deletePersonFailure,
  getFreeRequest,
  getFreeRequestSuccess,
  getFreeRequestFailure,
  registerPersonRequest,
  registerPersonSuccess,
  registerPersonFailure,
  getPerInspectionRequest,
  getPerInspectionSuccess,
  getPerInspectionFailure,
  getPerInspectionListRequest,
  getPerInspectionListSuccess,
  getPerInspectionListFailure,
  registerPerInspectionRequest,
  registerPerInspectionSuccess,
  registerPerInspectionFailure,
} from '../../modules/preference/personModule';

// 個人情報ガイド一覧取得Action発生時に起動するメソッド
function* runRequestPersonGuideList(action) {
  try {
    // 個人情報ガイド一覧取得処理
    const payload = yield call(personService.getPersonList, action.payload);
    // 個人場ガイド一覧取得成功Actionを発生させる
    yield put(getPersonGuideListSuccess(payload));
  } catch (error) {
    // 個人場ガイド一覧取得失敗Actionを発生させる
    yield put(getPersonGuideListFailure(error.response));
  }
}

// 個人情報ガイドアイテム取得Action発生時に起動するメソッド
function* runRequestPersonGuide(action) {
  try {
    // 個人情報ガイドアイテム取得処理
    const payload = yield call(personService.getPerson, { params: action.payload });
    // 個人情報ガイドアイテム取得成功Actionを発生させる
    yield put(getPersonGuideSuccess(payload));
  } catch (error) {
    // 個人情報ガイドアイテム取得失敗Actionを発生させる
    yield put(getPersonGuideFailure(error.response));
  }
}

// 個人一覧取得Action発生時に起動するメソッド
function* runRequestPerList(action) {
  try {
    // 個人一覧取得処理実行
    const payload = yield call(personService.getPersonList, action.payload);
    // 個人一覧取得成功Actionを発生させる
    yield put(getPersonListSuccess(payload));
  } catch (error) {
    // 個人一覧取得失敗Actionを発生させる
    yield put(getPersonListFailure(error.response));
  }
}

// 個人情報取得Action発生時に起動するメソッド
function* runRequestPerson(action) {
  try {
    const { formName } = action.payload;
    // 個人情報取得処理実行
    let perData = yield call(personService.getPerson, action.payload);
    let medbirthjp = '';
    if (perData.medbirth !== null) {
      medbirthjp = perData.medbirthyearshorteraname + perData.medbirtherayear + moment(perData.medbirth).format('(YYYY)年MM月DD日');
    }
    perData = { ...perData, medbirthjp };

    let peraddrData = [];
    let wkperaddrData = [];
    try {
      // 個人住所情報処理実行
      peraddrData = yield call(personService.getPersonAddr, action.payload);
      for (let i = 0; i < peraddrData.length; i += 1) {
        let peraddr = peraddrData[i];
        if (peraddr.addrdiv === 4) {
          const prefData = yield call(prefService.getPref, { prefcd: peraddr.prefcd });
          const { prefname } = prefData;
          peraddr = { ...peraddr, prefname };
          peraddrData[i] = peraddr;
          break;
        }
      }
      // 検索用の住所区分を設定
      const addrDiv = [1, 4, 2, 3];
      for (let i = 0; i < 4; i += 1) {
        const element = peraddrData.find((rec) => (rec.addrdiv === addrDiv[i]));
        if (element) {
          wkperaddrData.push(element);
        } else {
          wkperaddrData.push({ addrdiv: addrDiv[i] });
        }
      }
    } catch (error) {
      // 個人情報取得失敗Actionを発生させる
      wkperaddrData = [
        {
          addrdiv: 1,
        },
        {
          addrdiv: 4,
        },
        {
          addrdiv: 2,
        },
        {
          addrdiv: 3,
        },
      ];
      yield put(getPersonFailure(error.response));
    }
    let perdetailData = {};
    try {
      // 個人IDの個人属性情報処理実行
      perdetailData = yield call(personService.getPersonDetail, action.payload);
    } catch (error) {
      // 個人情報取得失敗Actionを発生させる
      yield put(getPersonFailure(error.response));
    }
    // 個人情報をredux-formへセットするActionを発生させる
    yield put(initialize(formName, { per: perData, peraddr: wkperaddrData, perdetail: perdetailData }));
  } catch (error) {
    // 個人情報取得失敗Actionを発生させる
    yield put(getPersonFailure(error.response));
  }
}

// 個人情報登録Action発生時に起動するメソッド
function* runRegisterPerson(action) {
  try {
    const { params, redirect, formName } = action.payload;
    // 個人情報取得処理実行
    const { per } = action.payload.data;
    // 個人住所情報処理実行
    const { peraddr } = action.payload.data;
    // 個人IDの個人属性情報処理実行
    const { perdetail } = action.payload.data;
    // 合併個人情報
    let data = Object.assign({}, per);
    data = {
      ...data,
      residentno: perdetail.residentno,
      unionno: perdetail.unionno,
      karte: perdetail.karte,
      notes: perdetail.notes,
      spare3: perdetail.spare1,
      spare4: perdetail.spare2,
      spare5: perdetail.spare3,
      spare6: perdetail.spare4,
      spare7: perdetail.spare5,
      marriage: perdetail.marriage,
    };
    data = { ...data, addresses: [] };
    for (let i = 0; i < peraddr.length; i += 1) {
      data.addresses[i] = peraddr[i];
    }
    // 個人情報登録処理実行
    const perdata = yield call(personService.registerPerson, { params, data });
    const { perid } = params;
    let wkperid = perid;
    if (perid === undefined) {
      yield call(redirect, perdata.perid);
      wkperid = perdata.perid;
    }
    // 個人情報登録成功Actionを発生させる
    yield put(registerPersonSuccess());
    yield put(getPersonRequest({ params: { perid: wkperid }, formName }));
  } catch (error) {
    // 個人情報登録失敗Actionを発生させる
    yield put(registerPersonFailure(error.response));
  }
}

// 個人情報削除Action発生時に起動するメソッド
function* runDeletePerson(action) {
  try {
    const { redirect, initialized } = action.payload;
    // 個人情報削除処理実行
    const payload = yield call(personService.deletePerson, action.payload);
    // 個人情報削除成功Actionを発生させる
    yield put(deletePersonSuccess(payload));
    // Router 新規モード処理実行
    yield call(redirect);
    // 画面を初期化
    yield call(initialized);
  } catch (error) {
    // 個人情報削除失敗Actionを発生させる
    yield put(deletePersonFailure(error.response));
  }
}

function* runRequestFreeList() {
  try {
    // 汎用情報一覧取得処理実行
    const freeValues = [];
    for (let i = 1; i <= 7; i += 1) {
      const perspare = `PERSPARE${i}`;
      const payload = yield call(freeService.getFree, { mode: 0, freecd: perspare });
      freeValues[i - 1] = payload[0].freename;
    }
    yield put(getFreeRequestSuccess(freeValues));
  } catch (error) {
    // 汎用情報一覧取得失敗Actionを発生させる
    yield put(getFreeRequestFailure(error.response));
  }
}

// 個人情報取得Action発生時に起動するメソッド
function* runRequestPerInspection(action) {
  try {
    // 個人情報取得処理実行
    const payload = yield call(personService.getPersonInf, action.payload);
    // 個人情報取得成功Actionを発生させる
    yield put(getPerInspectionSuccess(payload));
  } catch (error) {
    // 個人情報取得失敗Actionを発生させる
    yield put(getPerInspectionFailure(error.response));
  }
}

// 個人検査情報取得Action発生時に起動するメソッド
function* runRequestPerInspectionList(action) {
  try {
    const { formName, params } = action.payload;
    // 個人検査情報取得処理実行
    const payload = yield call(perResultService.getPerResultList, params);
    const { count, perResultGrp } = payload;
    yield put(initialize(formName, { perresultitem: perResultGrp }));
    // 個人検査情報取得成功Actionを発生させる
    yield put(getPerInspectionListSuccess({ data: { allcount: count, perresultitem: perResultGrp } }));
  } catch (error) {
    // 個人検査情報取得失敗Actionを発生させる
    yield put(getPerInspectionListFailure(error.response));
  }
}

// 個人検査情報登録Action発生時に起動するメソッド
function* runRegisterPerInspection(action) {
  try {
    // 個人検査情報登録処理実行
    yield call(perResultService.updatePerResult, action.payload);
    // 個人検査情報登録成功Actionを発生させる
    yield put(registerPerInspectionSuccess());
    const { formName, params } = action.payload;
    // 個人検査情報取得処理実行
    const payload = yield call(perResultService.getPerResultList, params);
    const { count, perResultGrp } = payload;
    yield put(initialize(formName, { perresultitem: perResultGrp }));
    // 個人検査情報取得成功Actionを発生させる
    yield put(getPerInspectionListSuccess({ data: { allcount: count, perresultitem: perResultGrp } }));
  } catch (error) {
    // 個人検査情報登録失敗Actionを発生させる
    yield put(registerPerInspectionFailure(error.response));
  }
}

// Actionとその発生時に実行するメソッドをリンクさせる
const personSagas = [
  takeEvery(getPersonGuideListRequest.toString(), runRequestPersonGuideList),
  takeEvery(getPersonGuideRequest.toString(), runRequestPersonGuide),
  takeEvery(getPersonListRequest.toString(), runRequestPerList),
  takeEvery(getPersonRequest.toString(), runRequestPerson),
  takeEvery(registerPersonRequest.toString(), runRegisterPerson),
  takeEvery(deletePersonRequest.toString(), runDeletePerson),
  takeEvery(getFreeRequest.toString(), runRequestFreeList),
  takeEvery(getPerInspectionRequest.toString(), runRequestPerInspection),
  takeEvery(getPerInspectionListRequest.toString(), runRequestPerInspectionList),
  takeEvery(registerPerInspectionRequest.toString(), runRegisterPerInspection),
];

export default personSagas;
