import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { reduxForm } from 'redux-form';
import qs from 'qs';

import TotalJudHeader from './TotalJudHeader';
import TotalJudEditBody from './TotalJudEditBody';

import { getCsGrpRequest } from '../../modules/judgement/interviewModule';

const formName = 'TotalJudEdit';
class TotalJudEdit extends React.Component {
  componentDidMount() {
    const { getCsGrp, match, location } = this.props;

    // qsを利用してquerystringをオブジェクト型に変換
    const param = qs.parse(location.search, { ignoreQueryPrefix: true });

    if (match.params.rsvno) {
      param.rsvno = match.params.rsvno;
    }

    // コースグループ取得
    if (!param.csgrp || param.csgrp === '') {
      getCsGrp({ rsvNo: param.rsvno });
    }
  }

  render() {
    const { csGrpData, handleSubmit, history, location, match } = this.props;

    // qsを利用してquerystringをオブジェクト型に変換
    const param = qs.parse(location.search, { ignoreQueryPrefix: true });

    if (match.params.action) {
      param.action = match.params.action;
    }
    if (match.params.winmode) {
      param.winmode = match.params.winmode;
    }
    if (match.params.rsvno) {
      param.rsvno = match.params.rsvno;
    }
    if (match.params.grpcd) {
      param.grpcd = match.params.grpcd;
    }
    if (match.params.cscd) {
      param.cscd = match.params.cscd;
    }
    if (match.params.csgrp) {
      param.csgrp = match.params.csgrp;
    }

    let strSelCsGrp = param.csgrp;

    if (!strSelCsGrp || strSelCsGrp === '') {
      if (csGrpData && csGrpData.length > 0) {
        strSelCsGrp = csGrpData[0].csgrpcd;
      } else {
        strSelCsGrp = '0';
      }
    }

    return (
      <div style={{ minWidth: '1000px' }}>
        <form>
          <TotalJudHeader handleSubmit={handleSubmit} history={history} match={match} params={{ ...param, csgrp: strSelCsGrp }} />
          <TotalJudEditBody handleSubmit={handleSubmit} history={history} location={location} match={match} params={{ ...param, csgrp: strSelCsGrp }} />
        </form>
      </div>
    );
  }
}

const TotalJudEditForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: false,
})(TotalJudEdit);

// propTypesの定義
TotalJudEdit.propTypes = {
  csGrpData: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  getCsGrp: PropTypes.func.isRequired,
  history: PropTypes.shape().isRequired,
  location: PropTypes.shape().isRequired,
  match: PropTypes.shape().isRequired,
  handleSubmit: PropTypes.func.isRequired,
};

const mapStateToProps = (state) => ({
  csGrpData: state.app.judgement.interview.csGrpData,
});

const mapDispatchToProps = (dispatch) => ({
  getCsGrp: (params) => {
    // 検索条件に従い受診情報一覧を抽出する
    dispatch(getCsGrpRequest({ ...params, formName }));
  },
});
export default connect(mapStateToProps, mapDispatchToProps)(TotalJudEditForm);
