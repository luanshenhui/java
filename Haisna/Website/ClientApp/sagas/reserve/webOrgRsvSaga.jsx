import { call, takeEvery, put } from 'redux-saga/effects';
import moment from 'moment';
import webOrgRsvService from '../../services/reserve/webOrgRsvService';
import consultService from '../../services/reserve/consultService';
import personService from '../../services/preference/personService';
import freeService from '../../services/preference/freeService';
import contractService from '../../services/preference/contractService';
import organizationService from '../../services/preference/organizationService';

import {
  webOrgRsvMainLoadRequest,
  webOrgRsvMainLoadSuccess,
  webOrgRsvMainLoadFailure,
  onChangeCsldivRequset,
  onChangeCsldivSuccess,
  onChangeCsldivFailure,
  registRequest,
  registSuccess,
  registFailure,
  // web団体予約情報検索
  getWebOrgRsvListRequest,
  getWebOrgRsvListSuccess,
  getWebOrgRsvListFailure,
} from '../../modules/reserve/webOrgRsvModule';

// 本登録フラグ(未登録者)
const REGFLG_UNREGIST = '1';
// 本登録フラグ(編集済み受診者)
const REGFLG_REGIST = '2';
// 汎用コード(はがきから送付案内への切り替えを行う日数)
const FREECD_RSVINTERVAL = 'RSVINTERVAL';
// 保存時印刷(なし)
const PRTONSAVE_INDEXNONE = 0;
// 保存時印刷(はがき)
const PRTONSAVE_INDEXCARD = 1;
// 保存時印刷(送付案内)
const PRTONSAVE_INDEXFORM = 2;
// セット分類(１日ドック(胃せず))
const SETCLASS_STOMAC_NOTHING = '035';
// セット分類(１日ドック(胃Ｘ線))
const SETCLASS_STOMAC_XRAY = '001';
// セット分類(１日ドック(胃内視鏡))
const SETCLASS_STOMAC_CAMERA = '002';
// セット分類(オプション乳房検査なし)
const SETCLASS_BREAST_NOTHING = '009';
// セット分類(乳房Ｘ線)
const SETCLASS_BREAST_XRAY = '010';
// セット分類(乳房超音波)
const SETCLASS_BREAST_ECHO = '011';
// セット分類(乳房Ｘ線・乳房超音波)
const SETCLASS_BREAST_XRAY_ECHO = '012';

// カンマ区切りで編集されているweb予約オプションコードを配列に変換
const ToArrayWebOptCd = (webOptCd) => {
  // web予約オプションコードの配列
  let vntArrWebOptCd = [];
  // web予約オプションコードの配列
  const strArrWebOptCd = [];
  // 乳房X線、乳房超音波同時受診であるか
  let blnMammoEcho;


  // 配列に変換
  vntArrWebOptCd = webOptCd.split(',');

  // 全要素のトリミング、かつ乳房X線、乳房超音波同時受診であるかを判定
  for (let i = 0; i < vntArrWebOptCd.length; i += 1) {
    if (vntArrWebOptCd[i] === 'P-XandE') {
      blnMammoEcho = true;
    }
  }

  // 空要素の除去、及び乳房X線、乳房超音波同時受診時の特殊処理
  for (let i = 0; i < vntArrWebOptCd.length; i += 1) {
    // 空要素であればスキップ
    if (vntArrWebOptCd[i] !== '' && !(blnMammoEcho && (vntArrWebOptCd[i] === 'P06' || vntArrWebOptCd[i] === 'P07'))) {
      strArrWebOptCd.push(vntArrWebOptCd[i]);
    }
  }
  return strArrWebOptCd;
};


// web団体予約情報保存Action発生時に起動するメソッド
function* runRegist(action) {
  try {
    const data = action.payload;
    let message = [];
    // 受診団体の必須チェック
    if (data.orgcd1 == null || data.orgcd1 == null) {
      message.push('受診団体を指定して下さい。');
      const payload = { message };
      yield put(registFailure(payload));
      return;
    }

    // 受診区分の必須チェック
    if (data.csldivcd === '' || data.csldivcd === null || data.csldivcd === undefined) {
      message.push('受診区分を指定して下さい。');
      const payload = { message };
      yield put(registFailure(payload));
      return;
    }

    // 契約パターンの存在チェック
    if (data.optcd === '' || data.optbranchno === '') {
      message.push('この受診条件に合致する契約情報は存在しません。');
      const payload = { message };
      yield put(registFailure(payload));
      return;
    }

    if (data.ctrptcd === '' || data.ctrptcd === null) {
      message.push('この受診条件に合致する契約情報は存在しません。');
      const payload = { message };
      yield put(registFailure(payload));
      return;
    }

    // 近い受診日で健診歴がある場合のワーニング対応
    if (data.perid !== null && data.ignoreflg === undefined) {
      while (true) {
        let arrRecentCslDate = [];
        // 近範囲の受診日
        let dtmRecentCslDate;

        // ワーニング対象となる受診日
        const strWarnCslDate = [];
        // ワーニング対象となる受診日の数
        let lngWarnCount = 0;

        let dtmDate = data.csldate.substring(0, 10);

        // ドック、定期健診を除くコースの場合はチェック非対象
        if (!(data.cscd === '100' || data.cscd === '110')) {
          break;
        }
        //  翌月以降で最古の受診日
        let dtmCslDateOfNextMonth = null;
        //  翌月以降で最古の受診日をもつ受診情報の予約番号
        let strRsvNoOfNextMonth = null;
        //  前月以前で最新の受診日
        let dtmCslDateOfLastMonth = null;
        //  前月以前で最新の受診日をもつ受診情報の予約番号
        let strRsvNoOfLastMonth = null;
        // 指定年月の受診日配列要素数
        let lngCurCslCount = 0;
        // 指定年月の受診日配列
        const dtmCslDateOfCurMonth = [];
        // 指定年月の予約番号配列
        const strRsvNoOfCurMonth = [];
        // 戻り値として返すべき受診日
        const strArrCslDate = [];
        // 戻り値として返すべき予約番号
        const strArrRsvNo = [];
        // 戻り値として返すべき受診日の数
        let lngCslCount = 0;


        // 初期設定
        dtmDate = moment(moment(dtmDate).format('YYYY/MM/01'));
        const dtmFirstDayOfNextMonth = dtmDate.add(1, 'months');
        const dtmLastDayOfPrevMonth = dtmDate.subtract(1, 'days');
        const params = { perid: data.perid };
        let consultHistory;
        try {
          consultHistory = yield call(consultService.getConsultHistory, params);
        } catch (error) {
          consultHistory = null;
        }
        for (let i = 0; consultHistory !== null && i < consultHistory.data.length; i += 1) {
          // ドック、定期健診のみを検索対象とする
          if (consultHistory.data[i].cscd !== '100' && consultHistory.data[i].cscd !== '110') {
            break;
          }

          // 'Date型による比較を行うため日付ワークに代入
          dtmDate = moment(consultHistory.data[i].csldate);

          if (dtmDate >= dtmFirstDayOfNextMonth) {
            // 翌月以降で最古の受診日値を更新(受診日の降順に検索するため、発生する度に値を更新)
            dtmCslDateOfNextMonth = dtmDate;
            strRsvNoOfNextMonth = consultHistory.data[i].rsvno;
          } else if (dtmDate <= dtmLastDayOfPrevMonth) {
            // 前月以前で最新の受診日値を更新
            dtmCslDateOfLastMonth = dtmDate;
            strRsvNoOfLastMonth = consultHistory.data[i].rsvno;
            // 一度前月以前で最新の受診日値が得られれば、受診日の降順に検索することから以降の検索は不要。
            break;
            // 指定年月の受診日であれば
          } else {
            dtmCslDateOfCurMonth.push(dtmDate);
            strRsvNoOfCurMonth.push(consultHistory.data[i].rsvno);
            lngCurCslCount += 1;
            break;
          }
        }

        // 翌月以降で最古の受診日
        if (dtmCslDateOfNextMonth !== null) {
          strArrCslDate.push(moment(dtmCslDateOfNextMonth).format('YYYY/MM/DD'));
          strArrRsvNo.push(strRsvNoOfNextMonth);
          lngCslCount += 1;
        }

        // 指定年月の受診日
        for (let i = 0; i < lngCurCslCount; i += 1) {
          strArrCslDate.push(dtmCslDateOfCurMonth[i]);
          strArrRsvNo.push(strRsvNoOfCurMonth[i]);
          lngCslCount += 1;
        }

        // 前月以前で最新の受診日
        if (dtmCslDateOfLastMonth !== null) {
          strArrCslDate.push(moment(dtmCslDateOfLastMonth).format('YYYY/MM/DD'));
          strArrRsvNo.push(strRsvNoOfLastMonth);
          lngCslCount += 1;
        }

        // 戻り値の設定
        if (lngCslCount > 0) {
          arrRecentCslDate = strArrCslDate;
        }
        // 指定年月の近範囲の受診日情報を取得
        if (arrRecentCslDate.length === 0) {
          break;
        }

        // 指定月数前の受診日、指定月数後の受診日を算出
        const dtmMinCslDate = moment(dtmDate).subtract(3, 'months');
        const dtmMaxCslDate = moment(dtmDate).add(3, 'months');

        // 受診日を検索
        for (let x = arrRecentCslDate.length - 1; x >= 0; x -= 1) {
          dtmRecentCslDate = moment(arrRecentCslDate[x]);
          const recentCslDate = arrRecentCslDate[x];
          // 指定月数前の受診日、指定月数後の受診日の範囲外ならば対象外
          if (dtmRecentCslDate < dtmMinCslDate || dtmRecentCslDate > dtmMaxCslDate) {
            break;
          }
          // 上記除外条件に該当しない場合はワーニング対象となる受診情報のため、スタック
          strWarnCslDate.push(moment(recentCslDate).format('YYYY年MM月DD日'));
          lngWarnCount += 1;
          break;
        }
        // ワーニング対象となる受診日存在時はメッセージを返す
        if (lngWarnCount > 0) {
          let content = '';
          for (let i = 0; i < strWarnCslDate.length; i += 1) {
            if (i !== strWarnCslDate.length - 1) {
              content += `${strWarnCslDate[i]}、`;
            } else {
              content += `${strWarnCslDate[i]}`;
            }
          }
          content = `${content}にこの受診者の受診情報がすでに存在します。`;
          message.push(content);
          break;
        }
      }
      if (message.length > 0) {
        const payload = { message };
        yield put(registFailure(payload));
        return;
      }
    }

    // web予約情報編集時、キャンセル対象者予約情報有無チェック
    let params = {};
    params.rsvno = data.rsvno !== null ? data.rsvno : 0;
    params.orgcd1 = data.orgcd1;
    params.orgcd2 = data.orgcd2;
    const consultCheck = yield call(webOrgRsvService.getConsultCheck, action.payload);

    if (consultCheck !== '') {
      try {
        params.force = false;
        params.cancelflg = 1;
        yield call(consultService.CancelConsult, action.payload);
      } catch (error) {
        message.push(error.response.data);
      }
    }
    // web予約情報の登録
    try {
      yield call(webOrgRsvService.regist, action.payload);
    } catch (error) {
      message.push(error.response.data);
    }
    if (message.length > 0) {
      params.ignoreflg = 2;
      params.rsvno = data.rsvno === null ? 0 : data.rsvno;
      try {
        yield call(consultService.restoreConsult, params);
      } catch (error) {
        message[0] = error.response.data;
        const payload = { message };
        yield put(registFailure(payload));
        return;
      }
    }

    params = {};
    params.csldate = data.csldate;
    params.webno = data.webno;
    params.strcsldate = data.strcsldate;
    params.endcsldate = data.endcsldate;
    params.key = data.key;
    params.stropdate = data.stropdate;
    params.endopdate = data.endopdate;
    params.orgcd1 = data.orgcd1;
    params.orgcd2 = data.orgcd2;
    params.opmode = data.opmode;
    params.regflg = '2';
    params.order = data.order;
    params.mousi = data.mousi;


    // 画面でデータを利用する
    const frameUsedData = {};
    // 受診付属情報読み込み
    let consultDetail;
    // 受診オプションの読み込み
    let consultO;
    // 個人情報読み込み
    let personLukes;
    // 受診情報読み込み
    let consultData;

    const webOrgRsvData = yield call(webOrgRsvService.getWebOrgRsv, params);
    params.orgcd1 = webOrgRsvData.orgcd1;
    params.orgcd2 = webOrgRsvData.orgcd2;
    const webOrgRsvNext = yield call(webOrgRsvService.getWebOrgRsvNext, params);

    frameUsedData.webOrgRsvNext = false;
    if (webOrgRsvNext !== '') {
      frameUsedData.webOrgRsvNext = true;
      if (params.div === 'next') {
        params.csldate = webOrgRsvNext.nextcsldate;
        params.webno = webOrgRsvNext.nextwebno;
      }
    }

    Object.assign(frameUsedData, webOrgRsvData);
    // 個人IDが存在する場合
    if (webOrgRsvData.perid !== null) {
      if (webOrgRsvData.lastkname === null && webOrgRsvData.firstkname === null) {
        const lastkname = webOrgRsvData.kananame.split('　')[0];
        const firstkname = webOrgRsvData.kananame.split('　')[1];
        frameUsedData.lastkname = lastkname;
        frameUsedData.firstkname = firstkname;
      }
      if (webOrgRsvData.lastname === null && webOrgRsvData.firstname === null) {
        const lastname = webOrgRsvData.fullname.split('　')[0];
        const firstname = webOrgRsvData.fullname.split('　')[1];
        frameUsedData.lastname = lastname;
        frameUsedData.firstname = firstname;
      }
      // 個人IDが存在しない場合
    } else {
      const lastkname = webOrgRsvData.kananame.split('　')[0];
      const firstkname = webOrgRsvData.kananame.split('　')[1];
      const lastname = webOrgRsvData.fullname.split('　')[0];
      const firstname = webOrgRsvData.fullname.split('　')[1];
      frameUsedData.lastkname = lastkname;
      frameUsedData.firstkname = firstkname;
      frameUsedData.lastname = lastname;
      frameUsedData.firstname = firstname;
    }
    // 未登録者、または編集済み受診者で予約番号を持たない場合
    if (params.regflg === REGFLG_UNREGIST || (params.regflg === REGFLG_REGIST && params.rsvno === '')) {
      // 編集用の受診日はキー値のそれとする
      frameUsedData.csldate = params.csldate;

      // 予約状況は個人IDが存在すれば確定、なければ保留(ない場合、保存時に仮IDで作成されるため)
      frameUsedData.rsvstatus = webOrgRsvData.perid !== null ? '0' : '1';

      frameUsedData.cardaddrdiv = '1';
      frameUsedData.formaddrdiv = '1';
      frameUsedData.reportaddrdiv = '1';

      frameUsedData.formouteng = 0;
      frameUsedData.reportouteng = 0;
      frameUsedData.cardouteng = 0;

      frameUsedData.issuecslticket = webOrgRsvData.perid !== null ? '2' : '1';

      params.mode = 0;
      params.freecd = FREECD_RSVINTERVAL;
      // 送付案内最新出力受診日の読み込み
      const getFreeData = yield call(freeService.getFree, params);

      // 日付比較を行うため、Date型に変換
      frameUsedData.dtmlastformcsldate = moment(getFreeData.freedate);

      // 新規の場合、受診日が送付案内出力最新受診日より未来ならはがき出力、さもなくば送付案内を出力
      frameUsedData.prtonsave = (moment(params.csldate) > frameUsedData.dtmlastformcsldate) ? PRTONSAVE_INDEXCARD : PRTONSAVE_INDEXFORM;

      frameUsedData.perid = webOrgRsvData.perid;
      frameUsedData.birth = webOrgRsvData.birth;
      // 編集済みでかつ予約番号を持つ場合
    } else {
      params.rsvno = webOrgRsvData.rsvno;
      // 受診情報読み込み
      consultData = yield call(consultService.getConsult, params);
      Object.assign(frameUsedData, consultData);
      // 受診付属情報読み込み
      consultDetail = yield call(consultService.getConsultDetail, params);
      // 印刷日の読み込み
      const consultPrintStatus = yield call(consultService.getConsultPrintStatus, params);
      // 予約状況は個人IDが存在すれば確定、なければ保留(ない場合、保存時に仮IDで作成されるため)
      Object.assign(frameUsedData, consultDetail);
      if (consultDetail.introductor !== null) {
        personLukes = yield call(personService.getPersonLukes, { params: { ...params, perid: consultDetail.introductor } });
        if (personLukes.lastname !== null) {
          frameUsedData.introductname = personLukes.lastname;
        }
        if (personLukes.firstname !== null) {
          frameUsedData.introductname += personLukes.firstname;
        }
      }

      frameUsedData.reportouteng = consultDetail.reportoureng;


      // 受診オプションの読み込み
      consultO = yield call(consultService.getConsultO, params);
      if (consultO !== '') {
        const optcd = [];
        const optbranchno = [];
        for (let i = 0; i < consultO.length; i += 1) {
          optcd.push(consultO[i].optcd);
          optbranchno.push(consultO[i].optbranchno);
        }
        frameUsedData.optcd = optcd;
        frameUsedData.optbranchno = optbranchno;
      }

      // 送付案内最新出力受診日の読み込み
      params.mode = 0;
      params.freecd = FREECD_RSVINTERVAL;
      // 送付案内最新出力受診日の読み込み
      const getFreeData = yield call(freeService.getFree, params);
      // 日付比較を行うため、Date型に変換
      frameUsedData.dtmlastformcsldate = moment(getFreeData.freedate);
      // (1)はがき、送付案内共に未出力の場合、受診日の状態に関わらず新規の場合と同じ
      if (consultPrintStatus.cardprintdate === null && consultPrintStatus.formprintdate === null) {
        frameUsedData.prtonsave = (moment(consultData.csldate) > frameUsedData.dtmlastformcsldate) ? PRTONSAVE_INDEXCARD : PRTONSAVE_INDEXFORM;
        // (2)はがきのみ出力済みの場合
      } else if (consultPrintStatus.cardprintdate !== null && consultPrintStatus.formprintdate === null) {
        // 受診日が送付案内出力最新受診日より未来ならなし
        if (moment(consultData.csldate) > frameUsedData.dtmlastformcsldate) {
          frameUsedData.prtonsave = PRTONSAVE_INDEXNONE;
        } else {
          // さもなくば送付案内
          frameUsedData.prtonsave = PRTONSAVE_INDEXFORM;
        }
      } else {
        // (3)送付案内のみ出力済みの場合、または(4)両方とも出力済みの場合(即ち送付案内出力済みの場合)はなしとする
        frameUsedData.prtonsave = PRTONSAVE_INDEXNONE;
      }
    }
    // 住所情報格納用変数を配列として初期化
    const zipcd = ['', '', ''];
    const prefcd = ['', '', ''];
    const prefname = ['', '', ''];
    const cityname = ['', '', ''];
    const address1 = ['', '', ''];
    const address2 = ['', '', ''];
    const tel1 = ['', '', ''];
    const phone = ['', '', ''];
    const tel2 = ['', '', ''];
    const extension = ['', '', ''];
    const fax = ['', '', ''];
    const email = ['', '', ''];
    // 個人IDが存在しない場合はweb予約情報の住所を個人住所情報のデフォルト値として適用する
    if (webOrgRsvData.perid === null) {
      // 自宅情報のデフォルト値編集
      zipcd[0] = webOrgRsvData.zipno;
      cityname[0] = webOrgRsvData.address1;
      address1[0] = webOrgRsvData.address2;
      address2[0] = webOrgRsvData.address3;
      tel1[0] = webOrgRsvData.tel;
      email[0] = webOrgRsvData.email;
      // 勤務先情報のデフォルト値編集
      tel1[1] = webOrgRsvData.defofficetel;
      // 個人ID存在時は、個人情報の不足分(ローマ字名)と住所情報とを読む
    } else {
      let ingIndex;
      params.perid = webOrgRsvData.perid;
      // 個人情報読み込み
      personLukes = yield call(personService.getPersonLukes, { params });
      Object.assign(frameUsedData, personLukes);
      // 個人住所情報読み込み
      const personAddr = yield call(personService.getPersonAddr, { params });
      // 読み込んだ住所情報を検索
      for (let i = 0; i < personAddr.length; i += 1) {
        // 住所区分値をもとに格納先のインデックスを定義
        if (personAddr[i].addrdiv === 1) {
          ingIndex = 0;
        } else if (personAddr[i].addrdiv === 2) {
          ingIndex = 1;
        } else if (personAddr[i].addrdiv === 3) {
          ingIndex = 2;
        } else {
          ingIndex = -1;
        }

        // 読み込んだ住所情報を格納用変数へ
        if (ingIndex > 0) {
          zipcd[ingIndex] = personAddr[i].zipcd;
          prefcd[ingIndex] = personAddr[i].prefcd;
          prefname[ingIndex] = personAddr[i].prefname;
          cityname[ingIndex] = personAddr[i].cityname;
          address1[ingIndex] = personAddr[i].address1;
          address2[ingIndex] = personAddr[i].address2;
          tel1[ingIndex] = personAddr[i].tel1;
          phone[ingIndex] = personAddr[i].phone;
          tel2[ingIndex] = personAddr[i].tel2;
          extension[ingIndex] = personAddr[i].extension;
          fax[ingIndex] = personAddr[i].fax;
          email[ingIndex] = personAddr[i].email;
        }
      }
    }

    frameUsedData.zipcd = zipcd;
    frameUsedData.prefcd = prefcd;
    frameUsedData.prefname = prefname;
    frameUsedData.cityname = cityname;
    frameUsedData.address1 = address1;
    frameUsedData.address2 = address2;
    frameUsedData.tel1 = tel1;
    frameUsedData.phone = phone;
    frameUsedData.tel2 = tel2;
    frameUsedData.extension = extension;
    frameUsedData.fax = fax;
    frameUsedData.email = email;


    if (consultData && consultData.cancelflg !== null && consultData.cancelflg !== 0) {
      // キャンセル理由を読み込む
      params.mode = 0;
      params.freecd = `CANCEL${consultData.cancelflg}`;
      const getFreeData = yield call(freeService.getFree, params);
      frameUsedData.reason = getFreeData[0].freefield1;
    }

    const payload = { frameUsedData, webOrgRsvData, consultDetail, consultO, personLukes, params, consultData };

    params.perid = frameUsedData.perid;
    params.birth = frameUsedData.birth;
    if (webOrgRsvData !== null) {
      params.gender = webOrgRsvData.gender;
      params.orgcd1 = webOrgRsvData.orgcd1;
      params.orgcd2 = webOrgRsvData.orgcd2;
      params.cscd = webOrgRsvData.cscd;
      params.stomac = webOrgRsvData.optionstomac;
      params.breast = webOrgRsvData.optionbreast;
      params.csloptions = webOrgRsvData.csloptions;
    }
    params.csldivcd = frameUsedData.csldivcd;
    // 登録済みの場合、常時読み取り専用フラグを送る
    if (params.regflg === 1) {
      params.readonly = 1;
    }
    // 検査セット画面に全セット表示フラグのエレメントが存在する場合
    params.showall = '';

    // 契約パターンコード指定時
    params.ctrptcd = null;
    if (consultData && consultData.ctrptcd !== null) {
      params.ctrptcd = consultData.ctrptcd;
    }

    // オプションコード指定時
    params.optcd = data.optcd;
    params.optbranchno = data.optbranchno;

    message = [];
    // 受診日時点での実年齢計算
    const calcage = yield call(freeService.calcAge, params);
    const realage = Math.floor(calcage.realAge);
    let newctrptcd = null;
    // 直前レコードのオプションコード
    let prevoptcd;
    let exist = false;

    params.strdate = params.csldate;
    params.enddate = params.csldate;
    // 指定団体における受診日時点で有効なすべてのコースを契約管理情報を元に読み込む
    const allctrmng = yield call(contractService.getAllCtrMng, params);
    // 受診日時点で有効なすべてのコースに指定されたコースが存在するかを検索し、その契約パターンコードを取得
    for (let i = 0; i < allctrmng.data.length; i += 1) {
      if (allctrmng.data[i].cscd === params.cscd) {
        newctrptcd = allctrmng.data[i].ctrptcd;
        break;
      }
    }
    // 指定条件を満たす契約情報が存在しない場合、年齢計算も不能、かつオプション検査の取得も不能なため、処理を終了する
    if (newctrptcd === null) {
      message = ['この団体のドック契約情報は存在しません。'];
      payload.message = message;
      payload.realage = realage;
      yield put(registSuccess(payload));
      return;
    }
    // 指定団体における受診日時点で有効な受診区分を契約管理情報を元に読み込む
    const allcsldiv = yield call(contractService.getAllCslDiv, params);
    payload.allcsldiv = allcsldiv;
    params.ctrptcd = newctrptcd;
    // 年齢計算に際し、まず契約情報を読み込んで年齢起算日を取得する(参照先の団体は後でアンカー用に使用する)
    const ctrmng = yield call(contractService.getCtrMng, params);
    // 年齢計算
    const age = yield call(freeService.calcAge, params);
    // 選択すべき受診区分が存在するかを検索
    for (let i = 0; i < allcsldiv.length; i += 1) {
      if (allcsldiv[i].csldivcd === data.csldivcd) {
        exist = true;
        break;
      }
    }
    // 選択すべき受診区分が存在しなければオプション検査の取得は不能と判断し、処理を終了する
    if (!exist) {
      message = ['基本情報を入力して下さい。'];
      payload.message = message;
      payload.age = age;
      payload.realage = realage;
      payload.frameUsedData.regflg = '2';
      yield put(registSuccess(payload));
      return;
    }
    // 指定契約パターンの全オプション検査とそのデフォルト受診状態を取得
    params.exceptnomatch = true;
    params.mode = 1;
    const ctrptoptfromconsult = yield call(contractService.getCtrPtOptFromConsult, params);
    // オプションが引数として渡されていない場合、または渡されているが契約パターンが一致しない場合(後者は事実上発生しない)
    if (params.ctrptcd === '' || params.ctrptcd !== newctrptcd) {
      // セット分類コード
      let setclasscd = [];
      // デフォルト受診状態を設定

      // 受診オプションのカンマ区切り文字列が指定されている場合はその内容をもとにデフォルト受診状態を設定。さもなくば旧来の設定ロジックを採用。
      if (params.csloptions !== null) {
        // 受診オプションのカンマ区切り文字列をセット分類の配列に変換

        let convertToSetClass = true;
        while (convertToSetClass) {
          // web予約オプションコードの配列
          let vntArrWkWebOptCd = [];
          // セット分類コードの配列
          let vntSetClassCd;
          // 配列の要素数
          let lngCount = [];

          // セット分類コードの配列
          const strSetClassCd = [];
          // セット分類コードの配列要素数
          const lngSetClassCount = [];

          // セット分類コード
          let strWkSetClassCd;
          // 重複存在か
          let blnDuplicated;

          // 配列に変換
          vntArrWkWebOptCd = ToArrayWebOptCd(params.csloptions);
          if (vntArrWkWebOptCd.length === 0) {
            setclasscd = strSetClassCd;
            convertToSetClass = false;
          }

          // web予約オプションコード変換情報の取得
          params.mode = 0;
          params.freeclasscd = 'WOP';
          lngCount = yield call(freeService.getFreeByClassCd, params);

          // 配列の各要素ごとの処理
          for (let i = 0; i < vntArrWkWebOptCd.length; i += 1) {
            strWkSetClassCd = '';
            for (let j = 0; j < lngCount.length; j += 1) {
              if (lngCount[j] === vntArrWkWebOptCd[i]) {
                strWkSetClassCd = vntSetClassCd[j];
                break;
              }
            }
            if (strWkSetClassCd !== '') {
              // すでに取得済みのセット分類であるかを判定
              blnDuplicated = false;
              for (let j = 0; j < lngSetClassCount.length; j += 1) {
                if (lngSetClassCount[j] === strWkSetClassCd) {
                  blnDuplicated = true;
                  break;
                }
              }

              // 取得済みでなければ追加
              if (!blnDuplicated) {
                strSetClassCd.push(strWkSetClassCd);
              }
            }
          }
          setclasscd = strSetClassCd;
          convertToSetClass = false;
        }
      }
      // 配列要素が存在する場合はそのすべてのセット分類を検索し、デフォルト受診状態を設定
      if (setclasscd.length > 0) {
        for (let i = 0; i < setclasscd.length; i += 1) {
          // 指定セット分類の任意受診検査セットに受診フラグを立てる
          for (let j = 0; j < ctrptoptfromconsult.length; j += 1) {
            if (ctrptoptfromconsult[j].addcondition === 1 && ctrptoptfromconsult[j].setclasscd === setclasscd[i]) {
              ctrptoptfromconsult[j].consult = 1;
            }
          }
        }
      }
      // 胃検査のデフォルト受診状態設定
      setclasscd = [SETCLASS_STOMAC_NOTHING, SETCLASS_STOMAC_XRAY, SETCLASS_STOMAC_CAMERA];
      for (let i = 0; i < ctrptoptfromconsult.length; i += 1) {
        // 指定セット分類の任意受診検査セットに受診フラグを立てる
        if (ctrptoptfromconsult[i].addcondition === 1 && ctrptoptfromconsult[i].setclasscd === setclasscd[params.stomac]) {
          ctrptoptfromconsult[i].consult = 1;
        }
      }

      // 胃検査のデフォルト受診状態設定
      setclasscd = [SETCLASS_BREAST_NOTHING, SETCLASS_BREAST_XRAY, SETCLASS_BREAST_ECHO, SETCLASS_BREAST_XRAY_ECHO];
      for (let i = 0; i < ctrptoptfromconsult.length; i += 1) {
        // 指定セット分類の任意受診検査セットに受診フラグを立てる
        if (ctrptoptfromconsult[i].addcondition === 1 && ctrptoptfromconsult[i].setclasscd === setclasscd[params.breast]) {
          ctrptoptfromconsult[i].consults = 1;
        }
      }

      // 受診フラグが立っていない任意受診のセットに対し、先頭セットを受診状態にする
      let blnconsult;
      // インデックス
      let i;
      let j;

      i = 0;
      while (!(i >= ctrptoptfromconsult.length)) {
        // 自動追加オプションはスキップ
        if (ctrptoptfromconsult[i].addcondition === 0) {
          i += 1;
          break;
        }
        // 枝番数が１のものは(チェックボックス制御となるので)スキップ
        if (ctrptoptfromconsult[i].branchcount <= 1) {
          i += 1;
          break;
        }
        // 現在位置をキープ
        j = i;

        prevoptcd = ctrptoptfromconsult[i].optcd;
        blnconsult = false;

        // 現在位置から同一オプションコードの受診状態を検索
        while (!(i >= ctrptoptfromconsult.length)) {
          // 直前レコードとオプションコードが異なる場合は終了
          if (ctrptoptfromconsult[i].optcd !== prevoptcd) {
            break;
          }
          // すでに受診状態のものがあればフラグ成立
          if (ctrptoptfromconsult[i].consult === '1') {
            blnconsult = true;
          }

          // 現在のオプションコードを退避
          prevoptcd = ctrptoptfromconsult[i].optcd;
          i += 1;
        }

        // 結果、受診状態のものがなければ先にキープしておいた先頭のオプションを受診状態にする
        if (!blnconsult) {
          ctrptoptfromconsult[j].consults = 1;
        }
      }

      // 複数の枝番セットに受診フラグが立つ任意受診のセットに対して、枝番が若い方を優先する
      let blnConsult;
      // インデックス
      let e;
      let f;

      e = 0;
      // 現在位置から同一オプションコードの受診状態を検索
      while (!(e >= ctrptoptfromconsult.length)) {
        // 自動追加オプションはスキップ
        if (ctrptoptfromconsult[e].addcondition === 0) {
          e += 1;
          break;
        }
        // 枝番数が１のものは(チェックボックス制御となるので)スキップ
        if (ctrptoptfromconsult[e].branchcount <= 1) {
          e += 1;
          break;
        }
        // 現在位置をキープ
        f = e;

        prevoptcd = ctrptoptfromconsult[i].optcd;
        blnConsult = false;

        // 現在位置から同一オプションコードの受診状態を検索
        while (!(e >= ctrptoptfromconsult.length)) {
          // 直前レコードとオプションコードが異なる場合は終了
          if (ctrptoptfromconsult[e].optcd !== prevoptcd) {
            break;
          }
          // すでにフラグ成立時は以降の枝番オプションの受診状態をクリア
          if (blnConsult) {
            ctrptoptfromconsult[f].consults = '';
          }
          // 受診状態のセットを最初に検索した場合にフラグ成立
          if (ctrptoptfromconsult[e].consults === 1) {
            blnConsult = true;
          }

          // 現在のオプションコードを退避
          prevoptcd = ctrptoptfromconsult[e].optcd;
          e += 1;
        }
      }
    }

    // オプションが渡され、かつ契約パターンも一致する場合は受診状態の継承を行う
    for (let i = 0; i < ctrptoptfromconsult.length; i += 1) {
      // フラグの初期化
      ctrptoptfromconsult[i].consults = '';
      // 引数未指定時は未選択とする
      if (params.optcd === '' && params.optbranchno === '') {
        break;
      }
      const optcd = params.optcd.split(',');
      const optbranchno = params.optbranchno.split(',');

      for (let j = 0; j < optcd.length; j += 1) {
        if (optcd[j] === ctrptoptfromconsult[i].optcd && Number(optbranchno[j]) === ctrptoptfromconsult[i].optbranchno) {
          ctrptoptfromconsult[i].consults = 1;
        }
      }
    }
    // 契約パターン情報を読み、契約上のコース名を取得
    const ctrpt = yield call(contractService.getCtrPt, params);
    payload.ctrptoptfromconsult = ctrptoptfromconsult;
    payload.ctrmng = ctrmng;
    payload.realage = realage;
    payload.age = age;
    payload.newctrptcd = newctrptcd;
    payload.ctrpt = ctrpt;
    payload.frameUsedData.regflg = '2';

    yield put(registSuccess(payload));
  } catch (error) {
    // 契約情報の読み込み情報取得失敗Actionを発生させる
    yield put(registFailure(error.response));
  }
}
// web団体予約情報登録初期化Action発生時に起動するメソッド
function* runwebOrgRsvMainLoad(action) {
  try {
    const { params } = action.payload;
    // 画面でデータを利用する
    const frameUsedData = {};
    // 受診付属情報読み込み
    let consultDetail;
    // 受診オプションの読み込み
    let consultO;
    // 個人情報読み込み
    let personLukes;
    // 受診情報読み込み
    let consultData;

    const webOrgRsvData = yield call(webOrgRsvService.getWebOrgRsv, params);
    params.orgcd1 = webOrgRsvData.orgcd1;
    params.orgcd2 = webOrgRsvData.orgcd2;
    const webOrgRsvNext = yield call(webOrgRsvService.getWebOrgRsvNext, params);

    frameUsedData.webOrgRsvNext = false;
    // 編集用の受診日はキー値のそれとする
    frameUsedData.csldate = params.csldate;
    if (webOrgRsvNext !== '') {
      frameUsedData.webOrgRsvNext = true;
      params.csldate = webOrgRsvNext.nextcsldate;
      params.webno = webOrgRsvNext.nextwebno;
    }

    Object.assign(frameUsedData, webOrgRsvData);
    // 個人IDが存在する場合
    if (webOrgRsvData.perid !== null) {
      if (webOrgRsvData.lastkname === null && webOrgRsvData.firstkname === null) {
        const lastkname = webOrgRsvData.kananame.split('　')[0];
        const firstkname = webOrgRsvData.kananame.split('　')[1];
        frameUsedData.lastkname = lastkname;
        frameUsedData.firstkname = firstkname;
      }
      if (webOrgRsvData.lastname === null && webOrgRsvData.firstname === null) {
        const lastname = webOrgRsvData.fullname.split('　')[0];
        const firstname = webOrgRsvData.fullname.split('　')[1];
        frameUsedData.lastname = lastname;
        frameUsedData.firstname = firstname;
      }
      // 個人IDが存在しない場合
    } else {
      const lastkname = webOrgRsvData.kananame.split('　')[0];
      const firstkname = webOrgRsvData.kananame.split('　')[1];
      const lastname = webOrgRsvData.fullname.split('　')[0];
      const firstname = webOrgRsvData.fullname.split('　')[1];
      frameUsedData.lastkname = lastkname;
      frameUsedData.firstkname = firstkname;
      frameUsedData.lastname = lastname;
      frameUsedData.firstname = firstname;
    }
    // 未登録者、または編集済み受診者で予約番号を持たない場合
    if (webOrgRsvData.regflg === REGFLG_UNREGIST || (webOrgRsvData.regflg !== REGFLG_UNREGIST && webOrgRsvData.rsvno === null)) {
      // 予約状況は個人IDが存在すれば確定、なければ保留(ない場合、保存時に仮IDで作成されるため)
      frameUsedData.rsvstatus = webOrgRsvData.perid !== null ? '0' : '1';

      frameUsedData.cardaddrdiv = '1';
      frameUsedData.formaddrdiv = '1';
      frameUsedData.reportaddrdiv = '1';
      frameUsedData.introductor = null;
      frameUsedData.introductname = null;

      frameUsedData.formouteng = 0;
      frameUsedData.reportouteng = 0;
      frameUsedData.cardouteng = 0;

      frameUsedData.issuecslticket = webOrgRsvData.perid !== null ? '2' : '1';

      params.mode = 0;
      params.freecd = FREECD_RSVINTERVAL;
      // 送付案内最新出力受診日の読み込み
      const getFreeData = yield call(freeService.getFree, params);

      // 日付比較を行うため、Date型に変換
      frameUsedData.dtmlastformcsldate = moment(getFreeData.freedate);

      // 新規の場合、受診日が送付案内出力最新受診日より未来ならはがき出力、さもなくば送付案内を出力
      frameUsedData.prtonsave = (moment(params.csldate) > frameUsedData.dtmlastformcsldate) ? PRTONSAVE_INDEXCARD : PRTONSAVE_INDEXFORM;

      frameUsedData.perid = webOrgRsvData.perid;
      frameUsedData.birth = webOrgRsvData.birth;
      // 編集済みでかつ予約番号を持つ場合
    } else {
      params.rsvno = webOrgRsvData.rsvno;
      // 受診情報読み込み
      consultData = yield call(consultService.getConsult, params);
      Object.assign(frameUsedData, consultData);
      // 受診付属情報読み込み
      consultDetail = yield call(consultService.getConsultDetail, params);
      // 印刷日の読み込み
      const consultPrintStatus = yield call(consultService.getConsultPrintStatus, params);
      // 予約状況は個人IDが存在すれば確定、なければ保留(ない場合、保存時に仮IDで作成されるため)
      Object.assign(frameUsedData, consultDetail);

      if (consultDetail.introductor !== null) {
        personLukes = yield call(personService.getPersonLukes, { params: { ...params, perid: consultDetail.introductor } });
        if (personLukes.lastname !== null) {
          frameUsedData.introductname = personLukes.lastname;
        }
        if (personLukes.firstname !== null) {
          frameUsedData.introductname += personLukes.firstname;
        }
      }
      frameUsedData.reportouteng = consultDetail.reportoureng;

      // 受診オプションの読み込み
      consultO = yield call(consultService.getConsultO, params);
      if (consultO !== '') {
        const optcd = [];
        const optbranchno = [];
        for (let i = 0; i < consultO.length; i += 1) {
          optcd.push(consultO[i].optcd);
          optbranchno.push(consultO[i].optbranchno);
        }
        frameUsedData.optcd = optcd;
        frameUsedData.optbranchno = optbranchno;
      }

      // 送付案内最新出力受診日の読み込み
      params.mode = 0;
      params.freecd = FREECD_RSVINTERVAL;
      // 送付案内最新出力受診日の読み込み
      const getFreeData = yield call(freeService.getFree, params);
      // 日付比較を行うため、Date型に変換
      frameUsedData.dtmlastformcsldate = moment(getFreeData.freedate);
      // (1)はがき、送付案内共に未出力の場合、受診日の状態に関わらず新規の場合と同じ
      if (consultPrintStatus.cardprintdate === null && consultPrintStatus.formprintdate === null) {
        frameUsedData.prtonsave = (moment(consultData.csldate) > frameUsedData.dtmlastformcsldate) ? PRTONSAVE_INDEXCARD : PRTONSAVE_INDEXFORM;
        // (2)はがきのみ出力済みの場合
      } else if (consultPrintStatus.cardprintdate !== null && consultPrintStatus.formprintdate === null) {
        // 受診日が送付案内出力最新受診日より未来ならなし
        if (moment(consultData.csldate) > frameUsedData.dtmlastformcsldate) {
          frameUsedData.prtonsave = PRTONSAVE_INDEXNONE;
        } else {
          // さもなくば送付案内
          frameUsedData.prtonsave = PRTONSAVE_INDEXFORM;
        }
      } else {
        // (3)送付案内のみ出力済みの場合、または(4)両方とも出力済みの場合(即ち送付案内出力済みの場合)はなしとする
        frameUsedData.prtonsave = PRTONSAVE_INDEXNONE;
      }
    }
    // 住所情報格納用変数を配列として初期化
    const zipcd = ['', '', ''];
    const prefcd = ['', '', ''];
    const prefname = ['', '', ''];
    const cityname = ['', '', ''];
    const address1 = ['', '', ''];
    const address2 = ['', '', ''];
    const tel1 = ['', '', ''];
    const phone = ['', '', ''];
    const tel2 = ['', '', ''];
    const extension = ['', '', ''];
    const fax = ['', '', ''];
    const email = ['', '', ''];
    // 個人IDが存在しない場合はweb予約情報の住所を個人住所情報のデフォルト値として適用する
    if (frameUsedData.perid === null) {
      // 自宅情報のデフォルト値編集
      zipcd[0] = webOrgRsvData.zipno;
      cityname[0] = webOrgRsvData.address1;
      address1[0] = webOrgRsvData.address2;
      address2[0] = webOrgRsvData.address3;
      tel1[0] = webOrgRsvData.tel;
      email[0] = webOrgRsvData.email;
      // 勤務先情報のデフォルト値編集
      tel1[1] = webOrgRsvData.defofficetel;
      // 個人ID存在時は、個人情報の不足分(ローマ字名)と住所情報とを読む
    } else {
      let ingIndex;
      params.perid = frameUsedData.perid;

      try {
        // 個人情報読み込み
        personLukes = yield call(personService.getPersonLukes, { params });

        Object.assign(frameUsedData, personLukes);
      } catch (error) {
        personLukes = {};
      }

      try {
        // 個人住所情報読み込み
        const personAddr = yield call(personService.getPersonAddr, { params });
        // 読み込んだ住所情報を検索
        for (let i = 0; i < personAddr.length; i += 1) {
          // 住所区分値をもとに格納先のインデックスを定義
          if (personAddr[i].addrdiv === 1) {
            ingIndex = 0;
          } else if (personAddr[i].addrdiv === 2) {
            ingIndex = 1;
          } else if (personAddr[i].addrdiv === 3) {
            ingIndex = 2;
          } else {
            ingIndex = -1;
          }

          // 読み込んだ住所情報を格納用変数へ
          if (ingIndex >= 0) {
            zipcd[ingIndex] = personAddr[i].zipcd;
            prefcd[ingIndex] = personAddr[i].prefcd;
            prefname[ingIndex] = personAddr[i].prefname;
            cityname[ingIndex] = personAddr[i].cityname;
            address1[ingIndex] = personAddr[i].address1;
            address2[ingIndex] = personAddr[i].address2;
            tel1[ingIndex] = personAddr[i].tel1;
            phone[ingIndex] = personAddr[i].phone;
            tel2[ingIndex] = personAddr[i].tel2;
            extension[ingIndex] = personAddr[i].extension;
            fax[ingIndex] = personAddr[i].fax;
            email[ingIndex] = personAddr[i].email;
          }
        }
      } catch (error) {
        // 自宅情報のデフォルト値編集
        zipcd[0] = null;
        cityname[0] = null;
        address1[0] = null;
        address2[0] = null;
        tel1[0] = null;
        email[0] = null;
        // 勤務先情報のデフォルト値編集
        tel1[1] = null;
      }
    }

    frameUsedData.zipcd = zipcd;
    frameUsedData.prefcd = prefcd;
    frameUsedData.prefname = prefname;
    frameUsedData.cityname = cityname;
    frameUsedData.address1 = address1;
    frameUsedData.address2 = address2;
    frameUsedData.tel1 = tel1;
    frameUsedData.phone = phone;
    frameUsedData.tel2 = tel2;
    frameUsedData.extension = extension;
    frameUsedData.fax = fax;
    frameUsedData.email = email;


    if (consultData && consultData.cancelflg !== null && consultData.cancelflg !== 0) {
      // キャンセル理由を読み込む
      params.mode = 0;
      params.freecd = `CANCEL${consultData.cancelflg}`;
      const getFreeData = yield call(freeService.getFree, params);
      frameUsedData.reason = getFreeData[0].freefield1;
    }

    const payload = { frameUsedData, webOrgRsvData, consultDetail, consultO, personLukes, params, consultData };

    params.perid = frameUsedData.perid;
    params.birth = frameUsedData.birth;
    if (webOrgRsvData !== null) {
      params.gender = webOrgRsvData.gender;
      params.orgcd1 = webOrgRsvData.orgcd1;
      params.orgcd2 = webOrgRsvData.orgcd2;
      params.cscd = webOrgRsvData.cscd;
      params.stomac = webOrgRsvData.optionstomac;
      params.breast = webOrgRsvData.optionbreast;
      params.csloptions = webOrgRsvData.csloptions;
    }
    if (params.orgcd1 !== undefined && params.orgcd2 !== undefined
      && params.orgcd1 !== null && params.orgcd2 !== null) {
      const orgDate = yield call(organizationService.getOrg, params);
      payload.orglukes = orgDate.org;
    }


    params.csldivcd = frameUsedData.csldivcd;
    // 登録済みの場合、常時読み取り専用フラグを送る
    if (params.regflg === 1) {
      params.readonly = 1;
    }
    // 検査セット画面に全セット表示フラグのエレメントが存在する場合
    params.showall = '';

    // 契約パターンコード指定時
    params.ctrptcd = null;
    if (consultData && consultData.ctrptcd !== null) {
      params.ctrptcd = consultData.ctrptcd;
    }

    // オプションコード指定時
    params.optcd = '';
    params.optbranchno = '';
    if (frameUsedData.optcd !== undefined) {
      params.optcd = frameUsedData.optcd;
    }
    if (frameUsedData.optbranchno !== undefined) {
      params.optbranchno = frameUsedData.optbranchno;
    }

    let message = [];
    // 受診日時点での実年齢計算
    const calcage = yield call(freeService.calcAge, params);
    const realage = Math.floor(calcage.realAge);
    let newctrptcd = null;
    // 直前レコードのオプションコード
    let prevoptcd;
    let exist = false;

    params.strdate = params.csldate;
    params.enddate = params.csldate;
    // 指定団体における受診日時点で有効なすべてのコースを契約管理情報を元に読み込む
    const allctrmng = yield call(contractService.getAllCtrMng, params);
    // 受診日時点で有効なすべてのコースに指定されたコースが存在するかを検索し、その契約パターンコードを取得
    for (let i = 0; i < allctrmng.data.length; i += 1) {
      if (allctrmng.data[i].cscd === params.cscd) {
        newctrptcd = allctrmng.data[i].ctrptcd;
        break;
      }
    }
    // 指定条件を満たす契約情報が存在しない場合、年齢計算も不能、かつオプション検査の取得も不能なため、処理を終了する
    if (newctrptcd === null) {
      message = ['この団体のドック契約情報は存在しません。'];
      payload.message = message;
      payload.realage = realage;
      yield put(webOrgRsvMainLoadSuccess(payload));
      return;
    }
    // 指定団体における受診日時点で有効な受診区分を契約管理情報を元に読み込む
    const allcsldiv = yield call(contractService.getAllCslDiv, params);
    payload.allcsldiv = allcsldiv;
    params.ctrptcd = newctrptcd;
    // 年齢計算に際し、まず契約情報を読み込んで年齢起算日を取得する(参照先の団体は後でアンカー用に使用する)
    const ctrmng = yield call(contractService.getCtrMng, params);
    // 年齢計算
    const age = yield call(freeService.calcAge, params);
    // 選択すべき受診区分が存在するかを検索
    for (let i = 0; i < allcsldiv.length; i += 1) {
      if (allcsldiv[i].csldivcd === params.csldivcd) {
        exist = true;
        break;
      }
    }
    // 選択すべき受診区分が存在しなければオプション検査の取得は不能と判断し、処理を終了する
    if (!exist) {
      message = ['基本情報を入力して下さい。'];
      payload.message = message;
      payload.age = age;
      payload.realage = realage;
      yield put(webOrgRsvMainLoadSuccess(payload));
      return;
    }
    // 指定契約パターンの全オプション検査とそのデフォルト受診状態を取得
    params.exceptnomatch = true;
    params.mode = 1;
    const ctrptoptfromconsult = yield call(contractService.getCtrPtOptFromConsult, params);
    // オプションが引数として渡されていない場合、または渡されているが契約パターンが一致しない場合(後者は事実上発生しない)
    if (params.ctrptcd === '' || params.ctrptcd !== newctrptcd) {
      // セット分類コード
      let setclasscd = [];
      // デフォルト受診状態を設定

      // 受診オプションのカンマ区切り文字列が指定されている場合はその内容をもとにデフォルト受診状態を設定。さもなくば旧来の設定ロジックを採用。
      if (params.csloptions !== null) {
        // 受診オプションのカンマ区切り文字列をセット分類の配列に変換

        let convertToSetClass = true;
        while (convertToSetClass) {
          // web予約オプションコードの配列
          let vntArrWkWebOptCd = [];
          // セット分類コードの配列
          let vntSetClassCd;
          // 配列の要素数
          let lngCount = [];

          // セット分類コードの配列
          const strSetClassCd = [];
          // セット分類コードの配列要素数
          const lngSetClassCount = [];

          // セット分類コード
          let strWkSetClassCd;
          // 重複存在か
          let blnDuplicated;

          // 配列に変換
          vntArrWkWebOptCd = ToArrayWebOptCd(params.csloptions);
          if (vntArrWkWebOptCd.length === 0) {
            setclasscd = strSetClassCd;
            convertToSetClass = false;
          }

          // web予約オプションコード変換情報の取得
          params.mode = 0;
          params.freeclasscd = 'WOP';
          lngCount = yield call(freeService.getFreeByClassCd, params);

          // 配列の各要素ごとの処理
          for (let i = 0; i < vntArrWkWebOptCd.length; i += 1) {
            strWkSetClassCd = '';
            for (let j = 0; j < lngCount.length; j += 1) {
              if (lngCount[j] === vntArrWkWebOptCd[i]) {
                strWkSetClassCd = vntSetClassCd[j];
                break;
              }
            }
            if (strWkSetClassCd !== '') {
              // すでに取得済みのセット分類であるかを判定
              blnDuplicated = false;
              for (let j = 0; j < lngSetClassCount.length; j += 1) {
                if (lngSetClassCount[j] === strWkSetClassCd) {
                  blnDuplicated = true;
                  break;
                }
              }

              // 取得済みでなければ追加
              if (!blnDuplicated) {
                strSetClassCd.push(strWkSetClassCd);
              }
            }
          }
          setclasscd = strSetClassCd;
          convertToSetClass = false;
        }
      }
      // 配列要素が存在する場合はそのすべてのセット分類を検索し、デフォルト受診状態を設定
      if (setclasscd.length > 0) {
        for (let i = 0; i < setclasscd.length; i += 1) {
          // 指定セット分類の任意受診検査セットに受診フラグを立てる
          for (let j = 0; j < ctrptoptfromconsult.length; j += 1) {
            if (ctrptoptfromconsult[j].addcondition === 1 && ctrptoptfromconsult[j].setclasscd === setclasscd[i]) {
              ctrptoptfromconsult[j].consult = 1;
            }
          }
        }
      }
      // 胃検査のデフォルト受診状態設定
      setclasscd = [SETCLASS_STOMAC_NOTHING, SETCLASS_STOMAC_XRAY, SETCLASS_STOMAC_CAMERA];
      for (let i = 0; i < ctrptoptfromconsult.length; i += 1) {
        // 指定セット分類の任意受診検査セットに受診フラグを立てる
        if (ctrptoptfromconsult[i].addcondition === 1 && ctrptoptfromconsult[i].setclasscd === setclasscd[params.stomac]) {
          ctrptoptfromconsult[i].consult = 1;
        }
      }

      // 胃検査のデフォルト受診状態設定
      setclasscd = [SETCLASS_BREAST_NOTHING, SETCLASS_BREAST_XRAY, SETCLASS_BREAST_ECHO, SETCLASS_BREAST_XRAY_ECHO];
      for (let i = 0; i < ctrptoptfromconsult.length; i += 1) {
        // 指定セット分類の任意受診検査セットに受診フラグを立てる
        if (ctrptoptfromconsult[i].addcondition === 1 && ctrptoptfromconsult[i].setclasscd === setclasscd[params.breast]) {
          ctrptoptfromconsult[i].consults = 1;
        }
      }

      // 受診フラグが立っていない任意受診のセットに対し、先頭セットを受診状態にする
      let blnconsult;
      // インデックス
      let i;
      let j;

      i = 0;
      while (!(i >= ctrptoptfromconsult.length)) {
        // 自動追加オプションはスキップ
        if (ctrptoptfromconsult[i].addcondition === 0) {
          i += 1;
          break;
        }
        // 枝番数が１のものは(チェックボックス制御となるので)スキップ
        if (ctrptoptfromconsult[i].branchcount <= 1) {
          i += 1;
          break;
        }
        // 現在位置をキープ
        j = i;

        prevoptcd = ctrptoptfromconsult[i].optcd;
        blnconsult = false;

        // 現在位置から同一オプションコードの受診状態を検索
        while (!(i >= ctrptoptfromconsult.length)) {
          // 直前レコードとオプションコードが異なる場合は終了
          if (ctrptoptfromconsult[i].optcd !== prevoptcd) {
            break;
          }
          // すでに受診状態のものがあればフラグ成立
          if (ctrptoptfromconsult[i].consult === '1') {
            blnconsult = true;
          }

          // 現在のオプションコードを退避
          prevoptcd = ctrptoptfromconsult[i].optcd;
          i += 1;
        }

        // 結果、受診状態のものがなければ先にキープしておいた先頭のオプションを受診状態にする
        if (!blnconsult) {
          ctrptoptfromconsult[j].consults = 1;
        }
      }

      // 複数の枝番セットに受診フラグが立つ任意受診のセットに対して、枝番が若い方を優先する
      let blnConsult;
      // インデックス
      let e;
      let f;

      e = 0;
      // 現在位置から同一オプションコードの受診状態を検索
      while (!(e >= ctrptoptfromconsult.length)) {
        // 自動追加オプションはスキップ
        if (ctrptoptfromconsult[e].addcondition === 0) {
          e += 1;
          break;
        }
        // 枝番数が１のものは(チェックボックス制御となるので)スキップ
        if (ctrptoptfromconsult[e].branchcount <= 1) {
          e += 1;
          break;
        }
        // 現在位置をキープ
        f = e;

        prevoptcd = ctrptoptfromconsult[i].optcd;
        blnConsult = false;

        // 現在位置から同一オプションコードの受診状態を検索
        while (!(e >= ctrptoptfromconsult.length)) {
          // 直前レコードとオプションコードが異なる場合は終了
          if (ctrptoptfromconsult[e].optcd !== prevoptcd) {
            break;
          }
          // すでにフラグ成立時は以降の枝番オプションの受診状態をクリア
          if (blnConsult) {
            ctrptoptfromconsult[f].consults = '';
          }
          // 受診状態のセットを最初に検索した場合にフラグ成立
          if (ctrptoptfromconsult[e].consults === 1) {
            blnConsult = true;
          }

          // 現在のオプションコードを退避
          prevoptcd = ctrptoptfromconsult[e].optcd;
          e += 1;
        }
      }
    }

    // オプションが渡され、かつ契約パターンも一致する場合は受診状態の継承を行う
    for (let i = 0; i < ctrptoptfromconsult.length; i += 1) {
      // フラグの初期化
      ctrptoptfromconsult[i].consults = '';
      // 引数未指定時は未選択とする
      if (params.optcd === '' && params.optbranchno === '') {
        break;
      }
      for (let j = 0; j < params.optcd.length; j += 1) {
        if (params.optcd[j] === ctrptoptfromconsult[i].optcd && params.optbranchno[j] === ctrptoptfromconsult[i].optbranchno) {
          ctrptoptfromconsult[i].consults = 1;
          break;
        }
      }
    }
    // 契約パターン情報を読み、契約上のコース名を取得
    const ctrpt = yield call(contractService.getCtrPt, params);
    payload.ctrptoptfromconsult = ctrptoptfromconsult;
    payload.ctrmng = ctrmng;
    payload.realage = realage;
    payload.age = age;
    payload.newctrptcd = newctrptcd;
    payload.ctrpt = ctrpt;

    yield put(webOrgRsvMainLoadSuccess(payload));
  } catch (error) {
    yield put(webOrgRsvMainLoadFailure(error.response));
  }
}
// web団体予約情報選択受診区分Action発生時に起動するメソッド
function* runOnChangeCsldiv(action) {
  try {
    const { params, frameUsedData } = action.payload;
    const ctrptCd = params.ctrptcd;
    let message = ['基本情報を入力して下さい。'];
    // 受診日時点での実年齢計算
    const calcage = yield call(freeService.calcAge, params);
    const realage = Math.floor(calcage.realAge);
    let newctrptcd = null;
    // 直前レコードのオプションコード
    let prevoptcd;
    let exist = false;

    params.strdate = params.csldate;
    params.enddate = params.csldate;
    // 指定団体における受診日時点で有効なすべてのコースを契約管理情報を元に読み込む
    const allctrmng = yield call(contractService.getAllCtrMng, params);
    // 受診日時点で有効なすべてのコースに指定されたコースが存在するかを検索し、その契約パターンコードを取得
    for (let i = 0; i < allctrmng.data.length; i += 1) {
      if (allctrmng.data[i].cscd === params.cscd) {
        newctrptcd = allctrmng.data[i].ctrptcd;
        break;
      }
    }
    // 指定条件を満たす契約情報が存在しない場合、年齢計算も不能、かつオプション検査の取得も不能なため、処理を終了する
    if (newctrptcd === null) {
      message = ['この団体のドック契約情報は存在しません。'];
      yield put(onChangeCsldivFailure({ message, realage }));
      return;
    }
    // 指定団体における受診日時点で有効な受診区分を契約管理情報を元に読み込む
    const allcsldiv = yield call(contractService.getAllCslDiv, params);
    params.ctrptcd = newctrptcd;
    // 年齢計算に際し、まず契約情報を読み込んで年齢起算日を取得する(参照先の団体は後でアンカー用に使用する)
    const ctrmng = yield call(contractService.getCtrMng, params);
    // 年齢計算
    const age = yield call(freeService.calcAge, params);
    // 選択すべき受診区分が存在するかを検索
    for (let i = 0; i < allcsldiv.length; i += 1) {
      if (allcsldiv[i].csldivcd === params.csldivcd) {
        exist = true;
        break;
      }
    }
    // 選択すべき受診区分が存在しなければオプション検査の取得は不能と判断し、処理を終了する
    if (!exist) {
      yield put(onChangeCsldivFailure({ message, age, realage }));
      return;
    }
    // 指定契約パターンの全オプション検査とそのデフォルト受診状態を取得
    params.exceptnomatch = true;
    params.mode = 1;
    let ctrptoptfromconsult;

    try {
      ctrptoptfromconsult = yield call(contractService.getCtrPtOptFromConsult, params);
    } catch (error) {
      message = ['この契約情報のオプション検査は存在しません。'];
      yield put(onChangeCsldivFailure({ message, age, realage }));
      return;
    }

    // オプションが引数として渡されていない場合、または渡されているが契約パターンが一致しない場合(後者は事実上発生しない)
    if (ctrptCd === '' || ctrptCd !== newctrptcd) {
      // セット分類コード
      let setclasscd = [];
      // デフォルト受診状態を設定

      // 受診オプションのカンマ区切り文字列が指定されている場合はその内容をもとにデフォルト受診状態を設定。さもなくば旧来の設定ロジックを採用。
      if (params.csloptions !== null) {
        // 受診オプションのカンマ区切り文字列をセット分類の配列に変換

        let convertToSetClass = true;
        while (convertToSetClass) {
          // web予約オプションコードの配列
          let vntArrWkWebOptCd = [];
          // 配列の要素数
          let lngCount = [];

          // セット分類コードの配列
          const strSetClassCd = [];
          // セット分類コードの配列要素数
          const lngSetClassCount = [];

          // セット分類コード
          let strWkSetClassCd;
          // 重複存在か
          let blnDuplicated;

          // 配列に変換
          vntArrWkWebOptCd = ToArrayWebOptCd(params.csloptions);
          if (vntArrWkWebOptCd.length === 0) {
            setclasscd = strSetClassCd;
            break;
          }

          // web予約オプションコード変換情報の取得
          params.mode = 0;
          params.freeclasscd = 'WOP';
          lngCount = yield call(freeService.getFreeByClassCd, params);

          // 配列の各要素ごとの処理
          for (let i = 0; i < vntArrWkWebOptCd.length; i += 1) {
            strWkSetClassCd = '';
            for (let j = 0; j < lngCount.length; j += 1) {
              if (lngCount[j].freefield1 === vntArrWkWebOptCd[i]) {
                strWkSetClassCd = lngCount[j].freefield3;
                break;
              }
            }
            if (strWkSetClassCd !== '') {
              // すでに取得済みのセット分類であるかを判定
              blnDuplicated = false;
              for (let j = 0; j < lngSetClassCount.length; j += 1) {
                if (lngSetClassCount[j] === strWkSetClassCd) {
                  blnDuplicated = true;
                  break;
                }
              }

              // 取得済みでなければ追加
              if (!blnDuplicated) {
                strSetClassCd.push(strWkSetClassCd);
              }
            }
          }
          setclasscd = strSetClassCd;
          convertToSetClass = false;
          break;
        }
      }
      // 配列要素が存在する場合はそのすべてのセット分類を検索し、デフォルト受診状態を設定
      if (setclasscd.length > 0) {
        for (let i = 0; i < setclasscd.length; i += 1) {
          // 指定セット分類の任意受診検査セットに受診フラグを立てる
          for (let p = 0; p < ctrptoptfromconsult.length; p += 1) {
            if (ctrptoptfromconsult[p].addcondition === 1 && ctrptoptfromconsult[p].setclasscd === setclasscd[i]) {
              ctrptoptfromconsult[p].consults = 1;
            }
          }
        }
      }
      // 胃検査のデフォルト受診状態設定
      setclasscd = [SETCLASS_STOMAC_NOTHING, SETCLASS_STOMAC_XRAY, SETCLASS_STOMAC_CAMERA];
      for (let i = 0; i < ctrptoptfromconsult.length; i += 1) {
        // 指定セット分類の任意受診検査セットに受診フラグを立てる
        if (ctrptoptfromconsult[i].addcondition === 1 && ctrptoptfromconsult[i].setclasscd === setclasscd[params.stomac]) {
          ctrptoptfromconsult[i].consults = 1;
        }
      }

      // 胃検査のデフォルト受診状態設定
      setclasscd = [SETCLASS_BREAST_NOTHING, SETCLASS_BREAST_XRAY, SETCLASS_BREAST_ECHO, SETCLASS_BREAST_XRAY_ECHO];
      for (let i = 0; i < ctrptoptfromconsult.length; i += 1) {
        // 指定セット分類の任意受診検査セットに受診フラグを立てる
        if (ctrptoptfromconsult[i].addcondition === 1 && ctrptoptfromconsult[i].setclasscd === setclasscd[params.breast]) {
          ctrptoptfromconsult[i].consults = 1;
        }
      }

      // 受診フラグが立っていない任意受診のセットに対し、先頭セットを受診状態にする
      let blnconsult;
      // インデックス
      let k;
      let l;

      k = 0;
      while (!(k >= ctrptoptfromconsult.length)) {
        const flg = true;
        while (flg) {
          // 自動追加オプションはスキップ
          if (ctrptoptfromconsult[k].addcondition === 0) {
            k += 1;
            break;
          }
          // 枝番数が１のものは(チェックボックス制御となるので)スキップ
          if (ctrptoptfromconsult[k].branchcount <= 1) {
            k += 1;
            break;
          }
          // 現在位置をキープ
          l = k;

          prevoptcd = ctrptoptfromconsult[k].optcd;
          blnconsult = false;

          // 現在位置から同一オプションコードの受診状態を検索
          while (!(k >= ctrptoptfromconsult.length)) {
            // 直前レコードとオプションコードが異なる場合は終了
            if (ctrptoptfromconsult[k].optcd !== prevoptcd) {
              break;
            }
            // すでに受診状態のものがあればフラグ成立
            if (ctrptoptfromconsult[k].consults === 1) {
              blnconsult = true;
            }

            // 現在のオプションコードを退避
            prevoptcd = ctrptoptfromconsult[k].optcd;
            k += 1;
          }

          // 結果、受診状態のものがなければ先にキープしておいた先頭のオプションを受診状態にする
          if (!blnconsult) {
            ctrptoptfromconsult[l].consults = 1;
          }
          break;
        }
      }

      // 複数の枝番セットに受診フラグが立つ任意受診のセットに対して、枝番が若い方を優先する
      let blnConsult;
      // インデックス
      let e;

      e = 0;
      // 現在位置から同一オプションコードの受診状態を検索
      while (!(e >= ctrptoptfromconsult.length)) {
        const flg = true;
        while (flg) {
          // 自動追加オプションはスキップ
          if (ctrptoptfromconsult[e].addcondition === 0) {
            e += 1;
            break;
          }
          // 枝番数が１のものは(チェックボックス制御となるので)スキップ
          if (ctrptoptfromconsult[e].branchcount <= 1) {
            e += 1;
            break;
          }

          prevoptcd = ctrptoptfromconsult[e].optcd;
          blnConsult = false;

          // 現在位置から同一オプションコードの受診状態を検索
          while (!(e >= ctrptoptfromconsult.length)) {
            // 直前レコードとオプションコードが異なる場合は終了
            if (ctrptoptfromconsult[e].optcd !== prevoptcd) {
              break;
            }
            // すでにフラグ成立時は以降の枝番オプションの受診状態をクリア
            if (blnConsult) {
              ctrptoptfromconsult[e].consults = '';
            }
            // 受診状態のセットを最初に検索した場合にフラグ成立
            if (ctrptoptfromconsult[e].consults === 1) {
              blnConsult = true;
            }

            // 現在のオプションコードを退避
            prevoptcd = ctrptoptfromconsult[e].optcd;
            e += 1;
          }
          break;
        }
      }
    } else {
      // オプションが渡され、かつ契約パターンも一致する場合は受診状態の継承を行う
      for (let x = 0; x < ctrptoptfromconsult.length; x += 1) {
        // フラグの初期化
        ctrptoptfromconsult[x].consults = '';
        // 引数未指定時は未選択とする
        if (params.optcd === '' || params.optbranchno === '') {
          break;
        }
        for (let m = 0; m < params.optcd.length; m += 1) {
          if (params.optcd[m] === ctrptoptfromconsult[x].optcd && params.optbranchno[m] === ctrptoptfromconsult[x].optbranchno) {
            ctrptoptfromconsult[x].consults = 1;
            break;
          }
        }
      }
    }
    // 契約パターン情報を読み、契約上のコース名を取得
    const ctrpt = yield call(contractService.getCtrPt, params);

    const payload = { ctrptoptfromconsult, ctrmng, realage, age, newctrptcd, params, ctrpt, frameUsedData };
    yield put(onChangeCsldivSuccess(payload));
  } catch (error) {
    yield put(onChangeCsldivFailure(error.response));
  }
}

// web団体予約情報検索一覧を取得するAction発生時に起動するメソッド
function* runRequestWebOrgRsvList(action) {
  try {
    // web団体予約情報検索一覧を取得処理実行
    const webOrgRsvList = yield call(webOrgRsvService.getWebOrgRsvList, action.payload);

    // web団体予約情報検索一覧を取得成功Actionを発生させる
    yield put(getWebOrgRsvListSuccess(webOrgRsvList));
  } catch (error) {
    // web団体予約情報検索一覧を取得失敗Actionを発生させる
    yield put(getWebOrgRsvListFailure(error.response));
  }
}

const webOrgRsvSagas = [
  takeEvery(webOrgRsvMainLoadRequest.toString(), runwebOrgRsvMainLoad),
  takeEvery(onChangeCsldivRequset.toString(), runOnChangeCsldiv),
  takeEvery(registRequest.toString(), runRegist),
  takeEvery(getWebOrgRsvListRequest.toString(), runRequestWebOrgRsvList),
];
export default webOrgRsvSagas;
