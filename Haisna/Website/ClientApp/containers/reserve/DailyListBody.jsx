import React from 'react';
import PropTypes from 'prop-types';
import moment from 'moment';
import GridList from '@material-ui/core/GridList';
import GridListTile from '@material-ui/core/GridListTile';
import { NavLink } from 'react-router-dom';

import * as constants from '../../constants/common';

import DailyListEditTitle from './DailyListEditTitle';

import Table from '../../components/Table';

const reserveicon = (
  <svg width="25px" height="25px" viewBox="0 0 128 128" enableBackground="new 0 0 128 128">
    <path
      fill="#FFFFFF"
      d="M100.65,61.221c-1.083-1.576-2.489-2.607-4.239-3.057L83.93,54.358c-1.379-0.382-2.41-1.115-3.129-2.185
      c-0.699-1.081-1.051-2.428-1.051-4.04v-3.45c0-1.702-0.692-2.541-2.071-2.541h-5.211c-1.367,0-2.047,0.839-2.047,2.531v4.719
      c0,0.85-0.352,1.26-1.031,1.26H58.029c-0.68,0-1.02-0.41-1.02-1.26v-4.719c0-1.692-0.696-2.531-2.061-2.531h-5.68
      c-0.549,0-1.039,0.211-1.439,0.631c-0.4,0.424-0.6,1.064-0.6,1.91v3.333c0,1.545-0.4,2.861-1.17,3.983
      c-0.779,1.109-1.75,1.859-2.939,2.236l-11.911,3.805c-1.68,0.621-3.059,1.721-4.1,3.293c-1.059,1.571-1.59,3.358-1.59,5.359V96.31
      c0,2.531,0.692,4.653,2.051,6.341c1.359,1.691,3.07,2.531,5.12,2.531H95.11c1.98,0,3.688-0.898,5.071-2.711
      c1.398-1.797,2.098-3.864,2.098-6.161V66.693C102.279,64.619,101.729,62.797,100.65,61.221z M52.519,95.88h-7.2v-9.103h7.2V95.88z
      M52.519,83.605h-7.2v-9.103h7.2V83.605z M52.519,71.327h-7.2v-9.091h7.2V71.327z M62.459,95.88h-7.21v-9.103h7.21V95.88z
      M62.459,83.605h-7.21v-9.103h7.21V83.605z M62.459,71.327h-7.21v-9.091h7.21V71.327z M72.374,95.88h-7.185v-9.103h7.185V95.88z
      M72.374,83.605h-7.185v-9.103h7.185V83.605z M72.374,71.327h-7.185v-9.091h7.185V71.327z M82.324,95.88H74.96v-9.103h7.364V95.88z
      M82.324,83.605H74.96v-9.103h7.364V83.605z M82.324,71.327H74.96v-9.091h7.364V71.327z"
    />
    <path
      fill="#FFFFFF"
      d="M90.63,24.649c-8.716-1.227-17.701-1.828-26.96-1.828c-8.841,0-17.641,0.566-26.401,1.715
      c-4.241,0.527-8.03,2.858-11.39,6.978c-3.362,4.133-5.042,8.79-5.042,14.003c0,1.618,0.611,2.422,1.861,2.422l17.08-2.305
      c1.241-0.148,1.87-0.998,1.87-2.527v-2.53c0-1.382,0.41-2.564,1.211-3.572c0.809-0.99,1.77-1.491,2.898-1.491h35.441
      c1.129,0,2.09,0.5,2.898,1.491c0.813,1.008,1.223,2.189,1.223,3.572v2.53c0,1.529,0.609,2.379,1.859,2.527l18.1,2.305
      c1.242,0,1.871-0.879,1.871-2.647c-0.379-5.524-2.102-10.208-5.18-14.071C98.899,27.38,95.11,25.186,90.63,24.649z"
    />
  </svg>);

const receipticon = (
  <svg width="25px" height="25px" viewBox="0 0 128 128" enableBackground="new 0 0 128 128">
    <path
      fill="#FFFFFF"
      d="M98.631,16.892H29.379c-2,0-3.63,1.623-3.63,3.623v86.967c0,2.002,1.63,3.627,3.63,3.627H69.54
      c0.95,0,1.88-0.39,2.56-1.063l29.092-29.089c0.67-0.675,1.06-1.597,1.06-2.56V20.514C102.251,18.514,100.621,16.892,98.631,16.892z
      M95.001,76.423H69.64c-1.149,0-2.08,0.927-2.08,2.069v25.366H33V24.137h62.001V76.423z"
    />
    <rect x="43.87" y="51.919" fill="#FFFFFF" width="40.26" height="4.833" />
    <rect x="43.87" y="65.2" fill="#FFFFFF" width="40.26" height="4.832" />
    <rect x="43.87" y="38.632" fill="#FFFFFF" width="40.26" height="4.833" />
  </svg>);

const monshinicon = (
  <svg width="25px" height="25px" viewBox="0 0 128 128" enableBackground="new 0 0 128 128">
    <g>
      <polygon fill="#FFFFFF" points="27.4,82.984 46.07,100.797 107.51,36.915 88.82,19.092" />
      <polygon fill="#FFFFFF" points="20.49,108.908 28.58,107.152 21.86,100.752" />
      <polygon fill="#FFFFFF" points="42.93,103.415 24.93,86.242 23.51,96.641 32.6,105.33" />
    </g>
  </svg>);

const interviewicon = (
  <svg width="25px" height="25px" viewBox="0 0 128 128" enableBackground="new 0 0 128 128">
    <g>
      <polygon
        fill="#FFFFFF"
        points="85.015,45.845 61.665,22.498 22.555,61.615 45.895,84.96 60.005,70.85 102.625,113.455
        113.225,102.85 70.615,60.232"
      />
      <polygon fill="#FFFFFF" points="20.535,63.627 14.755,69.4 38.095,92.75 43.885,86.975" />
      <polygon fill="#FFFFFF" points="92.965,37.885 69.615,14.542 63.825,20.328 87.185,43.675" />
    </g>
  </svg>);

const inquiryicon = (
  <svg width="25px" height="25px" viewBox="0 0 128 128" enableBackground="new 0 0 128 128">
    <path
      fill="#FFFFFF"
      d="M108.46,92.482L88.38,75.07c2.86-5.105,4.5-10.978,4.5-17.235c0-19.547-15.899-35.445-35.45-35.445
      c-19.55,0-35.449,15.897-35.449,35.445c0,19.553,15.899,35.458,35.449,35.458c7.011,0,13.511-2.07,19.011-5.582l20.649,17.904
      c1.65,1.413,3.68,2.11,5.7,2.11c2.43,0,4.83-1.015,6.56-2.985C112.49,101.115,112.1,95.628,108.46,92.482z M57.43,78.826
      c-11.569,0-20.989-9.413-20.989-20.988c0-11.578,9.42-20.982,20.989-20.982c11.57,0,21,9.405,21,20.982
      C78.43,69.413,69,78.826,57.43,78.826z"
    />
  </svg>);

const lifemarkicon = (
  <svg width="25px" height="25px" viewBox="0 0 128 128" enableBackground="new 0 0 128 128">
    <g>
      <defs>
        <rect id="SVGID_1_" x="-0.002" y="0" width="128.004" height="128" />
      </defs>
      <clipPath id="SVGID_2_">
        <use xlinkHref="#SVGID_1_" overflow="visible" />
      </clipPath>
      <g clipPath="url(#SVGID_2_)">
        <defs>
          <rect id="SVGID_3_" x="-22.724" y="-2.496" width="173.557" height="144.633" />
        </defs>
        <clipPath id="SVGID_4_">
          <use xlinkHref="#SVGID_3_" overflow="visible" />
        </clipPath>
        <g transform="matrix(1 0 0 1 -1.531018e-007 5.017472e-008)" clipPath="url(#SVGID_4_)">
          <image
            overflow="visible"
            width="48"
            height="40"
            xlinkHref="data:image/jpeg;base64,/9j/4AAQSkZJRgABAgEAFAAUAAD/7AARRHVja3kAAQAEAAAAHgAA/+4AIUFkb2JlAGTAAAAAAQMA
            EAMCAwYAAAHxAAACYQAAA23/2wCEABALCwsMCxAMDBAXDw0PFxsUEBAUGx8XFxcXFx8eFxoaGhoX
            Hh4jJSclIx4vLzMzLy9AQEBAQEBAQEBAQEBAQEABEQ8PERMRFRISFRQRFBEUGhQWFhQaJhoaHBoa
            JjAjHh4eHiMwKy4nJycuKzU1MDA1NUBAP0BAQEBAQEBAQEBAQP/CABEIACkAMAMBIgACEQEDEQH/
            xACXAAACAwEBAAAAAAAAAAAAAAAEBQECAwYAAQEBAQEBAAAAAAAAAAAAAAADBAIFBhAAAgICAgIC
            AwAAAAAAAAAAAgMBBAAREgUhMhMUMSMzEQACAgIABAUEAwAAAAAAAAABAgARIQMxUWESQXGRIjIQ
            gRME4ZIjEgACAQMEAgMAAAAAAAAAAAAAAREh4QIxUWFxoSJBgaL/2gAMAwEAAhEDEQAAAA5jTu+e
            OZGFwdPkPOtFCjXmn4UshRigdaoMXWxU1Yzs1rEgo0RDu66x/9oACAECAAEFAJ1hv/Z84acMxnEx
            lUTETMYf5GfH/9oACAEDAAEFAPM4uvpf1mbQUTHICh0xMxBaXE6OJ5f/2gAIAQEAAQUAlzdw12Ua
            zzK3Vaa7b2EYwxdaAKZBUznWVeS7dQmJHolLwqlPKaBla6ldgrWCxsV3Pd2qWFhKKMroYR1nqSie
            6RsnjxtOGwxySWX262y7FBit6WGy3Nevcso38yTjIyv7WfSz/Rfp/9oACAECAgY/ABfEMSxU70KZ
            S+CWtdxJvwKV+rClKO7ChebH/9oACAEDAgY/AKD1cqe6DyyaTeldCuMLkhPTYbSn7HD79bmUP24V
            xy/Fz//aAAgBAQEGPwD5t6mfNvUzS5dve2BZ+Ki4mtWYBeJswJrdvx6/auTnrDud27nNItnhzmAT
            5TIqfqPXtGpvUkRk1+1mFA8pe1+7zwIDsfXjAgW+08wBANiByPEgXAqigOEttnZ+utUi8WPWJ2Gk
            XmaAmdif2lts/Gt88zOzuVeLMbgAyCa/mYMZNv8Ak91Y4HzEo8OcJ7mvnUVO5gq+FQKpJLGhiay9
            +nERWewzCwKzXWHLEL0+o8xFn2Eaf//Z"
            transform="matrix(3.6158 0 0 3.6158 -22.7236 -2.4956)"
          />
        </g>
      </g>
    </g>
  </svg>);

// 表示行数一覧選択肢
class DailyListBody extends React.Component {
  // 生年月日
  getBirth = (strDate) => {
    const date = moment(strDate);
    if (date.isBetween(moment('1989/01/08', 'YYYY/MM/DD'), moment())) {
      return `H${date.year() - 1988}.${date.format('MM')}.${date.format('DD')}`;
    } else if (date.isBetween(moment('1926/12/25', 'YYYY/MM/DD'), moment('1989/01/07', 'YYYY/MM/DD'))) {
      return `S${date.year() - 1925}.${date.format('MM')}.${date.format('DD')}`;
    } else if (date.isBetween(moment('1912/07/30', 'YYYY/MM/DD'), moment('1926/12/24', 'YYYY/MM/DD'))) {
      return `T${date.year() - 1911}.${date.format('MM')}.${date.format('DD')}`;
    } else if (date.isBetween(moment('1868/09/08', 'YYYY/MM/DD'), moment('1912/07/29', 'YYYY/MM/DD'))) {
      return `M${date.year() - 1867}.${date.format('MM')}.${date.format('DD')}`;
    }

    return strDate;
  }

  // urlボタンクリック時の処理
  handleUrlClick = (strUrl) => {
    const { history } = this.props;
    history.push({
      pathname: strUrl,
    });
  }

  // 受付画面を表示
  showReceipt = (rsvNo, date) => {
    // 受付画面のURL編集
    // eslint-disable-next-line no-alert,no-restricted-globals
    alert(`/webHains/contents/receipt/rptEntry.asp?rsvNo=${rsvNo}${date}`);
  }

  // 追加検査の編集
  editAddItem = (additems) => {
    const items = additems;

    // 追加検査が存在しない場合は処理終了
    if (items == null || items.length === 0) {
      return null;
    }

    return (
      <GridList cols={3} cellHeight="auto" style={{ width: '500px' }}>
        {items.map((rec, index) => (
          <GridListTile key={`${rec.addname}-${index.toString()}`}>
            <span>
              {/* マークの編集 */}
              {(() => {
                switch (rec.adddiv) {
                  case 0: return <span>○</span>;
                  case 1: return <span>●</span>;
                  case 2: return <span>×</span>;
                  default: return <span />;
                }
              })()}
            </span>
            <span>
              {rec.addname}
            </span>
          </GridListTile>
        ))}
      </GridList>
    );
  }

  // 受診項目の編集
  editConsultItem = (consultitems) => {
    // 受診項目が存在しない場合は処理終了
    if (consultitems == null || consultitems.length === 0) {
      return null;
    }

    return (
      <GridList cols={4} cellHeight="auto" style={{ width: '800px' }}>
        {consultitems.map((rec, index) => (
          <GridListTile key={`${rec.requestname}-${index.toString()}`}>
            <span>{rec.requestname}</span>
          </GridListTile>
        ))}
      </GridList>
    );
  }

  // サブコースの編集
  editSubCourse = (subcourses) => {
    const items = subcourses;

    // サブコースが存在しない場合は処理終了
    if (items == null || items.length === 0) {
      return null;
    }

    return (
      <GridList cols={3} cellHeight="auto" style={{ width: 200 }}>
        {items.map((rec, index) => (
          <GridListTile key={`${rec.csname}-${index.toString()}`}>
            <span>
              {/* webカラーの編集 */}
              {(rec.webcolor != null && rec.webcolor !== '')
                && <span style={{ color: `#${rec.webcolor}` }}>■</span>}
            </span>
            <span>
              {rec.csname}
            </span>
          </GridListTile>
        ))}
      </GridList>
    );
  }

  // 保険区分一覧ドロップダウンリストの編集
  editButtonCol = (key, lngRsvNo, lngCancelFlg, dtmCslDate, strPerId, strDayId, dtmRptDate) => {
    // 日付
    let dtmDate;
    // ジャンプ先のURL
    let strURL;
    const strHtml = [];
    const strButtons = [];

    // 予約ボタン
    strButtons.push((
      <div key={`editButtonCol-1-${key}`} className="editbutton">
        <NavLink to={`/contents/reserve/main/${lngRsvNo}`} className="btn_op btn_reserveicon" title="予約内容を見る">{reserveicon}</NavLink>
      </div>
    ));
    if (lngCancelFlg !== constants.CONSULT_USED) {
      strButtons.push((
        <div key={`editButtonCol-0-${key}`} className="editbuttoncancel">キャンセルされました。</div>
      ));
    } else {
      // 受付ボタン
      strButtons.push((
        <div key={`editButtonCol-2-${key}`} className="editbutton">
          <a title="受付する" role="presentation" className="btn_op btn_receipticon" onClick={() => (this.showReceipt({ lngRsvNo }, { dtmRptDate }))}>
            {receipticon}
          </a>
        </div>
      ));

      // 結果入力ボタン
      // 受診日と受付日が異なり、かつ当日IDが存在する場合、受付日ベースで指定する
      if (dtmCslDate !== dtmRptDate && (strDayId != null && strDayId !== '')) {
        dtmDate = dtmRptDate;
      } else {
        dtmDate = dtmCslDate;
      }

      // 結果入力画面のURL編集
      const strURL3 = `/contents/dailywork/preparationinfo/${lngRsvNo}`;
      strButtons.push((
        <div
          key={`editButtonCol-3-${key}`}
          className="editbutton"
        ><a title="結果入力" onClick={() => (this.handleUrlClick(strURL3))} className="btn_op btn_monshinicon" href={strURL}>{monshinicon}</a>
        </div>
      ));

      // 判定ボタン(当日ID指定時)
      if (strDayId != null && strDayId !== '') {
        // 判定入力画面のURL編集
        const strURL4 = `/contents/judgement/interview/top/${lngRsvNo}/totaljudview/0/0`;
        strButtons.push((
          <div key={`editButtonCol-4-${key}`} className="editbutton">
            <a role="presentation" title="面接支援" onClick={() => (this.handleUrlClick(strURL4))} className="btn_op btn_interviewicon" >{interviewicon}</a>
          </div>
        ));
      } else {
        strButtons.push((
          <div key={`editButtonCol-4-${key}`} className="editbutton" />
        ));
      }

      // 健診歴参照
      strButtons.push((
        <div key={`editButtonCol-5-${key}`} className="editbutton">
          <a title="健診歴を参照" className="btn_op btn_inquiryicon" href="/webhains/contents/inquiry/inqmain.asp?perid={strperid}">{inquiryicon}</a>
        </div>
      ));

      // 電子チャート起動（モード選択画面）
      if (strPerId.substring(0, 1) !== '@') {
        // 仮患者IDでない場合、アイコン表示

        strURL = '';
        strURL = `${strURL}/webHains/contents/sso/HainsEgmainConnect.asp`;
        strURL = `${strURL}?funccode=FC001`;
        strURL = `${strURL}&csldate=${moment(dtmDate).format('YYYYMMDD')}`;
        strURL = `${strURL}&perID=${strPerId}`;
        strButtons.push((
          <div key={`editButtonCol-6-${key}`} className="editbutton">
            <a title="電子チャート情報を参照" className="btn_op btn_lifemarkicon" href="">{lifemarkicon}</a>
          </div>
        ));
      } else {
        // 仮患者IDの場合、アイコン非表示
        strButtons.push((
          <div key={`editButtonCol-6-${key}`} className="editbutton" />
        ));
      }
    }
    strHtml.push((
      <div key={`editButtonCol-div-${key}`} className="editbutton_container">
        {strButtons}
      </div>
    ));

    return strHtml;
  }

  editListBody = (params, data) => {
    const lngArrPrtField = params.arrPrtField;
    const lngPrint = params.print;

    const strTr = [];

    for (let i = 0; i < data.length; i += 1) {
      // 各表示列ごとの編集
      const strTd = [];
      for (let j = 0; j < lngArrPrtField.length; j += 1) {
        strTd.push((
          <td key={lngArrPrtField[j]} nowrap="true" valign="top" align={lngArrPrtField[j] === 9 ? 'right' : ''}>
            {(() => {
              switch (lngArrPrtField[j]) {
                // 時間枠
                case 1: return null;
                // 当日ＩＤ
                case 2: return <span>{data[i].dayid}</span>;
                // 管理番号
                case 3: return null;
                // コース
                case 4: return (data[i].csname != null && data[i].csname !== '') ? <span><span style={{ color: `#${data[i].webcolor}` }}>■</span>{data[i].csname}</span> : null;
                // 氏名
                case 5: return <span>{data[i].name}</span>;
                // カナ氏名
                case 6: return <span>（{data[i].kananame}）</span>;
                // 性別
                case 7: return <span>{data[i].gender === 1 ? '男' : '女'}</span>;
                // 生年月日
                case 8: return <span>{this.getBirth(data[i].birth)}</span>;
                // 受診時年齢
                case 9: return (data[i].age != null && data[i].age !== '') ? <span> {parseInt(data[i].age, 10)}歳</span> : null;
                // 団体略称
                case 10: return <span>{data[i].orgsname}</span>;
                // 予約番号
                case 11: return <span>{data[i].rsvno}</span>;
                // 受診日
                case 12: return <span>{data[i].csldate && moment(data[i].csldate).format('YYYY/MM/DD')}</span>;
                // 予約日
                case 13: return <span>{data[i].rsvdate && moment(data[i].rsvdate).format('YYYY/MM/DD')}</span>;
                // 追加検査
                case 14: return <span>{this.editAddItem(data[i].additems)}</span>;
                // 受付日(未使用)
                case 15: return null;
                // 個人氏名
                case 16: return <div><div style={{ fontSize: '9px', marginBottom: '-5px' }}>{data[i].kananame}</div><div>{data[i].name}</div></div>;
                // 個人ＩＤ
                case 17: return <span>{data[i].perid}</span>;
                // 受診項目
                case 18: return <span>{this.editConsultItem(data[i].consultitems)}</span>;
                // 部門送信(未使用)
                case 19: return null;
                // 受診日からの相対日(未使用)
                case 20: return null;
                // 従業員番号
                case 21: return null;
                // 健保記号
                case 22: return <span>{data[i].isrsign}</span>;
                // 健保番号
                case 23: return <span>{data[i].isrno}</span>;
                // 事業部名称
                case 24: return null;
                // 室部名称
                case 25: return null;
                // 所属名称
                case 26: return null;
                // 受診日確定フラグ
                case 27: return null;
                // ＯＣＲ用受診日
                case 28: return null;
                // 検体番号
                case 29: return null;
                // 問診票出力日
                case 30: return null;
                // 胃カメラ受診日
                case 31: return null;
                // サブコース
                case 32: return <span>{this.editSubCourse(data[i].subcourses)}</span>;
                // 個人情報の健保記号
                case 33: return null;
                // 個人情報の健保番号
                case 34: return null;
                // 結果入力状態
                case 35: return <span>{data[i].entry === 0 && '全て入力'}{data[i].entry !== 0 && (data[i].entry === 1 ? '未入力あり' : '')}</span>;
                // 予約状況
                case 36: return <span>{data[i].rsvstatus === 0 && '確定'}{data[i].rsvstatus !== 0 && (data[i].rsvstatus === 1 ? '保留' : '未確定')}</span>;
                // 確認はがき出力日
                case 37: return <span>{data[i].cardprintdate && moment(data[i].cardprintdate).format('YYYY/MM/DD H:m:s')}</span>;
                // 一式書式出力日
                case 38: return <span>{data[i].formprintdate && moment(data[i].formprintdate).format('YYYY/MM/DD H:m:s')}</span>;
                // 予約群名称
                case 39: return <span>{data[i].rsvgrpname}</span>;
                // お連れ様有無
                case 40: return <span>{parseInt(data[i].hasfriends, 10) > 0 ? 'あり' : ''}</span>;
                default: return null;
              }
            }
            )()}
          </td>
        ));
      }

      // 通常表示モードの場合は操作用の列を編集する
      if (lngPrint === 0) {
        if (data[i].rsvno != null && data[i].rsvno !== '') {
          strTd.push((
            <td key={`editButtonCol-td-${i}`} align="middle">
              {this.editButtonCol(i, parseInt(data[i].rsvno, 10), parseInt(data[i].cancelflg, 10), data[i].csldate, data[i].perid, data[i].dayid, data[i].csldate)}
            </td>
          ));
        } else {
          strTd.push((
            <td key={`editButtonCol-td-${i}`} />
          ));
        }
      }

      strTr.push((
        <tr key={`listbody-tr-${i}`}>
          {strTd}
        </tr>
      ));
    }

    return strTr;
  }

  render() {
    const { params, data, setNewParams } = this.props;

    if (!data || data.length === 0) return null;
    return (
      <div>
        {params.print === 0
          &&
          <a
            role="presentation"
            style={{ textDecoration: 'underline', color: '#006699', cursor: 'pointer' }}
            onClick={() => (params.print === 0 ? setNewParams({ print: 1 }) : setNewParams({ print: 0 }))}
          >印刷用に表示
          </a>
        }

        <Table style={{ padding: '0' }} border="0" cellSpacing={params.print === 0 ? '2' : '1'} cellPadding="1">
          {/* タイトル行の編集 */}
          <thead>
            <DailyListEditTitle {...this.props} />
          </thead>
          <tbody>
            {this.editListBody(params, data)}
          </tbody>
        </Table>
      </div>
    );
  }
}

// プロパティの型を定義する
DailyListBody.propTypes = {
  params: PropTypes.shape().isRequired,
  setNewParams: PropTypes.func.isRequired,
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  history: PropTypes.shape().isRequired,
};

export default DailyListBody;

