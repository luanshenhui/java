import { call, takeEvery, put } from 'redux-saga/effects';
import moment from 'moment';
import { initialize } from 'redux-form';
import contractService from '../../services/preference/contractService';
import contractControlService from '../../services/preference/contractControlService';
import organizationService from '../../services/preference/organizationService';
import courseService from '../../services/preference/courseService';
import freeService from '../../services/preference/freeService';
import * as Constants from '../../constants/common';

import {
  getAllCtrMngRequest,
  getAllCtrMngSuccess,
  getAllCtrMngFailure,
  registerCopyRequest,
  registerCopySuccess,
  registerCopyFailure,
  registerReleaseRequest,
  registerReleaseSuccess,
  registerReleaseFailure,
  getCtrPtRequest,
  getCtrPtSuccess,
  getCtrPtFailure,
  getPriceOptAllRequest,
  getPriceOptAllSuccess,
  getPriceOptAllFailure,
  getCtrPtOrgPriceRequest,
  getCtrPtOrgPriceSuccess,
  getCtrPtOrgPriceFailure,
  deleteContractRequest,
  deleteContractSuccess,
  deleteContractFailure,
  getCtrMngRequest,
  getCtrMngSuccess,
  getCtrMngFailure,
  registerSplitRequest,
  registerSplitSuccess,
  registerSplitFailure,
  registerCtrPtRequest,
  registerCtrPtSuccess,
  registerCtrPtFailure,
  updatePeriodRequest,
  updatePeriodSuccess,
  updatePeriodFailure,
  checkPeriodSuccess,
  checkPeriodFailure,
  getCtrMngWithPeriodRequest,
  getCtrMngWithPeriodSuccess,
  getCtrMngWithPeriodFailure,
  getLimitPriceRequest,
  getLimitPriceSuccess,
  getLimitPriceFailure,
  updateLimitPriceRequest,
  updateLimitPriceSuccess,
  updateLimitPriceFailure,
  deleteLimitPriceRequest,
  deleteLimitPriceSuccess,
  deleteLimitPriceFailure,
  deleteOptionRequest,
  deleteOptionSuccess,
  deleteOptionFailure,
  checkAgeCalc,
  insertContractRequest,
  insertContractSuccess,
  insertContractFailure,
  updateContractRequest,
  updateContractSuccess,
  updateContractFailure,
  checkDemandValue,
  getCtrMngReferRequest,
  getCtrMngReferSuccess,
  getCtrMngReferFailure,
  referContractRequest,
  referContractFailure,
  copyContractRequest,
  copyContractFailure,
  getSetGuideRequest,
  getSetGuideSuccess,
  getSetGuideFailure,
  setAddOptionRequest,
  setAddOptionSuccess,
  setAddOptionFailure,
} from '../../modules/preference/contractModule';

// 指定団体の全契約情報取得Action発生時に起動するメソッド
function* runRequestAllCtrMng(action) {
  try {
    // 指定団体の全契約情報取得処理実行
    const payload = yield call(contractService.getAllCtrMng, action.payload);
    // 指定団体の全契約情報取得成功Actionを発生させる
    yield put(getAllCtrMngSuccess(payload));
  } catch (error) {
    // 指定団体の全契約情報取得失敗Actionを発生させる
    yield put(getAllCtrMngFailure(error.response));
  }
}

// 参照中契約情報のコピー処理Action発生時に起動するメソッド
function* runRequestRegisterCopy(action) {
  try {
    // 契約期間の分割登録処理実行
    const payload = yield call(contractControlService.registerCopy, action.payload);
    // 参照中契約情報のコピー処理成功Actionを発生させる
    yield put(registerCopySuccess(payload));
  } catch (error) {
    // 参照中契約情報のコピー処理失敗Actionを発生させる
    yield put(registerCopyFailure(error.response));
  }
}

// 契約情報の参照を解除Action発生時に起動するメソッド
function* runRequestRegisterRelease(action) {
  try {
    // 契約期間の分割登録処理実行
    const payload = yield call(contractControlService.deleteRelease, action.payload);
    // 契約情報の参照を解除成功Actionを発生させる
    yield put(registerReleaseSuccess(payload));
  } catch (error) {
    // 契約情報の参照を解除失敗Actionを発生させる
    yield put(registerReleaseFailure(error.response));
  }
}

// 契約パターン情報取得Action発生時に起動するメソッド
function* runRequestCtrPt(action) {
  try {
    // 契約パターン情報取得処理実行
    const payload = yield call(contractService.getCtrPt, action.payload);
    // 契約パターン情報取得成功Actionを発生させる
    yield put(getCtrPtSuccess(payload));
  } catch (error) {
    // 契約パターン情報取得失敗Actionを発生させる
    yield put(getCtrPtFailure(error.response));
  }
}

// 指定契約パターンにおける指定オプション区分の全負担情報取得Action発生時に起動するメソッド
function* runRequestPriceOptAll(action) {
  try {
    const { ctrptcd } = action.payload;
    // 指定契約パターンにおける指定オプション区分の全負担情報取得処理実行
    const ptPriceOptData = yield call(contractService.getCtrPtPriceOptAll, action.payload);
    const { data } = ptPriceOptData;
    for (let i = 0; i < data.length; i += 1) {
      const { optcd, optbranchno } = data[i];
      const params = { ctrptcd, optcd, optbranchno };
      const ptOptData = yield call(contractService.getCtrPtOpt, { params });
      const { exceptlimit } = ptOptData;
      data[i] = { ...data[i], exceptlimit };
    }
    // 指定契約パターンにおける指定オプション区分の全負担情報取得成功Actionを発生させる
    yield put(getPriceOptAllSuccess({ data }));
  } catch (error) {
    // 指定契約パターンにおける指定オプション区分の全負担情報取得失敗Actionを発生させる
    yield put(getPriceOptAllFailure(error.response));
  }
}

// 指定契約パターンの負担元および負担金額情報取得Action発生時に起動するメソッド
function* runRequestCtrPtOrgPrice(action) {
  try {
    // 指定契約パターンの負担元および負担金額情報取得処理実行
    const payload = yield call(contractService.getCtrPtOrgPrice, action.payload);
    // 指定契約パターンの負担元および負担金額情報取得成功Actionを発生させる
    yield put(getCtrPtOrgPriceSuccess(payload));
  } catch (error) {
    // 指定契約パターンの負担元および負担金額情報取得失敗Actionを発生させる
    yield put(getCtrPtOrgPriceFailure(error.response));
  }
}

// 契約情報削除Action発生時に起動するメソッド
function* runDeleteContract(action) {
  try {
    // 契約情報削除処理実行
    yield call(contractControlService.deleteContract, action.payload);
    // 契約情報削除成功Actionを発生させる
    yield put(deleteContractSuccess());
  } catch (error) {
    // 契約情報削除失敗Actionを発生させる
    yield put(deleteContractFailure(error.response));
  }
}

// 契約情報の読み込み情報取得Action発生時に起動するメソッド
function* runRequestCtrMng(action) {
  try {
    // 契約情報の読み込み情報取得処理実行
    const payload = yield call(contractService.getCtrMng, action.payload);
    // 契約情報の読み込み情報取得成功Actionを発生させる
    yield put(getCtrMngSuccess(payload));
  } catch (error) {
    // 契約情報の読み込み情報取得失敗Actionを発生させる
    yield put(getCtrMngFailure(error.response));
  }
}

// 契約期間の分割登録Action発生時に起動するメソッド
function* runRegisterSplit(action) {
  try {
    // 契約期間の分割登録処理実行
    const payload = yield call(contractControlService.registerSplit, action.payload);
    // 契約期間の分割登録成功Actionを発生させる
    yield put(registerSplitSuccess(payload));
  } catch (error) {
    // 契約期間の分割登録失敗Actionを発生させる
    yield put(registerSplitFailure(error.response));
  }
}

// 契約パターンレコードの更新Action発生時に起動するメソッド
function* runRegisterCtrPt(action) {
  try {
    let newDate = null;
    let date = null;
    let checkParams = 1;
    let agecalc;
    const { params, data } = action.payload;
    const ingagecalc = action.payload.data.agecalc;
    const { agecalcyear, agecalcmonth, agecalcday } = action.payload.data;

    // 日付の書式
    const parsingFormat = ['YYYY/M/D', 'M/D', 'YYYYMMDD', 'YYMMDD', 'MMDD'];
    // 引数値の妥当性チェックを行う,受診日で起算する場合は不要
    if (ingagecalc === 1) {
      // 月日が指定されていない場合はエラー
      if (agecalcmonth + agecalcday === 0 || agecalcmonth.length + agecalcday.length === 0) {
        checkParams = 0;
        yield put(checkAgeCalc(checkParams));
        return;
      }
      // 年が指定されていない場合の月日チェック(閏年でない任意の年を使用して年月日チェックを行う)
      if (agecalcyear === 0 || agecalcyear.length === 0) {
        date = agecalcmonth.toString().padStart(2, '0') + agecalcday.toString().padStart(2, '0');
        date = `2001${date}`;
        // 書式に従って日付を取得
        newDate = moment(date, parsingFormat, true);
        if (!newDate.isValid()) {
          yield put(checkAgeCalc(checkParams));
          return;
        }
        // 年が指定されている場合の月日チェック
      } else {
        date = agecalcyear.toString().padStart(4, '0') + agecalcmonth.toString().padStart(2, '0') + agecalcday.toString().padStart(2, '0');
        // 書式に従って日付を取得
        newDate = moment(date, parsingFormat, true);
        if (!newDate.isValid()) {
          yield put(checkAgeCalc(checkParams));
          return;
        }
      }
    }
    // 年齢起算日の編集
    if (ingagecalc === 1) {
      if (agecalcyear !== 0 && agecalcyear.length !== 0) {
        agecalc = agecalcyear.toString().padStart(4, '0') + agecalcmonth.toString().padStart(2, '0') + agecalcday.toString().padStart(2, '0');
      } else {
        agecalc = agecalcmonth.toString().padStart(2, '0') + agecalcday.toString().padStart(2, '0');
      }
    } else {
      agecalc = '';
    }
    // 契約パターンレコードの更新処理実行
    const payload = yield call(contractService.registerCtrPt, { params, data: { ...data, agecalc } });
    // 契約パターンレコードの更新成功Actionを発生させる
    yield put(registerCtrPtSuccess(payload));
  } catch (error) {
    // 契約パターンレコードの更新失敗Actionを発生させる
    yield put(registerCtrPtFailure(error.response));
  }
}

// 契約期間を更新
function* runUpdatePeriod(action) {
  try {
    const { actmode, data } = action.payload;
    let message = [];
    // 契約開始終了年月日チェック
    if (data.strdate === null) {
      message = ['契約開始日を入力して下さい。'];
      yield put(checkPeriodFailure({ errors: message }));
      return;
    }
    if (data.enddate === null) {
      message = ['契約終了日を入力して下さい。'];
      yield put(checkPeriodFailure({ errors: message }));
      return;
    }
    if (data.strdate > data.enddate) {
      message = ['契約開始・終了日の範囲指定が正しくありません。'];
      yield put(checkPeriodFailure({ errors: message }));
      return;
    }

    // 次へ時(即ち新規時)
    if (actmode === 'guide' || actmode === 'browse') {
      try {
        // 同一団体・コースにおいて既存の契約情報と契約期間が重複しないかをチェックする
        yield call(contractService.checkContractPeriod, { data });
      } catch (error) {
        // 契約期間取得失敗Actionを発生させる
        yield put(checkPeriodFailure(error.response));
        return;
      }

      // 契約適用期間に適用可能なコースカウントを取得処理実行
      const payload = yield call(courseService.getHistoryCount, action.payload);
      if (payload.count <= 0) {
        message = ['指定された契約期間に適用可能なコース履歴が存在しません。'];
        yield put(checkPeriodFailure({ errors: message }));
        return;
      }
    }
    yield put(checkPeriodSuccess());

    if (actmode === 'guide') {
      // 新規契約作成時は負担元・負担金額の設定へ
      const { onNext } = action.payload;
      yield call(onNext);
    } else if (actmode === 'browse') {
      // 契約情報の参照・コピーを行う場合は参照先団体の選択画面へ
      const { redirect } = action.payload;
      yield call(redirect);
    } else {
      // 契約期間取得処理実行
      const payload = yield call(contractControlService.updatePeriod, action.payload);
      // 契約期間取得成功Actionを発生させる
      yield put(updatePeriodSuccess(payload));
    }
  } catch (error) {
    // 契約期間取得失敗Actionを発生させる
    yield put(updatePeriodFailure(error.response));
  }
}

// 契約期間付きの契約管理情報を取得
function* runGetCtrMngWithPeriod(action) {
  try {
    // 契約期間取得処理実行
    const payload = yield call(contractService.getCtrMngWithPeriod, action.payload);
    yield put(getCtrMngWithPeriodSuccess(payload));
  } catch (error) {
    // 契約期間取得Actionを発生させる
    yield put(getCtrMngWithPeriodFailure(error.response));
  }
}

// 指定契約パターンの負担元および負担金額情報取得(団体)Action発生時に起動するメソッド
function* runRequestLimitPrice(action) {
  let ptdata = null;
  let bdndata = null;
  try {
    // 契約パターン情報取得処理実行
    ptdata = yield call(contractService.getCtrPt, action.payload);
    // 契約団体自身の場合は団体名称を取得
    const orgdata = yield call(organizationService.getOrg, action.payload);
    // 指定契約パターンの負担元および負担金額情報取得処理実行
    bdndata = yield call(contractService.getCtrPtOrgPrice, action.payload);
    // 指定契約パターンの負担元および負担金額情報取得成功Actionを発生させる
    yield put(getLimitPriceSuccess({ bdn: bdndata, org: orgdata.org, ctrPtdata: ptdata }));
  } catch (error) {
    // 契約パターン情報と指定契約パターンの負担元および負担金額情報取得失敗Actionを発生させる
    yield put(getLimitPriceFailure({ error: error.response, ptdata, bdndata }));
  }
}

// 限度額情報の更新Action発生時に起動するメソッド
function* runstRegisterLimitPrice(action) {
  try {
    // 限度額情報の更新処理実行
    yield call(contractControlService.checkLimitPrice, action.payload);

    const { bdnItems } = action.payload.params;
    const { data } = action.payload;
    const burdens = [];
    let limitprice = 0;

    bdnItems.map((item) => (
      burdens.push({ seq: item.seq, orgcd1: item.orgcd1, orgcd2: item.orgcd2 })
    ));
    limitprice = (data.limitprice === '' || data.limitprice === null) ? 0 : data.limitprice;
    const payload = yield call(contractControlService.updateLimitPrice, { params: action.payload.params, data: { ...data, limitprice, burdens } });

    // 限度額情報の更新成功Actionを発生させる
    yield put(updateLimitPriceSuccess(payload));
  } catch (error) {
    // 限度額情報の更新失敗Actionを発生させる
    yield put(updateLimitPriceFailure(error.response));
  }
}

// 限度額情報の削除Action発生時に起動するメソッド
function* runDeleteLimitPrice(action) {
  try {
    const { bdnItems } = action.payload.params;
    const { data } = action.payload;
    const burdens = [];

    bdnItems.map((item) => (
      burdens.push({ seq: item.seq, orgcd1: item.orgcd1, orgcd2: item.orgcd2 })
    ));
    // 限度額情報の削除処理実行(全値クリア)
    const payload = yield call(contractControlService.updateLimitPrice, {
      params: action.payload.params,
      data: {
        ...data,
        seqorg: '',
        limitrate: 0,
        limittaxflg: 1,
        limitprice: 0,
        seqbdnorg: '',
        burdens,
      } });

    // 限度額情報の削除成功Actionを発生させる
    yield put(deleteLimitPriceSuccess(payload));
  } catch (error) {
    // 限度額情報の削除失敗Actionを発生させる
    yield put(deleteLimitPriceFailure(error.response));
  }
}
// オプションの削除Action発生時に起動するメソッド
function* runDeleteOption(action) {
  try {
    // オプションの削除処理実行
    const payload = yield call(contractControlService.deleteOption, action.payload);

    // オプションの削除成功Actionを発生させる
    yield put(deleteOptionSuccess(payload));
  } catch (error) {
    // オプションの削除失敗Actionを発生させる
    yield put(deleteOptionFailure(error.response));
  }
}

// 新しい契約情報を作成
function* runInsertContract(action) {
  try {
    let message = [];

    const { data } = action.payload;

    for (let i = 0; i < data.burdens.length; i += 1) {
      // 個人受診管理用の団体が指定されていないかを検索
      if (Constants.APDIV_PERSON !== data.burdens[i].apdiv &&
        data.burdens[i].orgcd1 === Constants.ORGCD1_PERSON &&
        data.burdens[i].orgcd2 === Constants.ORGCD2_PERSON
      ) {
        message = ['個人受診用の団体コードを指定することはできません。'];
        yield put(checkDemandValue({ ...data, message }));
        return;
      }

      // 自社が指定されていないかを検索
      if (data.burdens[i].orgcd1 === data.orgcd1 &&
        data.burdens[i].orgcd2 === data.orgcd2
      ) {
        message = ['契約団体自身の団体コードを指定することはできません。'];
        yield put(checkDemandValue({ ...data, message }));
        return;
      }

      // 団体重複チェック
      let j = 0;
      while (j < i) {
        if (data.burdens[i].orgcd1 !== null && data.burdens[i].orgcd2 !== null &&
          (data.burdens[i].orgcd1 === data.burdens[j].orgcd1) &&
          (data.burdens[i].orgcd2 === data.burdens[j].orgcd2)) {
          message = ['同一団体を複数指定することはできません。'];
          yield put(checkDemandValue({ ...data, message }));
          return;
        }
        j += 1;
      }

      // セット料金負担を行う負担元は削除できない
      if (data.burdens[i].apdiv === Constants.APDIV_ORG && data.burdens[i].orgcd1 === '' && data.burdens[i].orgcd2 === '') {
        if (data.bburdens[i].optBurden(i) !== '0' || data.burdens[i].taxflg[i] !== '0') {
          message = ['セット料金負担を行う団体は削除できません。'];
          yield put(checkDemandValue({ ...data, message }));
          return;
        }
      }

      // 限度額設定にて使用されている負担元は削除できない
      if (data.burdens[i].apdiv === Constants.APDIV_ORG && data.burdens[i].orgcd1 === '' && data.burdens[i].orgcd2 === '') {
        message = ['限度額負担の設定が行われている負担元は削除できません。'];
        yield put(checkDemandValue({ ...data, message }));
        return;
      }

      // 限度額設定にて使用されている負担元は削除できない
      if (data.burdens[i].orgcd1 !== '' || data.burdens[i].orgcd2 !== '') {
        if (data.burdens[i].seq > 99) {
          message = ['負担情報のシーケンス値が最大数を超えました。'];
          yield put(checkDemandValue({ ...data, message }));
          return;
        }
      }
    }
    // 契約期間取得処理実行
    const payload = yield call(contractControlService.insertContract, action.payload);
    // 契約期間取得成功Actionを発生させる
    yield put(insertContractSuccess(payload));
  } catch (error) {
    // 契約期間取得失敗Actionを発生させる
    yield put(insertContractFailure(error.response));
  }
}

// 契約情報を更新
function* runUpdateContract(action) {
  try {
    let message = [];

    const { data } = action.payload;

    for (let i = 0; i < data.burdens.length; i += 1) {
      // 個人受診管理用の団体が指定されていないかを検索
      if (Constants.APDIV_PERSON !== data.burdens[i].apdiv &&
        data.burdens[i].orgcd1 === Constants.ORGCD1_PERSON &&
        data.burdens[i].orgcd2 === Constants.ORGCD2_PERSON
      ) {
        message = ['個人受診用の団体コードを指定することはできません。'];
        yield put(checkDemandValue({ ...data, message }));
        return;
      }

      // 自社が指定されていないかを検索
      if (data.burdens[i].orgcd1 === data.orgcd1 &&
        data.burdens[i].orgcd2 === data.orgcd2
      ) {
        message = ['契約団体自身の団体コードを指定することはできません。'];
        yield put(checkDemandValue({ ...data, message }));
        return;
      }

      // 団体重複チェック
      let j = 0;
      while (j < i) {
        if (data.burdens[i].orgcd1 !== null && data.burdens[i].orgcd2 !== null &&
          (data.burdens[i].orgcd1 === data.burdens[j].orgcd1) &&
          (data.burdens[i].orgcd2 === data.burdens[j].orgcd2)) {
          message = ['同一団体を複数指定することはできません。'];
          yield put(checkDemandValue({ ...data, message }));
          return;
        }
        j += 1;
      }

      // セット料金負担を行う負担元は削除できない
      if (data.burdens[i].apdiv === Constants.APDIV_ORG && data.burdens[i].orgcd1 === '' && data.burdens[i].orgcd2 === '') {
        if (data.bburdens[i].optBurden(i) !== '0' || data.burdens[i].taxflg[i] !== '0') {
          message = ['セット料金負担を行う団体は削除できません。'];
          yield put(checkDemandValue({ ...data, message }));
          return;
        }
      }

      // 限度額設定にて使用されている負担元は削除できない
      if (data.burdens[i].apdiv === Constants.APDIV_ORG && data.burdens[i].orgcd1 === '' && data.burdens[i].orgcd2 === '') {
        message = ['限度額負担の設定が行われている負担元は削除できません。'];
        yield put(checkDemandValue({ ...data, message }));
        return;
      }

      // 限度額設定にて使用されている負担元は削除できない
      if (data.burdens[i].orgcd1 !== '' || data.burdens[i].orgcd2 !== '') {
        if (data.burdens[i].seq > 99) {
          message = ['負担情報のシーケンス値が最大数を超えました。'];
          yield put(checkDemandValue({ ...data, message }));
          return;
        }
      }
    }
    // 契約期間取得処理実行
    const payload = yield call(contractControlService.updateContract, action.payload);

    // 契約期間取得成功Actionを発生させる
    yield put(updateContractSuccess(payload));
  } catch (error) {
    // 契約期間取得失敗Actionを発生させる
    yield put(updateContractFailure(error.response));
  }
}

// 参照先団体の契約情報が参照元団体から参照可能を取得
function* runRequestCtrMngRefer(action) {
  try {
    // 参照先団体の契約情報が参照元団体から参照可能を取得処理実行
    const payload = yield call(contractService.getCtrMngRefer, action.payload);

    // 参照先団体の契約情報が参照元団体から参照可能を取得成功Actionを発生させる
    yield put(getCtrMngReferSuccess(payload));
  } catch (error) {
    // 参照先団体の契約情報が参照元団体から参照可能を取得失敗Actionを発生させる
    yield put(getCtrMngReferFailure(error.response));
  }
}

// 契約情報の参照処理
function* runRequestReferContract(action) {
  try {
    const { redirect } = action.payload;
    // 契約情報の参照処理実行
    yield call(contractControlService.refer, action.payload);
    yield call(redirect);
  } catch (error) {
    // 参契約情報の参照処理失敗Actionを発生させる
    yield put(referContractFailure(error.response));
  }
}

// 契約情報のコピー処理
function* runRequestcopyContract(action) {
  try {
    const { redirect } = action.payload;
    // 参契約情報のコピー処理実行
    yield call(contractControlService.copy, action.payload);
    yield call(redirect);
  } catch (error) {
    // 契約情報のコピー処理失敗Actionを発生させる
    yield put(copyContractFailure(error.response));
  }
}

// 検査セットの登録情報取得Action発生時に起動するメソッド
function* runRequestSetGuide(action) {
  const { formName, params } = action.payload;
  const { mode } = params;
  const ages = {};
  let mngData = [];
  let itemData = [];
  let optData = {};
  let ageData = [];
  let grpData = [];
  let orgPriceData = [];
  let message = [];
  let taxrate = null;
  let totalprice = 0;
  let totaltax = 0;
  try {
    // 契約情報の読み込み
    mngData = yield call(contractService.getCtrMng, params);

    try {
      // 契約パターン負担金額情報の読み込み
      orgPriceData = yield call(contractService.getCtrPtOrgPrice, params);
      for (let i = 0; i < orgPriceData.length; i += 1) {
        totalprice += orgPriceData[i].price;
        totaltax += orgPriceData[i].tax;
      }
    } catch (error) {
      message = ['契約情報が存在しません。'];
      // 検査セットの登録情報取得失敗Actionを発生させる
      yield put(getSetGuideFailure({ error: error.response, message }));
    }

    if (mode === Constants.MODE_UPDATE || mode === Constants.MODE_COPY) {
      try {
        // 契約パターンオプション管理情報の読み込み
        optData = yield call(contractService.getCtrPtOpt, action.payload);
        // コピーモードの場合はオプションコード、枝番をクリアする
        if (mode === Constants.MODE_COPY) {
          optData.optcd = '';
          optData.optbranchno = '';
        }
      } catch (error) {
        message = ['セット検査情報が存在しません。'];
        // 検査セットの登録情報取得失敗Actionを発生させる
        yield put(getSetGuideFailure({ error: error.response, message }));
      }

      try {
        // 契約パターンオプション年齢条件情報の読み込み
        ageData = yield call(contractService.getCtrPtOptAge, action.payload);
        // 契約パターングループ情報の読み込み
        grpData = yield call(contractService.getCtrPtGrp, action.payload);
        // 契約パターン検査項目情報の読み込み
        itemData = yield call(contractService.getCtrPtItem, action.payload);
      } catch (error) {
        // 検査セットの登録情報取得失敗Actionを発生させる
        yield put(getSetGuideFailure(error.response));
      }
    } else {
      // すべての年齢をチェック対象とさせるための初期値を作成
      ageData.push({ strage: 0, endage: 999 });
      optData = { ...optData, gender: 0, addcondition: 0, optdiv: 0, setcolor: '000000', cscd: mngData.cscd };
    }

    let freeData = [];
    try {
      // 税率情報の読み込み
      freeData = yield call(freeService.getFree, { mode: 0, freecd: 'TAX' });
    } catch (error) {
      // 検査セットの登録情報取得失敗Actionを発生させる
      yield put(getSetGuideFailure(error.response));
    }
    // 汎用日付未設定時は計算しない
    const { freedate, freefield1, freefield2 } = freeData[0];
    const { strdate } = mngData;
    if (moment(freedate).isValid) {
      // 汎用日付と契約開始日との関係よりいずれの税率を使用するかを判定
      taxrate = strdate >= freedate ? freefield2 : freefield1;
    }

    // 受診対象年齢から受診対象開始・終了年齢配列への変換
    for (let i = 0; i < ageData.length; i += 1) {
      // 開始・終了範囲の全年齢値を追加
      const { strage, endage } = ageData[i];
      for (let k = strage; k <= endage; k += 1) {
        // 年齢が100歳を超える場合は打ち切り
        if (k > 100) {
          break;
        }
        // 配列の新要素として追加
        ages[`age${k}`] = k;
      }
    }
    yield put(getSetGuideSuccess({ grpData, itemData }));
  } catch (error) {
    // 検査セットの登録情報取得失敗Actionを発生させる
    yield put(getSetGuideFailure(error.response));
  }
  yield put(initialize(formName, { option: optData, orgprices: orgPriceData, mng: mngData, ages, taxrate, totalprice, totaltax }));
}

// 追加オプション書き込み
function* runRequestSetAddOption(action) {
  try {
    const { params, data } = action.payload;
    const { ages, orgprices, ptgroups, ptitems } = data;
    const optages = [];
    let isAdd = false;
    let lastAge = null;
    let count = 0;
    for (let i = 0; i <= 100; i += 1) {
      const currentAge = ages[`age${i}`];
      isAdd = false;
      if (currentAge !== null && currentAge !== undefined) {
        // 最初は必ず新たな要素を作成
        if (lastAge === null) {
          isAdd = true;
        }
        // 直前に検索した年齢値と連続していない場合は新たな要素を作成
        if (lastAge !== null) {
          if (Number.parseInt(currentAge, 10) - Number.parseInt(lastAge, 10) > 1) {
            isAdd = true;
          }
        }
        if (isAdd) {
          // 新要素作成処理
          optages.push({ strage: currentAge, endage: currentAge });
          count += 1;
        } else {
          // 新要素を作成しない場合は最終要素の受診対象終了年齢を更新する
          optages[count - 1].endage = currentAge;
        }
        // 現在の受診対象年齢を退避
        lastAge = currentAge;
      }
    }
    // 最終要素の受診対象終了年齢が100歳の場合は100歳以上が対象となるよう、値を置換
    if (optages.length > 0) {
      if (Number.parseInt(optages[count - 1].endage, 10) >= 100) {
        optages[count - 1].endage = Constants.AGE_MAXVALUE;
      }
    }
    // 契約パターン負担元情報
    const burdens = [];
    for (let i = 0; i < orgprices.length; i += 1) {
      burdens.push({ seq: orgprices[i].seq, apdiv: orgprices[i].apdiv, orgcd1: orgprices[i].orgcd1, orgcd2: orgprices[i].orgcd2 });
    }
    // 契約パターングループ情報
    const groupcds = [];
    for (let i = 0; i < ptgroups.length; i += 1) {
      groupcds.push(ptgroups[i].grpcd);
    }
    // 契約パターン検査項目情報
    const itemcds = [];
    for (let i = 0; i < ptitems.length; i += 1) {
      itemcds.push(ptitems[i].itemcd);
    }
    // 追加オプション書き込み処理実行
    yield call(contractControlService.setAddOption, { params, data: { ...data, optages, burdens, groupcds, itemcds } });
    yield put(setAddOptionSuccess());
  } catch (error) {
    // 追加オプション書き込み処理失敗Actionを発生させる
    yield put(setAddOptionFailure(error.response));
  }
}

// Actionとその発生時に実行するメソッドをリンクさせる
const contractSagas = [
  takeEvery(getAllCtrMngRequest.toString(), runRequestAllCtrMng),
  takeEvery(registerCopyRequest.toString(), runRequestRegisterCopy),
  takeEvery(registerReleaseRequest.toString(), runRequestRegisterRelease),
  takeEvery(getCtrPtRequest.toString(), runRequestCtrPt),
  takeEvery(getPriceOptAllRequest.toString(), runRequestPriceOptAll),
  takeEvery(getCtrPtOrgPriceRequest.toString(), runRequestCtrPtOrgPrice),
  takeEvery(deleteContractRequest.toString(), runDeleteContract),
  takeEvery(getCtrMngRequest.toString(), runRequestCtrMng),
  takeEvery(registerSplitRequest.toString(), runRegisterSplit),
  takeEvery(registerCtrPtRequest.toString(), runRegisterCtrPt),
  takeEvery(updatePeriodRequest.toString(), runUpdatePeriod),
  takeEvery(getCtrMngWithPeriodRequest.toString(), runGetCtrMngWithPeriod),
  takeEvery(getLimitPriceRequest.toString(), runRequestLimitPrice),
  takeEvery(updateLimitPriceRequest.toString(), runstRegisterLimitPrice),
  takeEvery(deleteLimitPriceRequest.toString(), runDeleteLimitPrice),
  takeEvery(deleteOptionRequest.toString(), runDeleteOption),
  takeEvery(insertContractRequest.toString(), runInsertContract),
  takeEvery(updateContractRequest.toString(), runUpdateContract),
  takeEvery(getCtrMngReferRequest.toString(), runRequestCtrMngRefer),
  takeEvery(referContractRequest.toString(), runRequestReferContract),
  takeEvery(copyContractRequest.toString(), runRequestcopyContract),
  takeEvery(getSetGuideRequest.toString(), runRequestSetGuide),
  takeEvery(setAddOptionRequest.toString(), runRequestSetAddOption),
];
export default contractSagas;
