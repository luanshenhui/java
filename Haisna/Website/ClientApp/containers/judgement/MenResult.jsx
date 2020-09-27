import React from 'react';
import PropTypes from 'prop-types';
import { reduxForm, formValueSelector, blur } from 'redux-form';
import { connect } from 'react-redux';
import qs from 'qs';

import GuideBase from '../../components/common/GuideBase';
import MenResultHeader from './MenResultHeader';
import MenResultBody from './MenResultBody';
import * as constants from '../../constants/common';
import { getMenResultGrpInfo } from './InterviewResult';
import InterviewHeader from '../../containers/common/InterviewHeaderForm';

import {
  registerResultRequest,
} from '../../modules/result/resultModule';

import {
  closeMenResultGuide,
  getHistoryRslListMenResultRequest,
} from '../../modules/judgement/interviewModule';

const formName = 'MenResultForm';

class MenResult extends React.Component {
  componentDidMount() {
    const { match, getHistoryRslList } = this.props;
    const params = this.convertParams(this.props);

    if (match && match.params && match.params.winmode === '0') {
      this.onLoad({ getHistoryRslList, params });
    }
  }

  // propが更新される際に呼ばれる処理
  componentWillReceiveProps(nextProps) {
    const { location, getHistoryRslList, resultdispmode } = nextProps;
    const params = this.convertParams(nextProps);

    if (this.props.location !== location || this.props.resultdispmode !== resultdispmode) {
      this.onLoad({ getHistoryRslList, params });
    }
  }

  onLoad = (props) => {
    const { getHistoryRslList, params } = props;

    // 指定対象受診者の検査結果を抽出する
    // オーダ番号、送信日を取得
    // 健診が終わった後受診者の個人IDを変更した場合、変更前のIDと変更後のIDを取得する
    getHistoryRslList({
      params: {
        rsvno: params.rsvno,
        csgrp: params.csgrp,
        cscd: params.cscd,
        resultdispmode: params.resultdispmode,
      },
      formName,
    });
  }

  convertParams = (props) => {
    const { match, location, resultdispmode } = props;
    let { params } = props;
    params = { ...params, resultdispmode };
    if (match && match.params && match.params.winmode === '0') {
      params = {
        ...params,
        winmode: match.params.winmode,
        resultdispmode: Number(match.params.grpno),
        rsvno: match.params.rsvno,
        cscd: match.params.cscd,
      };
    }

    // qsを利用してquerystringをオブジェクト型に変換
    if (location && location.search) {
      const param = qs.parse(location.search, { ignoreQueryPrefix: true });
      params = { ...params, ...param };
    }

    return params;
  }

  render() {
    const { csGrpData } = this.props;
    const params = this.convertParams(this.props);
    const { winmode, rsvno, cscd, resultdispmode } = params;
    let strSelCsGrp = params.csgrp;

    // コースしばりのデフォルト値を判断する
    if (!strSelCsGrp || strSelCsGrp === '') {
      if (csGrpData.length > 0) {
        strSelCsGrp = csGrpData[0].csgrpcd;
      } else {
        strSelCsGrp = '0';
      }
    }

    // グループ情報取得
    const {
      lngMenResultTypeNo,
      strMenResultTitle,
    } = getMenResultGrpInfo(resultdispmode);
    const memResult = { winmode, rsvno, grpno: resultdispmode, cscd, csgrp: strSelCsGrp };

    const menResultHeaderParams = {
      history: this.props.history,
      match: this.props.match,
      memResult,
      consultHistoryData: this.props.consultHistoryData,
      historyRslData1: this.props.historyRslData1,
      historyRslData3: this.props.historyRslData3,
      peridData: this.props.peridData,
      orderNoData1: this.props.orderNoData1,
      orderNoData2: this.props.orderNoData2,
      orderNoData3: this.props.orderNoData3,
      handleSubmit: this.props.handleSubmit,
      setValue: this.props.setValue,
      onUpdate: this.props.onUpdate,
      entrymode: this.props.entrymode,
      ismodal: this.props.ismodal,
    };

    const menResultBodyParams = {
      history: this.props.history,
      match: this.props.match,
      memResult,
      consultHistoryData: this.props.consultHistoryData,
      historyRslData1: this.props.historyRslData1,
      historyRslData3: this.props.historyRslData3,
      setValue: this.props.setValue,
      onUpdate: this.props.onUpdate,
      entrymode: this.props.entrymode,
      hideflg: this.props.hideflg,
    };

    const page = [];
    const body = (
      <div style={{ height: '820px' }}>
        <div>
          {memResult.winmode === '1' && <InterviewHeader rsvno={memResult.rsvno} reqwin={0} />}
        </div>
        {lngMenResultTypeNo === constants.INTERVIEWRESULT_TYPE1 && (
          <div>
            <MenResultHeader {...menResultHeaderParams} />
            <MenResultBody tabletype="0" memResult={memResult} />
          </div>
        )}
        {lngMenResultTypeNo === constants.INTERVIEWRESULT_TYPE2 && (
          <div>
            <MenResultHeader {...menResultHeaderParams} />
            <MenResultBody tabletype="2" {...menResultBodyParams} />
            <MenResultBody tabletype="0" {...menResultBodyParams} />
          </div>
        )}
        {lngMenResultTypeNo === constants.INTERVIEWRESULT_TYPE3 && (
          <div>
            <MenResultHeader {...menResultHeaderParams} />
            <MenResultBody tabletype="2" {...menResultBodyParams} />
          </div>
        )}
      </div>
    );

    if (winmode === '1') {
      page.push((
        <GuideBase {...this.props} title={`${strMenResultTitle} 検査結果表示`} usePagination={false}>
          {body}
        </GuideBase>
      ));
    } else {
      page.push((
        <div>
          {body}
        </div>
      ));
    }

    return (
      <form>
        {page}
      </form>
    );
  }
}

const MenResultForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: false,
})(MenResult);

// propTypesの定義
MenResult.propTypes = {
  getOrderNo: PropTypes.func.isRequired,
  getChangePerId: PropTypes.func.isRequired,
  csGrpData: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  resultdispmode: PropTypes.number.isRequired,
  orderNoData1: PropTypes.shape().isRequired,
  orderNoData2: PropTypes.shape().isRequired,
  orderNoData3: PropTypes.shape().isRequired,
  peridData: PropTypes.shape().isRequired,
  params: PropTypes.shape(),
  consultHistoryData: PropTypes.arrayOf(PropTypes.shape()),
  historyRslData1: PropTypes.arrayOf(PropTypes.shape()),
  historyRslData3: PropTypes.arrayOf(PropTypes.shape()),
  getHistoryRslList: PropTypes.func.isRequired,
  hideflg: PropTypes.string,
  entrymode: PropTypes.number,
  updinfo: PropTypes.arrayOf(PropTypes.shape()),
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  onUpdate: PropTypes.func.isRequired,
  getCsGrp: PropTypes.func.isRequired,
  history: PropTypes.shape().isRequired,
  location: PropTypes.shape().isRequired,
  match: PropTypes.shape().isRequired,
  handleSubmit: PropTypes.func.isRequired,
  setValue: PropTypes.func.isRequired,
  ismodal: PropTypes.number,
};

// defaultPropsの定義
MenResult.defaultProps = {
  consultHistoryData: [],
  historyRslData1: [],
  historyRslData3: [],
  hideflg: undefined,
  entrymode: undefined,
  updinfo: [],
  params: {},
  ismodal: 0,
};

const mapStateToProps = (state) => {
  const selector = formValueSelector(formName);
  return {
    hideflg: selector(state, 'hideflg'),
    entrymode: selector(state, 'entrymode'),
    updinfo: selector(state, 'updinfo'),
    visible: state.app.judgement.interview.menResult.visible,
    resultdispmode: state.app.judgement.interview.menResult.resultdispmode,
    orderNoData1: state.app.judgement.interview.menResult.orderNoData1,
    orderNoData2: state.app.judgement.interview.menResult.orderNoData2,
    orderNoData3: state.app.judgement.interview.menResult.orderNoData3,
    peridData: state.app.judgement.interview.menResult.peridData,
    consultHistoryData: state.app.judgement.interview.menResult.consultHistoryData,
    historyRslData1: state.app.judgement.interview.menResult.historyRslData1,
    historyRslData3: state.app.judgement.interview.menResult.historyRslData3,
    message: state.app.result.result.resultEdit.message,
    csGrpData: state.app.judgement.interview.csGrpData,
  };
};

const mapDispatchToProps = (dispatch) => ({
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeMenResultGuide());
  },
  getHistoryRslList: (conditions) => {
    // 指定対象受診者の検査結果を抽出する
    dispatch(getHistoryRslListMenResultRequest({ ...conditions }));
  },
  setValue: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },
  onUpdate: (params, data) => dispatch(registerResultRequest({ params, data })),
});
export default connect(mapStateToProps, mapDispatchToProps)(MenResultForm);
