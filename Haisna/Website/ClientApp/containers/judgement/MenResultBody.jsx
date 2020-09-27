import React from 'react';
import PropTypes from 'prop-types';

import * as constants from '../../constants/common';
import EditMenResultTable, { getMenResultGrpInfo } from './InterviewResult';

const MenResultBody = (props) => {
  const { memResult, consultHistoryData, historyRslData1, historyRslData3, tabletype, hideflg, entrymode, setValue } = props;

  const lngHisCount = consultHistoryData.length;
  // 前回歴表示モード（0:すべて、1:同一コース、2:任意指定）
  let lngLastDspMode;
  // 前回歴表示モード＝0:null ＝1:コースコード ＝2:コースグループコード
  let vntCsGrp;
  const strGrpNo = memResult.grpno;
  const lngRsvNo = memResult.rsvno;
  let strSelCsGrp = memResult.csgrp;
  strSelCsGrp = ((!strSelCsGrp || strSelCsGrp === '') ? '0' : strSelCsGrp);
  let lngEntryMode = entrymode;
  if (!lngEntryMode || lngEntryMode === '') {
    lngEntryMode = constants.INTERVIEWRESULT_REFER;
  }
  let lngHideFlg = hideflg;
  if (!lngHideFlg || lngHideFlg === '') {
    lngHideFlg = '1';
  }

  // グループ情報取得
  const {
    lngMenResultTypeNo,
    strMenResultGrpCd1,
  } = getMenResultGrpInfo(strGrpNo);

  switch (strSelCsGrp) {
    // すべてのコース
    case '0':
      lngLastDspMode = 0;
      vntCsGrp = '';
      break;
    // 同一コース
    case '1':
      lngLastDspMode = 1;
      vntCsGrp = memResult.cscd;
      break;
    default:
      lngLastDspMode = 2;
      vntCsGrp = memResult.csgrp;
  }

  const params = {
    csgrp: vntCsGrp,
    lastDspMode: lngLastDspMode,
    grpcd: strMenResultGrpCd1,
    hisCount: lngHisCount,
    rsvno: lngRsvNo,
    tabletype,
    consultHistoryData,
    historyRslData1,
    historyRslData3,
    hideflg: lngHideFlg,
    entrymode: lngEntryMode,
    setValue,
    menResultTypeNo: lngMenResultTypeNo,
  };

  return (
    <div>
      <form>
        <EditMenResultTable {...params} />
      </form>
    </div>
  );
};

// propTypesの定義
MenResultBody.propTypes = {
  memResult: PropTypes.shape().isRequired,
  tabletype: PropTypes.string.isRequired,
  consultHistoryData: PropTypes.arrayOf(PropTypes.shape()),
  historyRslData1: PropTypes.arrayOf(PropTypes.shape()),
  historyRslData3: PropTypes.arrayOf(PropTypes.shape()),
  hideflg: PropTypes.string,
  entrymode: PropTypes.number,
  setValue: PropTypes.func.isRequired,
};

// defaultPropsの定義
MenResultBody.defaultProps = {
  consultHistoryData: [],
  historyRslData1: [],
  historyRslData3: [],
  hideflg: '',
  entrymode: undefined,
};

export default MenResultBody;
